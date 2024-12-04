library(shiny)
library(ggplot2)
library(dplyr)

# Assume `league`, `league_by_team`, and `team_names` are loaded.

ui = fluidPage(
    titlePanel("NFL Team Statistics"),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "tab_select",
                label = "Select Tab:",
                choices = list(
                    "Overview" = "overview",
                    "Team Comparison" = "team_comparison"
                )
            )
        ),
        mainPanel(
            tabsetPanel(
                id = "tabs",
                tabPanel(
                    title = "Overview",
                    value = "overview",
                    h3("Welcome to the NFL Team Statistics Dashboard!")
                ),
                tabPanel(
                    title = "Team Comparison",
                    value = "team_comparison",
                    fluidRow(
                        column(
                            width = 12,
                            selectInput(
                                inputId = "team_select",
                                label = "Select Team:",
                                choices = team_names
                            ),
                            plotOutput("team_comparison_plot")
                        )
                    )
                )
            )
        )
    )
)

server = function(input, output, session) {
    # Update the active tab when `tab_select` changes
    observe({
        updateTabsetPanel(session, inputId = "tabs", selected = input$tab_select)
    })
    
    # Render the plot for the selected team
    output$team_comparison_plot = renderPlot({
        req(input$team_select)
        
        # Filter data for the selected team
        selected_team_data = league %>%
            filter(team == input$team_select)
        
        # Get the team's main and text colors
        team_colors = league_by_team %>%
            filter(team == input$team_select) %>%
            select(main_color, text_color) %>%
            slice(1)
        
        main_color = team_colors$main_color %||% "#CCCCCC" # Default line color
        text_color = team_colors$text_color %||% "#000000" # Default text color
        
        # Generate the plot
        ggplot(selected_team_data, aes(x = season)) +
            geom_line(aes(y = off_points, color = "Offensive Points"), size = 1.2) +
            geom_line(aes(y = def_points, color = "Defensive Points"), size = 1.2) +
            scale_color_manual(
                values = c("Offensive Points" = main_color, "Defensive Points" = text_color)
            ) +
            theme_minimal(base_size = 14) +
            theme(
                plot.background = element_rect(fill = "white", color = NA),
                panel.background = element_rect(fill = "white", color = NA),
                plot.title = element_text(color = text_color, face = "bold"),
                axis.text = element_text(color = text_color),
                axis.title = element_text(color = text_color),
                legend.title = element_text(color = text_color),
                legend.text = element_text(color = text_color)
            ) +
            labs(
                title = paste("Team Comparison for", input$team_select),
                x = "Season",
                y = "Points"
            )
    })
}

shinyApp(ui = ui, server = server)
