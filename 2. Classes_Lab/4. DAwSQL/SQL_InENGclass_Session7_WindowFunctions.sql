/* Session: 7:
November 1st
Window Functions
*/
-- Window Functions (WF) vs. GROUP BY
--Find stock amounts of products

--Using Group By
SELECT product_id,SUM(Quantity) as total_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id;

--Using WF
SELECT *, SUM(Quantity) OVER(PARTITION BY product_id) as total_stock
FROM product.stock
ORDER BY product_id;
----------------------
-- Let's write a query that returns average list price of bicycles by brands. 

SELECT brand_id, AVG(list_price) as avg_price
FROM product.product
GROUP By brand_id
ORDER BY brand_id;

--Same query using Window Function
SELECT [brand_id], [category_id], [product_name], [list_price],
AVG(list_price) OVER(PARTITION BY brand_id) as avg_price
FROM product.product
ORDER BY brand_id, category_id;

/* Partition BY: Groups result set into partitions
where the aggregate function is applied*/

--Using WF
SELECT *, SUM(Quantity) OVER(PARTITION BY product_id) as total_stock
FROM product.stock
ORDER BY product_id;
SELECT *, SUM(Quantity) OVER(PARTITION BY product_id ORDER BY store_id
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as total_stock
FROM product.stock
ORDER BY product_id;

/* Default: UNBOUNDED PRECEEDING - CURRENT ROW
UNBOUNDED PRECEEDING = 1st row for partition
UNBOUNDED FOLLOWING == last row for partition
*/

SELECT category_id, product_id,
COUNT(*) OVER() as NO_group,
COUNT(*) OVER(PARTITION BY category_id) count_by_cat,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) count_by_cat2 ,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) count_by_cat3 ,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) count_by_cat30,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) count_by_cat4,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) count_by_cat5,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) count_by_cat51
FROM product.product

------------------------------------
--cheapest Bike
SELECT DISTINCT MIN(list_price) OVER() cheapest_bike
FROM product.product

----cheapest bike in each category
SELECT DISTINCT category_id,
MIN(list_price) OVER (PARTITION BY category_id) cheapest_by_cat
FROM product.product

--How many different bikes in the product table?
SELECT distinct COUNT(product_id) OVER() num_of_bikes
FROM product.product

--4. How many different bikes in the Order_item table?
SELECT  distinct COUNT( product_id) OVER() total_bikes
FROM sale.order_item

select count(distinct product_id) as total_bikes
FROM sale.order_item

--how many products in each order

SELECT DISTINCT order_id, SUM(quantity) OVER (PARTITION BY order_id) tot_product_per_order
FROM sale.order_item
ORDER BY order_id

--5. How many different bikes are in each brand in each category?

SELECT distinct category_id, brand_id
, COUNT(product_id) OVER (PARTITION BY category_id, brand_id) num_of_bikes_by_brand_cat
FROM product.product
ORDER BY category_id, brand_id;

select * from 
product.product
where category_id = 1 AND brand_id = 2

--how many different brands are in each category 

SELECT DISTINCT COUNT(A.product_id) OVER () num_of_bike
FROM (SELECT distinct product_id
		FROM sale.order_item) A

--how many different brands are in each category 
SELECT category_id, COUNT(brand_id)
FROM product.product
GROUP BY category_id;

SELECT DISTINCT category_id, COUNT(brand_id) OVER (PARTITION BY category_id)
FROM product.product
-----\
-- 2. ANALYTIC NAVIGATION FUNCTIONS --

--FIRST_VALUE() - LAST_VALUE()

--FIRST VALUE

SELECT A.customer_id, A.first_name, B.order_date,
	FIRST_VALUE(order_date) OVER (ORDER BY B.order_date) first_Date
FROM 
	sale.customer A JOIN
	sale.orders B ON A.customer_id = B.customer_id
	;
	--LAST VALUE

	SELECT A.customer_id, A.first_name, B.order_date,
	LAST_VALUE(order_date) OVER (ORDER BY B.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) second_Date
FROM 
	sale.customer A JOIN
	sale.orders B ON A.customer_id = B.customer_id

	---Mix n match

SELECT A.customer_id, A.first_name, B.order_date,
	FIRST_VALUE(order_date) OVER (ORDER BY B.order_date desc) last_Date
FROM 
	sale.customer A JOIN
	sale.orders B ON A.customer_id = B.customer_id
	;

--The name of the cheapest bike (use first_value)

SELECT distinct FIRST_VALUE(product_name) OVER (ORDER BY list_price) cheapest_bike
FROM product.product

--How to add list price of the cheapest bike?

SELECT product_name, list_price
FROM product.product
WHERE product_name  = (SELECT distinct FIRST_VALUE(product_name) OVER (ORDER BY list_price) cheapest_bike
FROM product.product)

--The name of the cheapest bike in each category (use first_value)
SELECT distinct category_id, 
FIRST_VALUE(product_name) OVER (PARTITION BY category_id ORDER BY list_price ) cheapest_bike_by_cat
FROM product.product