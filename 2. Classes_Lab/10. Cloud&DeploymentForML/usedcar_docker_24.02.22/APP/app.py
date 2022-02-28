from unittest import result
from flask import Flask, request, render_template
import joblib
import pandas as pd


app = Flask(__name__)

@app.route("/", methods= ["GET", "POST"])
def home():
    if request.method == "GET":
        return render_template("index2.html")
    if request.method == "POST":
        data = {}
        data["Year"]=int(request.form["Year"])
        data["Present_Price"]= float(request.form["Present_Price"])
        data["Kms_Driven"]= int(request.form["Kms_Driven"])
        data["Fuel_Type"]=request.form["Fuel_Type"]
        data["Seller_Type"]=request.form["Seller_Type"]
        data["Transmission"]=request.form["Transmission"]
        data["Owner"]=int(request.form["Owner"])
        df = pd.DataFrame([data])
        df["Year"] = 2018 - df["Year"]
        df = pd.get_dummies(df).reindex(columns=columns, fill_value=0)
        df = scaler.transform(df)
        result = model.predict(df)
        return render_template("result2.html", result=f" $ {result[0]:.4f}")
    

# api codes

@app.route("/api", methods= ["GET", "POST"])
def api():
    if request.method == "GET":
        return "my API server is running"
    if request.method == "POST":
        data = {}
        data["Year"]=int(request.json["Year"])
        data["Present_Price"]= float(request.json["Present_Price"])
        data["Kms_Driven"]= int(request.json["Kms_Driven"])
        data["Fuel_Type"]=request.json["Fuel_Type"]
        data["Seller_Type"]=request.json["Seller_Type"]
        data["Transmission"]=request.json["Transmission"]
        data["Owner"]=int(request.json["Owner"])
        df = pd.DataFrame([data])
        df["Year"] = 2018 - df["Year"]
        df = pd.get_dummies(df).reindex(columns=columns, fill_value=0)
        df = scaler.transform(df)
        result = model.predict(df)
        return {"predicted_price":f" $ {result[0]:.4f}"}
    
if __name__ == "__main__":
    scaler = joblib.load(open("scaler.joblib","rb"))
    model = joblib.load(open("xgb_model.joblib","rb"))
    columns = joblib.load("columns.joblib")
    app.run(debug=True, host="0.0.0.0")
