library(shiny)
library(dplyr, warn.conflicts=FALSE)
library(ggplot2)

team_names = list(
    "Arizona Cardinals" = "ARI",
    "Atlanta Falcons" = "ATL",
    
    "Baltimore Ravens" = "BAL",
    "Buffalo Bills" = "BUF",
    
    "Carolina Panthers" = "CAR",
    "Chicago Bears" = "CHI",
    "Cincinnati Bengals" = "CIN",
    "Cleveland Browns" = "CLE",
    
    "Dallas Cowboys" = "DAL",
    "Denver Broncos" = "DEN",
    "Detroit Lions" = "DET",
    
    "Green Bay Packers" = "GB",
    "Houston Texans" = "HOU",
    "Indianapolis Colts" = "IND",
    "Jacksonville Jaguars" = "JAX",
    "Kansas City Chiefs" = "KC",
    
    "Los Angeles Chargers" = "LAC",
    "Los Angeles Rams" = "LAR",
    "Las Vegas Raiders" = "LV",
    
    "Miami Dolphins" = "MIA",
    "Minnesota Vikings" = "MIN",
    
    "New England Patriots" = "NE",
    "New Orleans Saints" = "NO",
    "New York Giants" = "NYG",
    "New York Jets" = "NYJ",
    
    "Philadelphia Eagles" = "PHI",
    "Pittsburgh Steelers" = "PIT",
    
    "Seattle Seahawks" = "SEA",
    "San Francisco 49ers" = "SF",
    
    "Tampa Bay Bucaneers" = "TB",
    "Tennessee Titans" = "TEN",
    
    "Washington Commanders" = "WAS"
)

detrend_names = list(
    "Points" = "off_points",
    "Detrend Points" = "off_detrend_points",
    
    "Yards" = "off_yards",
    "Detrend Yards" = "off_detrend_yards",
    
    "Touchdowns" = "off_touchdown",
    "Detrend Touchdowns" = "off_detrend_touchdown",
    
    "Field Goals" = "off_field_goal",
    "Detrend Field Goals" = "off_detrend_field_goal",
    
    "Punts" = "off_punt",
    "Detrend Punts" = "off_detrend_punt",
    
    "Safeties" = "def_safety"
)

score_names = list(
    "Record" = "record",
    "Record ATS" = "record_ats",
    
    "Points Scored" = "off_points",
    "Yards Gained" = "off_yards",
    "Touchdowns" = "off_touchdown",
    "Field Goals" = "off_field_goal",
    "Safeties" = "def_safety",
    "Punts" = "off_punt",
    
    "Points Allowed" = "def_points",
    "Yards Allowed" = "def_yards",
    "Touchdowns Allowed" = "def_touchdown",
    "Field Goals Allowed" = "def_field_goal",
    "Safeties Allowed" = "off_safety",
    "Punts Forced" = "def_punt",
    
    "Points Rank" = "off_points_rank",
    "Yards Rank" = "off_points_rank",
    "Touchdowns Rank" = "off_touchdown_rank",
    "Field Goal Rank" = "off_field_goal_rank",
    "Safeties Rank" = "def_safeties_rank",
    "Punts Rank" = "off_punt_rank",
    
    "Points Allowed Rank" = "def_points_rank",
    "Yards Allowed Rank" = "def_points_rank",
    "Touchdowns Allowed Rank" = "def_touchdown_rank",
    "Field Goal Allowed Rank" = "def_field_goal_rank",
    "Safeties Allowed Rank" = "off_safeties_rank",
    "Punts Allowed Rank" = "def_punt_rank"
)

color_similarity = function(hex1, hex2) {
    rgb1 = col2rgb(hex1)
    rgb2 = col2rgb(hex2)
    
    distance = sqrt(sum((rgb1 - rgb2) ^ 2))
    
    return(distance / 441.673)
}

