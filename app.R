library(shiny)
library(ggplot2)
library(leaflet)
library(tidyverse)
library(treemapify)
library(thematic)
library(shinythemes)
if(!require(shinycssloaders)){
  install.packages("shinycssloaders")
  library(shinycssloaders)
}

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
  theme = bslib::bs_theme(bootswatch = "cerulean"),
  
  tags$title('This is my page'),
  
  # title
  titlePanel(title = span(img(src = "van_logo.png", height = 70), 
                          strong("VanArt"),
                          "|",
                          em("Discover Public Art in Vancouver!"), 
                          style = "font-size:23px;"),
             windowTitle = "VanArt"
  ),
  
  # image on browser tab 
  tags$head(
    tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "/van_logo.png")),
  
  # adding download button
  downloadButton("download", "Download Filtered Data", 
                 class = "btn-primary", style = "position: absolute; top: 10px; right: 10px;"),
  
  # navbarPage
  navbarPage("",
    id = 'navbar',
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
        column(8, shinycssloaders::withSpinner(leafletOutput("mainMap",
                                                             height = "450px"))
        ),
        column(4, 
               tabsetPanel(
                 id = "tabset",
                 tabPanel("Year Installed",
                          shinycssloaders::withSpinner(
                            plotOutput("densityPlot"))),
                 tabPanel("Art Type",
                          shinycssloaders::withSpinner(
                            plotOutput("treePlot"))),
                 tabPanel("Neighbourhood",
                          shinycssloaders::withSpinner(
                            plotOutput("barPlot")))
               )
        )
      ),
    br(),
    br(),
        
    # adding scrollable popup scroll in leaflet render
    tags$style(".popup-scroll {max-height: 300px; overflow-y: auto;}")),
    
    
    # about page
    tabPanel("About",
      p(h3(strong("Welcome!")),
        "VanArt is a dashboard that lets you explore art installed around Vancouver.
        With our dashboard, you can:",
        br(),
        br(),
        tags$ul(
          tags$li("Click around the map to find art in different locations"), 
          tags$li("Filter by the year(s) art pieces were installed"), 
          tags$li("Filter by the type of art you want to see"),
          tags$li("Filter by the neighbourhood you want to explore")
        ),
        "We hope VanArt will enhance your Vancouver experience, whether you're 
        a tourist visiting Vancouver for the first time or a local wishing to 
        explore the city's public art scene!",
        br(),
        br(),
        img(src='the_birds.jpg', align = "center", height = 400),
        br(),
        em('"The Birds" by Myfanwy MacLeod (Photo by Robert Keziere)'),
        hr(),
        h4(strong("Data")),
        "The data used to create this app was accessed from the",
        tags$a(href="https://opendata.vancouver.ca/explore/dataset/public-art/export/", 
               "City of Vancouver Open Data Portal"),
        hr(),
        h4(strong("Attributions")),
        "VanArt was created using the Shiny library for R:",
        br(),
        br(),
        tags$blockquote("Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J, 
        McPherson J, Dipert A, Borges B (2023). shiny: Web Application Framework 
        for R. R package version 1.7.4.9002, https://shiny.rstudio.com/.", 
                        style = "font-size:13px;"),
        "The City of Vancouver logo in the header is from:",
        br(), br(),
        tags$blockquote("https://vancouver.ca/news-calendar/city-symbols.aspx", 
                        style = "font-size:13px;"),
        hr(),
        h4(strong("GitHub")),
        "Please visit our GitHub for more information about our dashboard:", 
        tags$a(href="https://github.com/UBC-MDS/VanArt", "UBC-MDS/VanArt"),
        hr(),
        h4(strong("Authors")),
        "VanArt was made by Hongjian Li, Lisa Sequeira, Robin Dhillon, and Shirley Zhang, students in 
        the Masters of Data Science program at the University of British Columbia.",
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
      
      # if filtered_data is empty
      if (nrow(filtered_data) == 0) {
        showNotification("No art found with selected filters! Showing all art!",
                         type = "warning",
                         duration = 30)
        filtered_data <- data
      }
      
      # validate(
      #   missing_values(filtered_data)
      #   )
      
      filtered_data  # original (if no inputs) or filtered data is returned
    })
  
  missing_values <- function(input_data){
    if (nrow(input_data) == 0){
      "No art found with selected filters! Please select new filters!"
    } else {
      NULL
    }
  }
  
  
  # Create main geographical map
  output$mainMap <- renderLeaflet({
    leaflet(reactive_data(),
            options = leafletOptions(
              attributionControl=FALSE)) |>
      addTiles(group = "Neighbourhood") |>  
      addProviderTiles(providers$CartoDB.VoyagerLabelsUnder,
                       group = "Basemap") |> 
      addProviderTiles(providers$Esri.WorldImagery,
                       group = "Satellite") |>
      addLayersControl(
        baseGroups = c("Basemap","Neighbourhood", "Satellite"),
        options = layersControlOptions(collapsed = FALSE)
      ) |> 
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
      #convert the continues data type into descrete
      mutate(YearOfInstallation = format(as.Date(paste0(YearOfInstallation, "-01-01")), "%Y"))|>
      ggplot(aes(x=YearOfInstallation)) +
      geom_bar(stat="count", color = "white", fill = "#339acc") +
      labs(
        x = "Year of Installation",
        y = "Number of Art Pieces"
      ) +
      ggtitle("Number of Art Pieces Installed Over Time")+
      #make sure the scale of x-axis is always readable
      scale_x_discrete(breaks = c(min(reactive_data()$YearOfInstallation),
                                  seq(min(reactive_data()$YearOfInstallation), 
                                      max(reactive_data()$YearOfInstallation), by = 7),
                                  max(reactive_data()$YearOfInstallation))
      )
       
  })   
  
  
  # Create barplot 
  output$barPlot <- renderPlot({
    grouped_data <- 
      reactive_data() |> 
      group_by(Neighbourhood) |> 
      summarise(num_art = n())
    
    grouped_data |> 
      ggplot(aes(x = num_art, y = reorder(Neighbourhood, -num_art))) +
      geom_bar(stat = "identity", color = "#339acc", fill = "#339acc") + 
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
      geom_treemap_text(colour = "black",
                        place = "centre",
                        size = 15) +
      scale_fill_brewer(palette = "Blues") +
      labs(title = "Number of Art Pieces by Type")
  })
  
  # function to create downloadable file

  output$download <- downloadHandler(
    filename = function() {
      paste0('filtered_data.tsv')
    },
    content = function(file) {
      vroom::vroom_write(reactive_data(), file)
      #write.csv(reactive_data(), file)
    }
  )
  
  
  
}

shinyApp(ui, server)
