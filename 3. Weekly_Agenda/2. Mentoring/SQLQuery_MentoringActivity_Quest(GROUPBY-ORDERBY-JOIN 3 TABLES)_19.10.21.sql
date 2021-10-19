--1. What is the sales quantity of product according to the brands and sort them highest lowest
----1.cözüm

SELECT A.brand_name, SUM(C.quantity) as total_of_sales
FROM product.brand A, product.product B, sale.order_item C
WHERE B.product_id = C.product_id and 
      A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY total_of_sales DESC

----2.çözüm
--- Brand name göre gruplandýrýp buna göre ürünlerin toplam satýþ miktarlarýný bulduk.
SELECT A.brand_name, SUM(C.quantity) as total_of_sales 
FROM sale.order_item C
INNER JOIN product.product B ON C.product_id = B.product_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY total_of_sales DESC

--2. Select the top 5 most expensive products 
SELECT TOP 5 A.product_id, A.product_name, A.list_price
FROM product.product A
ORDER BY A.list_price DESC

--3.What are the categories that each brand has
----1.çözüm
--brand name ve category name göre gruplandýrdýk ve her bir brand name kaç tane farklý category var onu bulduk.
SELECT A.brand_name, COUNT(DISTINCT B.category_id) as count_of_category
FROM product.category C
INNER JOIN product.product B ON C.category_id = B.category_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY count_of_category DESC
----1.çözüm
--brand name ve category name göre gruplandýrdýk ve brand name göre sýraladýk.
SELECT A.brand_name, C.category_name
FROM product.category C 
INNER JOIN product.product B ON C.category_id = B.category_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name, C.category_name
ORDER BY A.brand_name DESC

----2.çözüm
SELECT A.brand_name, C.category_name
FROM product.category C, product.product B, product.brand A
WHERE C.category_id = B.category_id AND A.brand_id = B.brand_id
GROUP BY A.brand_name, C.category_name
ORDER BY A.brand_name DESC

--4.Select the avg prices according to brands and categories
--brand name ve category name göre gruplandýrýp bunlarýn ortalama fiyatýný alýp fiyata göre sýraladýk.
SELECT A.brand_name, C.category_name, AVG(B.list_price) as avg_list_price
FROM product.category C
INNER JOIN product.product B ON C.category_id = B.category_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name, C.category_name
ORDER BY avg_list_price DESC

--brand name ve category name göre gruplandýrýp bunlarýn ortalama fiyatýný aldýk ve brand name göre gruplandýrdýk.
SELECT A.brand_name, C.category_name, AVG(B.list_price) as avg_list_price
FROM product.category C
INNER JOIN product.product B ON C.category_id = B.category_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name, C.category_name
ORDER BY A.brand_name DESC