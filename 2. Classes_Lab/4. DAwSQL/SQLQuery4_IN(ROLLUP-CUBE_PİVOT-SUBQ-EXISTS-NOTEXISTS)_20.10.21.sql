-----///    2021-10-20 DAwSQL Session 3 (Organize Complex Queries)


--- FROM THE LAST SESSION

DROP TABLE IF EXISTS sale.sales_summary;

--Summary Table

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


-- ROLLUP

--brand, category, model_year sütunlarý için Rollup kullanarak total sales hesaplamasý yapýn.
--üç sütun için 4 farklý gruplama varyasyonu üretmek istiyoruz.

SELECT *
FROM sale.sales_summary

SELECT brand, Category, Model_Year, SUM(total_sales_price) total_price
FROM sale.sales_summary
GROUP BY
		ROLLUP(brand, Category, Model_Year)

--brand, category, model_year sütunlarý için cube kullanarak total sales hesaplamasý yapýn.

--üç sütun için 8 farklý gruplama varyasyonu oluþturuyor	



SELECT	brand, Category, Model_Year, SUM(total_sales_price) total_price
FROM	sale.sales_summary
GROUP BY
		CUBE (brand, Category, Model_Year)
ORDER BY
		brand, Category


--PIVOT 


-- ÝSE TEK SATIR YAZMAK ÝÇÝN.
/* BUNLARIN ARASINA BÝRKAÇ SATIR YORUM YAZMAK ÝSTERSEK KULLANILIR. 
SHÝFT TUÞUNA UZUN BASIP AÞAÐI YUKARI GEDÝBÝLÝRÝZ.*/


SELECT *
FROM sale.sales_summary

--Kategorilere ve model yýlýna göre toplam sales miktarýný summary tablosu üzerinden toplayalým.

SELECT Category, Model_Year, SUM(total_sales_price) Total_Prices
FROM sale.sales_summary
GROUP BY Category, Model_Year
ORDER BY 1,2 --SELECT TEKÝ BÝRÝNCÝ VE ÝKÝNCÝ SÜTUNA GÖRE. GROUP BY DA BU ÖZELLÝK YOK.

--Kaynak tablom aþaðýdaki gibidir.

SELECT Category, Model_Year, total_sales_price
FROM	SALE.sales_summary

SELECT *
FROM
	(
	SELECT Category, Model_Year, total_sales_price --Bunu burada yazmassak yukarýda SELECT sonrasý yazmamýz gerekir.
	FROM	SALE.sales_summary  --Kaynak table
	) A
PIVOT
	(
	SUM(total_sales_price) --aggregate func.
	FOR Category           --category sütunu.
	IN (                   --category altýndaki alt kategorileri [] içinde yazdým.
		[Children Bicycles],  --Shift + tab ile geri, tab ile ileri.
		[Comfort Bicycles],
		[Cruisers Bicycles],
		[Cyclocross Bicycles],
		[Electric Bikes],
		[Mountain Bikes],
		[Road Bikes]
		)
	) AS P1

-- MODEL YILLARINA GÖRE

SELECT *
FROM
	(
	SELECT Category, Model_Year, total_sales_price
	FROM	SALE.sales_summary
	) A
PIVOT
	(
	SUM(total_sales_price)
	FOR model_year
	IN (
	[2018], [2019], [2020]
		)
	) AS P1


-- SUBQUERIES
--Write a query that returns the total list price by each order ids.
--order id lere göre toplam list price larý hesaplayalým.

--Toplam list_price getirip her order_id nin yazýna yazdý.

SELECT *
FROM sale.order_item


SELECT order_id,
	(SELECT SUM(list_price) FROM sale.order_item)
FROM sale.order_item

--Correlated Subquery
--Aþaðýda outer query ile inner queryden seçtiðim order_id deðerlerini birbirine eþitledim.

SELECT DISTINCT order_id,
		(SELECT SUM(list_price) FROM sale.order_item B WHERE A.order_id = B.order_id) SUM_PRICE
FROM	sale.order_item A

--Yukarýdakini GROUP BY ile yaptýk.

SELECT order_id, SUM(list_price)
FROM sale.order_item
GROUP BY order_id

--Bring all the staff from the store that Maria Cussona works.
--Maria Cussona nýn calýþtýðý maðazadaki tüm personelleri listeleyin.

SELECT *
FROM sale.staff


--Inner queryden dönen sonuç single row olduðundandolayý outer query da = kullandýk.
SELECT *
FROM sale.staff
WHERE store_id = (
					SELECT store_id
					FROM sale.staff A
					WHERE A.first_name='Maria' AND A.last_name='Cussona'
				)

--List the staff that Jane Destrey is the manager of.
--Jane Destreyin manageri olduðu kiþileri bulalým.

SELECT *
FROM sale.staff

SELECT *
FROM sale.staff
WHERE manager_id = (
					SELECT staff_id
					FROM sale.staff 
					WHERE first_name='Jane' AND last_name='Destrey'
				)


/* Bazi arkadaslar goruyorum sorguda ‘Jane’ yerine ‘jane’ kullanmis. 
Default olarak SQL Server case-insensitive oldugu icin problem olmuyor. 
Ama database olustururken istersek ‘COLLATION’ ile case-sensitive bir 
database olusturabiliriz. Bu da benden bir interview sorusu..*/

--Write a query that returns customers in the city where the"Sacramento Bikes" store is located.


SELECT *
FROM sale.customer
WHERE city = (
				SELECT DISTINCT city
				FROM sale.store A INNER JOIN sale.orders B ON A.store_id=B.store_id
				WHERE store_name='Sacramento Bikes'
			 )

