library("ggplot2")
pitch_rank_data <- read.csv("one_way_anova.csv") # missing values filled via mean of category

single_model <- aov(rating~pitch, data=pitch_rank_data)
summary(single_model)
TukeyHSD(single_model)

ggplot(pitch_rank_data, aes(x = factor(pitch), y = rating)) +
  geom_boxplot(fill = "blue") +
  stat_summary(fun = "mean", geom = "point", shape = 18, size = 3, color = "white")