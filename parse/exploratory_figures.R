library(ggplot2)
library(ggrepel)

record_plot = ggplot(league |> filter(!is.na(record)), aes(x = record, y = record_ats)) +
    geom_count(aes(color = after_stat(n)), show.legend = FALSE) +
    geom_smooth(method = "lm", se = TRUE, color = "#33aa00") +
    scale_color_gradient(low = "lightblue", high = "darkblue") +
    labs(title = "Regular Season Record and ATS", x = "Record", y = "Record ATS") +
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 45, hjust = 1)
    )
ggsave("plots/record_vs_ats.png", plot = record_plot, width = 6, height = 4, dpi = 300)

td_plot = ggplot(league_by_season, aes(x = season, y = touchdown_per_game)) +
    geom_line(color = "blue") +
    geom_smooth(method = "lm", se = TRUE, color = "darkblue") +
    labs(title = "Touchdowns per Game by Season", x = "Season", y = "Touchdowns") +
    coord_cartesian(xlim = c(2006, 2023)) +
    theme_minimal()
ggsave("plots/td_per_game.png", plot = td_plot, width = 6, height = 4, dpi = 300)

fg_plot = ggplot(league_by_season, aes(x = season, y = field_goal_per_game)) +
    geom_line(color = "darkgreen") +
    geom_smooth(method = "lm", se = TRUE, color = "#33aa00") +
    labs(title = "Field Goals per Game by Season", x = "Season", y = "Field Goals") +
    coord_cartesian(xlim = c(2006, 2023)) +
    theme_minimal()
ggsave("plots/fg_per_game.png", plot = fg_plot, width = 6, height = 4, dpi = 300)

punt_plot = ggplot(league_by_season, aes(x = season, y = punt_per_game)) +
    geom_line(color = "purple") +
    geom_smooth(method = "lm", se = TRUE, color = "#330088") +
    coord_cartesian(xlim = c(2006, 2023)) +
    labs(title = "Punts per Game by Season", x = "Season", y = "Punts") +
    theme_minimal()
ggsave("plots/punt_per_game.png", plot = punt_plot, width = 6, height = 4, dpi = 300)


vol_teams = league |> group_by(team) |> summarize(
    off_point_vol = sd(off_points_rank),
    off_point_abs = sum(abs(off_points_rank), na.rm = TRUE),
    def_point_vol = sd(def_points_rank),
    def_point_abs = sum(abs(def_points_rank), na.rm = TRUE)
)
vol_teams$main_color = league_by_team$main_color
vol_teams$text_color = league_by_team$text_color


vol_plot = ggplot(vol_teams, aes(x = off_point_vol, y = def_point_vol)) +
    geom_point(aes(color = main_color), size = 4) +
    geom_text_repel(aes(label = team, color = text_color), box.padding = 0.2) +
    scale_color_identity() +
    theme_minimal() +
    labs(title = "Team Rank Volatility", x = "Offense", y = "Defense")
ggsave("plots/volatility.png", plot = vol_plot, width = 6, height = 4, dpi = 300)

abs_dev_plot = ggplot(vol_teams, aes(x = off_point_abs, y = def_point_abs)) +
    geom_point(aes(color = main_color), size = 4) +
    geom_text_repel(aes(label = team, color = text_color), box.padding = 0.2) +
    scale_color_identity() +
    theme_minimal() +
    labs(title = "Team Rank Absolute Deviation", x = "Offense", y = "Defense")
ggsave("plots/abs_dev.png", plot = abs_dev_plot, width = 6, height = 4, dpi = 300)



