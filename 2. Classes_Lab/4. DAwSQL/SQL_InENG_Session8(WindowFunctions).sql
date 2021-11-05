/* November 11th
Session # 7 Part 2
Lead/Lag
*/
-- LEAD( COLUMN NAME, OFFSET, DEFAULT VALUE)
SELECT order_date,
	LAG(order_date) OVER (ORDER BY order_Date) prev_w_lag,
	LAG(order_date,2) OVER (ORDER BY order_Date) prev_2_lag,
	LAG(order_date,3, '1900-01-01') OVER (ORDER BY order_Date) prev_3_lag
FROM sale.orders
;

SELECT order_date,
	LEAD(order_date,1,GETDATE()) OVER (ORDER BY order_Date) prev_w_lead
	--LAG(order_date,2) OVER (ORDER BY order_Date) prev_2_lag,
	--LAG(order_date,3, '1900-01-01') OVER (ORDER BY order_Date) prev_3_lag
FROM sale.orders

--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)

SELECT  B.staff_id,A.order_id, B.first_name, B.last_name, A.order_date,
	LAG(A.order_date) OVER (PARTITION BY B.staff_id ORDER BY order_id) as previous_order_date
FROM sale.orders A JOIN
	sale.staff B ON A.staff_id = B.staff_id
		ORDER BY 1,2

--DBCC FREEPROCCACHE
--Write a query that returns the order date of the one next sale of each staff (use the LEAD function)
SELECT  B.staff_id,A.order_id, B.first_name, B.last_name, A.order_date,
	LEAD(A.order_date,1) OVER (PARTITION BY B.staff_id ORDER BY order_id) as next_order_date
FROM sale.orders A JOIN
	sale.staff B ON A.staff_id = B.staff_id
		ORDER BY 1,2

/*-------------------------------------------------------
---------------------------------------------------------
ROW_NUMBER()
RANK()
DENSE_RANK()
---------------------------------------------------------
--------------------------------------------------------*/

SELECT order_id, item_id,
	ROW_NUMBER() OVER (ORDER BY order_id) AS [ROW_Number]
FROM sale.order_item

SELECT order_id, item_id,
	ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS [ROW_Number]
FROM sale.order_item

---------------------------------
--Cumulative Distribution
SELECT list_price,
	ROUND(CUME_DIST() OVER (ORDER BY list_price),3) as [Cume_dist]
FROM product.product

--Percent Rank
--Row_number -1/Total # of rows - 1

SELECT list_price,
	PERCENT_RANK() OVER (ORDER BY list_price) as Percent_Rank
FROM product.product

----NTILE
/*
NTILE(2) for 10 rows -- 2 groups 5 rows each
NTILE(3) for 10 rows -- 3 groups :
1st gp 4
2 gp 3
3 gp -3

NTILE(11) 10 rows
*/

SELECT * 
FROM product.product
WHERE list_price < 250
order by list_price

SELECT list_price,
NTILE(3) OVER (Order by list_price) as [NTILE]

FROM product.product
WHERE list_price < 250
------------------------------------
----Assign a ordinal number to the bike prices for each category in ascending order

SELECT category_id,list_price,
 ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price) [Row_Num]
 FROM product.product

 
SELECT category_id,list_price,
 ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price) [Row_Num],
 RANK() OVER (PARTITION BY category_id ORDER BY list_price ) [Rank],
 DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price ) [DENSE_RANK]
 FROM product.product

 ---- Write a query that returns the cumulative distribution of sum of product quantity customers ordered.
 ;WITH T1 AS (
 SELECT customer_id, SUM(quantity) product_quantity
 FROM sale.orders A JOIN
	 sale.order_item B ON A.order_id = B.order_id
 GROUP BY customer_id
 )

 SELECT DISTINCT product_quantity,
  ROUND(CUME_DIST() OVER  (ORDER BY product_quantity),3) as Cume_Dist
 FROM T1
 ORDER BY 1
 ;

 -- Write a query that returns the relative standing of the sum of product quantity customers ordered.
 ;WITH T2 AS(
 SELECT customer_id, SUM(quantity) as product_quantity
 FROM sale.orders A JOIN 
	sale.order_item B ON A.order_id = B.order_id
GROUP BY customer_id
)
SELECT DISTINCT product_quantity,
 ROUND (PERCENT_RANK() OVER (ORDER BY product_quantity),3) as PERCENT_RANK
FROM T2
ORDER BY 1
;

--Divide customers into 5 groups based on the quantity of product they order.
 ;WITH T3 AS(
 SELECT customer_id, SUM(quantity) as product_quantity
 FROM sale.orders A JOIN 
	sale.order_item B ON A.order_id = B.order_id
GROUP BY customer_id
)

SELECT customer_id,
 NTILE(5) OVER (ORDER BY product_quantity) AS gp_by_quantity
FROM T3
ORDER BY 2, 1

----Write a query that returns both of the followings:
--The average product price of orders.
--Average net amount.

SELECT DISTINCT order_id,
 AVG(list_price) OVER (PARTITION BY order_id) AS AVG_Price,
 ROUND(AVG(quantity*list_price*(1-discount)) OVER (),2) AVG_NET_AMOUNT
 FROM sale.order_item

 --List orders for which the average product price is higher than the average net amount.
 ;WITH T4 AS (
 SELECT DISTINCT order_id,
 AVG(list_price) OVER (PARTITION BY order_id) AS AVG_Price,
 ROUND(AVG(quantity*list_price*(1-discount)) OVER (),2) AVG_NET_AMOUNT
 FROM sale.order_item
 )
  SELECT *
 FROM T4 
 WHERE AVG_Price > AVG_NET_AMOUNT

 --Calculate the stores' weekly cumulative number of orders for 2018
 --DBCC FREEPROCCACHE
 SELECT DISTINCT B.store_id, B.store_name, DATEPART(WK,A.order_Date) as Week_of_Year,
  COUNT(*) OVER (PARTITION BY A.store_id , DATEPART(WK,A.order_Date)) as Weeks_order,
  COUNT(*) OVER( PARTITION BY A.store_id ORDER BY DATEPART(WK,A.order_Date) ) as cum_tot_order
 FROM sale.orders A JOIN sale.store B ON A.store_id = B.store_id
 WHERE YEAR(A.order_date) = 2018
 ORDER BY B.store_id
 -----------------------------------

 SELECT DISTINCT B.store_id, B.store_name, DATEPART(WK,A.order_Date)as Week_of_Year,
 COUNT(*) OVER (PARTITION BY A.store_id , DATEPART(WK,A.order_Date)) as Weeks_order,
  COUNT(*) OVER (PARTITION BY A.store_id ORDER BY DATEPART(WK,A.order_Date)) as cum_tot_order
    FROM sale.orders A JOIN sale.store B ON A.store_id = B.store_id
   WHERE YEAR(A.order_date) = 2018
   ORDER BY B.store_id
   -----Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.


   ;WITH T5 AS(
   SELECT DISTINCT order_date, SUM(quantity) OVER (PARTITION BY order_date) sum_quantity
   FROM sale.order_item A JOIN sale.orders B ON A.order_id = B.order_id
   WHERE B.order_date BETWEEN '2018-03-12' and '2018-04-12'
   )
   SELECT order_date,sum_quantity,
   AVG(sum_quantity) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) seven_day_moving_avg

   FROM T5
   order BY 1