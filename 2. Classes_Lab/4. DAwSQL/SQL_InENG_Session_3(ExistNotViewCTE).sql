
/* Session 3 - Part 1 October 23 */
--------EXISTS-------------------
select * 
FROM sale.customer
WHERE EXISTS (SELECT 1 WHERE 1 = 0)

-------NOT EXISTS -------------------
--Write a query that returns State where 'Trek Remedy 9.8 - 2019' proudct is not ordered

SELECT distinct state
FROM sale.customer X
WHERE NOT EXISTS(

SELECT 1
FROM product.product A
	JOIN sale.order_item B ON A.product_id = B.product_id
	JOIN sale.orders C ON B.order_id = C.order_id
	JOIN sale.customer D ON D.customer_id = C.customer_id
WHERE A.product_name = 'Trek Remedy 9.8 - 2019'
	AND D.state = X.state)
	;
-------------------
--VIEWS
-------------------
-- Create 'NEW_PRODUCTS' view, that contain products produced after 2019 
CREATE VIEW products_2019 AS
SELECT *
FROM product.product 
WHERE model_year >2019


select * from products_2019
---------------------------------------------
--CTE
--------------------------------------------
-- List all customers who orders on the same dates as Abby Parks.
--subquery method

SELECT A.first_name, A.last_name, B.order_date
FROM sale.customer A 
	JOIN sale.orders B 
	ON A.customer_id = B.customer_id
WHERE B.order_date IN (SELECT B.order_date
						FROM sale.customer A
						JOIN sale.orders B ON A.customer_id = B.customer_id
						WHERE A.first_name = 'Abby' AND
						A.last_name = 'Parks' )
-------------------------------------------------------
;WITH MyCTE AS (
		SELECT B.order_date
		FROM sale.customer A
		JOIN sale.orders B ON A.customer_id = B.customer_id
		WHERE A.first_name = 'Abby' AND
		A.last_name = 'Parks'  )

SELECT A.first_name, A.last_name, B.order_date
FROM sale.customer A JOIN
	sale.orders B ON A.customer_id = B.customer_id JOIN
	 MyCTE ON B.order_date = MyCTE.order_date

	 -------------------------------------------------------

--List products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes in 2018.
--using subquery

SELECT	product_name, list_price
FROM	product.product
WHERE	category_id IN (SELECT	category_id
			    FROM product.category
			    WHERE category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes'))
		AND model_year = 2018
;

-----------------------
--using CTE

;WITH T1 AS(SELECT	category_id
			    FROM product.category
			    WHERE category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
				)
SELECT  A.product_name, list_price
FROM product.product  A JOIN
T1 B ON A.category_id = B.category_id
WHERE model_year = 2018

-------
--recursive CTE
WITH T1 AS(
		SELECT 0 seed --- anchor

		UNION ALL

		SELECT seed+1
		FROM  T1 -- recursive membr
		WHERE  seed < 9 ) -- terminating condition

select * from t1
--------------------------------------------
--Home Work
--------------------------------------------
--List customers who have an order prior to the last order of a customer named Sharyn Hopkins 
--and are residents of the city of San Diego.

--Try to do this by your self first
--Here's the solution:

;WITH t2 AS
	(
	SELECT	MAX(B.order_date) last_order_date
	FROM	sale.customer A, sale.orders B
	WHERE	A.first_name = 'Sharyn' AND
			A.last_name = 'Hopkins' AND
			A.customer_id = B.customer_id
	)
SELECT	B.customer_id, B.first_name, B.last_name, B.city, C.order_date
FROM	t2 A, sale.customer B, sale.orders C
WHERE	B.customer_id = C.customer_id 
AND		C.order_date < A.last_order_date
AND		B.city = 'San Diego'
;
--HW2
--Write a query that returns all staff with their manager_ids.

WITH T1 AS (
    SELECT staff_id, first_name, manager_id
    FROM   sale.staff
    WHERE  staff_id=1
    UNION ALL
    SELECT A.staff_id, A.first_name, A.manager_id
    FROM   sale.staff A, T1 B 
	WHERE  B.staff_id = A.manager_id
)
SELECT * FROM T1;


-----//////

--HW 3

--How we use outsource values not in a table with CTE's


WITH Users As
(
SELECT * 
FROM (
		VALUES 
				(1,'start', CAST('01-01-20' AS date)),
				(1,'cancel', CAST('01-02-20' AS date)), 
				(2,'start', CAST('01-03-20' AS date)), 
				(2,'publish', CAST('01-04-20' AS date)), 
				(3,'start', CAST('01-05-20' AS date)), 
				(3,'cancel', CAST('01-06-20' AS date)), 
				(1,'start', CAST('01-07-20' AS date)), 
				(1,'publish', CAST('01-08-20' AS date))
		) as table_1 ([user_id], [action], [date])
)
SELECT * FROM Users

