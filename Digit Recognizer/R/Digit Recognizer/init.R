library(readr)
train <- read_csv("train-kaggle.csv")
test <- read_csv("test.csv")

train[, 1] <- as.factor(train[, 1]$label)  # As Category


#remove zeros
train_orig <- train
test_orig <- test
library(caret) 
nzv.data <- nearZeroVar(train, saveMetrics = TRUE)
drop.cols <- rownames(nzv.data)[nzv.data$nzv == TRUE]
train <- train[,!names(train) %in% drop.cols]
test <- test[,!names(test) %in% drop.cols]

train


#explorations
library(RColorBrewer)
BNW <- c("white", "black")
CUSTOM_BNW <- colorRampPalette(colors = BNW)

par(mfrow = c(4, 3), pty = "s", mar = c(1, 1, 1, 1), xaxt = "n", yaxt = "n")
images_digits_0_9 <- array(dim = c(10, 28 * 28))
for (digit in 0:9) {
  images_digits_0_9[digit + 1, ] <- apply(train_orig[train_orig[, 1] == digit, -1], 2, sum)
  images_digits_0_9[digit + 1, ] <- images_digits_0_9[digit + 1, ]/max(images_digits_0_9[digit + 1, ]) * 255
  z <- array(images_digits_0_9[digit + 1, ], dim = c(28, 28))
  z <- z[, 28:1]
  image(1:28, 1:28, z, main = digit, col = CUSTOM_BNW(256))
}



et.seed(43210)
trainIndex <- createDataPartition(train$label, p = 0.1, list = FALSE, times = 1)
allindices <- c(1:42000)
training <- train[trainIndex,]
validating <- train[-trainIndex,]
vali0_index <- allindices[! allindices %in% trainIndex]
validIndex <- createDataPartition(validating$label, p = 0.11, list = FALSE, times = 1)
validating <- validating[validIndex,]
original_validindex <- vali0_index[validIndex]

#RandomForest

library(randomForest)
rf_model <- randomForest(data = train, label ~ ., ntree = 20, do.trace = 1)

print("random forest trained.")
pred <- predict(rf_model, newdata = test)
pred_df <- data.frame(ImageId = 1:28000, Label = pred )
write.csv(pred_df, file = "randomForestResult.csv", row.names = FALSE)

#decision tree
library(party)
rf_modelTree <- ctree(data = train, label ~ .)

print("random forest trained.")
predTree <- predict(rf_modelTree, newdata = test)
SVMRadial_predict1 <- as.numeric(predict(rf_modelTree,newdata = test))-1
pred_dfTree <- data.frame(ImageId = 1:28000, Label = predTree )
write.csv(pred_dfTree, file = "decisionTreeResult.csv", row.names = FALSE)
confusionMatrix(SVMRadial_predict1, validating$label)
