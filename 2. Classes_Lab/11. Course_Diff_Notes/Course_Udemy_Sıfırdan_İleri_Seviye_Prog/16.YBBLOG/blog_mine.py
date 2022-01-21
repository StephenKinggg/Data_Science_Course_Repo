from flask import Flask, render_template

app = Flask(__name__)  

@app.route("/")  
def index():   
    return render_template("index.html", islem=1)  # önce layout.html yaptım sonra bundan inheritance yapmak için inde.html yazdık.

@app.route("/about")
def about():
    return render_template("about.html")

if __name__ =="__main__" : 
    app.run(debug=True)