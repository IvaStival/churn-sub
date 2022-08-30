#%%
import sqlalchemy as sql
# %%
engine = sql.create_engine("sqlite:///../../data/bronze/gc_bronze.db")
conn = engine.connect()
# %%

query = "SHOW CREATE TABLE tb_lobby_stats_player"