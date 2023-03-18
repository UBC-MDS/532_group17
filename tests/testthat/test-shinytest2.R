library(shinytest2)

test_that("{shinytest2} recording: Test_Art_Type_Filter", {
  app <- AppDriver$new(name = "Test_Art_Type_Filter", seed = 532, height = 714, width = 1235)
  app$set_inputs(type = "Figurative")
  app$expect_values()
})


test_that("{shinytest2} recording: Test_Neighbourhood", {
  app <- AppDriver$new(name = "Test_Neighbourhood", seed = 532, height = 714, width = 1235)
  app$set_inputs(neighbourhood = "Fairview")
  app$expect_values()
})



test_that("{shinytest2} recording: Test_Default_view", {
  app <- AppDriver$new(name = "Test_Default_view", seed = 532, height = 714, width = 1235)
  app$expect_values()
})
