import pandas as pd
import numpy as np
import pickle
import streamlit as st
from PIL import Image

st.header("Employee Churn Prediction")

# loading in the model to predict on the data

#df = pd.read_csv('HR_Dataset.csv')
#df.columns = df.columns.str.lower().str.replace(" ", "")
#st.write(df)


# here we define some of the front end elements of the web page like
# the font and background color, the padding and the text to be displayed
html_temp = """
	<div style ="background-color:red;padding:10px">
	<h1 style ="color:white;text-align:center;">Streamlit Employee Churn Prediction ML Model </h1>
	</div>
	"""

# this line allows us to display the front end aspects we have
# defined in the above code
st.markdown(html_temp, unsafe_allow_html = True)



# the following lines create text boxes in which the user can enter
# the data required to make the prediction
satisfaction_level = st.number_input("Satisfaction Level", min_value=0.09, max_value=1.0,value=0.1, step=0.01)
last_evaluation = st.number_input("Last Evaluation", min_value=0.36, max_value=1.0,value=0.4, step=0.01)
number_project = st.number_input("Number Project", min_value=2.0, max_value=7.0,value=4.0, step=1.0)
average_montly_hours = st.number_input("Average Montly Hours", min_value=96.0, max_value=310.0,value=100.0, step=1.0)
time_spend_company = st.number_input("Time Spend Company", min_value=2.0, max_value=10.0,value=4.0, step=1.0)
work_accident = st.number_input("Work Accident", min_value=0.0, max_value=1.0,value=0.0, step=0.1)
promotion_last_5years = st.number_input("Promotion Last 5year", min_value=0.0, max_value=1.0,value=0.0, step=0.1)
departments = st.sidebar.radio("Department", ('IT','RandD','Accounting','HR','Management','Marketing', 'Product Mng','Sales','Support','Technical'))
salary = st.sidebar.radio("Salary", ('High','Medium','Low'))
prediction =""



model_name=st.selectbox('Select your ML model',('GradientBoosting','KNN','RandomForest'))
if model_name=='GradientBoosting':
    model_gb=pickle.load(open('gb_model', 'rb'))
    st.success('You selected {} model'.format(model_name))
    
elif model_name=='KNN':
    model_knn=pickle.load(open('knn_model', 'rb'))
    st.success('You selected {} model'.format(model_name))
    
else:
    model_rf=pickle.load(open('rf_model', 'rb'))
    st.success('You selected {} model'.format(model_name))


# the below line ensures that when the button called 'Predict' is clicked,
# the prediction function defined above is called to make the prediction
# and store it in the variable result

my_dict = {
    "satisfaction_level": satisfaction_level,
    "last_evaluation": last_evaluation,
    "number_project": number_project,
    "average_montly_hours": average_montly_hours,
    'time_spend_company':time_spend_company,
    'work_accident':work_accident,
    'promotion_last_5years':promotion_last_5years,
    'departments':departments,
    'salary':salary
}

df = pd.DataFrame.from_dict([my_dict])
columns=pickle.load(open('my_columns','rb'))
df = pd.get_dummies(df).reindex(columns=columns, fill_value=0)


st.subheader('Press the predict button if everything is okay')

if st.button("Predict"):
    if model_name=='GradientBoosting':
        scaler=pickle.load(open('my_scaler','rb'))
        df=scaler.transform(df)
        prediction=model_gb.predict(df)
        st.write(prediction)
        
        
    elif model_name=='KNN':
        scaler=pickle.load(open('my_scaler','rb'))
        df=scaler.transform(df)
        prediction=model_knn.predict(df)
        st.write(prediction)
        
    else:
        scaler=pickle.load(open('my_scaler','rb'))
        df=scaler.transform(df)
        prediction=model_rf.predict(df)
        st.write(prediction)
    

if prediction==[[1]]:
	img = Image.open("1.jpeg")
	st.image(img,caption="Left", width=600) 

else:
#elif result==[[0]]:
	img = Image.open("0.jpeg")
	st.image(img,caption="Working", width=600)    
