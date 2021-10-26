--Session 4 Oct 23rd 
/* SET OPERATIONS - CASE EXPRESSION */


------ SET OPERATIONS ------
-- UNION / UNION ALL

select 1 as num, 2 as num2

--UNION

select 'a' as num, 2 as num2
--------------------------

SELECT distinct brand_id
FROM product.brand
--ORDER BY 1

UNION

SELECT DISTINCT brand_id
FROM product.product
ORDER BY 1
--------------------------
--List Customer's last names in Sacramento and Monroe

SELECT last_name
FROM sale.customer
WHERE city = 'Sacramento'
UNION ALL 
SELECT last_name
FROM sale.customer
WHERE city = 'Monroe'
;

----------------
select 1 as num, 2 as num2
UNION
select 3 as num3, 4 as num2
ORDER BY 2 desc
---------------------------

--customer with first name 'Carter' and with last name 'Carter'

SELECT first_name,last_name
FROM sale.customer
WHERE first_name = 'Carter'
UNION 
SELECT first_name,last_name
FROM sale.customer
WHERE last_name = 'Carter'
-----------------------------------------------------------
-- Write a query that returns brands that have products for both 2018 and 2019.
SELECT *
FROM product.brand
WHERE brand_id IN (

SELECT brand_id
FROM product.product
WHERE model_year = 2018
INTERSECT
SELECT brand_id
FROM product.product
WHERE model_year = 2019
)
---------------------------------------------------------------------
-- Write a query that returns customers who have orders for both 2018, 2019, and 2020
select first_name,last_name
FROM sale.customer
WHERE customer_id IN (

SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE  DATEPART(year,order_date) = '2019'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31'
)
------------------------------------------------------------
------ EXCEPT


-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.

SELECT	*
FROM	product.brand
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2018
					EXCEPT
					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2019
					)
;
-- Write a query that returns only products ordered in 2019 (not ordered in other years).


SELECT	product_id, product_name
FROM	product.product
WHERE	product_id IN (
						SELECT	B.product_id
						FROM	sale.orders A, sale.order_item B
						WHERE	A.order_id = B.order_id AND
								A.order_date BETWEEN '2019-01-01' AND '2019-12-31'
						EXCEPT
						SELECT	B.product_id
						FROM	sale.orders A, sale.order_item B
						WHERE	A.order_id = B.order_id AND
								A.order_date not BETWEEN '2019-01-01' AND '2019-12-31'
						)

;






select * from sale.orders








