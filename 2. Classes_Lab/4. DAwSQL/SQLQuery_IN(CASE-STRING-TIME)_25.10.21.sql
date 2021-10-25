--25.10.21 
-- EXCEPT
-- 2018 model bisiklet markalarýndan hangilerinin 2019 model bisikleti yoktur?



SELECT COUNT(DISTINCT brand_id)
FROM product.product
WHERE model_year= 2018

SELECT COUNT(DISTINCT brand_id)
FROM product.product
WHERE model_year= 2019

SELECT brand_id, brand_name    --Sonra brand tablosundan brand_id lerin isimlerini buluyoruz.
FROM product.brand
WHERE brand_id IN(
SELECT brand_id          --2018 yýlýnda üretilen markalarýn id sine baktýk.
FROM product.product
WHERE model_year= 2018

EXCEPT                  -- 2018 den 2019 çýkardýk.

SELECT brand_id           --2019 yýlýnda ürütelin markalarýn id sine baktýk.
FROM product.product
WHERE model_year= 2019)

SELECT DISTINCT model_year
FROM product.product
WHERE brand_id=5

--Question:
--Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda verilmeyen ürünler hangileridir?
-- Sadece dediði zaman bu hususa dikkat etmek gerekir.

SELECT C.product_id, C.product_name  --Çýkan sonucu product tablosu ile ýnner join yapýp buradan product_id ve name çekiyoruz.
FROM product.product C
INNER JOIN(
SELECT A.product_id  --2019 yýlýnda sipariþ verilen ürünleri bulduk.
FROM sale.order_item A, sale.orders B
WHERE A.order_id=B.order_id
AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'  --LIKE '2019%' da kullanabiliriz.

EXCEPT

SELECT A.product_id  --2019 yýlý dýþýnda sipariþ verilen ürünleri bulduk.ve bunu 2019 yýlýndan çýkarýnca kalan sadece 2019 yýlýnda verilen diðer yýllarda verilmeyenlerdir.
FROM sale.order_item A, sale.orders B
WHERE A.order_id=B.order_id
AND B.order_date NOT BETWEEN '2019-01-01' AND '2019-12-31'
) D
ON C.product_id=D.product_id


--CASE Expression
--Question:
-- Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturum.
--1=Pending, 2=Processing, 3=Rejected, 4=Completed

SELECT *
FROM sale.orders

SELECT order_id, order_status,
       CASE order_status    --çalýþtýðýmýz sütun belirttik.
			WHEN 1 THEN 'Pending'   --sütunu belirtince burada sadece içeriðindeki deðerleri yazmamýz yeterli
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			ELSE 'Completed'
	   END AS order_status_mean  --sütunu isim veriyoruz.
FROM sale.orders
ORDER BY order_status

--Question:
--Staff tablosuna çalýþanlarýn maðaza isimlerini ekleyin.
--1 = sacramento bikes, 2: buffalo bikes, 3: san angelo bikes
--SINGLE CASE

SELECT first_name, last_name,
       CASE store_id   --çalýþtýðýmýz sütun belirttik.
			WHEN 1 THEN 'Sacramento Bikes'   --sütunu belirtince burada sadece içeriðindeki deðerleri yazmamýz yeterli
			WHEN 2 THEN 'Buffalo Bikes'
			ELSE 'San Angelo Bikes'  --ELSE þart koþulmaz.
	   END AS store_name  --sütunu isim veriyoruz.
FROM sale.staff
ORDER BY store_name


--Staff tablosuna çalýþanlarýn maðaza isimlerini ekleyin.
--1 = sacramento bikes, 2: buffalo bikes, 3: san angelo bikes
--SEARCHED CASE

SELECT first_name, last_name,
		CASE   --Single dan farký buraya sütun adý yazmýyoruz.
			WHEN store_id=1 THEN 'Sacramento Bikes'   --sütunu burada belirtiyoruz.
			WHEN store_id=2 THEN 'Buffalo Bikes'
			WHEN store_id=3 THEN 'San Angelo Bikes'
	   END AS store_name  --sütunu isim veriyoruz.
FROM sale.staff
ORDER BY store_name

--Question:
--Customer tablosundaki email adreslerinden gmail, yahoo ve hotmail olanlar dýþýndakiler için other kullanalým. 


SELECT A.first_name, A.last_name, email,
	CASE
		WHEN email LIKE '%yahoo.com%' THEN 'Yahoo' 
		WHEN email LIKE '%hotmail.com%' THEN 'Hotmail'
		WHEN email LIKE '%gmail.com%' THEN 'Gmail'
		WHEN email IS NULL THEN 'Others'   --NULL DEGERLER DIÞINDAKÝLER ÝÇÝN OTHERS YAZIYOR.
	END AS email_service_provier  
FROM sale.customer A

--2.çözüm

SELECT email, substring(email,
        charindex('@',email,1)+1,
        charindex('.',email,charindex('@',email,1)+1)-charindex('@',email,1)-1) as email_service_provider
FROM sale.customer


--Question:
-- Ayný sipariþte hem Electric Bikes, hem Comfort Bicycles hem de Children Bicycles ürünlerini sipariþ veren müþterileri bulunuz.

