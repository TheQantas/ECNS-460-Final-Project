library(dplyr)



# Load raw data ################################################################



if (!exists('offense')) {
    offense = read.csv('data/drives_offense.csv')
}
if (!exists('defense')) {
    defense = read.csv('data/drives_defense.csv')
}

stopifnot(nrow(offense) %% 32 == 0) #make sure all teams are present
stopifnot(nrow(defense) %% 32 == 0) #make sure all teams are present



# Add columns for per-game data ################################################


offense$games_played = ifelse(
    offense$season < 2021 | (offense$season == 2022 & (offense$team == "BUF" | offense$team == "CIN")),
    16,
    17
)
offense$punt = offense$punt + offense$turnovers + offense$blocked_punt + offense$blocked_fg + offense$missed_fg + offense$downs
offense = offense[, !names(offense) %in% c("turnovers", "blocked_punt", "blocked_fg", "missed_fg", "downs")]
offense$points_per_game = offense$points / offense$games_played
offense$yards_per_game = offense$yards / offense$games_played
offense$touchdown_per_game = offense$touchdown / offense$games_played
offense$field_goal_per_game = offense$field_goal / offense$games_played
offense$punt_per_game = offense$punt / offense$games_played
offense$safety_per_game = offense$safety / offense$games_played
offense$total_per_game = offense$total / offense$games_played
offense$end_of_period_per_game = offense$end_of_period / offense$games_played



defense$games_played = ifelse(
    defense$season < 2021 | (defense$season == 2022 & (defense$team == "BUF" | defense$team == "CIN")),
    16,
    17
)
defense$punt = defense$punt + defense$turnovers + defense$blocked_punt + defense$blocked_fg + defense$missed_fg + defense$downs
defense = defense[, !names(defense) %in% c("turnovers", "blocked_punt", "blocked_fg", "missed_fg", "downs")]
defense$points_per_game = defense$points / defense$games_played
defense$yards_per_game = defense$yards / defense$games_played
defense$touchdown_per_game = defense$touchdown / defense$games_played
defense$field_goal_per_game = defense$field_goal / defense$games_played
defense$punt_per_game = defense$punt / defense$games_played
defense$safety_per_game = defense$safety / defense$games_played
defense$total_per_game = defense$total / defense$games_played
defense$end_of_period_per_game = defense$end_of_period / defense$games_played



# Add columns for offense detrended data #######################################



offense_total_by_season = offense |> select(-team, -playoff) |> group_by(season) |> summarize(
    across(everything(), sum)
)

off_pt_model = lm(points ~ season, data = offense_total_by_season)
off_yds_model = lm(yards ~ season, data = offense_total_by_season)
off_td_model = lm(touchdown ~ season, data = offense_total_by_season)
off_fg_model = lm(field_goal ~ season, data = offense_total_by_season)
off_punt_model = lm(punt ~ season, data = offense_total_by_season)

off_pg_pt_model = lm(points_per_game ~ season, data = offense_total_by_season)
off_pg_yds_model = lm(yards_per_game ~ season, data = offense_total_by_season)
off_pg_td_model = lm(touchdown_per_game ~ season, data = offense_total_by_season)
off_pg_fg_model = lm(field_goal_per_game ~ season, data = offense_total_by_season)
off_pg_punt_model = lm(punt_per_game ~ season, data = offense_total_by_season)

