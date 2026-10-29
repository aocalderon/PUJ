# Install and load the library
if(!require(neuralnet)) install.packages("neuralnet")
library(neuralnet)

# Using the built-in iris dataset
data(iris)

# Binary classification: Is the species "setosa"?
iris$is_setosa <- ifelse(iris$Species == "setosa", 1, 0)

# Normalization to [0, 1] range
maxs <- apply(iris[, 1:4], 2, max)
mins <- apply(iris[, 1:4], 2, min)
scaled <- as.data.frame(scale(iris[, 1:4], center = mins, scale = maxs - mins))
final_data <- cbind(scaled, is_setosa = iris$is_setosa)

# Splitting into Training (70%) and Test (30%)
set.seed(42)
index <- sample(1:nrow(final_data), 0.7 * nrow(final_data))
train_set <- final_data[index, ]
test_set <- final_data[-index, ]

# Training a network with one hidden layer of 3 units
# This is a two-layer neural network (input layer not counted)
nn <- neuralnet(is_setosa ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
                data = train_set,
                hidden = 3,
                linear.output = FALSE)

# Plotting the network architecture
plot(nn)

# Prediction on test data
results <- compute(nn, test_set[, 1:4])
predictions <- ifelse(results$net.result > 0.5, 1, 0)

# Confusion Matrix and Accuracy
conf_matrix <- table(Actual = test_set$is_setosa, Predicted = predictions)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)

print(conf_matrix)
print(paste("Test Accuracy: ", round(accuracy, 4)))

# New tuple: SL=5.0, SW=3.4, PL=1.5, PW=0.2
new_tuple <- data.frame(Sepal.Length=5.0, Sepal.Width=3.4, Petal.Length=1.5, Petal.Width=0.2)
new_scaled <- as.data.frame(scale(new_tuple, center = mins, scale = maxs - mins))

# Compute prediction
pred_new <- compute(nn, new_scaled)
print(paste("Probability of Setosa: ", round(pred_new$net.result, 4)))

