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


/*
SELECT C.order_item, C.product_id
FROM sale.order_item C,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name IN ('Electric Bikes' , 'Comfort Bicycles','Children Bicycles')))


SELECT order_id, product_id
FROM sale.order_item C, 
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name IN ('Electric Bikes' , 'Comfort Bicycles','Children Bicycles'))
ORDER BY C.order_id
*/

/*
WITH T1 AS
		(SELECT O.order_id, C.first_name, C.last_name
		FROM sale.customer C, sale.orders O
		WHERE C.customer_id=O.customer_id),

WITH T2 AS
		(SELECT I.order_id, I.product_id
		FROM sale.order_item I, sale.orders O
		WHERE I.order_id=O.order_id),
	T3 AS
		(SELECT A.category_id, A.category_name, B.product_id
		FROM product.category A , product.product B
		WHERE A.category_id=B.category_id
		AND A.category_name IN ('Electric Bikes' , 'Comfort Bicycles','Children Bicycles'))
SELECT T2.order_id, T3.product_id,T3.category_name
FROM T2,T3
WHERE T2.product_id=T3.product_id
ORDER BY T2.order_id
*/

SELECT C.first_name, C.last_name
FROM sale.orders S, sale.customer C,
(SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Electric Bikes') E
WHERE O.product_id=E.product_id

INTERSECT

SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Comfort Bicycles') C
WHERE O.product_id=C.product_id

INTERSECT

SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Children Bicycles') C1
WHERE O.product_id=C1.product_id) ORD
WHERE ORD.order_id=S.order_id
AND S.customer_id=C.customer_id


--DATE FUNCTIONS
--Date Types


CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT *
FROM t_date_time

SELECT Getdate() as [now]

INSERT t_date_time
VALUES(Getdate(),Getdate(),Getdate(),Getdate(),Getdate(),Getdate())

SELECT Getdate() as [now]


SELECT CONVERT (varchar, GETDATE(), 6)

--convert a varchar to date

SELECT CONVERT (DATE, '25 Oct 21', 6)  -- Varcharý 6 numaralý sitil date dönüþtürdü.

SELECT CONVERT (DATE, '25 Oct 21', 2)

SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time

SELECT	A_date,
		DATENAME(DW, A_date) [DAY]
FROM	t_date_time

SELECT	A_date,
		DATENAME(WEEKDAY, A_date) [weekDAY]
FROM	t_date_time

SELECT	A_date,
		MONTH(A_date) [month]
FROM	t_date_time

SELECT	A_date,
	DATEPART (NANOSECOND, A_time)
FROM	t_date_time


SELECT	A_date,
	DATEPART (WEEK, A_date)[week]
FROM	t_date_time
