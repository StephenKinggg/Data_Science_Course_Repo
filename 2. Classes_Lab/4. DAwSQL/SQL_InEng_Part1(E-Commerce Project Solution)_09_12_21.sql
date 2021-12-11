/* December 9th 2021 -- PROJECT SOLUTION and RECAP */
--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

SELECT *
INTO
combined_table
FROM
(
SELECT 
cd.Cust_id, cd.Customer_Name, cd.Province, cd.Region, cd.Customer_Segment, 
mf.Ord_id, mf.Prod_id, mf.Sales, mf.Discount, mf.Order_Quantity, mf.Product_Base_Margin,
od.Order_Date, od.Order_Priority,
pd.Product_Category, pd.Product_Sub_Category,
sd.Ship_id, sd.Ship_Mode, sd.Ship_Date
FROM market_fact mf
INNER JOIN cust_dimen cd ON mf.Cust_id = cd.Cust_id
INNER JOIN orders_dimen od ON od.Ord_id = mf.Ord_id
INNER JOIN prod_dimen pd ON pd.Prod_id = mf.Prod_id
INNER JOIN shipping_dimen sd ON sd.Ship_id = mf.Ship_id
) A;

select * from combined_table

--2. Find the top 3 customers who have the maximum count of orders.

SELECT	TOP 3 Cust_id, Customer_name, COUNT(Ord_id) COUNT_ORD
FROM	combined_table
GROUP BY
		Cust_id, Customer_name
ORDER BY 3 DESC

--3.	Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.

--Data Manipulation Laguage DML

--Data Definition Language DDL

ALTER TABLE combined_table
ADD DaysTakenForDelivery INT;

UPDATE combined_table
SET DaysTakenForDelivery = DATEDIFF(DAY, Order_date, Ship_date)


--4. Find the customer whose order took the maximum time to get delivered.
SELECT	Cust_id, Customer_name, Order_Date, Ship_Date, DaysTakenForDelivery
FROM combined_table
WHERE DaysTakenForDelivery = (
					SELECT MAX(DaysTakenForDelivery)
					FROM combined_table)


					
SELECT TOP(1) Customer_name, Ord_id, DaysTakenForDelivery
FROM	[dbo].[combined_table]
ORDER BY DaysTakenForDelivery DESC

--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

SELECT	COUNT (DISTINCT Cust_id) AS Unique_Customers
FROM	combined_table
WHERE	YEAR (Order_Date) = 2011
AND		MONTH(Order_Date) = 01;

SELECT Month(Order_date)as [Month], Count(Distinct cust_id) as Cust_Count
FROM  combined_table A
WHERE EXISTS (
				SELECT	cust_id
				FROM	combined_table B
				WHERE	A.Cust_id = B.Cust_id
				AND YEAR (Order_Date) = 2011
				AND		MONTH(Order_Date) = 01)
AND YEAR(ORder_Date) =2011
GROUP BY
	MONTH(Order_Date)

--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID


select * from combined_table

-- Let's find the first purchase for each customer
select Cust_id, Min(Order_Date) as First_Purchase
FROM combined_table
GROUP BY Cust_id



SELECT Cust_id, Order_Date, Ord_id,
 MIN(Order_Date) OVER (PARTITION BY Cust_id) First_Purchase,
 DENSE_RANK() OVER (PARTITION BY Cust_id ORDER BY Order_Date) DENSE_DATE
FROM combined_table

SELECT  DISTINCT
		Cust_id,
		First_Purchase,
		Order_Date as Third_Purchase,
		DATEDIFF(DAY,First_Purchase, Order_Date) Days_Elapsed


FROM (
		SELECT Cust_id, Order_Date, Ord_id,
		MIN(Order_Date) OVER (PARTITION BY Cust_id) First_Purchase,
		DENSE_RANK() OVER (PARTITION BY Cust_id ORDER BY Order_Date) DENSE_DATE
		FROM combined_table) A
WHERE DENSE_DATE = 3

-----------------------
;WITH CTE AS (
SELECT Cust_id, Order_Date, Ord_id,
		MIN(Order_Date) OVER (PARTITION BY Cust_id) First_Purchase,
		DENSE_RANK() OVER (PARTITION BY Cust_id ORDER BY Order_Date) DENSE_DATE
		FROM combined_table
)

SELECT  DISTINCT
		Cust_id,
		First_Purchase,
		Order_Date as Third_Purchase,
		DATEDIFF(DAY,First_Purchase, Order_Date) Days_Elapsed
		FROM CTE WHERE DENSE_DATE = 3

--------------------------------------

SELECT *,
		DATEDIFF(DAY, (FIRST_VALUE(Order_Date) OVER(PARTITION BY Cust_id ORDER BY Order_Date)), 
		(LEAD(Order_Date,2) OVER(PARTITION BY Cust_id ORDER BY Order_Date))) AS first_third_diff
FROM [dbo].[combined_table]
ORDER BY Cust_id ASC

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.

;WITH T1 AS 
(
	SELECT	Cust_id,
			SUM(CASE WHEN Prod_id = 'Prod_11' THEN order_quantity ELSE 0 END) AS P11,
			SUM(CASE WHEN Prod_id = 'Prod_14' THEN order_quantity ELSE 0 END) AS P14,
			SUM (order_quantity) TOTAL_PROD
	FROM	combined_table
	GROUP BY
			Cust_id
	HAVING
			SUM(CASE WHEN Prod_id = 'Prod_11' THEN order_quantity ELSE 0 END) >=1 AND
			SUM(CASE WHEN Prod_id = 'Prod_14' THEN order_quantity ELSE 0 END) >=1
)

SELECT	Cust_id, P11, P14, TOTAL_PROD,
		CAST (1.0*P11/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P11,
		CAST (1.0*P14/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P14
FROM T1


select * from combined_table