euclideanDistance <- function(u, v){
  return(sqrt(sum((u - v)^2)))
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
  return (names(which.max(d)))  
}

oneNN <- function(xl, z, metricFunction =euclideanDistance){
  
  min_dist = 1e15
  min_dist_class = 'setosa'
  
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  for (i in 1:l){
    tmp_dist =metricFunction(xl[i, 1:n], z)
    
    if(tmp_dist < min_dist) {
      min_dist = tmp_dist
      min_dist_class = xl[i, n+1]
    }
  }
  
  return (c(min_dist, min_dist_class))
}

kNN <- function(xl, z, k = 3){
  
  orderedXl <- sortObjectsByDist(xl, z)
  n <- dim(orderedXl)[2] - 1
  
  classes <- orderedXl[1:k, n + 1]
  
  counts <- table(classes)
  
  class <- which.max(counts)
  return (c(1,class))
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
    
    if(classes[as.integer(class)] == data[i,3]){
      data[i,5] = 'true'
      good_class <- data.frame(rbind(good_class, data[i,]))
      accuracy = accuracy + 1
    } else {
      bad_class <- data.frame(rbind(bad_class, data[i,]))
    }
  }
  
  colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue1")
  pchList <- c("true" = 21, "false" = 17, "train" = 23)
  plot(data[, 1:2],
       pch = pchList[data[,5]],
       bg = colors[data$Species],
       col = colors[data$Species],
       xlab = 'petal length',
       ylab = 'petal width',
       main = 'parsen with gaussian kernel',
       asp=1
  )
  legend(1, 2.75, legend=c("right classified", "wrong classified", "support elements"),
         pt.bg=c(NA, NA, "orange"), pch=c(19,17,21), cex=0.6, pt.cex = 1, text.width = 1)
  points(learn_data[,1:2], pch=21, bg="orange", col=colors[learn_data$Species])
  
  return(c(length(data[,1]) - accuracy, names(which.max(table(bad_class[,3])))))
}

paintClassificationCard <- function(my_iris){
  colors <- c("setosa" = "red", "versicolor" = "green3",
              "virginica" = "blue")
  plot(my_iris[, 1:2],
       pch = 21,
       bg = colors[my_iris$Species],
       col = colors[my_iris$Species],
       xlab = 'petal length',
       ylab = 'petal width',
       main = '1NN',
       asp=1
  )
  points_array = c()
  
  step <- 0.5
  
  for (xtmp in seq(0, 7, by=step)){
    for (ytmp in seq(0, 3, by=step)){
      z <- c(xtmp,ytmp)
      class <- oneNN(my_iris, z)[2]
      points_array = c(points_array, c(z))
      points(z[1], z[2], pch = 1, col = colors[class])
    }
  }
}

distanceToClasses <- function(x, my_iris){
  his_class <- my_iris[my_iris$Species == x$Species &
                         my_iris$Petal.Length != x$Petal.Length &
                         my_iris$Petal.Width != x$Petal.Width, ]
  alien_class <- my_iris[my_iris$Species != x$Species &
                           my_iris$Petal.Length != x$Petal.Length &
                           my_iris$Petal.Width != x$Petal.Width, ]
  
  min_dist_to_his_class <- oneNN(his_class, x[,1:2])[1]
  min_dist_to_alien_class <- oneNN(alien_class, x[,1:2])[1]

  return(c(min_dist_to_his_class, min_dist_to_alien_class))
}

riskFunction <- function(x, my_iris){
  
  distances = distanceToClasses(x, my_iris)
  
  distIn = distances[1] # distance to nearest element from his class
  distOut = distances[2] # distance to nearest element from alien class
  # return(distIn/distOut)
  return(margin(x, my_iris, 3))
}

margin <- function(x, my_iris, k) {
  # ## kNN
  # orderedXl <- sortObjectsByDist(my_iris, x[,1:2])
  # 
  # n <- dim(orderedXl)[2] - 1
  # 
  # classes <- orderedXl[1:k, n + 1]
  # 
  # counts <- table(classes)
  # 
  # n <- length(counts)
  # sortedCounts = sort(counts,partial=n-1)
  # 
  # return(sortedCounts[n] - sortedCounts[n-1])
  # ##
  
  l <- dim(my_iris)[1]
  n <- dim(my_iris)[2] - 1

  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")

  for (i in 1:l){
    curObjClass = my_iris[i, n+1]
    d[curObjClass] <- d[curObjClass] + kernelGaussian(my_iris[i,1:2], x[,1:2], metricFunction=euclideanDistance, h=0.1)
  }

  sortedCounts = sort(d)
  
  return(sortedCounts[3] - sortedCounts[2])
}

