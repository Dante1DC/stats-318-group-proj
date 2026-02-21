import pandas as pd

df = pd.read_parquet("nasdaq_stock_data.parquet")
print(df.tail())