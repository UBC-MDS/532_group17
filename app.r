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
      data |> 
        filter(
          YearOfInstallation >= input$bins[1] &
            YearOfInstallation <= input$bins[2]) |>
        filter(Neighbourhood %in% input$neighbourhood) |> 
        filter(Type %in% input$type)
        
        
        # if (is.null(input$neighbourhood) &
        #     is.null(input$artist) &
        #     is.null(input$type) &
        #     is.null(input$bins)){
        #   data <- data
        # }else{
        #   data <-
        #     data |> 
        #     filter(Neighbourhood %in% input$neighbourhood)
        # }
      
      # if (TRUE){
      #   data <- data
      # }else{
      #   data <-
      #     data |>
      #     filter(Neighbourhood %in% input$neighbourhood)
      # }
    })
  
  # initial_lat <- 49.247643
  # initial_lng <- -123.138699
  # initial_zoom <- 12
  
  # Create main geographical map
  output$mainMap <- renderLeaflet({
    leaflet(reactive_data()) |>
      #setView(lat = initial_lat, lng = initial_lng, zoom = initial_zoom) |> 
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