-- List customers whose order dates are before Arla Ellis.

SELECT B.first_name, B.last_name, A.order_date
FROM sale.orders A INNER JOIN sale.customer B ON A.customer_id=B.customer_id
WHERE A.order_date < (
						SELECT order_date
						FROM sale.orders A INNER JOIN sale.customer B ON A.customer_id=B.customer_id
						WHERE A.customer_id = (
												SELECT customer_id
												FROM sale.customer
												WHERE first_name='Arla' and last_name='Ellis'
						))


--Multiple Row Subqueries

--List order dates for customers residing in the Holbrok city.
--Holbrok þehrinde oturan müþterilerin sipariþ tariherini listeleyin.



SELECT *
FROM sale.customer
WHERE city='Holbrook'



SELECT *
FROM sale.orders
WHERE customer_id IN (SELECT customer_id
					  FROM sale.customer
					  WHERE city='Holbrook'
					  )

--List all customers who orders on the same dates as Abby Parks.
-- Abby	Parks isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.


SELECT B.first_name, B.last_name, A.order_date
FROM sale.orders A INNER JOIN sale.customer B ON A.customer_id=B.customer_id
WHERE A.order_date IN (
						SELECT order_date
						FROM sale.orders A INNER JOIN sale.customer B ON A.customer_id=B.customer_id
						WHERE A.customer_id = (
												SELECT customer_id
												FROM sale.customer
												WHERE first_name='Abby' and last_name='Parks'
						))


--Abby nin sipariþ verdiði tarihler

SELECT *
FROM sale.customer A
INNER JOIN sale.orders B ON A.customer_id=B.customer_id
WHERE A.last_name='Parks' AND A.first_name='Abby'


SELECT C.first_name, C.last_name, A.order_id, A.order_date
FROM sale.orders A
INNER JOIN (SELECT A.first_name,A.last_name,B.customer_id,B.order_id,B.order_date
			FROM sale.customer A
			INNER JOIN sale.orders B ON A.customer_id=B.customer_id
			WHERE A.last_name='Parks' AND A.first_name='Abby') B
ON A.order_date=B.order_date
INNER JOIN sale.customer C ON A.customer_id=C.customer_id

--List bikes that model year equal to 2020 and its prices more than all electric bikes.
--Bütün elektrikli bisikletlerden pahalý olan bisikletleri listeleyin.
--Ürün adý, model yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru listeleyelim.

/*
ALL ile inner query içindeki fiyatlardan daha büyük olanlarý al demek istiyoruz. 4999 dan büyük olanlarý getirir.
ANY ile inner query içindeki fiyatlardan en düþük olandan fazla olanlarý alýr. 1599 dan büyük olanlarý getirir.
*/

SELECT product_name, model_year, list_price
FROM product.product
WHERE list_price > ALL (
						SELECT	list_price
						FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
						WHERE	B.category_name = 'Electric Bikes')
AND model_year = 2020
					


SELECT product_name, list_price
FROM product.product
WHERE list_price > ANY (
						SELECT	list_price
						FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
						WHERE	B.category_name = 'Electric Bikes')	
AND model_year = 2020


/* EXIST ve NOT EXIST içteki tablonun ne döndürdüðü ile 
deðil döndürüp döndürmediði ile ilgileniyor.*/

----Abby Parks isimli bir müþteri olduðundan dýþtaki query döner.

SELECT B.first_name, B.last_name, A.order_date
FROM sale.orders A 
INNER JOIN sale.customer B 
on A.customer_id=B.customer_id
WHERE EXISTS  (
               SELECT 1  
			   FROM sale.customer A
			   JOIN sale.orders B
			   ON A.customer_id=B.customer_id
			   WHERE first_name = 'Abby' and last_name= 'Parks'
			   )

--Abby Parks isimli bir müþteri olduðundan boþ döner.

SELECT B.first_name, B.last_name, A.order_date
FROM sale.orders A 
INNER JOIN sale.customer B 
on A.customer_id=B.customer_id
WHERE NOT EXISTS  (
                       SELECT 1  
					   FROM sale.customer A
					   JOIN sale.orders B
					   ON A.customer_id=B.customer_id
					   WHERE first_name = 'Abby' and last_name= 'Parks'
				  )

--AbbAy Parks isimli bir müþteri varsa bu boþ döner ancak yoksa dýþtaki query nin hepsi gelir. 

SELECT B.first_name, B.last_name, A.order_date
FROM sale.orders A 
INNER JOIN sale.customer B 
on A.customer_id=B.customer_id
WHERE NOT EXISTS  (
                       SELECT 1  
					   FROM sale.customer A
					   JOIN sale.orders B
					   ON A.customer_id=B.customer_id
					   WHERE first_name = 'AbbAy' and last_name= 'Parks'
					)


SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM sale.orders A 
INNER JOIN sale.customer B 
on A.customer_id=B.customer_id
WHERE EXISTS  (
				   SELECT 1  
 				   FROM sale.customer A
				   JOIN sale.orders B
				   ON A.customer_id=B.customer_id
				   WHERE first_name = 'AbbAy' and last_name= 'Parks'
			   )


SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM sale.orders A 
INNER JOIN sale.customer B 
on A.customer_id=B.customer_id
WHERE EXISTS  (
				   SELECT 1  
 				   FROM sale.customer C
				   JOIN sale.orders D
				   ON C.customer_id=D.customer_id
				   WHERE first_name = 'Abby' and last_name= 'Parks'
				   AND A.order_date=D.order_date
			   )