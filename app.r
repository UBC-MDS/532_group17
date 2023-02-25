library(shiny)
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
                             value=c(0, 72),  # add two way slider
                             sep = "")  # removes comma in slider
               )
        )
      ),
      fluidRow(
        column(12,
               wellPanel(
                 # dropdown menu for choosing artist 
                 selectInput(
                   'artist', 'Artist',
                   choices = c("Select artist(s)" = '',
                               sort(unique(data$Artists))),  # 487 unique vals
                   multiple = TRUE  # to undo selection: select -> delete
                   )
               )
        )
      ),
      fluidRow(
        column(12,
               wellPanel(
                 # checkboxes for choosing art type 
                 selectInput(
                   'type', 'Art Type',
                   choices = c("Select type(s) of art" = '',
                               sort(unique(data$Type))),
                   multiple = TRUE
                 )
               )
        )
      ),
      fluidRow(
        column(12,
               wellPanel(
                 # checkboxes for choosing neighbourhood 
                 selectInput(
                   'neighbourhood', 'Neighbourhood',
                   choices = c("Select neighbourhood(s)" = '',
                               unique(data$Neighbourhood)),  # no sort due to NA
                   multiple = TRUE
                   )
                 )
               )
        )
      )
    ),
    # main panel for the map 
    mainPanel(
        leafletOutput("mainMap", width = "600px", height = "500px")
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
           longitude = as.numeric(longitude),
           Neighborhood = coalesce("Neighborhood", "Geo Local Area"))
  # impute missing values in neighborhood using Geo Local Area
  
  # group data depending on neighborhood for plot
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
      addCircleMarkers(lat = ~latitude,  # can change CircleMarkers -> Markers
                 lng = ~longitude,
                 popup = ~paste("Neighbourhood: ", Neighbourhood, "<br>",
                                "Number of art pieces: ", num_art, "<br>"))
  })
}

shinyApp(ui, server)