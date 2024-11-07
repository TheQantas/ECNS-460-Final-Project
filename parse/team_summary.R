teams = offense |> group_by(team) |> summarize(
    avg_points = mean(points),
    sd_point_rank = sd(points_rank)
)







