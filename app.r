library(shiny)
library(ggplot2)
library(leaflet)
library(tidyverse)

# read data
data <- read_csv2("data/public-art.csv") #|> 
  #drop_na()

# separate longitude and latitude and convert to numeric for plot
data <- separate(data,
                 col = "geo_point_2d",
                 into = c("latitude", "longitude"), sep = ", ") |> 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude),
         Neighborhood = coalesce("Neighborhood", "Geo Local Area"))
# impute missing values in neighborhood using Geo Local Area

ui <- fluidPage(
  
  # title 
  titlePanel("VanArt ~ Discover public art in Vancouver!"),
  
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
                             value=c(1950, 2022),  # add two way slider
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
                               unique(data$Artists)),  # 487 unique vals
                   selected = "All",
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
                               unique(data$Type)),
                   selected = "All",
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
                   selected = "All",
                   multiple = TRUE
                   )
                 )
               )
        )
      )
    ),
    # main panel for the map 
    mainPanel(
      fluidRow(
        column(8, leafletOutput("mainMap", width = "800px", height = "500px")),
        column(4,
               fluidRow(column(12, plotOutput("barPlot")))
               )
        )
      )
    )
  )

server <- function(input, output, session){
  # applies theme selected for the app to ggplot
  thematic::thematic_shiny() 
  
  # Create reactive data 
  reactive_data <- 
    reactive({
      # set default view as all data
      filtered_data <- data
      
      # filter based on input years
      if (!is.null(input$bins)) {
        filtered_data <- 
          filtered_data |> 
          filter(
            YearOfInstallation >= input$bins[1] &
              YearOfInstallation <= input$bins[2])
      }
      
      # filter based on artist
      if (!is.null(input$artist)) {
        filtered_data <- 
          filtered_data |> 
          filter(Artist %in% input$artist)
      }
      
      # filter based on art type
      if (!is.null(input$type)) {
        filtered_data <- 
          filtered_data |> 
          filter(Type %in% input$type)
      }
      
      # filter based on neighbourhood
      if (!is.null(input$neighbourhood)) {
        filtered_data <- 
          filtered_data |> 
          filter(Neighbourhood %in% input$neighbourhood)
      }
      
      filtered_data

    })
  
  # Create main geographical map
  output$mainMap <- renderLeaflet({
    leaflet(reactive_data()) |>
      addTiles() |>  
      addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        radius = 2,
        clusterOptions = markerClusterOptions(),
        popup = ~paste(
          "Title of work: ", `Title of Work`, "<br>",
          "Type of art: ", Type, "<br>",
          "Description: ", DescriptionOfwork, "<br> <br>",
          "Neighbourhood: ", Neighbourhood, "<br>",
          "Year installed: ", YearOfInstallation, "<br>",
          "Photo URL: ", PhotoURL, "<br> <br>"
          )
        )
  })
  
}

shinyApp(ui, server)