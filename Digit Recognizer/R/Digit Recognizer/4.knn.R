rm(list = ls())


#loading libraries
library(class)
library(data.table)

#loading datasets
train <- fread("train-kaggle.csv")
test <- fread("test.csv")
train[, 1] <- as.factor(train[, 1]$label)  # As Category

#preapring
train_orig <- train
test_orig <- test
set.seed(43210)
trainIndex <- createDataPartition(train$label, p = 0.1, list = FALSE, times = 1)
allindices <- c(1:42000)
training <- train[trainIndex,]
validating <- train[-trainIndex,]
vali0_index <- allindices[! allindices %in% trainIndex]
validIndex <- createDataPartition(validating$label, p = 0.11, list = FALSE, times = 1)
validating <- validating[validIndex,]
original_validindex <- vali0_index[validIndex]

#fnn
library(FNN)
fnn.kd1 <- FNN::knn(train[,-1], validating[,-1], training$label, k=5, algorithm = c("kd_tree"))
fnn.kd.pred1 <- as.numeric(fnn.kd1)-1
fnn.kd2 <- FNN::knn(training2[,-1], validating2[,-1], training2$label, k=5, algorithm = c("kd_tree"))
fnn.kd.pred2 <- as.numeric(fnn.kd2)-1
fnn.kd3 <- FNN::knn(training3[,-1], validating3[,-1], training3$label, k=5, algorithm = c("kd_tree"))
fnn.kd.pred3 <- as.numeric(fnn.kd3)-1

