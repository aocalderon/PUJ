# run the below line just one time...
# install.packages(c("rpart", "rpart.plot", "caTools", "ggplot2", "dplyr"))
library(rpart)
library(rpart.plot)
library(caTools)
library(ggplot2)
library(dplyr)

# Loading the Advertisement dataset
dataset <- read.csv("Advertisement.csv")
head(dataset, 10)

# Convert target variable to factor
dataset$Purchased <- factor(dataset$Purchased, levels = c(0, 1))
# Splitting dataset
set.seed(42)
split <- sample.split(dataset$Purchased, SplitRatio = 0.75)
training_set <- subset(dataset, split == TRUE)
test_set <- subset(dataset, split == FALSE)

# Normalize numerical features
training_set[c("Age", "EstimatedSalary")] <- scale(training_set[c("Age", "EstimatedSalary")])
test_set[c("Age", "EstimatedSalary")] <- scale(test_set[c("Age", "EstimatedSalary")])
head(training_set, 5)
head(test_set, 5)

# Fitting Decision Tree to the Training set
classifier <- rpart(formula = Purchased ~ Age + EstimatedSalary,
                    data = training_set,
                    method = "class")

# Decision tree
rpart.plot(classifier,
           type = 2,
           extra = 101,
           under = TRUE,
           box.palette = "BlGnYl",
           main = "Ad Decision Logic")

# Predicting the Test set results
y_pred <- predict(classifier, newdata = test_set[-5], type = "class")

# Creating the Confusion Matrix
cm <- table(test_set[, 5], y_pred)
print(cm)
# Accuracy calculation
accuracy <- sum(diag(cm)) / sum(cm)
print(paste("Model Accuracy: ", round(accuracy, 2)))

cm_df <- as.data.frame(cm)
colnames(cm_df) <- c("Actual", "Predicted", "Freq")

matrix <- ggplot(cm_df, aes(x = Predicted, y = Actual)) +
  geom_tile(aes(fill = Freq), color = "white") +
  geom_text(aes(label = Freq), vjust = 0.5, fontface = "bold", size = 5) +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  labs(title = "Confusion Matrix", x = "Predicted Label", y = "Actual Label") +
  theme_minimal()
plot(matrix)