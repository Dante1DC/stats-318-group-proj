def calc_intraday_action(df):
    df['Intraday_Action_USD'] = df['Close'] - df['Open']
    
    df['Intraday_Action_Pct'] = (df['Intraday_Action_USD'] / df['Open']) * 100
    
    return df

def apply_derived_features(df):
    """
    do NOT ask a data scientist to make a data pipeline: they don't even have data plumbing!
    """
    pipeline = [
        calc_intraday_action
    ]
    
    for func in pipeline:
        df = func(df)
        
    return df