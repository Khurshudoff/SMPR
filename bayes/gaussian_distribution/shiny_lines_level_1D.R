library(shiny)

# ui ----
ui <- fluidPage(
  # App title ----
  titlePanel("1d lines level"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "mu",
                  label = "mean",
                  min = -3,
                  max = 3,
                  value = 0,
                  step = 0.1),
      
      sliderInput(inputId = "sigma",
                  label = "variance",
                  min = 0.1,
                  max = 4,
                  value = 1,
                  step = 0.1)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      plotOutput(outputId = "linesLevel")
      
    )
  )
)

server <- function(input, output) {
  output$linesLevel <- renderPlot({
    
    mu = input$mu
    sigma = input$sigma
    
    arr <- c()
    range_border <- 10
    # if(sigma>3){
    #   range_border <- 15  
    # }
    range <- seq(-range_border,range_border,0.05)
    
    for(i in range){
      arr <- c(arr, dnorm(i, mu, sigma))
    }
    
    plot(range, arr, type='l')
  })
  
}

shinyApp(ui = ui, server = server)

