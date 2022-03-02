import uvicorn
import sklearn
import pickle
import joblib
import numpy as np 
import pandas as pd
from preprocessing import cleaning
from fastapi import FastAPI, Request, File,  Form
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates # web template engine for python. Similar to django

tfidf_vec = open('models/tfidf_vectorizer.pkl', 'rb')
tfidf_vec = joblib.load(tfidf_vec)

model = open('models/logreg_tweet_classifier.pkl', 'rb')
model = joblib.load(model)

# init app
app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")

templates = Jinja2Templates(directory="templates")

# ML Aspect
@app.get("/")
async def predict():
    return 'Welcome to the Class'

# ML Aspect
@app.get("/predict/{tweet}")
async def predict(tweet: str):

    #tweet = request.form['tweet']
    
    #cleaned_text = pd.Series(tweet).apply(cleaning)
    vectorized_text = tfidf_vec.transform([tweet]).toarray()
    prediction = model.predict(vectorized_text)
    prob = model.predict_proba(vectorized_text)

    return {"original_text":tweet, "prediction":prediction[0], "Prob":np.max(np.round(prob,3))}

@app.get("/main", response_class=HTMLResponse)
def home_func(request: Request):
    return templates.TemplateResponse("item.html", {"request": request, "airline":""})

@app.get("/main/{air_line}", response_class=HTMLResponse)
def home(request: Request, air_line: str):
    return templates.TemplateResponse("item.html", {"request": request, "airline": air_line})

# POST end-point
@app.post("/get_prediction")
async def handle_tweet(request: Request, tweet: str = Form(...)):
    #cleaned_text = pd.Series(tweet).apply(cleaning)
    vectorized_text = tfidf_vec.transform([tweet]).toarray()
    prediction = model.predict(vectorized_text)
    prob = model.predict_proba(vectorized_text)

    return templates.TemplateResponse("item2.html", 
            {"request": request, "airline":"", "original_text":tweet, "prediction":prediction[0], 
             "Prob":np.max(np.round(prob,3))})

if __name__=='__main__':
    uvicorn.run(app, host='127.0.0.1', port=8009)