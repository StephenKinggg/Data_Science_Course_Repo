from flask import Flask, request, render_template
import joblib
import pandas as pd

app = Flask(__name__)
@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "GET":
        return render_template("index.html")
    if request.method == "POST":
        data={}
        data['make_model']      = request.form['make_model']
        data['hp_kW']           = float(request.form['hp_kW'])
        data['km']              = float(request.form['km'])
        data['age']             = float(request.form['age'])
        data['Gearing_Type']    = request.form['Gearing_Type']
        data['Gears']           = float(request.form['Gears'])
        df = pd.DataFrame([data])
        df = pd.get_dummies(df).reindex(columns=columns, fill_value=0)
        df = scaler.transform(df)
        res = model.predict(df)
        return render_template("result.html", result=f"$ {res[0]:.4f}")


@app.route("/api", methods=["GET", "POST"])
def api():
    if request.method == "GET":
        return "API server is running"
    if request.method == "POST":
        data={}
        data['make_model']      = request.json['make_model']
        data['hp_kW']           = float(request.json['hp_kW'])
        data['km']              = float(request.json['km'])
        data['age']             = float(request.json['age'])
        data['Gearing_Type']    = request.json['Gearing_Type']
        data['Gears']           = float(request.json['Gears'])
        df = pd.DataFrame([data])
        df = pd.get_dummies(df).reindex(columns=columns, fill_value=0)
        df = scaler.transform(df)
        res = model.predict(df)
        return {"predicted price is":f"$ {res[0]:.4f}"}


if __name__ == "__main__":
    scaler = joblib.load(open("scaler.joblib","rb"))
    model = joblib.load(open("xgb_model.joblib","rb"))
    columns = joblib.load(open("columns.joblib","rb"))
    app.run(host="0.0.0.0", debug=True)