ui = fluidPage(
    titlePanel("NFL Team Statistics (2002-2023)"),
    
    mainPanel(
        tabsetPanel(
            tabPanel(
                "Summaries",
                tableOutput("league_overview"),
                tableOutput("team_overview"),
                tableOutput("season_overview")
            ),
            
            tabPanel(
                "Team Comparison",
                fluidRow(
                    column(
                        4,
                        selectInput(
                            "team1",
                            "Select Team 1:",
                            choices = unique(league$team),
                            selected = "DEN"
                        ),
                    ),
                    column(
                        4,
                        selectInput(
                            "team2",
                            "Select Team 2:",
                            choices = unique(league$team),
                            selected = "LV"
                        )
                    ),
                    column(
                        4,
                        selectInput(
                            "comparison_score",
                            "Select Team Metric:",
                            choices = score_names
                        ),
                    )
                ),
                plotOutput("team_comparison")
            ),
            
            tabPanel(
                "Yearly Trends",
                fluidRow(
                    column(
                        6,
                        selectInput(
                            "metric_trend",
                            "Select Metric for Trends:",
                            choices = detrend_names
                        )
                    ),
                    column(
                        6,
                        sliderInput(
                            "trend_years",
                            "Select Year Range:",
                            min = min(league$season),
                            max = max(league$season),
                            value = c(min(league$season), max(league$season)),
                            step = 1
                        )
                    )
                ),
                plotOutput("yearly_trends")
            ),
            
            tabPanel(
                "League Leaders",
                fluidRow(
                    column(
                        6,
                        selectInput(
                            "metric_leader",
                            "Select Metric for Leaders:",
                            choices = score_names
                        )
                    ),
                    column(
                        6,
                        sliderInput(
                            "leader_year",
                            "Select Year:",
                            min = min(league$season),
                            max = max(league$season),
                            value = max(league$season),
                            step = 1
                        )
                    )
                ),
                fluidRow(
                    column(
                        6,
                        h4("Top Teams by Metric:"),
                        tableOutput("leaders_table")
                    ),
                    column(
                        6,
                        h4("Bottom Teams by Metric:"),
                        tableOutput("leaders_table_bottom")
                    )
                )
            ),
            
            tabPanel(
                "Play Types",
                selectInput(
                    "play_metric",
                    "Select Play Metric:",
                    choices = score_names[c(-1, -2)]
                ),
                plotOutput("play_type_plot")
            ),
            
            tabPanel(
                "Record Predicators",
                fluidRow(
                    column(
                        6,
                        selectInput(
                            "ats_against",
                            "Select Record Type:",
                            choices = list(
                                "Record" = "record",
                                "Record ATS" = "record_ats"
                            )
                        )
                    ),
                    column(
                        6,
                        selectInput(
                            "ats_predictor",
                            "Select Play Metric:",
                            choices = score_names[c(-1, -2)]
                        )
                    )
                ),
                plotOutput("ats_plot")
            )
        )
    )
)

