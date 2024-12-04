library(shiny)

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

ui = fluidPage(
    titlePanel("Shiny App Example"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput(
                "num", 
                label = "Select a number:", 
                min = 1, 
                max = 100, 
                value = 50
            )
        ),
        
        mainPanel(
            plotOutput("distPlot")
        )
    ),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(
                "team_id", 
                label = "Select a team:", 
                choices = teams,
                selected = "DEN"
            )
        ),
        
        mainPanel(
            tableOutput("dataPreview")
        )
    )
)

# Define the server
server = function(input, output) {
    output$distPlot = renderPlot({
        hist(rnorm(input$num), 
             col = "skyblue", 
             border = "white", 
             main = paste("Histogram of", input$num, "Random Numbers"))
    })
    output$dataPreview = renderTable({
        index = which(league_by_team == input$team_id)
        return( league_by_team[index, ] )
    })
}

# Run the app
shinyApp(ui = ui, server = server)
