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
  return (c(1,names(which.max(d))))
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

riskFunction <- function(x, my_iris){
  return(margin(x, my_iris))
}

margin <- function(x, my_iris) {
  l <- dim(my_iris)[1]
  n <- dim(my_iris)[2] - 1
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")
  
  for (i in 1:l){
    curObjClass = my_iris[i, n+1]
    d[curObjClass] <- d[curObjClass] + kernelGaussian(my_iris[i,1:2], x[,1:2], metricFunction=euclideanDistance, h=0.1)
  }
  
  namesD = names(d)
  
  dCur <- which(namesD %in% x$Species)
  
  sortedCounts = sort(d[-dCur])
  
  return(d[x[, 3]] - sortedCounts[2])
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
  
  
  # #3 finding elements from each class with minimal risk
  
  my_iris_without_learn_data <- my_iris_without_noiseObjesct
  
  learn_data <- data.frame()
  
  for(i in unique(iris$Species)){
    curDF <- my_iris_without_noiseObjesct[my_iris_without_noiseObjesct[,dim(my_iris)[2]-1] == i,]
    classMin <- curDF[which.min(curDF[,dim(my_iris)[2]]), ]
    curDF <- curDF[-which.min(curDF[,dim(my_iris)[2]]), ]
    learn_data <- rbind(learn_data, classMin)
  }

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
    
    className <- accArr[2]
    curClassDF <- my_iris_without_learn_data[my_iris_without_learn_data$Species == className, ]
    
    maxIndex <- which.max(curClassDF[, dim(my_iris)[2]])
    print(curClassDF[maxIndex, ])
    
    learn_data <- data.frame(rbind(learn_data, curClassDF[maxIndex, ]))
    
    my_iris_without_learn_data <- my_iris_without_learn_data[-maxIndex, ]

  }

  print(paste0('accuracy = ', 1 - as.integer(findAccuracy(learn_data, my_iris, classifMethod)[1]) / length(my_iris[,1]) ))

  start <- Sys.time()
  for(idx in 1:150){
    parsen(learn_data[, 1:3], my_iris[idx,1:2])
  }
  print(Sys.time() - start)
}

# my_iris = read.table("/Users/khurshudov/Desktop/SMPR/metric_classification/iris30.txt", sep="\t", header=TRUE)
my_iris = iris[, 3:5]

# printAccuracy(my_iris)
# paintClassificationCard(my_iris)
stolp(my_iris, 5, classifMethod = parsen)

# margin(my_iris[1], my_iris, 3)