offense = offense |> group_by(season) |> mutate(
    detrend_points = points - fitted(off_pt_model)[season - 2001] / 32,
    detrend_yards = yards - fitted(off_yds_model)[season - 2001] / 32,
    detrend_touchdown = touchdown - fitted(off_td_model)[season - 2001] / 32,
    detrend_field_goal = field_goal - fitted(off_fg_model)[season - 2001] / 32,
    detrend_punt = punt - fitted(off_punt_model)[season - 2001] / 32,
    
    detrend_pg_points = points - fitted(off_pg_pt_model)[season - 2001] / 32,
    detrend_pg_yards = yards - fitted(off_pg_yds_model)[season - 2001] / 32,
    detrend_pg_touchdown = touchdown - fitted(off_pg_td_model)[season - 2001] / 32,
    detrend_pg_field_goal = field_goal - fitted(off_pg_fg_model)[season - 2001] / 32,
    detrend_pg_punt = punt - fitted(off_pg_punt_model)[season - 2001] / 32,
    
    points_rank = 33 - rank(points, ties.method = "average"),
    yards_rank = 33 - rank(yards, ties.method = "average"),
    touchdown_rank = 33 - rank(touchdown, ties.method = "average"),
    field_goal_rank = 33 - rank(field_goal, ties.method = "average"),
    punt_rank = 33 - rank(punt, ties.method = "average"),
    safety_rank = 33 - rank(safety, ties.method = "average"),
)

stopifnot( abs(sum(offense$detrend_field_goal)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_points)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_yards)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_touchdown)) < 1e-5 )
stopifnot( abs(sum(offense$detrend_punt)) < 1e-5 )

rm(off_pt_model, off_fg_model, off_punt_model, off_td_model, off_yds_model)
rm(off_pg_pt_model, off_pg_fg_model, off_pg_punt_model, off_pg_td_model, off_pg_yds_model)



# Add columns for defense detrended data #######################################



defense_total_by_season = defense |> select(-team, -playoff) |> group_by(season) |> summarize(
    across(everything(), sum)
)

def_pt_model = lm(points ~ season, data = defense_total_by_season)
def_yds_model = lm(yards ~ season, data = defense_total_by_season)
def_td_model = lm(touchdown ~ season, data = defense_total_by_season)
def_fg_model = lm(field_goal ~ season, data = defense_total_by_season)
def_punt_model = lm(punt ~ season, data = defense_total_by_season)

def_pg_pt_model = lm(points_per_game ~ season, data = defense_total_by_season)
def_pg_yds_model = lm(yards_per_game ~ season, data = defense_total_by_season)
def_pg_td_model = lm(touchdown_per_game ~ season, data = defense_total_by_season)
def_pg_fg_model = lm(field_goal_per_game ~ season, data = defense_total_by_season)
def_pg_punt_model = lm(punt_per_game ~ season, data = defense_total_by_season)

defense = defense |> group_by(season) |> mutate(
    detrend_points = points - fitted(def_pt_model)[season - 2001] / 32,
    detrend_yards = yards - fitted(def_yds_model)[season - 2001] / 32,
    detrend_touchdown = touchdown - fitted(def_td_model)[season - 2001] / 32,
    detrend_field_goal = field_goal - fitted(def_fg_model)[season - 2001] / 32,
    detrend_punt = punt - fitted(def_punt_model)[season - 2001] / 32,
    
    detrend_pg_points = points - fitted(def_pg_pt_model)[season - 2001] / 32,
    detrend_pg_yards = yards - fitted(def_pg_yds_model)[season - 2001] / 32,
    detrend_pg_touchdown = touchdown - fitted(def_pg_td_model)[season - 2001] / 32,
    detrend_pg_field_goal = field_goal - fitted(def_pg_fg_model)[season - 2001] / 32,
    detrend_pg_punt = punt - fitted(def_pg_punt_model)[season - 2001] / 32,
    
    points_rank = rank(points, ties.method = "average"),
    yards_rank = rank(yards, ties.method = "average"),
    touchdown_rank = rank(touchdown, ties.method = "average"),
    field_goal_rank = rank(field_goal, ties.method = "average"),
    punt_rank = rank(punt, ties.method = "average"),
    safety_rank = rank(safety, ties.method = "average"),
)

stopifnot( abs(sum(defense$detrend_field_goal)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_points)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_yards)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_touchdown)) < 1e-5 )
stopifnot( abs(sum(defense$detrend_punt)) < 1e-5 )

