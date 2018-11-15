# library(dict)
data <- read.csv('/Users//khurshudov/Desktop/SMPR/bayes/naive_bayes/names.csv')
data = data[,2:3]

small_data = data[1:100,]

train <- function(samples){
  classes <- list()
  freq <- list()
  
  for(idx in 1:length(small_data[,1]) ){
    feats <- small_data[idx,1]
    label <- small_data[idx,2]
    
    classes[label] <- classes[label] + 1
  }
  
}

# classify <- function(classifier, feats){
#   classes = classifier[1]
#   prob = classifier[2]
#   
#   for(feat in feats){
#     
#   }
# }

log(2)
