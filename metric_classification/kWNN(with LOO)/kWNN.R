euclideanDistance <- function(u, v){
  sqrt(sum((u - v)^2))
}

weight <- function(i, q){
  res = q^i
  return(res)
}

##  Сортируем объекты согласно расстояния до объекта z
sortObjectsByDist <- function(xl, z, metricFunction = euclideanDistance){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  ##  Создаём матрицу расстояний
  distances <- matrix(NA, l, 2)
  for (i in 1:l)
  {
    distances[i, ] <- c(i, metricFunction(xl[i, 1:n], z))
  }
  ##  Сортируем
  orderedXl <- xl[order(distances[, 2]), ]
  return (orderedXl);
}
##  Применяем метод kNN
kWNN <- function(xl, z, k, q){
  ##  Сортируем выборку согласно классифицируемого объекта
  orderedXl <- sortObjectsByDist(xl, z)
  n <- dim(orderedXl)[2] - 1
  ##  Получаем классы первых k соседей
  classes <- orderedXl[1:k, n + 1]
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")
  
  for (i in c(1:length(classes))){
    d[classes[i]] <- d[classes[i]] + weight(i, q)
  }

  ##  Находим класс, который доминирует среди первых k соседей
  class <- names(which.max(d))
  return (class)
}

## создаем уменьшенную выборку
iris33 = iris[sample(c(1:330), 33, replace=FALSE),]

##  Рисуем выборку
colors <- c("setosa" = "red", "versicolor" = "green3",
            "virginica" = "blue")
plot(iris33[, 3:4], pch = 21, bg = colors[iris33$Species], col
     = colors[iris33$Species], asp = 1)

##  Классификация одного заданного объекта
# z <- c(5, 1.6)
# xl <- iris33[, 3:5]
# class <- kWNN(xl, z, k=7, q=0.5)
# points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

## selecting q by LOO
loo_q <- c()

for (q in seq(0.02,1.0,by=0.05)){
  count = 0
  for (i in c(1:33)){
    xl = iris33[-i,3:5]
    class <- kWNN(xl, iris33[i,3:4], k=1, q=q)
    if(iris33[i,5] != class){
      count <- count + 1
    }
  }
  loo_q <- c(loo_q, count/33)
}

plot(seq(0.02,1,by=0.05), loo_q, 'p', col='blue', xlab='q', ylab='loo')
lines(seq(0.02,1,by=0.05), loo_q, type="l", pch=22, lty=1, col="red")

opt_q = seq(0.02,1,by=0.05)[which.min(loo_q)]


## selecting k by LOO
loo_k <- c()

for (k in c(1:33)){
  count = 0
  for (i in c(1:33)){
    xl = iris33[-i,3:5]
    class <- kWNN(xl, iris33[i,3:4], k=k, q=opt_q)
    if(iris33[i,5] != class){
      count <- count + 1
    }
  }
  loo_k <- c(loo_k, count/33)
}

plot(c(1:33), loo_k, 'p', col='blue', xlab='k', ylab='loo')
lines(c(1:33), loo_k, type="l", pch=22, lty=1, col="red")

opt_k = which.min(loo_k)

print(opt_k)
print(opt_q)



# plot(iris33[, 3:4], pch = 21, bg = colors[iris33$Species], col
#      = colors[iris33$Species], asp = 1)

# points_array <- c()
# 
# for (xtmp in seq(0, 7, by=0.1)){
#   for (ytmp in seq(0, 3, by=0.1)){
#     z <- c(xtmp,ytmp)
#     class <- kWNN(xl, z, opt_k, opt_q)
#     points_array <- c(points_array, c(z))
#     points(z[1], z[2], pch = 1, col = colors[class])
#   }
# }


iris_test33 = iris[sample(c(1:330), 33, replace=FALSE),]

accuracy_kNN <- 0
accuracy_kWNN <- 0

for (i in c(1:length(iris_test33))){
  xl = iris33[,3:5]
  class_kNN <- kWNN(xl, iris_test33[i,3:4], k=opt_k, q=1)
  class_kWNN <- kWNN(xl, iris_test33[i,3:4], k=opt_k, q=opt_q)
  if(iris_test33[i,5] == class_kNN){
    accuracy_kNN <- accuracy_kNN + 1
  }
  if(iris_test33[i,5] == class_kWNN){
    accuracy_kWNN <- accuracy_kWNN + 1
  }
}
print(accuracy_kNN)
print(accuracy_kWNN)


