library(shinytest2)
library(diffviewer)

test_that("{shinytest2} recording: Art_type_filter", {
  app <- AppDriver$new(name = "Art_type_filter", height = 714, width = 1235)
  app$set_inputs(type = "Totem pole")
  app$set_inputs(type = c("Totem pole", "Other"))
  app$set_inputs(tabset = "Art Type")
  app$expect_values()
})


test_that("{shinytest2} recording: Test_Neighbourhood_filter", {
  app <- AppDriver$new(name = "Test_Neighbourhood_filter", height = 714, width = 1235)
  app$set_inputs(neighbourhood = "Fairview")
  app$set_inputs(tabset = "Neighbourhood")
  app$expect_values()
  app$set_inputs(tabset = "Art Type")
  app$expect_values()
  app$set_inputs(tabset = "Year Installed")
  app$expect_values()
})



test_that("{shinytest2} recording: Test_default_view", {
  app <- AppDriver$new(name = "Test_default_view", height = 714, width = 1235)
  app$expect_values()
  app$set_inputs(tabset = "Art Type")
  app$set_inputs(tabset = "Neighbourhood")
  app$set_inputs(tabset = "Year Installed")
})
