library(dplyr)



################################################################################



if (!exists('offense')) {
    offense = read.csv('data/drives_offense.csv')
}
if (!exists('defense')) {
    defense = read.csv('data/drives_defense.csv')
}

stopifnot(nrow(offense) %% 32 == 0) #make sure all teams are present
stopifnot(nrow(defense) %% 32 == 0) #make sure all teams are present



################################################################################



offense_total_by_season = offense |> select(-team, -playoff) |> group_by(season) |> summarize(
    across(everything(), sum)
)

off_pt_model = lm(points ~ season, data = offense_total_by_season)
off_yds_model = lm(yards ~ season, data = offense_total_by_season)
off_td_model = lm(touchdown ~ season, data = offense_total_by_season)
off_fg_model = lm(field_goal ~ season, data = offense_total_by_season)
off_punt_model = lm(punt ~ season, data = offense_total_by_season)

offense = offense |> group_by(season) |> mutate(
    detrend_points = points - fitted(off_pt_model)[season - 2001] / 32,
    detrend_yards = yards - fitted(off_yds_model)[season - 2001] / 32,
    detrend_touchdown = touchdown - fitted(off_td_model)[season - 2001] / 32,
    detrend_field_goal = field_goal - fitted(off_fg_model)[season - 2001] / 32,
    detrend_punt = punt - fitted(off_punt_model)[season - 2001] / 32,
    
    points_rank = rank(points),
    yards_rank = rank(yards),
    touchdown_rank = rank(touchdown),
    field_goal_rank = rank(field_goal),
    missed_fg_rank = rank(missed_fg),
    punt_rank = rank(punt),
    turnovers_rank = rank(turnovers),
    safety_rank = rank(safety)
)

stopifnot( abs(sum(offense$detrend_field_goal)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_points)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_yards)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_touchdown)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_punt)) < 1e-5 )

rm(off_pt_model, off_fg_model, off_punt_model, off_td_model, off_yds_model)



################################################################################



defense_total_by_season = defense |> select(-team, -playoff) |> group_by(season) |> summarize(
    across(everything(), sum)
)

def_pt_model = lm(points ~ season, data = defense_total_by_season)
def_yds_model = lm(yards ~ season, data = defense_total_by_season)
def_td_model = lm(touchdown ~ season, data = defense_total_by_season)
def_fg_model = lm(field_goal ~ season, data = defense_total_by_season)
def_punt_model = lm(punt ~ season, data = defense_total_by_season)

defense = defense |> group_by(season) |> mutate( #defenses want few points/yds/tds
    detrend_points = points - fitted(def_pt_model)[season - 2001] / 32,
    detrend_yards = yards - fitted(def_yds_model)[season - 2001] / 32,
    detrend_touchdown = touchdown - fitted(def_td_model)[season - 2001] / 32,
    detrend_field_goal = field_goal - fitted(def_fg_model)[season - 2001] / 32,
    detrend_punt = punt - fitted(def_punt_model)[season - 2001] / 32,
    
    points_rank = 32 - rank(points),
    yards_rank = 32 - rank(yards),
    touchdown_rank = 32 - rank(touchdown),
    field_goal_rank = 32 - rank(field_goal),
    missed_fg_rank = 32 - rank(missed_fg),
    punt_rank = 32 - rank(punt),
    turnovers_rank = 32 - rank(turnovers),
    safety_rank = 32 - rank(safety)
)

stopifnot( abs(sum(defense$detrend_field_goal)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_points)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_yards)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_touchdown)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_punt)) < 1e-5 )

rm(def_pt_model, def_fg_model, def_punt_model, def_td_model, def_yds_model)


################################################################################



league = merge(
    offense |> rename_with(~ paste0("off_", .), -c(team, season)),
    defense |> rename_with(~ paste0("def_", .), -c(team, season)),
    by = c("team", "season")
) |> mutate(
    playoff = off_playoff,
    off_playoff = NULL,
    def_playoff = NULL
)



################################################################################



odds = read.csv('data/odds.csv')
odds$overtime = odds$overtime == 'Y'
odds$playoff = odds$playoff == 'Y'
odds$neutral = NULL
odds$date = as.Date(odds$date)
odds$season = sapply(odds$date, FUN = function(d) {
    year = as.integer(format(d, "%Y"))
    month = as.integer(format(d, "%m"))
    if (month == 1 || month == 2) {
        year - 1
    } else {
        year
    }
})



################################################################################



odds = left_join(
    odds,
    league |> rename_with(~ paste0("away_", .)) |> mutate(
        away = away_team,
        away_team = NULL,
        away_playoff = NULL,
        season = away_season,
        away_season = NULL
    ),
    by = c('season', 'away')
)
odds = left_join(
    odds,
    league |> rename_with(~ paste0("home_", .)) |> mutate(
        home = home_team,
        home_team = NULL,
        home_playoff = NULL,
        season = home_season,
        home_season = NULL
    ),
    by = c('season', 'home')
)



################################################################################


save(offense, file = "output/offense.RData")
save(defense, file = "output/defense.RData")
save(league, file = "output/league.RData")
save(odds, file = "output/odds.RData")






