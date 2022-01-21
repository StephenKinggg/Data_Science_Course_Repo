from wsgiref.validate import validator
from flask import Flask,render_template,flash,redirect,url_for,session,logging,request
from flask_mysqldb import MySQL
from wtforms import Form,StringField,TextAreaField,PasswordField,validators
from passlib.hash import sha256_crypt
from functools import wraps


# Kullanıcı Kayıt Formu :
class RegisterForm(Form):
    name = StringField("İsim Soyisim", validators=[validators.Length(min=4, max=25)])
    username = StringField("Kullanıcı Adı", validators=[validators.Length(min=5, max=35)])
    email = StringField("Email Adresi", validators=[validators.Email(message = "Lütfen Geçerli Bir Email Adresi Giriniz.")])
    password = PasswordField("Parola: ", validators= [
        validators.DataRequired(message = "Lütfen bir parola belirleyiniz."),
        validators.EqualTo(fieldname = "confirm", message ="Parola uyuşmuyor...")
        ])
    confirm = PasswordField("Parola Doğrula")

class LoginForm(Form):
    username = StringField("Kullanıcı Adı")
    password = PasswordField("Parola:")
    
app = Flask(__name__)  
app.secret_key = "ybblog"

app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"]="ybblog"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)

@app.route("/")  
def index():   
    articles = [{"id":1, "title":"Deneme1","content":"Deneme1 içerik"},
               {"id":2, "title":"Deneme2","content":"Deneme2 içerik"},
               {"id":3, "title":"Deneme3","content":"Deneme3 içerik"}
               ]
    
    return render_template("index.html", articles=articles)  # önce layout.html yaptım sonra bundan inheritance yapmak için inde.html yazdık.


@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/article/<string:id>")
def detail(id):
    return "Article Id:"+id

# Kayıt olma
@app.route("/register", methods=["GET","POST"])
def register():
    form = RegisterForm(request.form)
    
    if request.method =="POST" and form.validate():
        name = form.name.data 
        username = form.username.data 
        email = form.email.data 
        password = sha256_crypt.encrypt(form.password.data)
        
        cursor = mysql.connection.cursor()
        
        sorgu = " Insert into users(name, email, username, password) VALUES(%s,%s,%s,%s)"
        cursor.execute(sorgu,(name, email, username, password))
        mysql.connection.commit()
        
        cursor.close()
        flash("Kayıt işlemi başarı ile sonuçlanmıştır.","success")
        return redirect(url_for("login"))
    
    else:
        return render_template("register.html", form=form) 

# Login İşlemi:
@app.route("/login", methods =["GET","POST"])
def login():
    form = LoginForm(request.form)
    if request.method == "POST":
        username = form.username.data
        password_entered = form.password.data

        cursor = mysql.connection.cursor()

        sorgu = "Select * From users where username = %s"

        result = cursor.execute(sorgu,(username,))
        
        if result > 0 :
            data = cursor.fetchone()  # kullanıcıya ait tüm veriyi çektik.
            real_password = data["password"] #sözlükte gezindiğim gibi geziniyorum.
            if sha256_crypt.verify(password_entered, real_password):
                flash("Başarı ile giriş yaptınız.","success")
                return redirect(url_for("index"))
            else:
                flash("Parolanızı Yanlış Girdiniz.","danger")
                return redirect(url_for("login"))
                
        else:
            flash("Böyle bir kullanıcı bulunmuyor...","danger")
            return redirect(url_for("login"))
        
    return render_template("login.html", form=form)

if __name__ =="__main__" : 
    app.run(debug=True)