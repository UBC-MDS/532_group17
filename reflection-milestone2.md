## Milestone Two Reflection

Project Title: VanArt

Group Members:
- Robin Dhillon
- Shirley Zhang
- Lisa Sequeira 
- Hongjian Li

### What we have done so far?

To date, we have built the majority of the dashboard to align with our mock-up. We have
created all our visualizations (with updates) and our interactive elements.

We have a central map which serves as the main element in our dashboard. This map allows 
you to select different neighbourhoods and see pinpoint locations of where art pieces in 
Vancouver are located. Clicking on a pinpoint also allows the user to see information about 
the piece, such as the title, a description, and a photo. 

We implemented an element with 3 panels, one for each of our charts. The first panel contains 
the histogram of counts for years art pieces were installed. 

We had to modify our code for the pie plot shown on the mock up as this did not do a good job 
displaying the variety of art types, and opted to do a tree plot instead. This tree plot is 
shown on the second panel. 

Finally, the third panel shows a bar chart of number of art pieces by neighbourhood. 

Our visualizations are all connected to the top 3 input selectors, which allow the user to filter 
art pieces by year of installation, art type, and neighbourhood. 

### What are limitations of our dashboard? 

Our dashboard currently includes all art pieces from the Vancouver Public Art dataset. However, 
there are many pieces which have been uninstalled that are listed on our dashboard. This would 
be misleading to tourists who want to find a piece that is not currently there. Furthermore, our 
dashboard was downloaded in February of 2023 and does not pull updated data directly from the 
Vancouver website. This can be problematic if more pieces get uninstalled in the future but they 
are still listed on our dashboard. 

We also opted to not include the artist data at this time, as it required a lot more data 
wrangling that initially anticipated. We hope to update this in the next iteration. 

### What is yet to be implemented?

In response to the uninstalled art pieces, we will add a filtering option so that users can choose 
to only see pieces that are currently installed. 

We also hope to add finer elements such as a consistent color theme throughout the dashboard, 
some background colors, and some navbar pages which could direct users to the original dataset 
or our GitHub repository. 