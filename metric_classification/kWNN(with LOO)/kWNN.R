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

looFuncOptKwnn <- function(k_min, k_max, k_step, 
                           q_min, q_max, q_step,
                           data, class_func){
  
  seq_k = seq(k_min, k_max, k_step)
  seq_q = seq(q_min, q_max, q_step)
  
  count_missclassif = matrix( rep( 0, len=length(seq_k)*length(seq_q)), nrow = length(seq_k))

  # print(length(seq_k)*length(seq_q))
  
  for(i in c(1:length(data[,1]) ) ){
    xl <- data[-i,] # train data
    z <- data[i,1:2] # object to classify
    
    orderedXl <- sortObjectsByDist(xl, z) # data sorted by distance to z
    
    n <- dim(orderedXl)[2] - 1 
    
    index_k = 1;
    
    for (k in seq_k){
        index_q = 1
        
        classes <- orderedXl[1:k, n+1]
        for(q in seq_q){
            d <- c(0.0,0.0,0.0)
            names(d) <- c("setosa", "versicolor", "virginica")
            
            for (j in c(1:length(classes))){
              d[classes[j]] <- d[classes[j]] + weight(j, q)
            }
            
            class <- names(which.max(d))
            
            if(class != data[i,3]){
              count_missclassif[index_k, index_q] = count_missclassif[index_k, index_q] + 1
            }
            index_q = index_q + 1
        }  
      index_k = index_k + 1
    }  
  }
  return(count_missclassif / 30)
}

# layout(matrix(c(1,1,2,2,0,3,3,0), 2, 4, byrow = TRUE), 
#        widths=c(1,1,1,1), heights=c(1,1))

iris30 = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)

colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")

looMatrix = looFuncOptKwnn(1, 30, 1, 
               0.05,1,0.05,
               iris30, kNN)

min_array = which(looMatrix == min(looMatrix), arr.ind = TRUE)

min_matrix = matrix( rep( '0', len=length(seq_k)*length(seq_q)), nrow = length(seq_k))

for(index in c(1:(length(min_array)/2))){
  min_matrix[min_array[index,1], min_array[index,2]] = 'min'
}

rownames(min_matrix) = seq(1, 30, 1)
colnames(min_matrix) = seq(0.05,1,0.05)
# print(min_matrix)

# plot(iris30[, 1:2], pch = 21, bg = colors[iris30$Species], col
#      = colors[iris30$Species], asp = 1)


# z <- c(6, 1.6)
# xl <- iris30[, 1:3]
# class <- kWNN(xl, z, k=30, q=1)
# points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

opt_k = min_array[100,1]
opt_q = min_array[100,2]/20

iris30_test = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30_test.txt", sep="\t", header=TRUE)
accuracy = 0

for(i in c(1:length(iris30_test[,1]))){
  z <- iris30_test[i,1:2]
  class <- kWNN(iris30, z, opt_k, opt_q)
  if(class == iris30_test[i,3]){
    accuracy = accuracy + 1
  }
}

print(accuracy/length(iris30_test[,1]))

plot(iris30[, 1:2], pch = 21, bg = colors[iris30$Species], col
     = colors[iris30$Species], asp = 1, main='kWNN', xlab = 'petal length', ylab = 'petal width')

points_array <- c()

for (xtmp in seq(0, 7, by=0.1)){
  for (ytmp in seq(0, 3, by=0.1)){
    z <- c(xtmp,ytmp)
    class <- kWNN(iris30, z, opt_k, opt_q)
    points_array <- c(points_array, c(z))
    points(z[1], z[2], pch = 1, col = colors[class])
  }
}
