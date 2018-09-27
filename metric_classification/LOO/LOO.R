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


iris30 = iris[sample(c(1:150), 30, replace=FALSE),]


colors <- c("setosa" = "red", "versicolor" = "green3",
            "virginica" = "blue")
#plot(iris30[, 3:4], pch = 21, bg = colors[iris30$Species], col
#     = colors[iris30$Species], asp = 1)


z <- c(2.7, 1)
xl <- iris30[, 3:5]
class <- kNN(xl, z, k=6)
# points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

loo <- c()

for (k in c(1:30)){
  count = 0
  for (i in c(1:30)){
    xl = iris30[-i,3:5]
    class <- kNN(xl, iris30[i,3:4], k=k)
    if(iris30[i,5] != class){
      count <- count + 1
    }
  }
  loo <- c(loo, count/30)
}

plot(c(1:30), 
     loo, 
     'p', 
     col='blue',
     xlab='k',
     ylab='loo')
lines(c(1:30), loo, type="l", pch=22, lty=1, col="red")

print(which.min(loo))
