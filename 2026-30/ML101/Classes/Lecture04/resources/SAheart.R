library(tidyverse)

# 1. Load data directly into a tibble
url <- "https://web.stanford.edu/~hastie/ElemStatLearn/datasets/SAheart.data"
sa_heart <- read_csv(url, show_col_types = FALSE)

# 2. Variable order from the figure
vars <- c("sbp", "tobacco", "ldl", "famhist", "obesity", "alcohol", "age")

# 3. Clean and prepare individual observations
set.seed(42)
df_clean <- sa_heart |>
  mutate(
    id = row_number(),
    famhist = if_else(famhist == "Present", 1, 0) + runif(n(), -0.04, 0.04),
    chd = factor(chd, levels = c(0, 1))
  ) |>
  select(id, chd, all_of(vars))

# 4. Reshape into pairwise grid via tidyverse joins
df_long <- df_clean |>
  pivot_longer(
    cols = all_of(vars),
    names_to = "var",
    values_to = "val"
  )

# Combine every variable against every other per row ID
df_pairs <- expand_grid(var_x = vars, var_y = vars) |>
  inner_join(df_long, by = c("var_x" = "var"), relationship = "many-to-many") |>
  rename(val_x = val) |>
  inner_join(df_long, by = c("id", "chd", "var_y" = "var")) |>
  rename(val_y = val) |>
  mutate(
    var_x = factor(var_x, levels = vars),
    var_y = factor(var_y, levels = vars)
  )

# 5. Diagonal labels tibble
df_labels <- tibble(
  var_x = factor(vars, levels = vars),
  var_y = factor(vars, levels = vars),
  label = vars
)

# 6. Plot the matrix
p <- df_pairs |>
  filter(var_x != var_y) |>
  ggplot(aes(x = val_x, y = val_y, color = chd, data_for_plotting)) +
  geom_point(shape = 1, size = 1.1, stroke = 0.5) +
  geom_text(
    data = df_labels,
    aes(x = -Inf, y = -Inf, label = label),
    hjust = -0.5,
    vjust = -0.5,
    inherit.aes = FALSE,
    size = 4.5,
    color = "black"
  ) +
  scale_color_manual(values = c("0" = "#17BECF", "1" = "#E41A1C")) +
  facet_grid(var_y ~ var_x, scales = "free") +
  theme_bw(base_size = 11) +
  theme(
    legend.position = "none",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92", linewidth = 0.3),
    strip.background = element_blank(),
    strip.text = element_blank(),
    panel.spacing = unit(0.1, "lines"),
    axis.text = element_text(size = 7, color = "grey20"),
    axis.title = element_blank()
  )

# Save to PDF
ggsave(
  filename = "SAheart_pairs_plot.pdf",
  plot = p,
  device = "pdf",
  width = 10,
  height = 10,
  units = "in"
)
