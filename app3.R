library(shiny)
library(dplyr)
library(ggplot2)

# Define the UI
ui = fluidPage(
    titlePanel("NFL Team Statistics (2002-2023)"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("tab_select", "Select Analysis Tab:",
                        choices = c("Dashboard", "Team Comparison", 
                                    "Yearly Trends", "League Leaders",
                                    "Play Type Analysis")),
            
            conditionalPanel(
                condition = "input.tab_select == 'Team Comparison'",
                selectInput("team1", "Select Team 1:", 
                            choices = unique(league$team)),
                selectInput("team2", "Select Team 2:", 
                            choices = unique(league$team))
            ),
            
            conditionalPanel(
                condition = "input.tab_select == 'Yearly Trends'",
                selectInput("metric_trend", "Select Metric for Trends:",
                            choices = c("Points Scored" = "off_points",
                                        "Points Allowed" = "def_points",
                                        "Touchdowns" = "off_touchdown",
                                        "Field Goals" = "off_field_goal")),
                sliderInput("trend_years", "Select Year Range:",
                            min = min(league$season),
                            max = max(league$season),
                            value = c(min(league$season), max(league$season)),
                            step = 1)
            ),
            
            conditionalPanel(
                condition = "input.tab_select == 'League Leaders'",
                selectInput("metric_leader", "Select Metric for Leaders:",
                            choices = c("Points Scored" = "off_points",
                                        "Touchdowns" = "off_touchdown",
                                        "Field Goals" = "off_field_goal")),
                sliderInput("leader_year", "Select Year:", 
                            min = min(league$season),
                            max = max(league$season),
                            value = max(league$season),
                            step = 1)
            ),
            
            conditionalPanel(
                condition = "input.tab_select == 'Play Type Analysis'",
                selectInput("play_metric", "Select Play Metric:",
                            choices = c("Touchdowns" = "off_touchdown",
                                        "Field Goals" = "off_field_goal",
                                        "Safeties" = "off_safety",
                                        "Punts" = "off_punt"))
            )
        ),
        
        mainPanel(
            tabsetPanel(
                id = "main_tabs",  # Assign an ID for dynamic tab switching
                tabPanel("Dashboard",
                         h4("League Overview"),
                         tableOutput("league_overview"),
                         plotOutput("overview_plot")),
                # tabPanel("Team Comparison",
                #          h4("Team Comparison:"),
                #          plotOutput("team_comparison")),
                tabPanel(
                    title = "Team Comparison",
                    value = "team_comparison",
                    fluidRow(
                        column(
                            width = 12,
                            selectInput(
                                inputId = "team_select",
                                label = "Select Team:",
                                choices = unique(league_by_team$team)
                            ),
                            plotOutput("team_comparison_plot")
                        )
                    )
                ),
                tabPanel("Yearly Trends",
                         h4("Yearly Trends:"),
                         plotOutput("yearly_trends")),
                tabPanel("League Leaders",
                         h4("Top Teams by Metric:"),
                         tableOutput("leaders_table")),
                tabPanel("Play Type Analysis",
                         h4("Play Type Distribution:"),
                         plotOutput("play_type_plot"))
            )
        )
    )
)

# Define the server
server = function(input, output, session) {
    # Update tab panel when the "tab_select" input changes
    observe({
        updateTabsetPanel(session, "main_tabs", selected = input$tab_select)
    })
    
    # Dashboard Overview
    output$league_overview = renderTable({
        league_by_season %>%
            summarise(across(c(off_points, def_points, off_touchdown, def_touchdown), mean)) %>%
            rename("Average Points Scored" = off_points,
                   "Average Points Allowed" = def_points,
                   "Average Touchdowns (Offense)" = off_touchdown,
                   "Average Touchdowns (Defense)" = def_touchdown)
    })
    
    output$overview_plot = renderPlot({
        league_by_season %>%
            ggplot(aes(x = season)) +
            geom_line(aes(y = off_points, color = "Points Scored")) +
            geom_line(aes(y = def_points, color = "Points Allowed")) +
            labs(title = "Yearly Trends in Points Scored and Allowed",
                 x = "Season", y = "Average Points") +
            scale_color_manual(values = c("Points Scored" = "blue", "Points Allowed" = "red"))
    })
    
    # Team Comparison
    output$team_comparison = renderPlot({
        league %>%
            filter(team %in% c(input$team1, input$team2)) %>%
            ggplot(aes(x = season, y = off_points, color = team, group = team)) +
            geom_line() +
            labs(title = paste("Offensive Points: ", input$team1, " vs ", input$team2),
                 x = "Season", y = "Points Scored")
    })
    
    # Yearly Trends
    output$yearly_trends = renderPlot({
        league %>%
            filter(season >= input$trend_years[1], season <= input$trend_years[2]) %>%
            group_by(season) %>%
            summarise(metric = mean(.data[[input$metric_trend]])) %>%
            ggplot(aes(x = season, y = metric)) +
            geom_line(color = "blue") +
            labs(title = paste("Yearly Trends:", input$metric_trend),
                 x = "Season", y = input$metric_trend)
    })
    
    # League Leaders
    output$leaders_table = renderTable({
        league %>%
            filter(season == input$leader_year) %>%
            arrange(desc(.data[[input$metric_leader]])) %>%
            head(10) %>%
            select(team, season, .data[[input$metric_leader]])
    })
    
    # Play Type Analysis
    output$play_type_plot = renderPlot({
        league %>%
            group_by(team) %>%
            summarise(total = sum(.data[[input$play_metric]])) %>%
            ggplot(aes(x = reorder(team, -total), y = total)) +
            geom_bar(stat = "identity", fill = "steelblue") +
            coord_flip() +
            labs(title = paste("Distribution of", input$play_metric, "by Team"),
                 x = "Team", y = paste(input$play_metric, "Total"))
    })
    
    output$team_comparison_plot = renderPlot({
        req(input$team_select)
        
        # Filter data for the selected team
        selected_team = league_by_team %>%
            filter(team == input$team_select)
        
        # Extract team colors
        main_color = selected_team$main_color
        text_color = selected_team$text_color
        
        # Generate the plot
        ggplot(selected_team, aes(x = season)) +
            geom_line(aes(y = off_points, color = "Points"), size = 1.2) +
            geom_line(aes(y = def_points, color = "Defense Points"), size = 1.2) +
            scale_color_manual(values = c("Points" = main_color, "Defense Points" = text_color)) +
            theme_minimal(base_size = 14) +
            theme(
                plot.background = element_rect(fill = main_color, color = NA),
                panel.background = element_rect(fill = "white", color = NA),
                plot.title = element_text(color = text_color, face = "bold"),
                axis.text = element_text(color = text_color),
                axis.title = element_text(color = text_color)
            ) +
            labs(
                title = paste("Team Comparison for", input$team_select),
                x = "Season",
                y = "Points"
            )
    })
}

# Run the app
shinyApp(ui = ui, server = server)
