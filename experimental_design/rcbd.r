data <- read.csv('~/Documents/stats-318-group-proj/experimental_design/STAT318 Project - RCBD Data.csv')

# RCBD
res.rcbd <- aov(Rating ~ PitchType + BusinessType, data = rcbd_data)
summary(res.rcbd)

tukey_results <- TukeyHSD(res.rcbd)

# CRD
res.crd <- aov(Rating ~ PitchType, data = rcbd_data)
summary(res.crd)

TukeyHSD(res.crd)

# Visualizations
ggplot(rcbd_data, aes(x = PitchType, y = Rating, group = BusinessType, color = BusinessType)) +
  stat_summary(fun = mean, geom = "line", linewidth = 1) +
  stat_summary(fun = mean, geom = "point", size = 3) +
  labs(title = "Interaction Plot: Pitch Type × Business Type",
       x = "Pitch Type", y = "Mean Rating", color = "Business Type") +
  theme_classic()

ggplot(rcbd_data, aes(x = BusinessType, y = Rating, fill = PitchType)) +
  stat_summary(fun = mean, geom = "bar", position = position_dodge(0.9)) +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               position = position_dodge(0.9), width = 0.25) +
  labs(title = "Mean Rating by Business Type and Pitch Type",
       x = "Business Type", y = "Mean Rating", fill = "Pitch Type") +
  theme_classic()

plot_data <- as.data.frame(tukey_results$PitchType)
plot_data$comparison <- rownames(plot_data)

ggplot(plot_data, aes(x = reorder(comparison, diff), y = diff)) +
  geom_point(size = 3, color = "steelblue") +
  geom_errorbar(aes(ymin = lwr, ymax = upr), width = 0.2, color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  coord_flip() +
  labs(title = "Tukey HSD: Pairwise Treatment Comparisons",
       x = "Comparison", y = "Difference in Mean Rating") +
  theme_classic()