rm(def_pt_model, def_fg_model, def_punt_model, def_td_model, def_yds_model)
rm(def_pg_pt_model, def_pg_fg_model, def_pg_punt_model, def_pg_td_model, def_pg_yds_model)


# Merge the offense and defense together #######################################



league = merge(
    offense |> rename_with(~ paste0("off_", .), -c(team, season)),
    defense |> rename_with(~ paste0("def_", .), -c(team, season)),
    by = c("team", "season")
) |> mutate(
    playoff = off_playoff,
    off_playoff = NULL,
    def_playoff = NULL
)



# Read in the odds #############################################################



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



# Merge the odds with the game-by-game data #####################################



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




# Merge the odds with the aggregated league data ###############################



league = left_join(
    league,
    odds |> filter(playoff==FALSE) |> group_by(away, season) |> summarize(
        away_wins = sum(ifelse(away_score > home_score, 1, 0)),
        away_losses = sum(ifelse(away_score < home_score, 1, 0)),
        away_ties = sum(ifelse(away_score == home_score, 1, 0)),
        away_wins_ats = sum(ifelse(away_score - home_score < home_line, 1, 0)),
        away_losses_ats = sum(ifelse(away_score - home_score > home_line, 1, 0)),
        away_ties_ats = sum(ifelse(away_score - home_score == home_line, 1, 0)),
        .groups = "drop"
    ) |> select(away_wins, away_losses, away_wins_ats, away_losses_ats, away_ties, away_ties_ats, season, away),
    by = c("season", "team" = "away"),
)
league = left_join(
    league,
    odds |> filter(playoff==FALSE) |> group_by(home, season) |> summarize(
        home_wins = sum(ifelse(away_score < home_score, 1, 0)),
        home_losses = sum(ifelse(away_score > home_score, 1, 0)),
        home_ties = sum(ifelse(away_score == home_score, 1, 0)),
        home_wins_ats = sum(ifelse(away_score - home_score > home_line, 1, 0)),
        home_losses_ats = sum(ifelse(away_score - home_score < home_line, 1, 0)),
        home_ties_ats = sum(ifelse(away_score - home_score == home_line, 1, 0)),
        .groups = "drop"
    ) |> select(home_wins, home_losses, home_wins_ats, home_losses_ats, home_ties, home_ties_ats, season, home),
    by = c("season", "team" = "home"),
)

stopifnot(league$def_games_played == league$off_games_played)
names(league)[names(league) == "off_games_played"] = "games_played"
league = league[, !names(league) %in% c("def_games_played")]


league$wins = league$away_wins + league$home_wins
league$losses = league$away_losses + league$home_losses
league$ties = league$away_ties + league$home_ties
league$wins_ats = league$away_wins_ats + league$home_wins_ats
league$losses_ats = league$away_losses_ats + league$home_losses_ats
league$ties_ats = league$away_ties_ats + league$home_ties_ats
league$record = (league$wins + league$ties / 2) / league$games_played
league$record_ats = (league$wins_ats + league$ties / 2) / league$games_played

stopifnot(league$wins + league$losses + league$ties == league$off_games_played)
stopifnot(league$wins_ats + league$losses_ats + league$ties_ats == league$off_games_played)

for (i in 1:nrow(league)) {
    if (league[i, 'season'] < 2006) {
        next
    }
    
    expected_games = league[i, 'games_played']
    played_games = league[i, 'wins'] + league[i, 'losses'] + league[i, 'ties']
    ats_games = league[i, 'wins_ats'] + league[i, 'losses_ats'] + league[i, 'ties_ats']
    
    if (expected_games != played_games) {
        stop(sprintf(
            "%s in %d expected %d games but played %d",
            league[i, 'team'],
            leauge[i, 'season'],
            expected_games,
            played_games
        ))
    }
    if (expected_games != ats_games) {
        stop(sprintf(
            "%s in %d expected %d games but played %d ATS",
            league[i, 'team'],
            leauge[i, 'season'],
            expected_games,
            ats_games
        ))
    }
}

