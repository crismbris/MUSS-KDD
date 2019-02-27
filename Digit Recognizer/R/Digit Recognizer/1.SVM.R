rm(list = ls())
#loading libraries
library("e1071")
library(data.table)

#loading datasets
train <- fread("train-kaggle.csv")
test <- fread("test.csv")


#remove zeros
train_orig <- train
test_orig <- test
library(caret) 
nzv.data <- nearZeroVar(train, saveMetrics = TRUE)
drop.cols <- rownames(nzv.data)[nzv.data$nzv == TRUE]
train <- train[,!names(train) %in% drop.cols]
test <- test[,!names(test) %in% drop.cols]

print("started modelling...")

rf_model <-svm(label ~ ., data = train, scaled = FALSE)  

rf_model
print("random forest trained.")
pred <- predict(rf_model, newdata = test)
pred_df <- data.frame(ImageId = 1:28000, Label = pred )
write.csv(pred_df, file = "svmResult.csv", row.names = FALSE)
