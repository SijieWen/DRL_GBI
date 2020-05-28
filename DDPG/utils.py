import numpy as np
import pandas as pd
import datetime
from config import START_DATE, DATE_FORMAT, START_DATETIME, EPS, STEP_LENGTH, ADD_INVEST, CSV_DIR


def read_stock_history(filepath):
    """ Read data from csv file
    Args:
        filepath: path of file
    Returns:
        history:
        abbreviation:
    """
    df = pd.read_csv(filepath)
    df = df.drop(columns=['Date','Adj Close'])
    arr = df.values
    abbreviation = ['IWR','IWL','SPX','EEM','TFI','JNK']    
    num_of_assets = len(abbreviation)    # 4   # 3
    num_of_data = int(df.shape[0]/num_of_assets)   # 2515  # 1257
    num_of_data_ = int(num_of_data/STEP_LENGTH)    # /5=503   # /3=419
    arr_ = np.zeros(shape=(num_of_data_*num_of_assets, 5))   # (1676,5)
    for i,j in zip(range(0,df.shape[0],STEP_LENGTH), range(num_of_data_*num_of_assets)):
        arr_[j] = np.array([arr[i][0], np.max(arr[i:i+STEP_LENGTH],axis=0)[1], np.min(arr[i:i+STEP_LENGTH],axis=0)[2], arr[i+STEP_LENGTH-1][3], np.sum(arr[i:i+STEP_LENGTH],axis=0)[4]])

    history = arr_.reshape((num_of_assets, num_of_data_, 5))    
    
    return history, abbreviation


def index_to_date(index):
    return (START_DATETIME + datetime.timedelta(index)).strftime(DATE_FORMAT)


def date_to_index(date_string):
    return (datetime.datetime.strptime(date_string, DATE_FORMAT) - START_DATETIME).days



def sharpe(returns, rfr=0):  
    """ 
    Calculate Annualized Sharpe Ratio:
    Given a set of returns, calculates sharpe ratio of risk-free return = 0 (rfr=0). 
    """
    if STEP_LENGTH == 1:   # adjust daily
        freq = 252
    if STEP_LENGTH == 5:   # adjust weekly
        freq = 52
    if STEP_LENGTH == 20:  # adjust monthly
        freq = 12
    return (np.sqrt(freq) * np.mean(returns - rfr + EPS)) / np.std(returns - rfr + EPS)


def max_drawdown(returns):
    """ Calculate Maximum Drawdown """
    peak = returns.max()
    trough = returns[returns.argmax():].min()
    return (trough - peak) / (peak + EPS)


def market_value(df_info, trading_cost):
    """ Calculate Equally Weighted Portfolio Value and Update the Output"""
    l = [np.fv(rate=df_info['return'][0], nper=1, pmt=-ADD_INVEST[0], pv=-1)]
    for i in range(1,len(df_info['return'])):
        l.append(np.fv(rate=df_info['return'][i], nper=1, pmt=-ADD_INVEST[i], pv=-l[i-1]) - trading_cost*ADD_INVEST[i])
    df_info['market_value'] = l
    cols = list(df_info)
    cols.insert(-3,cols.pop(cols.index('market_value')))
    df_info = df_info.loc[:,cols]
    df_info.to_csv(CSV_DIR, encoding='utf-8', index=False)
    return pd.read_csv(CSV_DIR)
