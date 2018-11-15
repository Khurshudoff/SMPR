data <- read.csv('/Users//khurshudov/Desktop/SMPR/bayes/naive_bayes/names.csv')

small_data = data[1:3,2:3]

small_data[1,1] <- list('a'=1, 'b'=2)
small_data[1,2] <- list('a'=11, 'b'=22)
small_data[1,3] <- list('a'=111, 'b'=222)

for(idx in 1:length(small_data[,1]) ){
  print(idx)
  print(small_data[idx,1])
}