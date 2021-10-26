--2.1. Select the annual amount of product produced according to brands 

SELECT *
FROM product.brand

SELECT *
FROM product.product


SELECT A.brand_name, B.model_year, COUNT(DISTINCT B.product_id)
FROM product.brand A, product.product B
WHERE A.brand_id=B.brand_id
GROUP BY A.brand_name, B.model_year
ORDER BY A.brand_name


--2.2. Select the store which has the most sales quantity in 2018 

SELECT *
FROM sale.orders

SELECT *
FROM sale.order_item

SELECT *
FROM sale.store


WITH T1 AS
(SELECT order_id, product_id, quantity
FROM sale.order_item),
T2 AS
(SELECT order_id,order_date, store_id
FROM sale.orders
WHERE order_date LIKE '%2018%'),
T3 AS 
(SELECT store_id, store_name
FROM sale.store)
SELECT T3.store_id, T3.store_name, SUM(T1.quantity) Total_Order_Quantity--T1.order_id, T1.quantity, T1.product_id,T2.order_date, T2.store_id, T3.store_name
FROM T1,T2,T3
WHERE T1.order_id=T2.order_id
AND T2.store_id=T3.store_id
GROUP BY T3.store_id, T3.store_name--, T1.quantity
ORDER BY Total_Order_Quantity DESC

--2.3. Select the store which has the most sales amount in 2018 


WITH T1 AS
(SELECT order_id, product_id, quantity, list_price
FROM sale.order_item),
T2 AS
(SELECT order_id,order_date, store_id
FROM sale.orders
WHERE order_date LIKE '%2018%'),
T3 AS 
(SELECT store_id, store_name
FROM sale.store)
SELECT T3.store_id, T3.store_name, SUM(T1.quantity*T1.list_price) Total_Order_Sales
FROM T1,T2,T3
WHERE T1.order_id=T2.order_id
AND T2.store_id=T3.store_id
GROUP BY T3.store_id, T3.store_name --T1.quantity
ORDER BY Total_Order_Sales DESC 


--2.4. Select the personnel which has the most sales amount in 2018

WITH T1 AS
(SELECT order_id, product_id, quantity, list_price
FROM sale.order_item),
T2 AS
(SELECT order_id,order_date, staff_id
FROM sale.orders
WHERE order_date LIKE '%2018%'),
T3 AS 
(SELECT staff_id, first_name, last_name
FROM sale.staff)
SELECT T3.staff_id, T3.first_name,T3.last_name, SUM(T1.quantity*T1.list_price) Total_Order_Sales--T1.order_id, T1.quantity, T1.product_id,T2.order_date, T2.store_id, T3.store_name
FROM T1,T2,T3
WHERE T1.order_id=T2.order_id
AND T2.staff_id=T3.staff_id
GROUP BY T3.staff_id,T3.first_name,T3.last_name--, T1.quantity
ORDER BY Total_Order_Sales DESC