countSigma <- function(my_iris, riskFunc) {
  
  # draw plot of margins
  
  sortedRiskVector <- sort(my_iris[,4])
  sigma <- sortedRiskVector[6]
  
  plotTitle <- paste('parsen with gaussian kernel \n sigma =', round(sigma, 3))
  plot(sortedRiskVector, pch=20, xlab='iris', ylab='margin', main=plotTitle)

  lines(sortedRiskVector, pch=16)
  lines(c(-100,250), c(sigma,sigma), pch=16, col='red')

  print(paste0('sigma = ', round(sigma, 3)))
  
  return(sigma)
}

stolp <- function(my_iris, l0, classifMethod=kNN, riskFunc=riskFunction){
  
  # #1 count risk vector and append it to data
  
  risk_vector <- c()
  
  for(i in 1:dim(my_iris)[1]){
    risk_vector <- c(risk_vector,riskFunc(my_iris[i,], my_iris))
  }
  my_iris = cbind(my_iris, risk_vector)
  
  # #2 delete noise ibjects
  
  sigma <- countSigma(my_iris, riskFunc)
  print(paste0('sigma = ', round(sigma, 3)))
  
  my_iris_without_noiseObjesct <- my_iris[my_iris[,dim(my_iris)[2]] > sigma, ]
  
  
  # #3 finding elements from each class with minimal resk
  
  setosaDF = my_iris_without_noiseObjesct[my_iris_without_noiseObjesct[,dim(my_iris)[2]-1] == 'setosa',]
  setosaMin <- setosaDF[which.min(setosaDF[,dim(my_iris)[2]]), ]
  # print(setosaMin)
  
  versicolorDF = my_iris_without_noiseObjesct[my_iris_without_noiseObjesct[,dim(my_iris)[2]-1] == 'versicolor',]
  versicolorMin <- versicolorDF[which.min(setosaDF[,dim(my_iris)[2]]), ]
  # print(versicolorMin)
  
  virginicaDF = my_iris_without_noiseObjesct[my_iris_without_noiseObjesct[,dim(my_iris)[2]-1] == 'virginica',]
  virginicaMin <- virginicaDF[which.min(setosaDF[,dim(my_iris)[2]]), ]
  # print(virginicaMin)
  
  learn_data <- data.frame(rbind(setosaMin, versicolorMin, virginicaMin))
  
  # #4 add element to learn_data
  while(TRUE){
    accArr <- findAccuracy(learn_data, my_iris, classifMethod)
    
    print( paste(
      paste(length(learn_data[,1]), ' |||| '),
      paste('false positive = ', accArr[1], '/', length(my_iris[,1]), ' = ', round(as.integer(accArr[1])/length(my_iris[,1]),3))
    ))
    
    if(as.integer(accArr[1]) < l0){
      break
    }
    
    if(accArr[2] == 'versicolor'){
      maxIndex = which.max(versicolorDF[, dim(my_iris)[2]])
      learn_data <- data.frame(rbind(learn_data, versicolorDF[maxIndex, ]))
      versicolorDF <- versicolorDF[-maxIndex, ]
    } else if(accArr[2] == 'setosa'){
      maxIndex = which.max(setosaDF[, dim(my_iris)[2]])
      learn_data <- data.frame(rbind(learn_data, setosaDF[maxIndex, ]))
      setosaDF <- setosaDF[-maxIndex, ]
    } else {
      maxIndex = which.max(virginicaDF[, dim(my_iris)[2]])
      learn_data <- data.frame(rbind(learn_data, virginicaDF[maxIndex, ]))
      virginicaDF <- virginicaDF[-maxIndex, ]
    }
    
  }

  print(paste0('accuracy = ', 1 - as.integer(findAccuracy(learn_data, my_iris, classifMethod)[1]) / length(my_iris[,1]) ))
  
  start <- Sys.time()
  for(idx in 1:150){
    parsen(learn_data[, 1:3], my_iris[idx,1:2])
  }
  print(Sys.time() - start)
}

my_iris = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)
# my_iris = iris[, 3:5]

# printAccuracy(my_iris)
# paintClassificationCard(my_iris)
stolp(my_iris, 5, classifMethod = kNN)
# margin(my_iris[20, ], my_iris, 3)
