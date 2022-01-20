from flask import Flask, render_template

app = Flask(__name__)  # Web sunucumuzu kendi bs çalıştıracağımızdan dolayı bir obj. oluşturduk.

@app.route("/")  # ben bir adrese gitmek istiyorum. içine de adresi yazıyoruz. request roote olarak yazdık.
def index(): # request yazdık.
    return render_template("index.html")  # render_template içine html yazdım. Ve request sonucu response olarak bunu döndürür.

if __name__== "__main__":
    app.run(debug=True)