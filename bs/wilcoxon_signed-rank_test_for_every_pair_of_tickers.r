# Basic Statistical Inference

# arrow let's us read parquet files
library(arrow)

# parquet file is in parent directory
data = read_parquet("stock_data.parquet")

head(data)

# 
# please read the markdown file
# in this directory for an explanation of what is
# about to happen
tickers = c("SONY", "EA", "NTES", "NFLX", "DIS", "CMSA", "SPOT", "LYV", "WMG")

filtered_data = data[data$Ticker %in% tickers, c("Date", "Ticker", "Intraday_Action_Pct")]

# timevar differentiates multiple records from the same group.
# idvar is the name of a variable which connects multiple records to the same group
returns = reshape(
  filtered_data,
  idvar = "Date",
  timevar = "Ticker",
  direction = "wide"
)

effect_size = function(ticker_a, ticker_b, df) {
  col_a = paste0("Intraday_Action_Pct.", ticker_a)
  col_b = paste0("Intraday_Action_Pct.", ticker_b)
  
  
  x_raw = df[[col_a]]
  y_raw = df[[col_b]]
  
  valid_pairs = which(!is.na(x_raw) & !is.na(y_raw))
  
  if (length(valid_pairs) == 0) return(NA,NA)
  
  # only take valid pairs
  x = x_raw[valid_pairs]
  y = y_raw[valid_pairs]
  
  test = wilcox.test(x, y, paired = T, exact = F)
  
  diffs = x-y
  diffs = diffs[diffs != 0]
  n = length(diffs)
  
  if (n == 0) return(0,1)
  
  magnitude = abs(qnorm(test$p.value / 2))
  direction = sign(median(diffs))
  z = magnitude * direction
  
  return(c(r = z/sqrt(n), p = test$p.value))
}

results = expand.grid(Ticker_A = tickers, Ticker_B = tickers, stringsAsFactors = F)
results = results[results$Ticker_A != results$Ticker_B, ]

m = mapply(
  effect_size,
  results$Ticker_A,
  results$Ticker_B,
  MoreArgs = list(df = returns)
)

m = t(m)

results$r = m[, "r"]
results$p = m[, "p"]

# bonferroni correction: threshold = 0.05/36
# we have used an uncorrected threshold (0.05)
# threshold*36 = 0.05
# threshold*36 = threshold_uncorrected
# "p_bonferroni" is a p-value that has been increased so I can still compare it to 0.05
results$p_bonferroni = pmin(results$p * (length(tickers)*length(tickers)-1)/2, 1)
results$is_sig = results$p_bonferroni < 0.05

# FUNction
final = aggregate(r ~ Ticker_A, data = results, FUN = mean, na.rm = T)

names(final) = c("Ticker", "Avg_Effect_Size")

final = final[order(-final$Avg_Effect_Size), ]

final$Rank = seq_len(nrow(final))

print(final)

print(head(results[results$is_sig == TRUE, ]))