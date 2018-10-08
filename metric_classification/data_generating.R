iris300 = iris[sample(c(1:150), 30, replace=FALSE),c(1,4,5)]
write.table(iris300,"/Users/khurshudov/Desktop/SMPR/metric_classification/iris30_test.txt", sep="\t")