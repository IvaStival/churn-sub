# %%

import sqlalchemy as sql
from sqlalchemy import inspect

import pandas as pd
import datetime

from tqdm import tqdm

# %%
start_date = "2021-11-01"
end_date = "2022-02-10"

data_base = "gc_silver"
fs_names = ["fs_assinatura", "fs_gameplay", "fs_medalha"]

# fs_name = "fs_assinatura"

def import_query(path):
    with open(path, 'r') as open_file:
        query = open_file.read();
    
    return query


def table_exists(db_name, table_name):
    engine = sql.create_engine(f"sqlite:///../../data/silver/{db_name}.db")

    inspector = inspect(engine)
    schemas = inspector.get_schema_names()

    for schema in schemas:
        for table in inspector.get_table_names(schema=schema):
            if table == table_name:
                return True

    return False

def date_range(start, stop):
    dates = []
    dt_start = datetime.datetime.strptime(start, "%Y-%m-%d")
    dt_stop = datetime.datetime.strptime(stop, "%Y-%m-%d")

    while dt_start <= dt_stop:
        dates.append(dt_start.strftime("%Y-%m-%d"))
        dt_start += datetime.timedelta(days=1)

    return dates

def exec_one(query, conn, date):
    query_exec = query.format(date=date)
    result = conn.execute(query_exec)
    df = pd.DataFrame(result.fetchall())

    return df

def exec(conn_bronze, query, dates, database, table):
    engine = sql.create_engine(f"sqlite:///../../data/silver/{database}.db")
    conn_silver = engine.connect()

    if not table_exists(database, table):
        date = dates.pop(0)
        df = exec_one(query, conn_bronze, date)
        df.to_sql(table, conn_silver, if_exists='replace', index=False)

    for date in tqdm(dates):
        conn_silver.execute(f"DELETE FROM {table} WHERE dtRef = '{date}' ")

        df = exec_one(query, conn_bronze, date)
        
        df.to_sql(table, conn_silver, if_exists='append', index=False)

        

# %%

engine = sql.create_engine(f"sqlite:///../../data/bronze/gc_bronze.db")
conn = engine.connect()

dates = date_range(start_date, end_date)

for fs_name in fs_names:
    query = import_query(f"{fs_name}.sql")
    exec(conn, query, dates, data_base, fs_name)

# %%
