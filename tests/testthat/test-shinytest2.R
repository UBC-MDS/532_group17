library(shinytest2)

test_that("{shinytest2} recording: yearinstalled_default", {
  app <- AppDriver$new(variant = platform_variant(), name = "yearinstalled_default", 
      height = 808, width = 1067)
  app$set_window_size(width = 581, height = 808)
  app$set_window_size(width = 583, height = 808)
  app$set_inputs(bins = c(1950, 2003))
  app$set_inputs(bins = c(1950, 2022))
  app$set_inputs(bins = c(1950, 2003))
  app$set_inputs(bins = c(1950, 2022))
  app$set_window_size(width = 855, height = 808)
  app$expect_values()
  app$expect_screenshot()
})

