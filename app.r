library(shiny)

ui <- fluidPage(
  
  # title 
  titlePanel("VanArt ~ Discover Art in Your Backyard"),
  
  # sidebar for filtering
  sidebarLayout(
    sidebarPanel(
                # slider for choosing year
                sliderInput(inputId='bins',
                             label='Year Installed',
                             min=1950,
                             max=2022,
                             value=72),
                 # dropdown menu for choosing artist 
                 selectInput('artist', 
                             "Artist", 
                             choices = c('A', 'B', 'C')),
                 # checkboxes for choosing art type 
                 checkboxGroupInput('type', 'Art Type',
                                    c("Mural" = "mural",
                                      "Statue" = "statue",
                                      "Graffiti" = "graffiti")),
                 # checkboxes for choosing neighbourhood 
                 checkboxGroupInput('neighbourhood', 'Neighbourhood',
                                    c("Downtown" = "downtown",
                                      "Dunbar" = "dunbar",
                                      "Kerrisdale" = "kerrisdale"))),
    # main panel for the map 
    mainPanel()
  )
)

server <- function(input, output, session){
}

shinyApp(ui, server)