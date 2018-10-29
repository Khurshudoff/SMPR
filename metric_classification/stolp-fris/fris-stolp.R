euclideanDistance <- function(u, v){
  return(sqrt(sum((u - v)^2)))
}

fris <- function(a, b, x, ro = euclideanDistance){
  (ro(a,x) - ro(a,b)) / (ro(a,x) + ro(a,b))
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
  
  return(1 / length(enemyClassesIris[,1]) * sum)
}

my_iris = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)

# print(nearestNeighbour(c(1,1), my_iris))
# print(fris(c(1,1),c(2,2),c(1,1)))

setosaDF = my_iris[my_iris$Species == 'setosa',]
setosaMin <- setosaDF[which.min(setosaDF[,dim(my_iris)[2]]), ]
# print(setosaDF)

versicolorDF = my_iris[my_iris$Species == 'versicolor',]
versicolorMin <- versicolorDF[which.min(setosaDF[,dim(my_iris)[2]]), ]
# print(versicolorMin)

virginicaDF = my_iris[my_iris$Species == 'virginica',]
virginicaMin <- virginicaDF[which.min(setosaDF[,dim(my_iris)[2]]), ]
# print(virginicaMin)

learn_data <- data.frame(rbind(setosaMin, versicolorMin, virginicaMin))
# print(tolerance(my_iris[1,], my_iris, learn_data))
print(defence(my_iris[2,], my_iris, learn_data))

# print(fris(iris[1,1:2],iris[2,1:2],iris[3,1:2]))