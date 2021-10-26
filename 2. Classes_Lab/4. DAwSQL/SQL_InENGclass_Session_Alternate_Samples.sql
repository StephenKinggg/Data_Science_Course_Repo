SELECT C.brand_name as Brand, D.category_name as Category,B.model_year as Model_Year,
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO sale.sales_summary
FROM sale.order_item A  -- total sales
JOIN product.product B  ON A.product_id = B.product_id-- model year
JOIN product.brand C ON  C.brand_id = B.brand_id -- brand name
JOIN product.category D ON D.category_id = B.category_id -- category names
GROUP BY C.brand_name, D.category_name,B.model_year ;



--Cube example query:x
--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
-- Calculate sum total_sales_price

SELECT	brand, category, model_year, SUM(total_sales_price)
FROM	sale.sales_summary
GROUP BY
		CUBE (brand,category, model_year)
ORDER BY
	brand, category

--same thing can be done for ROLLUP:

SELECT	brand, category,model_year, SUM(total_sales_price) as Total_Sales
FROM	sale.sales_summary
GROUP BY
	ROLLUP (brand,category,model_year				
					)
ORDER BY Brand, Category


SELECT  *
FROM
(SELECT category, total_sales_price ,model_year
FROM sale.sales_summary) A
PIVOT (
	 SUM(total_sales_price)  -- aggregation
	 FOR category            -- spreading
		IN (	
	[Children Bicycles],
    [Comfort Bicycles],
    [Cruisers Bicycles],
    [Cyclocross Bicycles],
    [Electric Bikes],
    [Mountain Bikes],
    [Road Bikes])
	) AS PIVOT_TABLE

/*
Here's the answer to the question in class about ANY

ANY will check against each value if it can find 'ANY' value that satisfies the condition, it doesn't have to be Minimum value

Here's a simple test you can do

--CREATE A TEST TABLE AND INSERT SOME VALUES
CREATE TABLE T1
(ID INT) ;
GO
INSERT T1 VALUES (1) ;
INSERT T1 VALUES (2) ;
INSERT T1 VALUES (3) ;
INSERT T1 VALUES (4) ;
--CHECK IF 3 IS < ANY value
IF 3 < ANY (SELECT ID FROM T1)
PRINT 'TRUE'
ELSE
PRINT 'FALSE' ;
-- ANY CHECKS EACH VALUE TO SEE
--IF 3 IS LESS THAN ANY VALUE
--RETURNS TRUEAS 3 < 4
-- 4 IS NOT THE MINIMUM VALUE
--DROP TABLE T1;
*/


SELECT COALESCE (Sender_ID, Reciever_ID) Account_ID,
		COALESCE(receive_amount, 0) - COALESCE(send_amount, 0) as net_change
FROM
	(SELECT Sender_ID, sum(Amount) as send_amount
	FROM ASSIGNMENT1
	GROUP BY Sender_ID) A
	FULL OUTER JOIN
	(SELECT Reciever_ID, sum(Amount) as receive_amount
	FROM ASSIGNMENT1
	GROUP BY Reciever_ID) B
ON A.Sender_ID = B.Reciever_ID
order by net_change DESC


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


SELECT	product_name, list_price
FROM	product.product
WHERE	category_id NOT IN (SELECT	category_id
			    FROM product.category
			    WHERE category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes'))
		AND model_year = 2018


WITH T1 AS(SELECT	category_id
			    FROM product.category
			    WHERE category_name IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes')
				)
SELECT  product_name, list_price
FROM product.product  A JOIN
T1 B ON A.category_id = B.category_id
WHERE model_year = 2018


SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND B.order_id IN (
SELECT order_id
FROM sale.order_item A JOIN
	product.product B ON A.product_id = B.product_id
WHERE B.category_id IN (
					SELECT category_id
					FROM product.category
					WHERE category_name = 'Electric Bikes')
INTERSECT
SELECT order_id
FROM sale.order_item A JOIN
	product.product B ON A.product_id = B.product_id
WHERE B.category_id IN (
					SELECT category_id
					FROM product.category
					WHERE category_name = 'Comfort Bicycles')
INTERSECT
SELECT order_id
FROM sale.order_item A JOIN
	product.product B ON A.product_id = B.product_id
WHERE B.category_id IN (
					SELECT category_id
					FROM product.category
					WHERE category_name = 'Children Bicycles')
					)

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	);
3:25
INSERT INTO t_date_time (
  [A_time]
, [A_date]
, [A_smalldatetime]
, [A_datetime]
, [A_datetime2]
, [A_datetimeoffset])
VALUES (
GETDATE(),
GETDATE(),
GETDATE(),
GETDATE(),
GETDATE(),
GETDATE()
)
3:26
INSERT INTO t_date_time (
  [A_time]
, [A_date]
, [A_smalldatetime]
, [A_datetime]
, [A_datetime2]
, [A_datetimeoffset])
VALUES (
'12:00:00',
'2021-10-25',
'2021-10-25',
'2021-10-25',
'2021-10-25',
'2021-10-25'
)