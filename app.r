library(shiny)
library(ggplot2)
library(leaflet)
library(tidyverse)
library(treemapify)
library(thematic)
library(shinythemes)

# read data
data <- read_csv2("data/public-art.csv")

# separate longitude and latitude and convert to numeric for plot
data <- separate(data,
                 col = "geo_point_2d",
                 into = c("latitude", "longitude"), sep = ", ") |> 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude),
         Neighborhood = coalesce("Neighborhood", "Geo Local Area")) |> 
  filter(!if_any(Neighbourhood, is.na))
# impute missing values in neighborhood using Geo Local Area

ui <- fluidPage(
  
  # theme 
  theme = shinytheme("lumen"),
  
  # title option 1
  #navbarPage(title="VanArt: Discover Public Art in Vancouver!"),
  
  # title option 2
  #navbarPage(
  #  title="VanArt: Discover Public Art in Vancouver!",
  #  tabPanel("Component 1")),
  
  # title option 3
  # fluidRow(
  #   column(12, wellPanel(h2("VanArt"), h5("Discover Public Art in Vancouver!")))
  # ),
  
  # title option 4 
  #wellPanel(
    titlePanel(title = span(img(src = "van_logo.png", height = 70), 
                            strong("VanArt"),
                            "|",
                            em("Discover Public Art in Vancouver!"), 
                            style = "font-size:23px;")), 
    #style = "padding: 2px;"), 
  #br(), 
  
  navbarPage("",
    tabPanel("Dashboard",
  
      # select input row 
      fluidRow(
        column(4,
               wellPanel(
                 sliderInput(inputId='bins',
                             label='Year Installed',
                             min=1950,
                             max=2022,
                             value=c(1950, 2022),  # add two way slider
                             sep = ""),  # removes comma in slider
                 style = "padding: 8px;"
                 )
        ),
        column(4,
               wellPanel(
                 # checkboxes for choosing art type 
                 selectInput(
                   'type', 'Art Type',
                   choices = c("Select type(s) of art" = '',
                               unique(data$Type)),
                   selected = "All",
                   multiple = TRUE)
                 )
        ),
        column(4,
               wellPanel(
                 # checkboxes for choosing neighbourhood 
                 selectInput(
                   'neighbourhood', 'Neighbourhood',
                   choices = c("Select neighbourhood(s)" = '',
                               unique(data$Neighbourhood)),  
                   selected = "All",
                   multiple = TRUE
                 )
               )
        )
      ),
      br(),
      
      # map and charts 
      fluidRow(
        column(8, leafletOutput("mainMap", height = "450px")
        ),
        column(4, 
               tabsetPanel(
                 id = "tabset",
                 tabPanel("Year Installed", plotOutput("densityPlot")),
                 tabPanel("Art Type", plotOutput("treePlot")),
                 tabPanel("Neighbourhood", plotOutput("barPlot"))
               )
        )
      ),
      br(),
      br(),
      
      # footnote 
      # fluidRow(
      #   p("Made by Robin Dhillon, Shirley Zhang, Lisa Sequeira, and Hongjian Li (MDS-V 2022-23)", align = "center")
      # ),
      
      # adding scrollable popup scroll in leaflet render
      tags$style(".popup-scroll {max-height: 300px; overflow-y: auto;}")),
      
  tabPanel("About",
      p(h3(strong("Welcome!")),
        "VanArt is a dashboard that 
        Public art is an important aspect of any city as it reflects the culture, 
        history, and values of a community. Vancouver is known for its vibrant and 
        diverse arts scene, and as a result, it has a plethora of public art installations 
        that locals and tourists can explore. However, apart from some well-known museums 
        that gather art collections together, with so many public art installations scattered 
        throughout the city, it can be difficult for tourists to find the art they 
        are interested in. As a result, we want to provide tourists with a centralized 
        location to find information on public art in Vancouver.",
        img(src='the_birds.jpg', align = "right"),
        hr(),
        h4(strong("Data")),
        hr(),
        h4(strong("Attributions")),
        "ShinyApp, logo image",
        hr(),
        h4(strong("GitHub")),
        "Please visit our GitHub for more information about our dashboard:", 
        a(href="VanArt", "https://github.com/UBC-MDS/VanArt"),
        hr(),
        h4(strong("Authors")),
        "VanArt was made by Hongjian Li, Lisa Sequeira, Robin Dhillon, and Shirley Zhang, students in 
        the Masters of Data Science program at the University of British Columbia.",
        ))
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
      
      filtered_data  # original (if no inputs) or filtered data is returned
    })
  
  # Create main geographical map
  output$mainMap <- renderLeaflet({
    leaflet(reactive_data(),
            options = leafletOptions(
              attributionControl=FALSE)) |>
      addTiles() |>  
      addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        radius = 5,
        color = "darkblue",
        clusterOptions = markerClusterOptions(),
        popup = ~paste(
          "<b>Title of work</b>: ", `Title of Work`, "<br>",
          "<b>Type of art</b>: ", Type, "<br>",
          "<b>Description</b>: ", DescriptionOfwork, "<br> <br>",
          "<b>Address</b>: ", SiteAddress, "<br>",
          "<b>Year installed</b>: ", YearOfInstallation, "<br>",
          # "<b>Photo URL</b>: ", "<a href='",
          # PhotoURL,
          # "' target='_blank'>Click here to view image.</a>", "<br> <br>"
          "<b>Photo:</b><br><img src='",
          PhotoURL,
          "' style='max-width:200px; max-height:200px;'><br>"
        ),
        popupOptions = popupOptions(
          closeButton = TRUE,
          className = "popup-scroll"
        )
      )
  })
  
  # Create line plot 
  output$densityPlot <- renderPlot({
    reactive_data() |>
      ggplot(aes(x=YearOfInstallation)) +
      geom_bar(stat="count", fill = "coral1") +
      labs(
        x = "Year of Installation",
        y = "Number of Art Pieces"
      ) +
      ggtitle("Number of Art Pieces Installed Over Time")
  })   
  
  
  # Create barplot 
  output$barPlot <- renderPlot({
    grouped_data <- 
      reactive_data() |> 
      group_by(Neighbourhood) |> 
      summarise(num_art = n())
    
    grouped_data |> 
      ggplot(aes(x = num_art, y = reorder(Neighbourhood, -num_art))) +
      geom_bar(stat = "identity", fill = "coral1") + 
      labs(
        x = "Number of Art Pieces",
        y = "Neighbourhood"
      ) +
      ggtitle("Number of Art Pieces by Neighbourhood")
  })
  
  # Create tree chart
  output$treePlot <- renderPlot({
    reactive_data() |> 
      group_by(Type) |> 
      summarise(type_num = n()) |>
      ggplot(aes(area = type_num, 
                 fill = Type, 
                 label = type_num)) +
      geom_treemap() +
      geom_treemap_text(colour = "white",
                        place = "centre",
                        size = 15) +
      scale_fill_viridis_d(option = "magma") +
      labs(title = "Number of Art Pieces by Type")
  })
  
}

shinyApp(ui, server)