library(mvtnorm)
library(shiny)
library(plotrix)

server <- function(input, output) {
  output$linesLevel <- renderPlot({
    
    mu=c(input$mu_x1,input$mu_x2)
    
    angle <- 0
    
    sigma=matrix(c(input$sigma_x1, angle,
                   angle,input$sigma_x2),nrow=2)
    
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
    
    plot(df$x,df$y,
         xlab='x1', ylab='x2',
         col=rgb(red=1,green=0,blue=0,alpha = df$v),
         bg=rgb(red=1,green=0,blue=0,alpha = df$v),
         pch=21, asp=1,
         xlim=c(-4,4), ylim=c(-4,4))
    
    for(kf in c(0.25, 0.75, 1.25)){
      draw.ellipse(input$mu_x1,input$mu_x2, a=input$sigma_x1 * kf, b=input$sigma_x2 * kf, border = 'blue') 
    }
  })
  
}