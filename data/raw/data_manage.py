# %%
import os
import pandas as pd
import sqlalchemy as sql
from tqdm import tqdm

#%%
list_dir = os.listdir('.')

engine = sql.create_engine("sqlite:///bronze/gc_bronze.db")
conn = engine.connect()

for file_name in tqdm(list_dir):
    if '.csv' in file_name:
        df = pd.read_csv(file_name)
        df.to_sql(name=file_name.split('.')[0] , con=conn)
