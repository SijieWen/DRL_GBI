import os
import datetime
import numpy as np

START_DATE = '2010-01-04'
END_DATE = '2020-01-07'
DATE_FORMAT = '%Y-%m-%d'
EPS = 1e-8

DATA_DIR = 'datasets/sug_EEM_bond2_2010_2020_month.csv'
CSV_DIR = 'output/portfolio-management.csv'
START_DATETIME = datetime.datetime.strptime(START_DATE, DATE_FORMAT)  # datetime.datetime(2010, 1, 4, 0, 0)

LAMBDA = 0.01  
RHO = 0.4
GAMMA = 1.01

STEP_LENGTH = 20   # adjust weights monthly now. You could try 1(adjust daily) or 5(adjust weekly)
GOAL = 23
ADD_INVEST = np.repeat(0.1, 120)  # add 0.1 cash into the portfolio every month of 10 years
