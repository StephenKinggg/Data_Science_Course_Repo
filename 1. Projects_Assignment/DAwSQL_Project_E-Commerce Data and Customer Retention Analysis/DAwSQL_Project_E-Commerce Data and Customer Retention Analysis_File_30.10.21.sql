

--DAwSQL Session -8 

--E-Commerce Project Solution

--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

WITH T1 AS
(
SELECT A.Ord_id,B.Cust_id,C.Ship_id,D.Prod_id, 
	   A.Order_Date,A.Order_Priority,
	   B.Customer_Name,B.Customer_Segment,B.Province,B.Region,
	   C.Ship_Date,C.Ship_Mode,
	   D.Product_Category,D.Product_Sub_Category,
	   E.Discount,E.Order_Quantity,E.Product_Base_Margin,E.Sales
FROM market_fact E 
JOIN orders_dimen A ON A.Ord_id=E.Ord_id
JOIN cust_dimen B ON E.Cust_id=B.Cust_id
JOIN shipping_dimen C ON E.Ship_id=C.Ship_id
JOIN prod_dimen D ON E.Prod_id=D.Prod_id
)
CREATE TABLE combined_table AS
SELECT * FROM T1


DROP TABLE IF EXISTS combined_table
CREATE TABLE combined_table AS

SELECT * INTO combined_table
FROM (SELECT E.Ord_id,E.Cust_id,E.Ship_id,E.Prod_id, 
	   A.Order_Date,A.Order_Priority,
	   B.Customer_Name,B.Customer_Segment,B.Province,B.Region,
	   C.Ship_Date,C.Ship_Mode,
	   D.Product_Category,D.Product_Sub_Category,
	   E.Discount,E.Order_Quantity,E.Product_Base_Margin,E.Sales
	   FROM market_fact E 
	   JOIN orders_dimen A ON A.Ord_id=E.Ord_id
	   JOIN cust_dimen B ON B.Cust_id=E.Cust_id
	   JOIN shipping_dimen C ON C.Ship_id=E.Ship_id
	   JOIN prod_dimen D ON D.Prod_id=E.Prod_id) A


SELECT *
FROM combined_table

--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.

SELECT *
FROM market_fact

WITH T1 AS
(
SELECT TOP 3 Cust_id, count(Order_Quantity) count_of_order
FROM market_fact
GROUP BY Cust_id
ORDER BY count_of_order DESC
)
SELECT A.Cust_id, A.Customer_Name, T1.count_of_order
FROM cust_dimen A, T1
WHERE T1.Cust_id=A.Cust_id


--/////////////////////////////////


--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

ALTER TABLE combined_table
ADD DaysTakenForDelivery INT;

UPDATE combined_table
SET DaysTakenForDelivery=DATEDIFF(Day, Order_Date, Ship_Date)

SELECT TOP 100 *
FROM combined_table

--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"


SELECT *
FROM cust_dimen

SELECT *
FROM combined_table
ORDER BY DaysTakenForDelivery 

SELECT TOP 1 Max(A.DaysTakenForDelivery)  
FROM combined_table A
GROUP BY A.Cust_id






--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries





--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions





--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions




--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.




--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.






--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.



--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.







--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.








--/////////////////////////////////////




--MONTH-WÝSE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps





--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.







---///////////////////////////////////
--Good luck!