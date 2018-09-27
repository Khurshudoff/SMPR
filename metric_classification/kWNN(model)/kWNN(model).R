euclideanDistance <- function(u, v){
  sqrt(sum((u - v)^2))
}

weight <- function(i, q){
  res = q^i
  return(res)
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

kWNN <- function(xl, z, k, q){
  
  orderedXl <- sortObjectsByDist(xl, z)
  n <- dim(orderedXl)[2] - 1
  
  classes <- orderedXl[1:k, n + 1]
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("class1", "class2")
  
  for (i in c(1:length(classes))){
    d[classes[i]] <- d[classes[i]] + weight(i, q)
  }
  
  print(d)
  
  class <- names(which.max(d))
  return (class)
}

model_data = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/custom.txt", sep="\t", header=TRUE)

colors <- c("class1" = "red", "class2" = "green3")

par(mfrow=c(1,2))

plot(model_data[, 1:2], pch = 21, bg = colors[model_data$class], 
     col = colors[model_data$class], asp = 1, xlab='property 1', ylab='property 2', main = '5NN')


z <- c(2, 2)
xl <- model_data
class <- kWNN(xl, z, k=5, q=1)
points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

plot(model_data[, 1:2], pch = 21, bg = colors[model_data$class], 
     col = colors[model_data$class], asp = 1, xlab='property 1', ylab='property 2', main = '5WNN')


z <- c(2, 2)
xl <- model_data
class <- kWNN(xl, z, k=5, q=0.8)
points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)