league = league |> arrange(season, team)
league$delta_off_points_rank = league$off_points_rank - lag(league$off_points_rank, 32)
league$delta_def_points_rank = league$def_points_rank - lag(league$def_points_rank, 32)

stopifnot( sum(league$wins, na.rm=T) == sum(league$losses, na.rm=T))
stopifnot( sum(league$ties, na.rm=T) %% 2 == 0 )
stopifnot( sum(league$wins_ats, na.rm=T) == sum(league$losses_ats, na.rm=T))
stopifnot( sum(league$ties_ats, na.rm=T) %% 2 == 0 )




league_by_season = league |> group_by(season) |> summarize(across(where(is.numeric), sum))
league_by_season$touchdown_per_game = league_by_season$off_touchdown / league_by_season$games_played
league_by_season$field_goal_per_game = league_by_season$off_field_goal / league_by_season$games_played
league_by_season$punt_per_game = league_by_season$off_punt / league_by_season$games_played

league_by_team = league |> group_by(team) |> summarize(across(where(is.numeric), sum))
league_by_team$season = NULL
league_by_team$main_color = c(
    "#97233F", #"ARI"
    "#a71930", #"ATL"
    "#241773", #"BAL"
    "#00338D", #"BUF"
    "#0085CA", #"CAR"
    "#0B162A", #"CHI"
    "#fb4f14", #"CIN"
    "#311D00", #"CLE"
    "#869397", #"DAL"
    "#FA4616", #"DEN"
    "#0076b6", #"DET"
    "#203731", #"GB"
    "#03202f", #"HOU"
    "#002C5F", #"IND"
    "#006778", #"JAX"
    "#E31837", #"KC" 
    "#0080C6", #"LAC"
    "#003594", #"LAR"
    "#000000", #"LV"
    "#008E97", #"MIA"
    "#4F2683", #"MIN"
    "#002244", #"NE"
    "#D3BC8D", #"NO"
    "#0B2265", #"NYG"
    "#125740", #"NYJ"
    "#004C54", #"PHI"
    "#101820", #"PIT"
    "#002244", #"SEA"
    "#AA0000", #"SF"
    "#D50A0A", #"TB"
    "#0C2340", #"TEN"
    "#5A1414" #"WAS"
)
league_by_team$text_color = c(
    "#000000", #"ARI"
    "#a5acaf", #"ATL"
    "#9E7C0C", #"BAL"
    "#C60C30", #"BUF"
    "#101820", #"CAR"
    "#c83803", #"CHI"
    "#000000", #"CIN"
    "#ff3c00", #"CLE"
    "#041E42", #"DAL"
    "#0064d9", #"DEN"
    "#B0B7BC", #"DET"
    "#FFB612", #"GB"
    "#A71930", #"HOU"
    "#A2AAAD", #"IND"
    "#D7A22A", #"JAX"
    "#cccc00", #"KC" 
    "#FFC20E", #"LAC"
    "#ffa300", #"LAR"
    "#aaaaaa", #"LV"
    "#FC4C02", #"MIA"
    "#FFC62F", #"MIN"
    "#C60C30", #"NE"
    "#101820", #"NO"
    "#a71930", #"NYG"
    "#000000", #"NYJ"
    "#A5ACAF", #"PHI"
    "#FFB612", #"PIT"
    "#69BE28", #"SEA"
    "#B3995D", #"SF"
    "#0A0A08", #"TB"
    "#4B92DB", #"TEN"
    "#FFB612" #"WAS"
)



# Clean up and export ##########################################################



rm(expected_games, ats_games, played_games, i)

save(offense, file = "output/offense.RData")
save(defense, file = "output/defense.RData")
save(league, file = "output/league.RData")
save(odds, file = "output/odds.RData")