server = function(input, output) {
    # Dashboard Overview
    output$league_overview = renderTable({
        league_by_season %>%
            summarise(across(
                c(off_points, def_points, off_touchdown, def_touchdown),
                mean
            )) %>%
            rename(
                "Average Points Scored" = off_points,
                "Average Points Allowed" = def_points,
                "Average Touchdowns (Offense)" = off_touchdown,
                "Average Touchdowns (Defense)" = def_touchdown
            )
    })
    
    output$team_overview = renderTable({
        league_by_team %>%
            select(team, off_points, def_points, off_touchdown, def_touchdown) %>%
            rename(
                "Team" = team,
                "Average Points Scored" = off_points,
                "Average Points Allowed" = def_points,
                "Average Touchdowns (Offense)" = off_touchdown,
                "Average Touchdowns (Defense)" = def_touchdown
            )
    })
    
    output$season_overview = renderTable({
        league_by_season %>%
            select(season, off_points, def_points, off_touchdown, def_touchdown) %>%
            rename(
                "Season" = season,
                "Average Points Scored" = off_points,
                "Average Points Allowed" = def_points,
                "Average Touchdowns (Offense)" = off_touchdown,
                "Average Touchdowns (Defense)" = def_touchdown
            )
    })
    
    # Team Comparison
    output$team_comparison = renderPlot({
        req(input$team1, input$team2, input$comparison_score)

        team1_color = (league_by_team |> filter(team == input$team1))$main_color %||% "#ccc"
        team2_color = (league_by_team |> filter(team == input$team2))$main_color %||% "#333"

        if (color_similarity(team1_color, team2_color) < 0.2) {
            team2_color = (league_by_team |> filter(team == input$team2))$text_color %||% "#333"
        }

        league %>%
            filter(team %in% c(input$team1, input$team2)) %>%
            ggplot(aes(
                x = season,
                y = !!sym(input$comparison_score),
                color = team,
                group = team
            )) +
            geom_line() +
            scale_color_manual(values = setNames(
                c(team1_color, team2_color),
                c(input$team1, input$team2)
            )) +
            labs(
                title = paste("Offensive Points: ", input$team1, " vs ", input$team2),
                x = "Season",
                y = "Points Scored"
            )
    })
    
    # Yearly Trends
    output$yearly_trends = renderPlot({
        league %>%
            filter(season >= input$trend_years[1],
                   season <= input$trend_years[2]) %>%
            group_by(season) %>%
            summarise(metric = mean(.data[[input$metric_trend]])) %>%
            ggplot(aes(x = season, y = metric)) +
            geom_line(color = "blue") +
            geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dotted") +
            labs(
                x = "Season",
                y = input$metric_trend
            )
    })
    
    # League Leaders
    output$leaders_table = renderTable({
        league %>%
            filter(season == input$leader_year) %>%
            arrange(desc(.data[[input$metric_leader]])) %>%
            head(10) %>%
            select(team, season, .data[[input$metric_leader]]) |>
            rename(
                "Team" = team,
                "Season" = season,
                "Metric" = !!sym(input$metric_leader)
            )
    })
    
    # League Leaders
    output$leaders_table_bottom = renderTable({
        league %>%
            filter(season == input$leader_year) %>%
            arrange(.data[[input$metric_leader]]) %>%
            head(10) %>%
            select(team, season, .data[[input$metric_leader]]) |>
            rename(
                "Team" = team,
                "Season" = season,
                "Metric" = !!sym(input$metric_leader)
            )
    })

    output$play_type_plot = renderPlot({
        league_by_team %>%
            select(team, main_color, !!sym(input$play_metric)) %>%
            rename(
                "total" = input$play_metric
            ) |>
            ggplot(aes(x = reorder(team, total), y = total, fill = main_color)) +
            geom_bar(stat = "identity") +
            coord_flip() +
            scale_fill_identity() +
            labs(
                x = "Team",
                y = paste(input$play_metric, "Total")
            )
    })
    
    output$ats_plot = renderPlot({
        predictor_col = rlang::parse_expr(input$ats_predictor)
        predictor_against = rlang::parse_expr(input$ats_against)
        model = lm(eval(predictor_against) ~ eval(predictor_col), data=league)
        rsq = summary(model)$r.squared
        
        rsq_color = ifelse(rsq<0.05, "red", ifelse(rsq<0.15, "#cc3", "darkgreen"))
        
        ggplot(league, aes(x = !!sym(input$ats_predictor), y = !!sym(input$ats_against))) +
            geom_point(size = 3, color = "blue") +
            annotate(
                "text", 
                x = Inf, y = Inf, 
                label = paste(
                    "Slope: ",
                    round(model$coefficients[2], 5),
                    " Intercept: ",
                    round(model$coefficients[1], 5),
                    " R-squared: ",
                    round(rsq, 2)
                ), 
                hjust = 1, vjust = 1, 
                size = 5, color = rsq_color
            ) +
            geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dotted") +
            theme_minimal()
    })
}

shinyApp(ui = ui, server = server)