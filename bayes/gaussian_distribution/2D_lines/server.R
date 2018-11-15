library(mvtnorm)
library(shiny)
library(plotrix)

zfunc <- function(x, y) {
  sapply(1:length(x), function(i) norm(x[i], y[i], mu, sigma))
}

norm = function(x, y, mu, sigma) {
  return(1)
  x = matrix(c(x, y), 1, 2)
  n = 2
  k = 1 / sqrt((2 * pi) ^ n * det(sigma))
  e = exp(-0.5 * (x - mu) %*% solve(sigma) %*% t(x - mu))
  k * e
}

server <- function(input, output) {
  output$linesLevel <- renderPlot({
    
    mu=c(input$mu_x1,input$mu_x2)
    
    angle <- input$naklon
    
    sigma=matrix(c(input$sigma_x1, angle,
                   angle,input$sigma_x2),2,2)
    
    arr <- c()
    rangeX = seq(-4,4,0.1)
    rangeY = seq(-4,4,0.1)
    
    df = data.frame()
    
    kf = 1 * max(input$sigma_x1, input$sigma_x2)
    
    for(x in rangeX){
      arr <- c()
      for(y in rangeY){
        val <- min(kf * dmvnorm(c(x,y), mu, sigma),1)
        df <- rbind(df, data.frame(x=x,y=y,v=val))
      }
    }
    
    z = outer(x, y, zfunc)
    
    for(kf in c(0.25, 0.75, 1.25)){
      add = F
      for (level in seq(0.005, 0.2, 0.005)) {
        col = 'blue'
        contour(rangeX, rangeY, z, levels = level, drawlabels = T, lwd = 1, col = col, add = add, asp = 1)
        add = T
      }
    }
    
    plot(df$x,df$y,
         xlab='x1', ylab='x2',
         col=rgb(red=1,green=0,blue=0,alpha = df$v),
         bg=rgb(red=1,green=0,blue=0,alpha = df$v),
         pch=21, asp=1,
         xlim=c(-4,4), ylim=c(-4,4))
  })
  
}