
--------Advanced Grouping Operations

----Write a query that checks if any product id is repeated in more than one row in the products table.
----product tablosunda herhangi bir product id' nin çoklayýp çoklamadýðýný kontrol ediniz.

SELECT *
FROM product.product

SELECT product_id, COUNT(*) CNT_ROW
FROM product.product 
GROUP BY product_id
HAVING COUNT(*) > 1 --Agg.sonucu ortaya çýkan yeni sütunda bir filtreleme yapýyorum.

--Write a query that returns category ids with a max list price above 4000 or a min list price below 500.
--maximum list price' ý 4000' in üzerinde olan veya minimum list price' ý 500' ün altýnda olan categori id' leri getiriniz
--category name' e gerek yok.


SELECT category_id, MAX(list_price) MAX_PRICE, MIN(list_price) MIN_PRICE
FROM product.product
GROUP BY category_id

SELECT category_id, list_price
FROM product.product
ORDER BY 1,2 

SELECT category_id, MAX(list_price) MAX_PRICE, MIN(list_price) MIN_PRICE
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500

SELECT category_id, MAX(list_price) MAX_PRICE, MIN(list_price) MIN_PRICE
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 AND MIN(list_price) < 500

--Find the average product prices of the brands.
--Markalara ait ortalama ürün fiyatlarýný bulunuz.
--ortalama fiyatlara göre azalan sýrayla gösteriniz.

SELECT B.brand_name, AVG(A.list_price) AVG_PRICE
FROM product.product A
INNER JOIN product.brand B ON A.brand_id=B.brand_id
GROUP BY B.brand_name
ORDER BY AVG(A.list_price) DESC

///***
SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
ORDER BY 
		avg_price DESC
***///

---Write a query that returns BRANDS with an average product price of more than 1000.
---ortalama ürün fiyatý 1000' den yüksek olan MARKALARI getiriniz

SELECT B.brand_name, AVG(A.list_price) AVG_PRICE
FROM product.product A
INNER JOIN product.brand B ON A.brand_id=B.brand_id
GROUP BY B.brand_name
HAVING AVG(A.list_price) > 1000
ORDER BY AVG(A.list_price) ASC  --AVG_PRICE da kullanabilirdik.


--Write a query that returns the net price by the customer for each order.(Dont neglect discounts and quantities)
--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.


SELECT *
FROM sale.order_item

SELECT *
FROM sale.orders

--Herbir müþteri tarafýndan verilen sipariþ toplamlarý
SELECT A.customer_id, A.order_id, SUM ((B.list_price*(1-B.discount))*B.quantity)
FROM sale.orders A
INNER JOIN sale.order_item B ON A.order_id=B.order_id
GROUP BY A.customer_id, A.order_id
ORDER BY A.customer_id

--Verilen her bir sipariþin toplam tutarý
SELECT A.order_id, SUM ((B.list_price*(1-B.discount))*B.quantity)
FROM sale.orders A
INNER JOIN sale.order_item B ON A.order_id=B.order_id
GROUP BY A.order_id
ORDER BY A.order_id


--SELECT ... INTO FROM ...
--Aþaðýda 4 tabloyu kullanarak aþaðýdaki columnleri içeren brand name, category name, model year göre bir gruplama yaparak yeni özet bir tablo oluþturuyoruz.

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


-----GROUPING SETS

SELECT *
FROM	sale.sales_summary

----1. Toplam sales miktarýný hesaplayýnýz.


SELECT	SUM(total_sales_price)
FROM	sale.sales_summary


--2. Markalarýn toplam sales miktarýný hesaplayýnýz

SELECT brand, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY brand


--3. Kategori bazýnda yapýlan toplam sales miktarýný hesaplayýnýz

SELECT Category, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY Category

--4. Marka ve kategori kýrýlýmýndaki toplam sales miktarýný hesaplayýnýz

SELECT brand, Category, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY brand, Category
ORDER BY brand

SELECT brand, category, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY 
	GROUPING SETS(
	         (brand, category), -- yukarýdaki brand ve category göre gruplandýrma
			 (brand),           -- yukarýdaki brand göre gruplandýrma
			 (category),        -- yukarýdaki category göre gruplandýrma
			 ()                 -- yukarýdaki gruplandýrma yapmadan toplam sales verir.
			 )
ORDER BY brand, category

--Yukarýdaki query göre çýkan tabloda () olunca sadece total_sales yazacak,category veya branda göre bu satýrlar dolu olacak, category ve brand göre iki sütun dolu olacak.


--brand, category, model_year sütunlarý için Rollup kullanarak total sales hesaplamasý yapýnýz.
--üç sütun için 4 farklý gruplama varyasyonu incelemeye çalýþýnýz.

SELECT brand, category,model_year, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY 
	ROLLUP (brand, category, model_year) 