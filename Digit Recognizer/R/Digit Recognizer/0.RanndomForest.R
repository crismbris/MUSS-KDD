rm(list = ls())

library("randomForest", lib.loc="~/R/win-library/3.4")
library(readr)
train <- read_csv("grises_out.csv")
test <- read_csv("test.csv")


train[, 1] <- as.factor(train[, 1]$label)  # As Category



#remove zeros
train_orig <- train
test_orig <- test
library(caret) 
"nzv.data <- nearZeroVar(train, saveMetrics = TRUE)
drop.cols <- rownames(nzv.data)[nzv.data$nzv == TRUE]
train <- train[,!names(train) %in% drop.cols]
test <- test[,!names(test) %in% drop.cols]"

#explorations
library(RColorBrewer)
BNW <- c("white", "black")
CUSTOM_BNW <- colorRampPalette(colors = BNW)

par(mfrow = c(4, 3), pty = "s", mar = c(1, 1, 1, 1), xaxt = "n", yaxt = "n")
images_digits_0_9 <- array(dim = c(10, 14 * 14))
for (digit in 0:9) {
  images_digits_0_9[digit + 1, ] <- apply(train_orig[train_orig[, 1] == digit, -1], 2, sum)
  images_digits_0_9[digit + 1, ] <- images_digits_0_9[digit + 1, ]/max(images_digits_0_9[digit + 1, ]) * 255
  z <- array(images_digits_0_9[digit + 1, ], dim = c(14, 14))
  z <- z[, 14:1]
  image(1:14, 1:14, z, main = digit, col = CUSTOM_BNW(196))
}

train [2,]
print("started modelling...")

rf_model <- randomForest(data = train, label ~ ., ntree = 30, do.trace = 10)
rf_model

print("random forest trained.")
pred <- predict(rf_model, newdata = test)
pred_df <- data.frame(ImageId = 1:28000, Label = pred )
pred
write.csv(pred_df, file = "randomForestResult.csv", row.names = FALSE)
