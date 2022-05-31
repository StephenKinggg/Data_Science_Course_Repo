--REPLACE

SELECT REPLACE('CHARACTER STRING', ' ','/')

SELECT REPLACE(123123123555, 123, 88)


--STR

SELECT STR(5454)  --10 KARAKTERDEN AZ GÝRERSEK KALAN BOÞLUKLA DOLDURUR.

SELECT STR(5454,4)  --4 HANELÝ GETÝRÝR.

SELECT STR(5454.475, 7)  --7 HANELÝ ÝSTEDÝK AMA NOKTADAN SONRASINI DÝKKATE ALMADI.

SELECT STR(5454.475, 7, 3 ) --NOKTADAN SONRA NOKTA DAHÝL KAÇ KARAKTER GETÝRECEÐÝMÝZÝ DE YAZDIK.

SELECT REPLACE(1232435464, 123, 'aha')+1

SELECT REPLACE(1232435464, 123, 123)+1

SELECT ISNUMERIC (REPLACE(1232435464, 123, 222))  --numeric ise 1 döndürür.

SELECT ISNUMERIC (REPLACE(1232435464, 123, 'aha'))  --numeric deðilse 0 döndürür.


--CAST

SELECT CAST(123135 AS VARCHAR)

SELECT CAST(0.33333 AS NUMERIC(3,2)) --3 haneli rakým 2 tanesi virgülden sonra gelsin.

SELECT CAST(10.33333 AS NUMERIC(5,3)) 


--CONVERT

SELECT CONVERT(INT, 30.48)  --integer dönüþtürdü.

SELECT CONVERT(DATETIME, '2021-10-10')  --datetime dönüþtürdü.

SELECT CONVERT(VARCHAR, '2021-10-10', 6) --bunu çalýþtýramadýk sorun oldu.


--COALESCE

SELECT COALESCE(NULL, NULL, 'Ahmet', NULL) --return the first non null argument.



--NULLIF

SELECT NULLIF(10,10)  --ilk expression ikincisine eþit ise NULL getiriyor.

SELECT NULLIF(10,9)  --deðilse ilkini getiriyor.


--ROUND

SELECT ROUND(432.368,2) --NOKTADAN SONRA ÝKÝ HANEYE YUVARLADI.

SELECT ROUND(432.368,3)

SELECT ROUND(432.368,2,1) -- ÝKÝNCÝ ARGÜMANI YAZMAZSAK DEFAULT OLARAK YUKARI YUVARLAR.

SELECT ROUND(432.368,1) --NOKTADAN SONRA BÝRÝNCÝ HANEDEN SONRASINI YUKARI YUVARLADI.

SELECT ROUND(432.364,1)


--QUESTÝON:

--How many yahoo mails in customers email column?Use Case Expression and Pathindex() function
-- Customer email sütununda kaç tane yahoo maili var?

SELECT *
FROM sale.customer

SELECT email, PATINDEX('%@yahoo%', email) --yahoo varsa indeksini getiriyor yoksa 0 getiriyor.
FROM sale.customer

SELECT SUM(CASE WHEN PATINDEX('%@yahoo%', email) >0 THEN 1 ELSE 0 END) --yahoo varsa indeksini getiriyor yoksa 0 getiriyor.
FROM sale.customer



--2.YÖNTEM:

SELECT count(*)
FROM sale.customer
WHERE email LIKE '%@yahoo%'


--3. Yöntem:

SELECT 
SUM(CASE WHEN PATINDEX('%@yahoo%', email) > 0 AND PATINDEX('%@yahoo%', email) IS NOT NULL THEN 1 ELSE 0 END) AS YAHOO
FROM sale.customer



-- QUESTION: 

--Write a query that returns the characters before the '.' character in the email column.
--Mail adresinde ilk noktaya kadar olan kýsmý alýnýz.

SELECT email, SUBSTRING(email, 1, CHARINDEX('.', email)-1 )
FROM sale.customer

--2.Yöntem:

