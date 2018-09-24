euclideanDistance <- function(u, v){
  sqrt(sum((u - v)^2))
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
kNN <- function(xl, z, k){
  ##  Сортируем выборку согласно классифицируемого объекта
  orderedXl <- sortObjectsByDist(xl, z)
  n <- dim(orderedXl)[2] - 1
  ##  Получаем классы первых k соседей
  classes <- orderedXl[1:k, n + 1]
  ##  Составляем таблицу встречаемости каждого класса
  counts <- table(classes)
  ##  Находим класс, который доминирует среди первых k соседей
  class <- names(which.max(counts))
  return (class)
}

## создаем уменьшенную выборку
iris30 = iris[sample(c(1:150), 30, replace=FALSE),]

##  Рисуем выборку
colors <- c("setosa" = "red", "versicolor" = "green3",
            "virginica" = "blue")
plot(iris30[, 3:4], pch = 21, bg = colors[iris30$Species], col
     = colors[iris30$Species], asp = 1)

##  Классификация одного заданного объекта
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
  loo <- c(loo, count)
}


print(loo)
#plot(c(1:30), loo, 'l', col='red')
plot(c(1:30), loo, 'p', col='blue')
lines(c(1:30), loo, type="l", pch=22, lty=1, col="red")
