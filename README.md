Sum of Square Meanie's
# Spoehr Family Inc. Action Report 

Collaborators: 
Dante Dyches-Chandler, Andrew Hall, Nathan Van Drie, Cole Welstead

# Summary
In this repository, you'll find all of the code we wrote to complete this project. For navigation purposes, here's where you'll find some key parts of the project:

## Root Directory
This is where the data collection pipeline lives. 

This Python code pulls data from the Yahoo Finance API, figures Intraday Action, and stores the data in a parquet file. 

### Usage
1. Create a Python virtual environment.
2. `pip install -r requirements.txt`
3. `python retrieve_stocks.py`

Boom! Now you have data. You'll use this in all of the R files which reference stock data. 

`retrieve_stocks.py` also has some arguments you can use to customize what data you pull. 
-> `--full-refresh`: by default `retrieve_stocks.py` appends new data to an existing parquet file if one exists. Passing this argument **deletes** the original `stock_data.parquet` file and fetchs all data in the specified/default range. 
-> `-s`: Specify a start date. By default it's 01-01-2026.
-> `-e`: Specify an end date. By default it's whatever today's date is.

<b>IMPORTANT:</b> This is necessary before running `./seasonality/stock_seasonality.ipynb`. Use the arguments `--full-refresh` and `-s 01-01-2022` to retrieve enough stock data to measure seasonality.</b>

Finally, go ahead and use this to pull different stocks if you'd like to try our analysis on different tickers. Alter the `TICKERS` constant with whatever stock ticker you want.

## `./bs`
This folder contains our Basic Statistical (BS) Analysis, done in R.

You'll see the QQ Plots from the report, and two R files. Before running them, if you're using RStudio as your IDE, make sure you 1) configure your project directory as the **root** directory of this repo, and 2) run `requirements.r` before running either of the files in this directory. They have dependencies which you must install first.  

## `./experimental_design`
This folder contains the code we used for our Experimental Design section.

## `./one_way_anova`
This folder contains the code we used to implement One-Way Anova. 

## `./seasonality`
This folder contains the Jupyter notebook used to investigate seasonality and (attempt) autoregressive seasonal modeling. Sorry for not using R, we were much more familiar with the necessary Python libraries.

### Further Considerations
In the `f.py` file, you'll see a function called `apply_derived_features`. This does what it sounds like: if you pass it any row-wise formula, it'll apply it to the stock dataset next time you fetch new data. Use this to include any derivative feature you want to the data. You'll notice this is where the intraday action features are calculated: use that as a reference. 
