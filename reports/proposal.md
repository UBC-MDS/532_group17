# Proposal
## Motivation and Purpose
Our Role: Travel Advising Team
Target Audience: Tourists in Vancouver

Public art is an important aspect of any city as it reflects the culture, history, and values of a community. Vancouver is known for its vibrant and diverse arts scene, and as a result, it has a plethora of public art installations that locals and tourists can explore. However, apart from some well-known museums that gather art collections together, with so many public art installations scattered throughout the city, it can be difficult for tourists to find the art they are interested in. As a result, we want to provide tourists with a centralized location for people to find information on public art in Vancouver.

Our `VanArt` dashboard provides a comprehensive and interactive dashboard that allows tourists to easily find the public art they are interested in. By providing information on the location, artists, year of installation, picture, etc. It will not only help tourists find the public art they are looking for but also provide context and background on each installation. Additionally, `VanArt` can serve as a tool to promote public art and encourage people to explore the city and appreciate the art scene in Vancouver. Overall, `VanArt` has the potential to enhance the experience of tourists visiting Vancouver by providing them with a unique and enriching way to explore the city's public art. Although geared towards tourists, `VanArt` can be used by anyone interested in the Vancouver public art scene; locals who would like to explore their city’s public art are welcome to and encouraged to use `VanArt`.

## Description of the data
We'll be using a dataset that contains information on roughly 470 public artworks in Vancouver, with each site having 11 variables. These variables are described below:
-	`Title of Work`: the title of the artwork 
-	`Type`: the type of art 
-	`Status`: whether this art is in place or deaccessioned 
-	`SiteAddress`: address of artwork
-	`Neighbourhood`: neighbourhood of artwork
-	`geo_point_2d`: latitude and longitude of the artwork
-	`PhotoURL`: the photo URL
-	`URL`: url with artwork information
-	`DescriptionOfWork`: brief introduction to the artwork
-	`YearOfInstallation`: the year artwork was installed

Additionally, we'll merge this dataset with another dataset that includes artist information, using the "ArtistID" variable to link them. This will allow us to provide the first name, last name, and artist URL of the author(s) of these public artworks.

## Research questions and usage scenarios
Some research questions that our project tackles are described below:
1.	Where can I find publicly displayed art in Vancouver? Which neighbourhoods have the most publicly displayed art?  
2.	Which artists have art displayed across Vancouver? 
3.	What types of public art are there in different neighbourhoods in Vancouver? 
4.	What type of art is most abundant in Vancouver? 

An example usage scenario of our dashboard by a tourist is as follows:

Imagine you’re a tourist visiting different parts of the world in search of art that speaks to your soul. In your travels, you finally reach the beautiful city of Vancouver. Being the art fiend you are, you quickly exhaust all the art museums and galleries but your craving for art still isn’t satiated. Since you’re a proper tourist, you wander the streets in hopes of discovering public art that will quench this thirst for art. In this search, you come across a specific artwork that has you mesmerized. You wish to find other art created by the same artist as you continue your search for public art. However, this is a laborious effort and you wish there were a tool that could guide you to these public art pieces. This is where `VanArt` comes in. 

`VanArt` is a dashboard that guides the user to public art created by various artists in Vancouver. Specifically, `VanArt` displays the map of Vancouver and geographically shows the locations of the aforementioned public art pieces, and the corresponding number of art pieces belonging to a specific location. 

Wherever these art pieces exist in Vancouver, they would have a corresponding geographic bubble with the number of art pieces which can allow tourists to plan their travels accordingly.  For example, Downtown would have a bubble with a large number (compared to UBC, for example) corresponding to the number of art pieces. Clicking on these bubbles zooms into the location until the desired art piece is reached. Upon clicking the art piece, the dashboard will show vital information regarding the piece, such as the title of the work, the website where it can be found, the artist, and the physical location of the piece. Our dashboard also gives finer control to the tourist. There exist dropdowns, sliders, and checkboxes that allow the tourist to select various options for the art pieces, such as: the year installed, the type of art, the neighbourhood, and the artist. These options give the tourist more control and convenience regarding where they should travel and look for the art pieces. Depending on these selected options, our dashboard also shows statistics such as bar plots, pie charts, and a density plot. By default, the main map in the middle of the dashboard shows all public artworks in Vancouver.

Ultimately, the usage scenarios of our dashboard are immense. Everyone can use this dashboard, not just tourists, to discover public art in Vancouver. A sketch of our app can be found here [here](../img/VanArt_mockup.jpg).

