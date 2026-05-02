# Define the data
stock_data <- data.frame(
	sony = c(25.12, 24.09, 23.68, 22.28, 21.91,22.95, 22.5, 21.41, 21.99, 21.49, 20.38, 20.54, 20.05),
	ntes = c(140.15, 137.63, 130.27, 132.46, 120.21, 117.33, 118.51, 114.48, 115.92, 114.12, 115.85, 113.06, 110.22),
	ea = c(204.31, 204.01, 203.96, 203.75, 196.65, 202.05, 200.04, 201.79, 201.73, 199.92, 200.61, 202.34, 202.27),
	nflx = c(90.73, 88.55, 85.36, 84.64, 80.16, 79.62, 77.99, 82.7, 98.66, 94.89, 94.7, 92.28, 93.79),
	dis = c(112.91, 113.53, 113.19, 109.56, 107.05, 108.12, 107.1, 105.05, 103.04, 100.89, 99.42, 95.95, 94.76),
	cmsa = c(27.58, 28.09, 28.89, 28.41, 30.5, 32.48, 31.6, 30.79, 32.09, 30.57, 28.57, 28.73, 28.65),
	spot = c(569.62, 8.92, 2.19, 508.7, 440.53, 487.17, 477.58, 463.28, 534.09, 514.37, 516.72, 473.21, 476.78),
	lyv = c(143.96, 146.78, 139.71, 147.53, 142.46, 151.11, 155.78, 155.22, 158.64, 165.83, 156.47, 154.92, 149.82),
	wmg = c(29.6, 31.07, 29.67, 29.65, 28.02, 29.59, 29.06, 26.9, 28.29, 27.05, 24.6, 23.89, 24.22)
)

# Predicting Sony using the other 8 as inputs
model_1 <- lm(sony ~ ntes + ea + nflx + dis + cmsa + spot + lyv + wmg, data = stock_data)
summary(model_1)

# Checking for multicollinearity
library(car)
vif(model_1)
1/vif(model_1)

# Remove all columns with multicollinearity but one: dis, cmsa, wmg
model_2 <- lm(sony ~ ntes + ea + nflx + spot + lyv, data = stock_data)
summary(model_2)

# Checking for multicollinearity
vif(model_2)
1/vif(model_2)