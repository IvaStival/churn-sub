# %%
from re import A
from statistics import mode
import pandas as pd
import sqlalchemy as sql
from feature_engine import imputation
from feature_engine import encoding

from sklearn import model_selection
from sklearn import pipeline
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics


# %%

## LOADING DATA BASE TO DF
def load_data_base(path, database):
    engine = sql.create_engine(f"sqlite:///{path}/{database}.db")
    return engine.connect()

db_path = "../../../data/silver"
db_name = "gc_silver"
con = load_data_base(db_path, db_name)

df = pd.read_sql("abt_model_churn", con)

# %%
## REMOVE UNUSED FEATURES
columns = df.columns
target = "flNaoChurn"
ids = ["dtRef", "idPlayer", "dtRef:1"]
to_remove = ["flAssinatura"]

features = list(set(columns) - set([target]) - set(ids) - set(to_remove))
# %%
## SPLIT DATA BETEWEEN TRAN AND TEST
X_train, X_test, Y_train, Y_test = model_selection.train_test_split(df[features],
                                                                    df[target],
                                                                    test_size=0.2,
                                                                    random_state=42 )

# %%
missing_columns = X_train.count()[X_train.count() < X_train.shape[0]].index.tolist()
missing_columns.sort()
missing_columns
 # %% 
missing_flags = ["avg1Kill", "avg2Kill", "avg3Kill", "avg4Kill", "avg5Kill", "avgAssist", "avgBombeDefuse", "avgBombePlant", "avgClutchWon", "avgDamage", "avgDeath", "avgFirstKill", "avgFlashAssist", "avgHits", "avgHs", "avgHsRate", "avgKDA", "avgKDR", "avgKill", "avgLastAlive", "avgPlusKill", "avgRoundsPlayed", "avgShots", "avgSurvived", "avgTk", "avgTkAssist", "avgTrade", "qtRecencia","vlHsRate","vlKDA","vlKDR","winRate"]
missing_zeros = ["propAncient","propDia1","propDia2","propDia3","propDia4","propDia5","propDia6","propDia7","propDust2","propInferno","propMirage","propNuke","propOverpass","propTrain","propVertigo","qtDias","qtPartidas", 'qtExpBatalha', 'qtMedalha', 'qtMedalhaDist', 'qtMedalhaTribo']

cat_features = X_train.dtypes[X_train.dtypes == "object"].index.tolist()

fe_missing_flags = imputation.ArbitraryNumberImputer(variables=missing_flags,
                                                    arbitrary_number=-100)
fe_missing_zeros = imputation.ArbitraryNumberImputer(variables=missing_zeros,
                                                    arbitrary_number=0)

fe_onehot = encoding.OneHotEncoder(variables=cat_features, drop_last=True)

model = DecisionTreeClassifier()

model_pipeline = pipeline.Pipeline([ ("Missing Flag", fe_missing_flags), 
                                     ("Missing Zero", fe_missing_zeros),
                                     ("OneHot", fe_onehot),
                                     ("Model", model) 
                                    ])

model_pipeline.fit(X_train, Y_train)
# %%
y_train_pred = model_pipeline.predict(X_train)
y_test_pred = model_pipeline.predict(X_test)

acc_train = metrics.accuracy_score(Y_train, y_train_pred)
acc_test = metrics.accuracy_score(Y_test, y_test_pred)

print("Acuracia Treino: ", acc_train)
print("Acuracia Test: ", acc_test)
# %%
features_fit = model_pipeline[:-1].transform(X_train).columns.tolist()
features_importance = pd.Series(model.feature_importances_, index=features_fit)
features_importance.sort_values(ascending=False).head(15)

# %%
cat_features
# %%
