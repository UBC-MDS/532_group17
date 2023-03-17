# VanArt

<!-- badges: start -->
[![App Deploys](https://github.com/UBC-MDS/VanArt/actions/workflows/deploy-app.yaml/badge.svg)](https://github.com/UBC-MDS/VanArt/actions/workflows/deploy-app.yaml)
[![App Deploys](https://github.com/UBC-MDS/VanArt/actions/workflows/testing.yaml/badge.svg)](https://github.com/UBC-MDS/VanArt/actions/workflows/testing.yaml)
<!-- badges: end -->

Welcome to VanArt! Our mission is to help you explore public art in the city of Vancouver 

🎨 Try out the app here: **[VanArt](https://shlrley.shinyapps.io/VanArt/)** 

---

- [Introduction](#introduction)
- [Dashboard Overview](#dashboard-overview)
- [Data Used](#data-used)
- [Run Locally](#run-locally)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)


## Introduction

**The problem**

Public art is an important aspect of any city as it reflects the culture, history, and values of a community. Vancouver is known for its vibrant and diverse arts scene, and as a result, it has a plethora of public art installations that locals and tourists can explore. However, apart from some well-known museums that gather art collections together, with so many public art installations scattered throughout the city, it can be difficult for tourists to find the art they are interested in. As a result, we want to provide tourists with a centralized location to find information on public art in Vancouver.

**The solution**

Our `VanArt` dashboard provides a comprehensive and interactive dashboard that allows tourists to easily find the public art they are interested in. By providing information on the location, year of installation, etc. our dashboard will not only help tourists find the public art they are looking for but also provide context and background on each installation. Additionally, `VanArt` can serve as a tool to promote public art and encourage people to explore Vancouver. Overall, `VanArt` has the potential to enhance the experience of tourists visiting Vancouver by providing them with a unique and enriching way to explore the city's public art. Although geared towards tourists, `VanArt` can be used by anyone interested in the Vancouver public art scene; locals who would like to explore their city’s public art are welcome to and encouraged to use `VanArt`.


## Dashboard description and overview

![VanArt Gif](vanart.gif)

Our application contains three different panels:
-   `The interactivity filter panel`: As the user selects options on the panel on the top, 
    they will filter down the art icons visible on the map. The panel on the top will include 
    the year(s) when the art was installed, the type (or category) of art (mural, sculpture etc.), 
    and the neighborhood of interest. 
-   `The main map panel`: It displays the locations of the public art. When first opening the application 
    (without any user input) the map will display all the art pieces in Vancouver and the corresponding statistics, such as number of arts in each neighborhood, the number of arts for each art type, and more. The user can also 
    interact with the map directly. When selecting an icon of interest, a panel will appear providing 
    the user all the details about that particular public art piece (including the name of the work, 
    an image of it, its address and finally a website link with more information about the art).  
-   `The statistics panel`: Shows the user some basic statistics to accompany the map, based on the 
    filtered criteria the user entered in the left most panel. This panel will include a bar chart 
    to show the number of art pieces against the year installed, a tree plot to show the types of art, 
    and a bar chart to show the number of art pieces by different neighborhoods.

## Data Used (Reference)

The data set we used to create this app is modified from [City of Vancouver Open Data Portal](https://opendata.vancouver.ca/explore/dataset/public-art/export/).

Our modified data contains the feature about: the title of the artwork, the type of art (mural, statue, etc.), address of artwork, neighborhood where the work is located, latitude and longitude of the artwork, the photo URL, URL with artwork information, brief introduction to the artwork, and the year artwork was installed.


## Installation and run locally

To make this app run locally on your computer, please:

1. Clone or fork this repository first to your local directory.
2. Install the following packages required to run this app by inputting the following command in your R Console:
````{bash}
install.packages(c("shiny", "ggplot2", "leaflet", "tidyverse", "treemapify", "thematic", "shinythemes"))
```
3. After installing these packages, navigate to the top (root) directory of the repository and run the following command in the terminal:

```{bash}
RScript app.R
```

4. The address can be copied and pasted in the browser to run the dashboard. 

## Contributing

Interested in contributing? You are welcome to make contributions on our VanArt App! We would love updated information regarding current art pieces, and information regarding art that we don't have in our database. Some updates include:
-   The up-to-date data that contains the information of more art pieces and the art pieces after 2022
-   The information of the artist of these public arts
-   Images of the missing artworks.

Also, please check out the [contributing](CONTRIBUTING.md) guidelines. Please note that this project is released with a [Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.


## License

`VanArt` is licensed under the terms of the [MIT](LICENSE) license.

## Authors:

- Robin Dhillon
- Shirley Zhang
- Lisa Sequeira 
- Hongjian Li

<a href="https://github.com/UBC-MDS/VanArt/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=UBC-MDS/VanArt&max=1000" />
</a>

This data science project is created for DSCI 532 (Data Visualization II); a course in the Master of Data Science program at the University of British Columbia.
