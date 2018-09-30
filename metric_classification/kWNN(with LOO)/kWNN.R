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
  names(d) <- c("setosa", "versicolor", "virginica")
  
  for (i in c(1:length(classes))){
    d[classes[i]] <- d[classes[i]] + weight(i, q)
  }
  
  class <- names(which.max(d))
  return (class)
}

# layout(matrix(c(1,1,2,2,0,3,3,0), 2, 4, byrow = TRUE), 
#        widths=c(1,1,1,1), heights=c(1,1))

iris30 = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)
# iris30 = iris[sample(c(1:150), 30, replace=FALSE),3:5]


colors <- c("setosa" = "red", "versicolor" = "green3",
            "virginica" = "blue")
# plot(iris30[, 1:2], pch = 21, bg = colors[iris30$Species], col
#      = colors[iris30$Species], asp = 1)


# z <- c(6, 1.6)
# xl <- iris30[, 1:3]
# class <- kWNN(xl, z, k=30, q=1)
# points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

## selecting k by LOO
loo_k <- c()

for (k_ch in 1:length(iris30[,1])){
  count = 0
  for (i in 1:length(iris30[,1])){
    xl = iris30[-i,1:3]
    class <- kWNN(xl, iris30[i,1:2], k=k_ch, q=1)
    if(iris30[i,3] != class){
      count <- count + 1
    }
  }
  loo_k <- c(loo_k, count/length(iris30[,1]))
}

plot(c(1:length(iris30[,1])), loo_k, 'p', col='blue', xlab='k', ylab='loo', main = 'Finding optimal k')
lines(c(1:length(iris30[,1])), loo_k, type="l", pch=22, lty=1, col="red")

opt_k = which.min(loo_k)

points(which.min(loo_k), min(loo_k), pch=21, bg = 'red', col = 'red')

## selecting q by LOO
loo_q <- c()

q_seq = c(seq(0.05,1.0,by=0.05))

for (q in q_seq){
  count = 0
  for (i in 1:length(iris30[,1])){
    xl = iris30[-i,1:3]
    class <- kWNN(xl, iris30[i,1:2], k=opt_k, q=q)
    if(iris30[i,3] != class){
      count <- count + 1
    }
  }
  loo_q <- c(loo_q, count/length(iris30[,1]))
}

plot(q_seq, loo_q, 'p', col='blue', xlab='q', ylab='loo', main = 'Finding optimal q')
lines(q_seq, loo_q, type="l", pch=22, lty=1, col="red")

opt_q = q_seq[which.min(loo_q)]

points(q_seq[which.min(loo_q)], min(loo_q), pch=21, bg = 'red', col = 'red')

plot(iris30[, 1:2], pch = 21, bg = colors[iris30$Species], col
     = colors[iris30$Species], asp = 1, main='kWNN', xlab = 'petal length', ylab = 'petal width')

points_array <- c()

for (xtmp in seq(0, 7, by=0.1)){
  for (ytmp in seq(0, 3, by=0.1)){
    z <- c(xtmp,ytmp)
    class <- kWNN(xl, z, opt_k, 0.5)
    points_array <- c(points_array, c(z))
    points(z[1], z[2], pch = 1, col = colors[class])
  }
}


iris_test30 = iris[sample(c(1:150), 30, replace=FALSE),]

accuracy_kNN <- 0
accuracy_kWNN <- 0

for (i in c(1:length(iris_test30[,1]))){
  xl = iris30[,1:3]
  class_kNN <- kWNN(xl, iris_test30[i,3:4], k=5, q=1)
  class_kWNN <- kWNN(xl, iris_test30[i,3:4], k=opt_k, q=opt_q)
  if(iris_test30[i,5] == class_kNN){
    accuracy_kNN <- accuracy_kNN + 1
  }
  if(iris_test30[i,5] == class_kWNN){
    accuracy_kWNN <- accuracy_kWNN + 1
  }
}
print(accuracy_kNN / length(iris_test30[,1]))
print(accuracy_kWNN / length(iris_test30[,1]))


