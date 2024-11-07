playoff_teams_offense = offense |> filter(playoff == 1)
playoff_teams_defense = defense |> filter(playoff == 1)

playoff_teams = merge(
    offense |> filter(playoff == 1) |> rename_with(~ paste0("off_", .), -c(team, season)) ,
    defense |> filter(playoff == 1) |> rename_with(~ paste0("def_", .), -c(team, season)) ,
    by = c("team", "season")
)

plot(
    playoff_teams$off_points_rank,
    playoff_teams$def_points_rank,
    xlim = c(1, 32),
    ylim = c(1, 32)
)




