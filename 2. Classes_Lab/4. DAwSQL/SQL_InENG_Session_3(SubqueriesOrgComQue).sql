--Session : 3:
--SUBQUERIES

--Show difference between product price and average product price

select avg(list_price)
from product.product

SELECT P.product_name, list_price - (select avg(list_price)from product.product) as DiffereceFromAverage
FROM product.product P

--Subquery in SELECT Statement

--Write a query that returns the total list price by each order ids.
--NOTE: This is actually also a correlated subquery so we will revisit later

SELECT SUM(list_price)
FROM sale.order_item A /* ....to be completed later*/
---------------------------------------------------------------
---------------------------------------------------------------

/* ORGANIZED COMPLEX QUERIES */

--Bring all the personnels from the store that Maria Cussona works

SELECT *
FROM sale.staff 
WHERE store_id = (SELECT store_id
				  FROM sale.staff
				  WHERE first_name = 'Maria' AND last_name = 'Cussona')

-- List the staff that Jane Destrey is the manager of.

SELECT *
FROM sale.staff
WHERE manager_id = (SELECT staff_id
				    FROM sale.staff
					WHERE first_name = 'Jane' AND last_name = 'Destrey') /* Subquery that returns Jane's staff_id*/

-- Write a query that returns customers in the city where the 'Sacramento Bikes' store is located.

SELECT first_name, last_name, city
FROM sale.customer
WHERE city = (SELECT city
			  FROM sale.store
			  WHERE store_name = 'Sacramento Bikes')

--List bikes that are more expensive than the 'Trek CrossRip - 2020' bike.
SELECT A.product_id, A.product_name, B.brand_name, C.category_name, A.list_price
FROM product.product A JOIN
 product.brand B on A.brand_id = B.brand_id  JOIN
 product.category C ON A.category_id = C.category_id
 WHERE A.list_price  > (SELECT list_price
						FROM product.product
						WHERE product_name = 'Trek CrossRip+ - 2020')
 ORDER BY 5 DESC

 -- List customers whose order dates are before Arla Ellis.

 --First let's find Arla's Order date
 SELECT A.first_name, A.last_name, B.order_date
 FROM sale.customer A
	JOIN sale.orders B ON A.customer_id = B.customer_id
 WHERE B.order_date <  (SELECT B.order_date
					    FROM	sale.customer A
						JOIN sale.orders B ON A.customer_id = B.customer_id
						WHERE A.first_name = 'Arla' AND A.last_name = 'Ellis')

--List order dates for customers residing in the Holbrook city.
SELECT  A.order_date
FROM sale.orders A 
  ---JOIN sale.customer B ON A.customer_id = B.customer_id
WHERE A.customer_id IN (SELECT customer_id
						FROM  sale.customer
						WHERE city = 'Holbrook')

-- List all customers who orders on the same dates as Abby Parks.
SELECT B.customer_id, B.first_name, B.last_name, A.order_date
FROM sale.orders A 
	JOIN sale.customer B ON A.customer_id = B.customer_id
WHERE A.order_date IN (SELECT B.order_date
						FROM sale.customer A JOIN
						sale.orders B on A.customer_id = B.customer_id
						WHERE A.first_name = 'Abby' AND A.last_name = 'Parks')

--List products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes in 2018.
SELECT product_id, product_name
FROM product.product
WHERE category_id NOT IN (
SELECT category_id
FROM product.category
WHERE category_name IN( 
	'Cruisers Bicycles', 
	'Mountain Bikes', 
	'Road Bikes'))
AND 
model_year = 2018

-- List bikes that model year equal to 2020 and its prices more than ALL electric bikes.
SELECT product_name, model_year, list_price
FROM product.product
WHERE list_price > ALL  (SELECT A.list_price
						FROM product.product A 
						JOIN product.category B ON A.category_id = B.category_id
						WHERE B.category_name = 'electric bikes')
AND model_year = 2020

-- List bikes that model year equal to 2020 and its prices more than ANY electric bikes.

SELECT product_name, model_year, list_price
FROM product.product
WHERE list_price > ANY  (SELECT A.list_price
						FROM product.product A 
						JOIN product.category B ON A.category_id = B.category_id
						WHERE B.category_name = 'electric bikes')
AND model_year = 2020

SELECT * 
FROM sale.customer
WHERE EXISTS (SELECT * from product.product WHERE 1 = 0)

---------CORRELATED SUBQUERIES

--EXISTS / NOT EXISTS

--Write a query that returns State where 'Trek Remedy 9.8 - 2019' proudct is not ordered
SELECT distinct state
FROM
sale.customer X
WHERE NOT EXISTS
(
SELECT	1
FROM	product.product A 
		JOIN sale.order_item B ON A.product_id = B.product_id 
		JOIN sale.orders C ON B.order_id = C.order_id
		JOIN sale.customer D ON C.customer_id = D.customer_id
WHERE	
	A.product_name = 'Trek Remedy 9.8 - 2019'
AND		D.STATE = X.STATE
) 