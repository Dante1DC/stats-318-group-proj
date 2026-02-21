import argparse
import yfinance as yf
import pandas as pd
import os
from datetime import datetime, timedelta

from f import apply_derived_features

TICKERS = ["U", "EA", "RBLX", "GME", "MSFT", "TTWO", "MYPS", "SONY", "GAME"] 
FILE_NAME = "stock_data.parquet"

def parse_arguments():
    parser = argparse.ArgumentParser(description="Fetch and store NASDAQ stock data.")
    
    default_start = "01-01-2026"
    default_end = datetime.now().strftime("%m-%d-%Y")
    
    parser.add_argument("--full-refresh", action="store_true", 
                        help="Ignore existing columnsdata, fetch the full range, and overwrite the file.")
    parser.add_argument("-s", "--start", type=str, default=default_start,
                        help="Start date in MM-DD-YYYY format. Default: 01-01-2026")
    parser.add_argument("-e", "--end", type=str, default=default_end,
                        help="End date in MM-DD-YYYY format. Default: Today")
    
    return parser.parse_args()

def update_stock_data(start_str, end_str, full_refresh):
    try:
        start_dt = datetime.strptime(start_str, "%m-%d-%Y")
        end_dt = datetime.strptime(end_str, "%m-%d-%Y")
    except ValueError:
        print("Error: Dates must be provided in exactly MM-DD-YYYY format.")
        return None

    yf_start = start_dt.strftime("%Y-%m-%d")
    
    yf_end = (end_dt + timedelta(days=1)).strftime("%Y-%m-%d")
    
    df_existing = pd.DataFrame()
    
    if not full_refresh and os.path.exists(FILE_NAME):
        print(f"Found existing file: {FILE_NAME}")
        df_existing = pd.read_parquet(FILE_NAME)
        
        latest_date = df_existing['Date'].max()
        fetch_start_dt = latest_date + timedelta(days=1)
        
        if fetch_start_dt > end_dt:
            print(f"Bozo. Data is already up to date through {end_str}!")
            df_existing = apply_derived_features(df_existing)
            df_existing.to_parquet(FILE_NAME, index=False)
            return df_existing
            
        yf_start = fetch_start_dt.strftime("%Y-%m-%d")
    else:
        if full_refresh:
            print("Full refresh. Overwriting existing data.")
        else:
            print("No existing data found. Creating new file.")

    print(f"Downloading data from {yf_start} to {end_dt.strftime('%Y-%m-%d')}...")
    raw_data = yf.download(TICKERS, start=yf_start, end=yf_end)

    if raw_data.empty:
        print("No trading data found for this range. Markets may not be open, but I bet Polymarket is.")
        return df_existing

    df_new = raw_data[['Open', 'Close']].stack(level=1, future_stack=True).rename_axis(['Date', 'Ticker']).reset_index()
    df_new['Date'] = pd.to_datetime(df_new['Date'])

    df_new = df_new[(df_new['Date'] >= start_dt) & (df_new['Date'] <= end_dt)]

    if df_new.empty:
        print("No new data available within the exact specified bounds. L.")
        return df_existing

    if not full_refresh and not df_existing.empty:
        df_combined = pd.concat([df_existing, df_new], ignore_index=True)
        df_combined = df_combined.drop_duplicates(subset=['Date', 'Ticker'])
    else:
        df_combined = df_new

    df_combined = apply_derived_features(df_combined)

    df_combined.to_parquet(FILE_NAME, index=False)
    print(f"Success! The Parquet file now has {len(df_combined)} rows.")
    
    return df_combined

if __name__ == "__main__":
    args = parse_arguments()
    final_df = update_stock_data(args.start, args.end, args.full_refresh)
    
    if final_df is not None and not final_df.empty:
        print("\nLast 10 Rows of the Parquet File:")
        print(final_df.sort_values(['Date', 'Ticker']).tail(10))