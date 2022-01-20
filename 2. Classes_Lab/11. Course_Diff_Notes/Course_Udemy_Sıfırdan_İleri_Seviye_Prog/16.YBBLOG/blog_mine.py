from flask import Flask, render_template

app = Flask(__name__)  # Web sunucumuzu kendi bs çalıştıracağımızdan dolayı bir obj. oluşturduk.

@app.route("/")  # ben bir adrese gitmek istiyorum. içine de adresi yazıyoruz. request roote olarak yazdık.
def index(): # request yazdık.
    return " Ana sayfa"  # böyle bir yazı dönsün yani bu response olacak. Tekrar localhost çalıştırınca işlem sonucunu görebiliriz.

@app.route("/about")   #bu işlem sonucu localhost:5000/about yazınca return işlemi sonucunu göreceğiz.
def about():
    return "Hakkımda"

@app.route("/about/kisi") 
def kisi():
    return " This page is about person."

if __name__ =="__main__" : # bir web sunucusunu çalıştırıyoruz.bir tane localhost çalıştırıyoruz.
    app.run(debug=True) # içine bir tane parametre verdik. hatalarımızı web sitemizde görelim. çünkü geliştirme aşamasındayız.
# burada if döngüsü ile biz python dosyasını başka bir dosyadan aktarmak istersek name değeri main olmuyor.
# name  main olması ile bu python dosyası terminalden mi çalıştırılmış yoksa bir modül olarakı mı
# çalıştırılmış onu anlıyoruz. Modül olarak aktarırsak name main eşit olmaması gerekir.
# web sunucumuzu bu kodlar ile hazırladıktan sonra YBBLOG sağ tıklayıp yeni bir int.terminal açtık.
# açılan alttaki terminale python blog_mine.py yazdık çalıştırdık.
# açılan local host crtl+c ile kapatabiliriz.
# browser dan localhost:5000 ile baktık. ancak hata verdiğini gördük.

# CRTL+C ile kapatıyoruz ve tekrar refresh yaparsak ulaşılamıyor.
# Daha sonra Xampp indiriyoruz. Ancak control paneli otomatik açtırmadık. 
# Burada Xampp control paneli açarak apache ve mysql start yaparak sunucularını açtık.
# Çalışırken bunların her zaman açık olması lazım.
# Daha sonra aynı yerden mysql admin açıyoruz. Bu açılan ekrandan herhangi bir sql sorgusunu çalıştırabiliyoruz.add()
# Tekrar local host açtık. Burada her bir request için bir response alacağız. 
# Yani her bir url adresi talebine karşın flask ta bir func bulunur. Bunun için hazır bir decorator mantığı kullanmamız gerekir.

# Yukarıda önce string template döndürmüştük şimdi ise bir html yani jinja template döndürmek istiyorum.
# bunu render ederek göndermek zorundayız. Bu durumda içine pyhton kodu yazabiliyorum.
# render_template func indirdik.

# .html django olarak açma sıkıntısını sağ alttan django html açıp sonra buradan html seçip kaldırıyoruz.


