# Summary
The file `wilcoxon_signed-rank_test_for_every_pair_of_tickers.r` runs a wilcoxon signed-rank test for every combinination of tickers, using the Intraday Action (in terms of percent change) of each stock. 

# Results
```
  Ticker Avg_Effect_Size Rank
    LYV     0.059922008    1
   NTES     0.049137323    2
     EA     0.017676673    3
   NFLX     0.014422123    4
   CMSA     0.013911606    5
    DIS     0.009380762    6
    WMG     0.004275585    7
   SONY    -0.032800758    8
   SPOT    -0.135925321    9
```
The greatest average effect size is present with the LYV stock. This means that the average magnitude of difference between LYV and the stocks it was compared against was greatest.

```
Ticker_A     Ticker_B     r           
p            p_bonferroni is_sig      
<0 rows> 
```
This means that none of the trials were statistically significant. Ie., there is no statistically sigificant difference in these stock's daily average returns. We used the Bonferroni Correction because we're running 36 tests. If one ran 36 hypothesis tests with a confidence interval of 95%, you should expect that your confidence interval for all of the tests if far lower, which Bonferroni corrects for. 

