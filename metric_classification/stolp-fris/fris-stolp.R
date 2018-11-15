euclideanDistance <- function(u, v){
  if((is.na(u[1])) | (is.na(v[1]))){
    return(5)
  }
  return(sqrt(sum((u - v)^2)))
}

fris <- function(a, b, x, ro = euclideanDistance){
  (ro(a,x) - ro(a,b)) / (ro(a,x) + ro(a,b))
}

kernelGaussian <- function(x, y, metricFunction, h){
  r = metricFunction(x,y) / h
  return(((2*pi)^(-1/2)) * exp(-1/2*r^2))
}

parsen <- function(xl, z, h = 0.1, metricFunction=euclideanDistance, kernel=kernelGaussian){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")
  
  for (i in 1:l){
    curObjClass = xl[i, n+1]
    d[curObjClass] <- d[curObjClass] + kernel(xl[i,1:n], z, metricFunction, h)
  }
  return (c(1,names(which.max(d))))
}

nearestNeighbour <- function(x, xl){
  min <- euclideanDistance(x,xl[1,1:2])
  minIris <- xl[1,1:2]
  for(i in 1:length(xl[,1])){
    if(euclideanDistance(x,xl[i,1:2]) < min){
      min <- euclideanDistance(x,xl[i,1:2])
      minIris <- xl[i,]
    }
  }
  return(minIris)
}

defence <- function(x, my_iris, Etalons){
  aliasClassIris = my_iris[my_iris$Species == x$Species & 
                           my_iris$Petal.Length != x$Petal.Length &
                           my_iris$Petal.Width != x$Petal.Width,]
  
  sum <- 0
  
  for(i in 1:length(aliasClassIris)){
    n = aliasClassIris[i,]
    z <- nearestNeighbour(n[,1:2], Etalons)
    
    sum = sum + fris(n[,1:2], x[,1:2], z[,1:2])
  }
  return(1 / length(aliasClassIris[,1]) * sum)
}

tolerance <- function(x, my_iris, Etalons){
  enemyClassesIris = my_iris[my_iris$Species != x$Species,]
  sum <- 0
  
  for(i in 1:length(enemyClassesIris)){
    m = enemyClassesIris[i,]
    z <- nearestNeighbour(m[,1:2], Etalons)
    sum = sum + fris(m[,1:2], x[,1:2], z[,1:2])
  }
  
  if(length(enemyClassesIris[,1]) == 0){
    return(sum)
  } else {
    return(1 / length(enemyClassesIris[,1]) * sum)
  }
}

efficiency <- function(lambda, def, tol){
  return(lambda*tol + (1-lambda)*def)
}

findEtalon <- function(Xy, Omega){
  x_max_eff = -10000000
  x_max = NA
  for(idx in 1:length(Xy[,1])){
    x = Xy[idx,]
    x_def = defence(x, Xy, Omega)
    x_tol = tolerance(x, Xy, Omega)
    
    x_eff = efficiency(0.5, x_def, x_tol)
    
    if(x_eff > x_max_eff){
      x_max_eff = x_eff
      x_max = x
    }
  }
  
  return(x_max)
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

findAccuracy <- function(learn_data ,data, classifMethod){
  accuracy = 0
  good_class <- data.frame()
  bad_class <- data.frame()
  
  for(i in c(1:length(data[,1]))){
    z <- data[i,1:2]
    classes = c('setosa','versicolor','virginica')
    class <- classifMethod(learn_data[,1:3], z)[2]
    
    data[i,5] = 'false'
    
    if(class == data[i,3]){
      # if(classes[as.integer(class)] == data[i,3]){
      data[i,5] = 'true'
      good_class <- data.frame(rbind(good_class, data[i,]))
      accuracy = accuracy + 1
    } else {
      bad_class <- data.frame(rbind(bad_class, data[i,]))
    }
  }
  
  colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue1")
  pchList <- c("true" = 21, "false" = 24, "train" = 23)
  plot(data[, 1:2],
       pch = pchList[data[,5]],
       col = colors[data$Species],
       xlab = 'petal length',
       ylab = 'petal width',
       main = 'parsen with gaussian kernel',
       asp=1
  )
  legend(1, 2.75, legend=c("right classified", "wrong classified", "support elements"),
         pt.bg=c(NA, NA, "black"), pch=c(21,24,21), cex=0.6, pt.cex = 1, text.width = 1)
  points(learn_data[,1:2], pch=21, bg=colors[learn_data$Species], col=colors[learn_data$Species])
  
  return(c(length(data[,1]) - accuracy, names(which.max(table(bad_class[,3])))))
}

fris_stolp <- function(my_iris, l0){
  etalonDF = data.frame(rbind(findEtalon(my_iris[my_iris$Species=='setosa',], my_iris[my_iris$Species!='setosa',]),
                              findEtalon(my_iris[my_iris$Species=='versicolor',], my_iris[my_iris$Species!='versicolor',]),
                              findEtalon(my_iris[my_iris$Species=='virginica',], my_iris[my_iris$Species!='virginica',])))
  
  
  while(TRUE){
    accArr <- findAccuracy(etalonDF, my_iris, parsen)
    
    print( paste(
      paste(length(etalonDF[,1]), ' |||| '),
      paste('false positive = ', accArr[1], '/', length(my_iris[,1]), ' = ', round(as.integer(accArr[1])/length(my_iris[,1]),3))
    ))
    
    if(as.integer(accArr[1]) < l0){
      break
    }
    
    className <- accArr[2]
    
    etalonDF <- data.frame(rbind(etalonDF, findEtalon(my_iris[my_iris$Petal.Length != etalonDF$Petal.Length && 
                                                              my_iris$Petal.Width != etalonDF$Petal.Width &&
                                                              my_iris$Petal.Length != etalonDF$Petal.Length &&
                                                              my_iris$Species == className] ,
                                                      etalonDF)))
  }
}

my_iris = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)

# print(nearestNeighbour(c(1,1), my_iris))
# print(fris(c(1,1),c(2,2),c(1,1)))

# print(tolerance(my_iris[1,], my_iris, learn_data))
# print(defence(my_iris[2,], my_iris, learn_data))

# print(fris(iris[1,1:2],iris[2,1:2],iris[3,1:2]))

fris_stolp(iris, 5)


