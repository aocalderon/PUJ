library(tidyverse)
library(plotly)

# 1. Load data and fit logistic regression model
url <- "https://web.stanford.edu/~hastie/ElemStatLearn/datasets/SAheart.data"
sa_heart <- read_csv(url, show_col_types = FALSE) |>
  mutate(
    famhist_num = if_else(famhist == "Present", 1, 0),
    chd = factor(chd, levels = c(0, 1))
  )

fit <- glm(chd ~ age + famhist_num, data = sa_heart, family = binomial)

# 2. Create a dense grid for the probability prediction surface
age_seq <- seq(min(sa_heart$age), max(sa_heart$age), length.out = 40)
famhist_seq <- seq(0, 1, length.out = 40)
grid <- expand_grid(age = age_seq, famhist_num = famhist_seq)

# Compute predicted probabilities P(CHD = 1)
grid$prob <- predict(fit, newdata = grid, type = "response")
z_matrix <- matrix(grid$prob, nrow = length(age_seq), ncol = length(famhist_seq))

# 3. Build interactive 3D plot
plot_ly() |>
  # Sigmoid fitted surface
  add_surface(
    x = ~famhist_seq,
    y = ~age_seq,
    z = ~z_matrix,
    opacity = 0.85,
    colorscale = "Viridis",
    colorbar = list(title = "P(CHD = 1)")
  ) |>
  # Actual observed binary data points
  add_markers(
    data = sa_heart,
    x = ~famhist_num,
    y = ~age,
    z = ~as.numeric(as.character(chd)),
    color = ~chd,
    colors = c("#17BECF", "#E41A1C"),
    marker = list(size = 3.5, symbol = "circle", opacity = 0.8),
    name = "Observed"
  ) |>
  layout(
    scene = list(
      xaxis = list(title = "Family History (0 = Absent, 1 = Present)"),
      yaxis = list(title = "Age"),
      zaxis = list(title = "Probability / CHD Outcome")
    ),
    legend = list(title = list(text = "CHD Event"))
  )
