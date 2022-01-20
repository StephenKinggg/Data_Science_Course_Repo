from flask import Flask, render_template

app = Flask(__name__)  

@app.route("/")  
def index():   
    return render_template("index.html")  #default olarak templates klasörüne gitti.

if __name__ =="__main__" : 
    app.run(debug=True)