SELECT email, CHARINDEX('.', email)-1  --noktanýn indeksini bulduk ve bunu 1 azaltarak string ifadenin uzunluðunu bulduk.
FROM sale.customer

SELECT email, LEFT(email, CHARINDEX('.', email)-1 )
FROM sale.customer

--Question: 
/*
--Add a new column to the customers table that contains the customers contact information. 
If the phone is not null, the phone information will be printed, if not, 
the email information will be printed.
*/
--Customer tablosundan contact bilgilerine bakarak eðerek tel bilgisi null deðilse telefon bilgisini, eðer null ise email bilgisini getir.
--her müþteriye ulaþabileceðim telefon veya email bilgisini istiyorum.
--Müþterinin telefon bilgisi varsa email bilgisine gerek yok.
--telefon bilgisi yoksa email adresi iletiþim bilgisi olarak gelsin.
--beklenen sütunlar: customer_id, first_name, last_name, contact

SELECT *, COALESCE(phone, email) as contact
FROM sale.customer


SELECT *
FROM sale.customer
WHERE email IS NULL   --email in null olduðu deðer yok.

SELECT email, NULLIF(email, 'emily.brooks@yahoo.com')   --eðer email bu adres ise NULL yazdýrýyor. Deðilse emaili yazýyor.
FROM sale.customer

SELECT *, COALESCE(phone, NULLIF(email, 'emily.brooks@yahoo.com'), 'a') contact
FROM sale.customer    --burada ise bu null deðerine a yazdýk.

SELECT *, COALESCE(phone, NULLIF(email, 'emily.brooks@yahoo.com')) contact --burada ilk emaili NULLIF ile NULL çevirdik. Phone da NULL olduðundan dolayý contact NULL döndü.
FROM sale.customer



--Question:
--Write a query that returns streets. The third character of the streets is numerical.
--Street sütununda soldan üçüncü karakterin rakam olduðu kayýtlarý getiriniz.

SELECT street
FROM sale.customer

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer

SELECT street, ISNUMERIC(SUBSTRING(street, 3, 1)) 
FROM sale.customer
WHERE ISNUMERIC(SUBSTRING(street, 3,1)) = 1

--2.yöntem:

SELECT street, SUBSTRING(street, 3, 1)  --3.karakterde olan sayýlarý getirdi bize.
FROM sale.customer
WHERE SUBSTRING(street, 3,1) LIKE '[0-9]'

--3.YÖNTEM

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer
WHERE SUBSTRING(street, 3,1) NOT LIKE '[a-z]' --3.karakteri harf olmayanlarý yazdýrdý.

--4.yöntem

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer
WHERE SUBSTRING(street, 3, 1) NOT LIKE '[^0-9]' --'[^0-9]' arasýnda kalanlarýn dýþýnda olanlar demek. 


--WINDOW FUNCTIONS

--Question: 
--Write a query that returns stock amounts of products(only stock tabele)(Use both Group by and WF)
--Stock tablosundaki ürünlerin stok miktarlarýný getiriniz.


SELECT product_id  --3 farklý maðazada toplam 939 tane satýr olduðunu gördük.
FROM product.stock


--Using Group By : 3 maðazadaki deðerleri topladý ve 313 satýra düþtü.

SELECT product_id, SUM(quantity) cnt_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id  --ORDER BY 1 kullanýlabilir.



--2.yöntem WF
-- Her bir ürünü hangi maðazada varsa o kadar olan miktarý getirdi. Ayrýca toplam miktarýnýda getirdi.
-- Mevcut tablonun yanýný gruplandýrma yapýlýrsa çýkan sonucu ayrý bir sütun olarak yanýna yazýyor.

SELECT *, 
SUM(quantity) OVER (PARTITION BY product_id) total_stock
FROM product.stock

SELECT DISTINCT product_id,  --313 satýra düþtü.
SUM(quantity) OVER (PARTITION BY product_id) total_stock
FROM product.stock

--Question: 
--Write a query that returns what is the cheapest bike price.
--En ucuz bisiklet fiyatý nedir?

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


---Window Frames

SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id  ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id