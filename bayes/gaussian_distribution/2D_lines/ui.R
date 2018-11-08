library(mvtnorm)
library(shiny)

# ui ----
ui <- fluidPage(
  # App title ----
  titlePanel("2d lines level"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "mu_x1",
                  label = "mean(x1)",
                  min = -1,
                  max = 1,
                  value = 0,
                  step = 0.05),
      
      sliderInput(inputId = "mu_x2",
                  label = "mean(x2)",
                  min = -1,
                  max = 1,
                  value = 0,
                  step = 0.05),
      
      
      sliderInput(inputId = "sigma_x1",
                  label = "variance(x1)",
                  min = 0.1,
                  max = 1.7,
                  value = 1,
                  step = 0.1),
      sliderInput(inputId = "sigma_x2",
                  label = "variance(x2)",
                  min = 0.1,
                  max = 1.7,
                  value = 1,
                  step = 0.1)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      plotOutput(outputId = "linesLevel")
      
    )
  )
)
