# check the distribution of our dataset
library(arrow)
library(ggplot2)

# parquet file is in parent directory
data = read_parquet("stock_data.parquet")

head(data)

tickers = c("SONY", "EA", "NTES", "NFLX", "DIS", "CMSA", "SPOT", "LYV", "WMG")

filtered_data = data[data$Ticker %in% tickers, ]

# qq plots for open, close, intraday_action_pct

# open
open = ggplot(filtered_data, aes(sample = Open)) +
  stat_qq(color = "steelblue") +
  stat_qq_line(color = "red") +
  facet_wrap(~ Ticker, scales = "free") +
  theme_minimal() +
  labs(title = "QQ Plot of Open Price by Ticker",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

print(open)

# close
close = ggplot(filtered_data, aes(sample = Close)) +
  stat_qq(color = "forestgreen") +
  stat_qq_line(color = "red") +
  facet_wrap(~ Ticker, scales = "free") +
  theme_minimal() +
  labs(title = "QQ Plot of Close Price by Ticker",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

print(close)

# intraday_action_pct
intraday_action_pct = ggplot(filtered_data, aes(sample = Intraday_Action_Pct)) +
  stat_qq(color = "purple") +
  stat_qq_line(color = "red") +
  facet_wrap(~ Ticker, scales = "free") +
  theme_minimal() +
  labs(title = "QQ Plot of Intraday_Action_Pct by Ticker",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

print(intraday_action_pct)

# intraday_action_pct but for all stocks 
intraday_action_pct_all = ggplot(filtered_data, aes(sample = Intraday_Action_Pct)) +
  stat_qq(color = "darkorange") +
  stat_qq_line(color = "red") +
  theme_minimal() +
  labs(title = "QQ Plot of All Intraday_Action_Pct (All Stocks)",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

print(intraday_action_pct_all)