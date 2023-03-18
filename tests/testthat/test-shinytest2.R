library(shinytest2)

test_that("{shinytest2} recording: VanArt_defaultscreen", {
  app <- AppDriver$new(variant = platform_variant(), name = "VanArt_defaultscreen", 
      height = 714, width = 1235)
  app$expect_values()
  app$expect_screenshot()
})
