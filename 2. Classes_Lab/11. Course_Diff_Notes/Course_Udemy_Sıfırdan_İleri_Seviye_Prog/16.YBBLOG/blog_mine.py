from flask import Flask

app = Flask(__name__)  # Web sunucumuzu kendi bs çalıştıracağımızdan dolayı bir obj. oluşturduk.

if __name__ =="__main__" : # bir web sunucusunu çalıştırıyoruz.bir tane localhost çalıştırıyoruz.
    app.run(debug=True) # içine bir tane parametre verdik. hatalarımızı web sitemizde görelim. çünkü geliştirme aşamasındayız.