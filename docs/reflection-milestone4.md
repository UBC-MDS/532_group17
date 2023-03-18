## Milestone 4 Reflection

Project Title: VanArt

Group Members:
- Robin Dhillon
- Shirley Zhang
- Lisa Sequeira 
- Hongjian Li

### What we have done so far?

*Improvements implemented in Milestone 4*

1. We added a `navbarPage` panel to create a "Dashboard" page which holds our main dashboard, and an "About" page which gives the user information about our dashboard. 
2. We accounted for the edge cases when there are no artworks depending on the user's inputs and thus, the whole world map would be displayed. Now when this happens, all the public art in Vancouver is displayed (like default case) and a notification is displayed (duration of 30s) which tells the user that no art exists for the current user input. 
3. Added three different types of maps for the main leaflet map. The user can now toggle between a `Basemap`, a `Neighbourhood` map which shows the different neighbourhoods unlike `Basemap`, as well as a `Satellite` map which gives a satellite view. 
4. Updated the README (added installation instructions, badges, and more) and proposal to reflect the most up-to-date dashboard.
4. Updated theme and all applicable visualization with the color theme "cerulean".

### What are limitations of our dashboard? What is yet to be implemented?

1. For some art pieces, there is no image available even when we have a link. Due to this, the image embedding in the popup doesn't show an image. Accounting for this has yet to be implemented as this has turned out to be quite difficult.
2. At the beginning of milestone 4, we thought about including a choropleth map but that would require another dataset with boundaries of Vancouver neighbourhoods. Currently, we don't have that but it definitely could be implemented in the future. 
3. We were also thinking about adding artists data and providing the user the opportunity to filter via artists. However, given the complexity of this data merger (multiple artists to a single art piece) and time constraints we were unable to make this update and hope to do so at the next iteration 

---

### Has it been easy to use our app?

- Yes, the app has been quite easy to use. One of our goals was to create an app that looks elegant while being easy to use, and user feedback confirms we have succeeded in this regard. 

### Are there reoccurring themes in your feedback on what is good and what can be improved?

- Color scheme can be changed and title(s) of plots can be made larger. 

### Is there any feedback (or other insight) that you have found particularly valuable during your dashboard development?
