
library("e1071")
library(data.table)

train <- fread("train-kaggle.csv")
test <- fread("test.csv")

## classification mode
# default with factor response:
model <- svm(label ~ ., data = train)

# alternatively the traditional interface:
x <- subset(train, select = -label)
y <- label
model <- svm(x, y) 

print(model)
summary(model)

# test with train data
pred <- predict(model, x)
# (same as:)
pred <- fitted(model)

# Check accuracy:
table(pred, y)
