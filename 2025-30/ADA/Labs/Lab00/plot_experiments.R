library(tidyverse) # this library is a God's blessing...

# read the output of my experiment and name the columns...
data = read_tsv("experiment.tsv", col_names = c("method", "size", "time")) |> 
  # as we performed 5 runs we must get the average for each method and size...
  group_by(method, size) |> summarise(time = mean(time))

# let's plot the data, in the x axis the array' sizes and...
# in the y axis the execution time...
# grouped by the two methods (algorithms): Insertion and Merge sorts...
p = ggplot(data, aes(x = as.factor(size), y = time, group = method)) +
  geom_line(aes(linetype = method, color = method)) +              # let's draw lines...
  geom_point(aes(shape = method, color = method), size = 3) +      # and points...
  labs(x="Array' size (number of integers)", y="Time(s)") +        # name the axis
  scale_color_discrete("Method") +                                 # we need this to rename the legend title...
  scale_shape_discrete("Method") +
  guides(linetype = "none") +
  theme_bw()                                                       # let's try a sober theme...
plot(p)  # this command create the plot...

W = 6
H = 4
# save the plot as PDF with these dimensions...
ggsave("figure.pdf", width = W, height = H)