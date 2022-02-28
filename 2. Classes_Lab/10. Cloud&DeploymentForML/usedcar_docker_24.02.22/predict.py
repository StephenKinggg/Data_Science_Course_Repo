print("you imported predict module")
import pandas as pd
import joblib
scaler = joblib.load(open("scaler.joblib","rb"))
model = joblib.load(open("xgb_model.joblib","rb"))
columns = joblib.load("columns.joblib")

def predictor(sample_two):
    print("predictor function is imported")
    df_two = pd.DataFrame(sample_two)
    df_two["Year"] = 2018-df_two["Year"]
    df_two = pd.get_dummies(df_two).reindex(columns=columns, fill_value=0)
    df_two = scaler.transform(df_two)
    res = model.predict(df_two)
    return res