euclideanDistance <- function(u, v){
  sqrt(sum((u - v)^2))
}

kernelRecktangle <- function(x, y, metricFunction, h){
  if(metricFunction(x,y) <= h){
    return(1/2)
  } 
  return(0)
}

parsen <- function(xl, z, h, metricFunction=euclideanDistance, kernel=kernelRecktangle){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")
  
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
# class <- parsen(xl, z, h=1)
# points(z[1], z[2], pch = 22, bg = colors[class], asp = 1)

points_array <- c()

## LOO

mySeq <- seq(0.1,2,by=0.05)

loo_h <- c()

for (h in mySeq){
  count = 0
  for (i in c(1:30)){
    xl = iris30[-i,3:5]
    class <- parsen(xl, iris30[i,3:4], h=h)
    if(iris30[i,5] != class){
      count <- count + 1
    }
  }
  loo_h <- c(loo_h, count/30)
}

opt_h = mySeq[which.min(loo_h)]

print(opt_h)
print(min(loo_h))

plot(mySeq, 
     loo_h, 
     'p', 
     col='blue',
     xlab='h',
     ylab='loo')
lines(mySeq, 
      loo_h, 
      type="l", 
      pch=22, 
      lty=1, 
      col="red")

plot(iris30[, 3:4], pch = 21, bg = colors[iris30$Species], col
     = colors[iris30$Species], asp = 1)

for (xtmp in seq(0, 7, by=0.1)){
  for (ytmp in seq(0, 3, by=0.1)){
    z <- c(xtmp,ytmp)
    class <- parsen(xl, z, h=opt_h)
    points_array <- c(points_array, c(z))
    points(z[1], z[2], pch = 1, col = colors[class])
  }
}

