library("ggplot2")
pitch_rank_data <- read.csv("one_way_anova.csv") # missing values filled via mean of category

single_model <- aov(rating~pitch, data=pitch_rank_data)
summary(single_model)
plot(TukeyHSD(single_model))

# boxplots of different pitch type means
ggplot(pitch_rank_data, aes(x = factor(pitch), y = rating)) +
  geom_boxplot(fill = "steelblue") +
  stat_summary(fun = "mean", geom = "point", shape = 18, size = 3, color = "white") +
  labs(title = "Difference in Ratings Across Pitch Types", x = "Pitch Type", y = "Rating")


res <- data.frame(residuals(single_model))
colnames(res) <- c("residuals")

# bar graph of ANOVA residuals 
ggplot(res, aes(x = residuals)) +
  geom_histogram(fill = "deeppink3") +
  labs(title = "Distribution of ANOVA Residuals", x = "Residuals", y = "Total Count")

# QQ-plot of ANOVA residuals 
ggplot(res, aes(sample = residuals)) +
  stat_qq_line(color = "steelblue", linewidth = 2) +
  stat_qq(color = "red", size = 2) +
  labs(title = "QQ-Plot of ANOVA Residuals", x = "Theoretical Quantile", y = "Sample Quantile")

# bar graph of different pitch type variances
ggplot(pitch_rank_data, aes(x = factor(pitch), y = rating)) +
  stat_summary(fun = var, geom = "bar", fill = "deeppink3") +
  labs(title = "Difference in Variance", x = "Pitch Type", y = "Rating Variance")