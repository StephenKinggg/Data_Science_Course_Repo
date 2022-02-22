from numpy.random import sample
import streamlit as st
import pandas as pd
import numpy as np
import datetime
from PIL import Image

st.title("Hello World")
st.text("This is a text")
st.markdown("Streamlit is **_really_ cool**.:+1:")
st.markdown("# This is a markdown")
st.markdown("* This is a markdown")
st.markdown("'This is a markdown'") 
st.header("'This is a header'")
st.subheader("This is a subheader")

st.success("This is a success message")
st.info("This is a purely informatinol message")
st.error("This is an error")

st.help(range)

st.write("Hello, *World!*:sunglasses:")
img=Image.open("alpine-valley-mountains-landscape-green-fields.jpg")
#st.image(img,caption="alpine",width=300)
st.image(img,caption="alpine",use_column_width=True)

my_video=open("video.mp4","rb")
st.video(my_video)
st.video("https://www.youtube.com/watch?v=V056WNg3ECo&list=RDV056WNg3ECo&start_radio=1")

cbox= st.checkbox("Hide and Seek")
if cbox:
    st.write("Hide")
else:
    st.write("Seek")

#st.radio("Select a color", ("blue","orange","yellow"))
status = st.radio("Select a color", ("blue","orange","yellow"))
st.write(f"Your favourite color is {status}")

# st.button("Press me")
if st.button("Press me"):
    st.success("Bamm")
    
# select box
# sn = st.selectbox("Select a number", [1,2,3,4])
sn = st.selectbox("Select a number", range(10))
if sn<1:
    st.write("No apples for you")
else:
    st.write(f"I will give you {sn} apples")
    
# st.multiselect("Select multiple numbers", [1,2,3,4,5])

multiselect=st.multiselect("Select multiple numbers", [1,2,3,4,5])
st.write(f"you selected {multiselect}")

option1=st.slider("select a number", min_value=5,  max_value=70, value=30, step=1)
option2=st.slider("select a number", min_value=0.5, max_value=30.0, value=20.0, step=0.5)
option1*option2

#date-time
st.date_input("Date", datetime.datetime.now())
st.time_input("Time", datetime.datetime.now())
st.time_input("Time", datetime.time(12,0))

# code

st.code("import pandas as pd")
st.code("import pandas as pd\nmiport numpy as np")

with st.echo():
    import pandas as pd
    import numpy as np
    #import matplotlib.pylot as plt
    df = pd.DataFrame({"a":[1,2,3], "b":[4,5,6]})
    df
    
#sidebar
st.sidebar.title("Sidebar title")
st.sidebar.markdown("##This is a markdown")
a=st.sidebar.slider("input",0,5,2,1)
st.write("# sidebar input result")
st.success(a*a)

#dataframe
st.write("# dataframes")
df = pd.read_csv("final_scout_dummy.csv", nrows=(100))
st.table(df.head())  
st.write(df.head()) #dynamic, you can sort, swiss knife
st.dataframe(df.head())#dynamic

#charts
st.write("# age")
st.line_chart(df.age)

st.write("# sidebar select")#double click to reset
x=st.sidebar.slider("line chart input")
srs = pd.Series(np.random.randn(x))
st.line_chart(srs)

with st.echo():
    import seaborn as sns
    penguins = sns.load_dataset("penguins")
    st.title("Hello")
    fig = sns.pairplot(penguins, hue="species")
    st.pyplot(fig)
    
    

#Project Example

# split the data into train and test
from sklearn.model_selection import train_test_split
import pickle
# to build linear regression_model
from sklearn.linear_model import LinearRegression

with st.echo():
    df = pd.read_csv("Advertising.csv")
    X= df.drop("sales", axis=1)
    y= df["sales"]
    x_train, x_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42)
    model = LinearRegression()
    model.fit(x_train, y_train)
    filename = 'finalized_model.sav'
    pickle.dump(model, open(filename, 'wb'))
    loaded_model = pickle.load(open(filename, 'rb'))
    result = loaded_model.score(x_test, y_test)
    st.write(result)
    pred = model.predict([[100,200,300]])
    st.write(pred)
    
    
    
st.table(df.head())
a = float(st.sidebar.number_input("TV:",value=230.1, step=10.1))
b = float(st.sidebar.number_input("radio:",value=37.8, step=10.1))
c = float(st.sidebar.number_input("newspaper:",value=69.2, step=10.1))
if st.button("Predict"): 
    pred = model.predict([[a,b,c]])
    st.write(pred)
    

    

#NLP-example


#data = ["I love you", "I hate you"],
txt = st.text_area("Enter a message", "I love you",20,150)
from transformers import pipeline
if st.button("Analyze"):
    st.success("analyzing")
    sentiment_pipeline = pipeline("text-classification")
    st.write(sentiment_pipeline(txt))