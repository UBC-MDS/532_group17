library(shiny)
library(plotly)
library(ggplot2)
library(leaflet)
library(tidyverse)


ui <- fluidPage(
  
  # title 
  titlePanel("VanArt ~ Discover Art in Your Backyard"),
  
  # sidebar for filtering
  sidebarLayout(
    tags$div(  # manual control over dimensions
      class = "sidebar",
      style = "width: 1000px;",
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
      )
    ),
    # main panel for the map 
    mainPanel(
      leafletOutput("mainMap")
    )
  )
)

server <- function(input, output, session){
  # aplies theme selected for the app to ggplot
  thematic::thematic_shiny() 
  
  # read data
  data <- read_csv2("data/public-art.csv")
  
  # separate longitude and latitude and convert to numeric for plot
  data <- separate(data,
                   col = "geo_point_2d",
                   into = c("latitude", "longitude"), sep = ", ") |> 
    mutate(latitude = as.numeric(latitude),
           longitude = as.numeric(longitude))
           #Neighborhood = coalesce("Neighborhood", "Geo Local Area"))
  
  # group data depending on neighborhood
  grouped_data <- 
    data |> 
    group_by(Neighbourhood) |> 
    summarise(num_art = n(),
              latitude = mean(latitude, na.rm = TRUE),
              longitude = mean(longitude, na.rm = TRUE))
  
  # Create map
  output$mainMap <- renderLeaflet({
    leaflet(grouped_data) %>% 
      addTiles() %>% 
      addMarkers(lat = ~latitude,
                 lng = ~longitude,
                 popup = ~paste("Neighbourhood: ", Neighbourhood, "<br>",
                                "Number of art pieces: ", num_art, "<br>"))
  })
}

shinyApp(ui, server)