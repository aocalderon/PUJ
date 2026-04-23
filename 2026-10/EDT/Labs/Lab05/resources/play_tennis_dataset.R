# Load necessary libraries
library(rpart)
library(rpart.plot)

# Load the dataset
tennis_data <- read.csv("play_tennis_dataset.csv")

# Remove the 'Day' column (unnecessary for prediction)
tennis_data$Day <- NULL

# Build the decision tree model
# Method "class" is used for classification
model <- rpart(PlayTennis ~ ., 
               data = tennis_data, 
               method = "class",
               control = rpart.control(cp = 0,       # No minimum improvement 
                                       minsplit = 2, # Split even with 2 samples
                                       maxdepth = 2  # Limit to 2 levels deep
                                       )) 

# View the basic structure
print(model)

# Visualize the decision-making process
rpart.plot(model,
           type = 2,
           extra = 101,
           under = TRUE,
           box.palette = "GnYlRd",
           main = "Play Tennis Decision Logic")

# Create a new weather scenario
new_weather <- data.frame(
  Outlook = "Rain",
  Temperature = "Mild",
  Humidity = "High",
  Wind = "Weak"
)

# Generate prediction
res <- predict(model, new_weather, type = "class")
cat("Prediction for the new day:", as.character(res))
