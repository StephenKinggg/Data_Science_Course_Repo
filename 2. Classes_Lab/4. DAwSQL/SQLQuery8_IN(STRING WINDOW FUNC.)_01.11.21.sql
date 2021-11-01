--REPLACE

SELECT REPLACE('CHARACTER STRING', ' ','/')

SELECT REPLACE(123123123555, 123, 88)

--STR

SELECT STR(5454)  --10 KARAKTERDEN AZ GÝRERSEK KALAN BOÞLUKLA DOLDURUR.

SELECT STR(5454,4)  --4 HANELÝ GETÝRÝR.

SELECT STR(5454.475, 7)  --7 HANELÝ ÝSTEDÝK AMA NOKTADAN SONRASINI DÝKKATE ALMADI.

SELECT STR(5454.475, 7,3 ) --NOKTADAN SONRA NOKTA DAHÝL KAÇ KARAKTER GETÝRECEÐÝMÝZÝ DE YAZDIK.

SELECT REPLACE(1232435464, 123, 'aha')

SELECT REPLACE(1232435464, 123, 123)+1

SELECT ISNUMERIC (REPLACE(1232435464, 123, 222))

SELECT ISNUMERIC (REPLACE(1232435464, 123, 'aha'))

--CAST

SELECT CAST(123135 AS VARCHAR)

SELECT CAST(0.33333 AS NUMERIC(3,2))


--CONVERT

SELECT CONVERT(INT, 30.48)

SELECT CONVERT(DATETIME, '2021-10-10')

SELECT CONVERT(VARCHAR, '2021-10-10', 6)

--COALESCE

SELECT COALESCE(NULL, NULL, 'Ahmet', NULL)

--NULLIF

SELECT NULLIF(10,9)

--ROUND

SELECT ROUND(432.368,2) --NOKTADAN SONRA ÝKÝ HANEYE YUVARLADI.

SELECT ROUND(432.368,3)

SELECT ROUND(432.368,2,1) -- ÝKÝNCÝ ARGÜMANI YAZMAZSAK DEFAULT OLARAK YUKARI YUVARLAR.

SELECT ROUND(432.368,1) --NOKTADAN SONRA BÝRÝNCÝ HANEDEN SONRASINI YUKARI YUVARLADI.

SELECT ROUND(432.364,1)

--QUESTÝON:

-- Customer email sütununda kaç tane yahoo maili var?

SELECT 
SUM(CASE WHEN PATINDEX('%@yahoo%', email) > 0 AND PATINDEX('%@yahoo%', email) IS NOT NULL THEN 1 ELSE 0 END) AS YAHOO
FROM sale.customer

--2.YÖNTEM:

SELECT count(*)
FROM sale.customer
WHERE email LIKE '%@yahoo%'

--3. Yöntem:

SELECT 
SUM(CASE WHEN PATINDEX('%@yahoo%', email) > 0 THEN 1 ELSE 0 END) AS YAHOO
FROM sale.customer

-- QUESTION: Mail adresinde ilk noktaya kadar olan kýsmý alýnýz.

SELECT email, SUBSTRING(email, 1, CHARINDEX('.', email)-1 )
FROM sale.customer

--2.Yöntem:

SELECT email, LEFT(email,CHARINDEX('.', email)-1 )
FROM sale.customer

--Question: Customer tablosundan contact bilgilerine bakarak eðerek tel bilgisi null deðilse telefon bilgisini, eðer null ise email bilgisini getir.

SELECT *, COALESCE(phone, email) as contact
FROM sale.customer

SELECT *
FROM sale.customer
WHERE email IS NULL   --email in null olduðu deðer yok.

SELECT *, COALESCE(phone, NULLIF(email, 'emily.brooks@yahoo.com')) contact
FROM sale.customer

SELECT email, NULLIF(email, 'emily.brooks@yahoo.com')   --bu adresi NULL çevirdik.
FROM sale.customer

SELECT *, COALESCE(phone, NULLIF(email, 'emily.brooks@yahoo.com'), 'a') contact
FROM sale.customer    --burada ise bu null deðerine a yazdýk.

--Question:street sütununda soldan üçüncü karakterin rakam olduðu kayýtlarý getiriniz.

SELECT street
FROM sale.customer

SELECT street, ISNUMERIC(SUBSTRING(street, 3,1)) 
FROM sale.customer
WHERE ISNUMERIC(SUBSTRING(street, 3,1)) =1

--2.yöntem:

SELECT street, SUBSTRING(street, 3,1)
FROM sale.customer
WHERE SUBSTRING(street, 3,1) LIKE '[0-9]'

--3.YÖNTEM

SELECT street, SUBSTRING(street, 3,1)
FROM sale.customer
WHERE SUBSTRING(street, 3,1) LIKE '[a-z]'

--4.yöntem

SELECT street, SUBSTRING(street, 3,1)
FROM sale.customer
WHERE SUBSTRING(street, 3,1) LIKE '[^0-9]'

--WINDOW FUNCTIONS

--Question: Stock tablosundaki ürünlerin stok miktarlarýný getiriniz.


SELECT product_id
FROM product.stock

SELECT product_id
FROM product.stock
GROUP BY product_id

SELECT product_id, SUM(quantity) cnt_stock
FROM product.stock
GROUP BY product_id
ORDER BY 1

--2.yöntem WF
-- Her bir ürünü hangi maðazada varsa o kadar olan miktarý getirdi. Ayrýca toplam miktarýnýda getirdi.
-- PMevcut tablonun yanýný gruplandýrma yapýlýrsa çýkan sonucu ayrý bir sütun olarak yanýna yazýyor.

SELECT *, 
SUM(quantity) OVER (PARTITION BY product_id) total_stock
FROM product.stock

SELECT DISTINCT product_id,
SUM(quantity) OVER (PARTITION BY product_id) total_stock
FROM product.stock

--Question: En ucuz bisiklet fiyatý nedir?

SELECT *
FROM product.product

SELECT MIN(list_price)  --DISTINCT YAPTI.
FROM product.product

SELECT MIN(list_price) OVER ()   -- HERBÝR SATIRIN KARÞISINA BUNU EKLEDÝ.
FROM product.product

--Herbir kategorideki en ucuz bisikletin fiyatý?

SELECT category_id, MIN(list_price) OVER(PARTITION BY category_id)
FROM product.product

SELECT DISTINCT category_id, MIN(list_price) OVER(PARTITION BY category_id)
FROM product.product

