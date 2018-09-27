euclideanDistance <- function(u, v){
  sqrt(sum((u - v)^2))
}

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

kernelRecktangle <- function(x, y, metricFunction, h){
  if(metricFunction(x,y) <= h){
    return(1/2)
  } 
  return(0)
}

parsen_dyn <- function(xl, z, h_dyn, metricFunction=euclideanDistance, kernel=kernelRecktangle){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")
  
  orderedXl <- sortObjectsByDist(xl, z)
  h = metricFunction(orderedXl[h_dyn+1, 1:n], z)
  
  for (i in 1:l){
    curObjClass = xl[i, n+1]
    d[curObjClass] <- d[curObjClass] + kernel(xl[i,1:n], z, metricFunction, h)
  }
  
  return (names(which.max(d)))
}

## создаем уменьшенную выборку
iris30 = iris[sample(c(1:150), 30, replace=FALSE),]

##  Рисуем выборку
colors <- c("setosa" = "red", "versicolor" = "green3",
            "virginica" = "blue")
plot(iris30[, 3:4], pch = 21, bg = colors[iris30$Species], col
     = colors[iris30$Species], asp = 1)


xl <- iris30[, 3:5]


##  Классификация одного заданного объекта
# z <- c(6, 0.5)
# class <- parsen_dyn(xl, z, h_dyn = 4)
# points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

points_array <- c()

## LOO

mySeq <- c(1:25)

loo_h_dyn <- c()

for (h_dyn in mySeq){
  count = 0
  for (i in c(1:30)){
    xl = iris30[-i,3:5]
    class <- parsen_dyn(xl, iris30[i,3:4], h_dyn=h_dyn)
    if(iris30[i,5] != class){
      count <- count + 1
    }
  }
  loo_h_dyn <- c(loo_h_dyn, count/30)
}

opt_h_dyn = mySeq[which.min(loo_h_dyn)]

print(opt_h_dyn)
print(min(loo_h_dyn))

plot(mySeq, 
     loo_h_dyn, 
     'p', 
     col='blue',
     xlab='k',
     ylab='loo')
lines(mySeq, 
      loo_h_dyn, 
      type="l", 
      pch=22, 
      lty=1, 
      col="red")

plot(iris30[, 3:4], pch = 21, bg = colors[iris30$Species], col
     = colors[iris30$Species], asp = 1)

for (xtmp in seq(0, 7, by=0.1)){
  for (ytmp in seq(0, 3, by=0.1)){
    z <- c(xtmp,ytmp)
    class <- parsen_dyn(xl, z, h_dyn=opt_h_dyn)
    points_array <- c(points_array, c(z))
    points(z[1], z[2], pch = 1, col = colors[class])
  }
}

