import pandas as pd
import numpy as np
import pickle
import streamlit as st
from PIL import Image


st.header("Iris Dataset")

# loading in the model to predict on the data
pickle_in = open('DTclassifier.pkl', 'rb')
classifier = pickle.load(pickle_in)

df = pd.read_csv('Iris.csv')
st.write(df)

# defining the function which will make the prediction using
# the data which the user inputs
def prediction(sepal_length, sepal_width, petal_length, petal_width):

	prediction = classifier.predict(
		[[sepal_length, sepal_width, petal_length, petal_width]])
	print(prediction)
	return prediction


# giving the webpage a title
st.title("Iris Flower Prediction")
	
# here we define some of the front end elements of the web page like
# the font and background color, the padding and the text to be displayed
html_temp = """
	<div style ="background-color:yellow;padding:13px">
	<h1 style ="color:black;text-align:center;">Streamlit Iris Flower Classifier ML App </h1>
	</div>
	"""
	
# this line allows us to display the front end aspects we have
# defined in the above code
st.markdown(html_temp, unsafe_allow_html = True)

# the following lines create text boxes in which the user can enter
# the data required to make the prediction
sepal_length = st.number_input("Sepal Length", min_value=4.3, max_value=7.9,value=4.9, step=0.2)
sepal_width = st.number_input("Sepal Width", min_value=2.0, max_value=4.4,value=2.7, step=0.2)
petal_length = st.number_input("Petal Length", min_value=1.0, max_value=6.9,value=3.9, step=0.2)
petal_width = st.number_input("Petal Width", min_value=0.1, max_value=2.5,value=1.9, step=0.2)
result =""

# the below line ensures that when the button called 'Predict' is clicked,
# the prediction function defined above is called to make the prediction
# and store it in the variable result
if st.button("Predict"):
	result = prediction(sepal_length, sepal_width, petal_length, petal_width)

st.success(f"Iris Flower is {result}")