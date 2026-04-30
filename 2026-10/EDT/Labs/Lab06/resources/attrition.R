# Helper packages
library(dplyr)    # for data wrangling
library(ggplot2)  # for awesome graphics
library(modeldata)  # for data splitting

# Modeling packages
library(caret)    # for classification and regression training
library(kernlab)  # for fitting SVMs

# Model interpretability packages
library(pdp)      # for partial dependence plots, etc.
library(vip)      # for variable importance plots

# Load attrition data
df <- attrition %>%
  mutate_if(is.ordered, factor, ordered = FALSE)

# Create training (70%) and test (30%) sets
set.seed(42)  # for reproducibility
churn_split <- initial_split(df, prop = 0.7, strata = "Attrition")
churn_train <- training(churn_split)
churn_test  <- testing(churn_split)

# Linear (i.e., soft margin classifier)
caret::getModelInfo("svmLinear")$svmLinear$parameters
##   parameter   class label
## 1         C numeric  Cost

# Polynomial kernel
caret::getModelInfo("svmPoly")$svmPoly$parameters
##   parameter   class             label
## 1    degree numeric Polynomial Degree
## 2     scale numeric             Scale
## 3         C numeric              Cost

# Radial basis kernel
caret::getModelInfo("svmRadial")$svmRadial$parameters
##   parameter   class label
## 1     sigma numeric Sigma
## 2         C numeric  Cost

# Example: Training an SVM with a Radial Basis Kernel
# 'attrition' dataset assumed to be pre-loaded

# Tune an SVM with radial basis kernel

set.seed(42)
churn_svm <- train(
  Attrition ~ .,
  data = churn_train,
  method = "svmRadial",
  preProcess = c("center", "scale"),
  trControl = trainControl(method = "cv", number = 10),
  tuneLength = 10
)

# View tuning results
print(churn_svm$results)

# Plot results
g <- ggplot(churn_svm) + theme_light()
plot(g)
