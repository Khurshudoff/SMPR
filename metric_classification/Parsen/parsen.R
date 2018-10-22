euclideanDistance <- function(u, v){
  sqrt(sum((u - v)^2))
}

kernelRectangle <- function(x, y, metricFunction, h){
  r = metricFunction(x,y) / h
  if(r <= 1){
    return(h/2)
  } 
  return(0)
}

kernelGaussian <- function(x, y, metricFunction, h){
  r = metricFunction(x,y) / h
  return(((2*pi)^(-1/2)) * exp(-1/2*r^2))
}

kernelEpanechnikov <- function(x, y, metricFunction, h){
  r = metricFunction(x,y) / h
  if(r<=1){
    return(3/4*(1-r^2))
  }
  return(0)
  
}

kernelQuart <- function(x, y, metricFunction, h){
  r = metricFunction(x,y) / h
  if(r<=1){
    return(15/15*(1-r^2)^2)
  }
  return(0)
  
}

kernelTriangle <- function(x, y, metricFunction, h){
  r = metricFunction(x,y) / h
  if(r<=1){
    return(1-abs(r))
  }
  return(0)
}

parsen <- function(xl, z, h=0.1, metricFunction=euclideanDistance, kernel=kernelGaussian){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")
  
  for (i in 1:l){
    curObjClass = xl[i, n+1]
    d[curObjClass] <- d[curObjClass] + kernel(xl[i,1:n], z, metricFunction, h)
  }
  if(sum(d) == 0){
    return("unknown")
  } else {
    return (names(which.max(d)))  
  }
}

looFunc <- function(mySeq, iris30, kernel){
  loo_h <- c()
  
  for (h in mySeq){
    count = 0
    for (i in c(1:length(xl[,1]))){
      xl = iris30[-i,1:3]
      class <- parsen(xl, iris30[i,1:2], h=h, kernel=kernel)
      if(iris30[i,3] != class){
        count <- count + 1
      }
    }
    loo_h <- c(loo_h, count/length(xl[,1]))
  }
  return(loo_h)
}

drawPlots <- function(kernel, kernelName, opt_h=-5, iris30){
  if(opt_h == -5){
    mySeq <- seq(0.1,2,by=0.05)
  
    loo_h <- looFunc(mySeq, iris30, kernel)
    
    opt_h = mySeq[which.min(loo_h)]
    
    print(opt_h)
    print(min(loo_h))
  
    plot(mySeq,
         loo_h,
         'p',
         col='blue',
         xlab='h',
         ylab='loo',
         main='optimization h with loo',
         cex.main=0.8)
    lines(mySeq,
          loo_h,
          type="l",
          pch=22,
          lty=1,
          col="red")
  
    points(mySeq[which.min(loo_h)], min(loo_h), pch=21, bg = 'red', col = 'red')
  }
  
  plot(iris30[, 1:2],
       pch = 21,
       bg = colors[iris30$Species],
       col = colors[iris30$Species],
       asp = 1,
       xlab='petal length',
       ylab='petal width',
       main=paste(c('parsen', kernelName, 'opt_h =', opt_h)),
       cex.main=0.8)

  for (xtmp in seq(0, 7, by=0.1)){
    for (ytmp in seq(0, 3, by=0.1)){
      z <- c(xtmp,ytmp)
      class <- parsen(iris30, z, h=opt_h, kernel=kernel)
      points_array <- c(points_array, c(z))
      points(z[1], z[2], pch = 1, col = colors[class])
    }
  }
}

layout(matrix(c(1,2), 1, 2, byrow = TRUE),
       widths=c(1,1), heights=c(1))

start <- Sys.time()
for(idx in 1:150){
  parsen(iris[, 3:5], iris[idx,3:4])
}
print(Sys.time() - start)

# iris30 = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)
# 
# colors <- c("setosa" = "red", "versicolor" = "green3",
#             "virginica" = "blue", "unknown" = "grey")
# 
# xl <- iris30[, 1:3]
# 
# # z <- c(6, 0.5)
# # class <- parsen(xl, z, h=1)
# # points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)
# 
# points_array <- c()
# 
# ## LOO
# 
# 
# drawPlots(kernelRectangle, 'kernel Rectangle',iris30=xl)
# drawPlots(kernelGaussian, 'kernel Gaussian',iris30=xl)
# drawPlots(kernelEpanechnikov, 'kernel Epanechnikov',iris30=xl)
# drawPlots(kernelQuart, 'kernel Quart',iris30=xl)
# drawPlots(kernelTriangle, 'kernel Triangle',iris30=xl)
# 
# test <- function(){
#   iris_test30 = iris
#   
#   accuracy_rect <- 0
#   accuracy_gaus <- 0
#   accuracy_epan <- 0
#   accuracy_quar <- 0
#   accuracy_tria <- 0
#   
#   for (i in c(1:length(iris_test30[,1]))){
#     xl = iris30[,1:3]
#     class_rect <- parsen(xl, iris_test30[i,3:4], h=0.6, kernel=kernelRectangle)
#     class_gaus <- parsen(xl, iris_test30[i,3:4], h=0.1, kernel=kernelGaussian)
#     class_epan <- parsen(xl, iris_test30[i,3:4], h=0.6, kernel=kernelEpanechnikov)
#     class_quar <- parsen(xl, iris_test30[i,3:4], h=0.6, kernel=kernelQuart)
#     class_tria <- parsen(xl, iris_test30[i,3:4], h=0.6, kernel=kernelTriangle)
#     if(iris_test30[i,5] == class_rect){
#       accuracy_rect <- accuracy_rect + 1
#     }
#     if(iris_test30[i,5] == class_gaus){
#       accuracy_gaus <- accuracy_gaus + 1
#     }
#     if(iris_test30[i,5] == class_epan){
#       accuracy_epan <- accuracy_epan + 1
#     }
#     if(iris_test30[i,5] == class_quar){
#       accuracy_quar <- accuracy_quar + 1
#     }
#     if(iris_test30[i,5] == class_tria){
#       accuracy_tria <- accuracy_tria + 1
#     }
#   }
#   print(accuracy_rect)
#   print(accuracy_gaus)
#   print(accuracy_epan)
#   print(accuracy_quar)
#   print(accuracy_tria)
#   
#   layout(matrix(c(1,1), 1, 1, byrow = TRUE),
#          widths=c(1), heights=c(1))
#   
#   # drawPlots(kernelRectangle, 'kernel Rectangle', opt_h=0.6, iris30=iris_test30[,3:5])
#   # drawPlots(kernelGaussian, 'kernel Gaussian', opt_h=0.1, iris30=iris_test30[,3:5])
#   # drawPlots(kernelEpanechnikov, 'kernel Epanechnikov', opt_h=0.6, iris30=iris_test30[,3:5])
#   # drawPlots(kernelQuart, 'kernel Quart', opt_h=0.6, iris30=iris_test30[,3:5])
#   # drawPlots(kernelTriangle, 'kernel Triangle', opt_h=0.6, iris30=iris_test30[,3:5])
#   
# }
# 
# test()
# 
# 
# 
