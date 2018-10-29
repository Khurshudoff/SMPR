euclideanDistance <- function(u, v){
  sqrt(sum((u - v)^2))
}

sortObjectsByDist <- function(xl, z, metricFunction = euclideanDistance){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  distances <- matrix(NA, l, 2)
  for (i in 1:l)
  {
    distances[i, ] <- c(i, metricFunction(xl[i, 1:n], z))
  }
  
  orderedXl <- xl[order(distances[, 2]), ]
  return (orderedXl);
}

kNN <- function(xl, z, k){
  
  orderedXl <- sortObjectsByDist(xl, z)
  n <- dim(orderedXl)[2] - 1
  
  classes <- orderedXl[1:k, n + 1]
  
  counts <- table(classes)
  
  class <- names(which.max(counts))
  return (class)
}

iris30 = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)

colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")

k = 5

# plot(iris30[, 1:2], pch = 21, bg = colors[iris30$Species], col = colors[iris30$Species], xlab = 'petal length',  ylab = 'petal width', main = paste(toString(k), 'NN', sep=''))
# 
# step <- 0.2
# 
# for (xtmp in seq(0, 7, by=step)){
#   for (ytmp in seq(0, 3, by=step)){
#     z <- c(xtmp,ytmp)
#     class <- kNN(iris30, z, k)
#     points(z[1], z[2], pch = 1, col = colors[class])
#   }
# }

library(shiny)

ui <- fluidPage(
  # App title ----
  titlePanel("KNN!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "K",
                  label = "Number of classes",
                  min = 1,
                  max = 15,
                  value = 5)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      plotOutput(outputId = "kPlot")
      
    )
  )
)

server <- function(input, output) {
  output$kPlot <- renderPlot({
    
    iris30 = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)
    
    colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
    
    k <- input$K
    
    plot(iris30[, 1:2], pch = 21, bg = colors[iris30$Species], col = colors[iris30$Species], xlab = 'petal length',  ylab = 'petal width', main = paste(toString(k), 'NN', sep=''))

    step <- 0.2

    for (xtmp in seq(0, 7, by=step)){
      for (ytmp in seq(0, 3, by=step)){
        z <- c(xtmp,ytmp)
        class <- kNN(iris30, z, k)
        points(z[1], z[2], pch = 1, col = colors[class])
      }
    }
  })
  
}

shinyApp(ui = ui, server = server)
