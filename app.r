library(shiny)
library(ggplot2)
library(leaflet)
library(tidyverse)

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
      fluidRow(
        column(8, leafletOutput("mainMap", width = "800px", height = "700px")),
        column(4,
               fluidRow(column(12, plotOutput("barPlot"))),
               fluidRow(column(12, plotOutput("densityPlot"))),
               fluidRow(column(12, plotOutput("piePlot")))
               )
        )
      )
    )
  )

server <- function(input, output, session){
  # applies theme selected for the app to ggplot
  thematic::thematic_shiny() 
  
  # Create main geographical map
  output$mainMap <- renderLeaflet({
    leaflet(grouped_data) |> 
      addTiles() |>  
      addCircleMarkers(lat = ~latitude,  # can change CircleMarkers -> Markers
                 lng = ~longitude,
                 popup = ~paste("Neighbourhood: ", Neighbourhood, "<br>",
                                "Number of art pieces: ", num_art, "<br>"))
  })
  
  # Create barplot 
  output$barPlot <- renderPlot({
    grouped_data |> 
      ggplot(aes(x = num_art, y = Neighbourhood)) +
      geom_bar(stat = "identity") + 
      labs(
        x = "Number of art pieces",
        y = "Neighbourhood"
      )
  })
  
  # Create density plot
  output$densityPlot <- renderPlot({
    data |> 
      ggplot(aes(YearOfInstallation)) +
      geom_density(fill = "aquamarine", alpha = 0.8) +
      labs(
        x = "Year of installation",
        y = "Density"
      )
  })
  
  # Create piechart
  output$piePlot <- renderPlot({
    data |> 
      group_by(Type) |> 
      summarise(num_art = n()) |> 
      ggplot(aes(x = "", y = num_art, fill = Type)) + 
      geom_bar(stat="identity", width=1) +
      coord_polar("y", start=0) + 
      labs(title = "Types of Art") + 
      theme(legend.position = "bottom")
  })
  
  # Create reactive data 
  reactive_data <-
    reactive({
      data |>
        filter(
          YearOfInstallation >= input$bins[1] & YearOfInstallation <= input$bins[2]) |>
        filter(Neighbourhood == input$neighbourhood) |>
        filter(Type == input$type) |>
        filter(Artists == input$artist)
    })
  
  # Create reactive plot
  

}

shinyApp(ui, server)