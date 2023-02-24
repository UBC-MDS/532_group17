library(shiny)

ui <- fluidPage(
  
  # title 
  titlePanel("VanArt ~ Discover Art in Your Backyard"),
  
  # sidebar for filtering
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(12,
               wellPanel(  # create separate boxes for each section
                 # slider for choosing year
                 sliderInput(inputId='bins',
                             label='Year Installed',
                             min=1950,
                             max=2022,
                             value=72)
               )
        )
      ),
      fluidRow(
        column(12,
               wellPanel(
                 # dropdown menu for choosing artist 
                 selectInput('artist', 
                             "Artist", 
                             choices = c('A', 'B', 'C'))
               )
        )
      ),
      fluidRow(
        column(12,
               wellPanel(
                 # checkboxes for choosing art type 
                 checkboxGroupInput('type', 'Art Type',
                                    c("Mural" = "mural",
                                      "Statue" = "statue",
                                      "Graffiti" = "graffiti"))
               )
        )
      ),
      fluidRow(
        column(12,
               wellPanel(
                 # checkboxes for choosing neighbourhood 
                 checkboxGroupInput('neighbourhood', 'Neighbourhood',
                                    c("Downtown" = "downtown",
                                      "Dunbar" = "dunbar",
                                      "Kerrisdale" = "kerrisdale")))
               )
        )
      ),
    # main panel for the map 
    mainPanel()
  )
)

server <- function(input, output, session){
}

shinyApp(ui, server)