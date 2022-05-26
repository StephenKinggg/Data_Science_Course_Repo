-------------- 14.10.2021 Combine Your Tables ----------------

------ INNER JOIN ------

-- List products with category names
-- Select product ID, product name, category ID and category names

SELECT  TOP 10 *
FROM product.product AS A

SELECT  TOP 10 *
FROM product.category AS B


SELECT A.product_name, A.product_id, B.category_id, B.category_name
FROM product.product AS A
INNER JOIN product.category AS B ON A.category_id = B.category_id

--List employees of stores with their store information
--Select employee name, surname, store names

SELECT  TOP 10 *
FROM sale.staff AS A

SELECT  TOP 10 *
FROM sale.store AS B

SELECT A.first_name, A.last_name, B.store_name
FROM sale.staff AS A
INNER JOIN sale.store AS B ON A.store_id = B.store_id

------ LEFT JOIN ------

-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Use Left Join)

SELECT DISTINCT P.product_id, P.product_name, O.order_id --Tekrarlayan veriyi engellemek için DISTINCT kullandýk.
FROM product.product AS P
LEFT JOIN sale.order_item AS O ON P.product_id = O.product_id

SELECT P.product_id, P.product_name, O.order_id
FROM product.product AS P
LEFT JOIN sale.order_item AS O ON P.product_id = O.product_id
WHERE O.order_id IS NULL -- = NULL da yazýlabilir.

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

SELECT P.product_id, P.product_name, S.store_id, S.quantity
FROM product.product AS P
LEFT JOIN product.stock AS S ON P.product_id = S.product_id
WHERE P.product_id > 310
ORDER BY store_id ASC

------ RIGHT JOIN ------

--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.

SELECT P.product_id, P.product_name, S.store_id, S.quantity
FROM product.stock AS S
RIGHT JOIN product.product AS P ON P.product_id = S.product_id
WHERE P.product_id > 310
ORDER BY store_id ASC


---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders


SELECT *
FROM SALE.staff

SELECT COUNT (staff_id) -- stafflarýn sayýsýný getirmek için Count kullandýk.
FROM SALE.staff

SELECT COUNT(DISTINCT A.staff_id) --Buradan 4 çalýþanýn hiç sipariþ almadýðýný anlýyoruz. Dýstýnct olmasa satýr sayýsýný getirir.
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id = B.staff_id


SELECT S.staff_id, S.first_name, S.last_name
FROM sale.orders AS O
INNER JOIN sale.staff AS S ON S.staff_id = O.staff_id
ORDER BY order_id ASC

------ FULL OUTER JOIN ------

--Write a query that returns stock and order information together for all products . (TOP 20)
--Expected columns: Product_id, store_id, quantity, order_id, list_price

SELECT *
FROM SALE.order_item A
FULL OUTER JOIN product.stock B ON A.product_id=B.product_id
ORDER BY A.product_id, A.order_id --Sýralamayý böyle yapýnca çýkan sonuca dikkat!!


SELECT *
FROM SALE.order_item A
FULL OUTER JOIN product.stock B ON A.product_id=B.product_id
ORDER BY B.product_id, A.order_id --Sýralamayý böyle yapýnca çýkan sonuca dikkat!!Yukarýdakinden farklý.


SELECT TOP 20 B.product_id, B.store_id, B.quantity,A.product_id, A.order_id, A.list_price
FROM SALE.order_item A
FULL OUTER JOIN product.stock B ON A.product_id=B.product_id
ORDER BY B.product_id, A.order_id

--Çýkan sonucun ilk 2 satýrýna bakýnca stock tablosunun product_id si varken order_item tablosunun bilgileri boþ gözüküyor.
-- Kesiþim yapmadýðýndan dolayý 2 tabloda da olan tüm product_id bilgilerini bize getiriyor.
