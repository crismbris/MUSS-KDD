rm(list = ls())


#loading libraries
library(party)
library(data.table)

#loading datasets
train <- fread("train-kaggle.csv")
test <- fread("test.csv")

print("started modelling...")

train$label <- factor(train$label)
rf_model <- ctree(data = train, label ~ .)

print("random forest trained.")
pred <- predict(rf_model, newdata = test)
pred_df <- data.frame(ImageId = 1:28000, Label = pred )
write.csv(pred_df, file = "deccisionTreeResult.csv", row.names = FALSE)
