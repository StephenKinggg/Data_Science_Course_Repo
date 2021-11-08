

--DAwSQL Session -8 

--E-Commerce Project Solution

--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

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



SELECT Ord_id, Ship_id, Order_Priority, Order_Date, Ship_Date, DaysTakenForDelivery
FROM combined_table


SELECT TOP 1 A.Cust_id, A.Customer_Name, A.Order_Date, A.Ship_Date, A.DaysTakenForDelivery
FROM combined_table A
WHERE A.DaysTakenForDelivery = (SELECT MAX(B.DaysTakenForDelivery) DaysTakenForDelivery
							   FROM combined_table B)


--////////////////////////////////


--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries


SELECT DISTINCT(A.Cust_id)  --2011 yýlý Ocak ayýndaki Cust_id leri distinct olarak bulduk.
FROM combined_table A
WHERE DATENAME(MONTH, A.Order_Date)='January'
AND DATENAME(YEAR, A.Order_Date)=2011

SELECT COUNT(DISTINCT(A.Cust_id))  --Bunlarýn sayýsýný bulduk.
FROM combined_table A
WHERE DATENAME(MONTH, A.Order_Date)='January'
AND DATENAME(YEAR, A.Order_Date)=2011


SELECT DATEPART(MONTH, A.Order_Date) [MONTH], Count(DISTINCT A.Cust_id) Monthly_Num_Of_Cust
FROM combined_table A
WHERE DATENAME(YEAR, A.Order_Date)=2011
AND A.Cust_id IN (SELECT DISTINCT(A.Cust_id)
		 FROM combined_table A
		 WHERE DATENAME(MONTH, A.Order_Date)='JanuarY'
		 AND DATENAME(YEAR, A.Order_Date)=2011 )
GROUP BY DATEPART(MONTH, A.Order_Date)

/*DATENAME ve DATEPART fonksiyonlarý belli bir tarih dilimindeki tarihlerin istenilen kýsýmlarýnýn geriye döndürülmesini saðlayan fonksiyonlardýr. Ýkisinin farkýna gelince, DATENAME fonksiyonu belli bir tarih içindeki aya ait ismi, güne ait ismi dönerken, DATEPART fonksiyonu ile ayýn veya günün sayýsal yani nümerik deðerini elde ederiz. Kullaným olarak syntax aþaðýdaki gibidir :

DATENAME(tarihverisininhangikýsmý,tarihverisi)
DATEPART(tarihverisininhangikýsmý,tarihverisi)
*/

----
/*
SELECT B.Cust_id
FROM (SELECT A.Cust_id, CASE WHEN COUNT(A.Cust_id) = 1 THEN 1 END Cust_Unique
					FROM combined_table A
					WHERE DATENAME(MONTH, A.Order_Date)='January'
					GROUP BY A.Cust_id) B
WHERE B.Cust_Unique=1


----
SELECT DATENAME(MONTH, A.Order_Date) [MONTH], COUNT(A.Cust_id) Num_Cust 
FROM combined_table A
WHERE DATENAME(YEAR, A.Order_Date)=2011
AND A.Cust_id IN (
					SELECT B.Cust_id
					FROM (SELECT A.Cust_id, CASE WHEN COUNT(A.Cust_id) = 1 THEN 1 END Cust_Unique
							FROM combined_table A
							WHERE DATENAME(MONTH, A.Order_Date)='January'
							GROUP BY A.Cust_id) B
					WHERE B.Cust_Unique=1
				)
GROUP BY DATENAME(MONTH, A.Order_Date)

----
/*

SELECT	COUNT(A.Cust_id), 
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='January' THEN 1 END) JANUARY,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='February' THEN 1 END) FEBRUARY,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='March' THEN 1 END) MARCH,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='April' THEN 1 END) APRIL,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='May' THEN 1 END) MAY,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='June' THEN 1 END) JUNE,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='July' THEN 1 END) JULY,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='August' THEN 1 END) AUGUST,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='September' THEN 1 END) SEPTEMBER,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='October' THEN 1 END) OCTOER,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='November' THEN 1 END) NOVEMBER,
		COUNT(CASE WHEN DATENAME(MONTH, A.Order_Date) ='December' THEN 1 END) DECEMBER
FROM combined_table A
WHERE DATENAME(YEAR, A.Order_Date)=2011
AND A.Cust_id IN (
					SELECT B.Cust_id
					FROM (SELECT A.Cust_id, CASE WHEN COUNT(A.Cust_id) = 1 THEN 1 END Cust_Unique
							FROM combined_table A
							WHERE DATENAME(MONTH, A.Order_Date)='January'
							GROUP BY A.Cust_id) B
					WHERE B.Cust_Unique=1
				)
GROUP BY A.Cust_id

---
select yr, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]
from
(select datepart(month,minDate) mth, datepart(year,minDate) yr, count(*) cnt
 from (select min(OrderDate) minDate, max(OrderDate) maxDate
       from tblOrder
       group by email) sq
 where datediff(month, minDate, maxDate) > 0
 group by datepart(month,minDate), datepart(year,minDate)) src
PIVOT
(max(cnt) 
 for mth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]) ) pvt

 */




--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions
*/

WITH T1 AS
(
SELECT Cust_id, Order_Date,
DENSE_RANK() OVER(PARTITION BY Cust_id ORDER BY Order_Date) DENSE_NUMBER,
MIN(Order_Date) OVER(PARTITION BY Cust_id ORDER BY Order_Date) FIRST_ORDER_DATE
FROM combined_table 
)

SELECT DISTINCT A.Cust_id, T1.Order_Date, T1.DENSE_NUMBER, T1.FIRST_ORDER_DATE, DATEDIFF(DAY,T1.FIRST_ORDER_DATE, T1.Order_Date) DAYS_ELAPSED
FROM combined_table A, T1
WHERE A.Cust_id = T1.Cust_id
AND T1.DENSE_NUMBER=3
ORDER BY A.Cust_id



--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions


WITH T1 AS
(
SELECT Cust_id
FROM combined_table
WHERE Prod_id ='Prod_11'

INTERSECT

SELECT Cust_id
FROM combined_table
WHERE Prod_id ='Prod_14'
)
SELECT DISTINCT A.Cust_id,
	    SUM(CASE WHEN A.Prod_id='Prod_11' THEN A.Order_Quantity ELSE 0 END) AS P11,
		SUM(CASE WHEN A.Prod_id='Prod_14' THEN A.Order_Quantity ELSE 0 END) AS P14,
		SUM(A.Order_Quantity) AS TOTAL,
		CONVERT(NUMERIC(3,2), 1.0 * (SUM(CASE WHEN A.Prod_id='Prod_11' THEN A.Order_Quantity ELSE 0 END))/(SUM(A.Order_Quantity))) Ratio_P11,
		CONVERT(NUMERIC(3,2), 1.0 * (SUM(CASE WHEN A.Prod_id='Prod_14' THEN A.Order_Quantity ELSE 0 END))/(SUM(A.Order_Quantity))) Ratio_P14
FROM combined_table A, T1
WHERE A.Cust_id=T1.Cust_id
GROUP BY A.Cust_id


/* ALTTAKÝ SORUN GROUP BY YAPMAMIÞ OLMAK. 

WITH T1 AS
(
SELECT Cust_id
FROM combined_table
WHERE Prod_id ='Prod_11'

INTERSECT

SELECT Cust_id
FROM combined_table
WHERE Prod_id ='Prod_14'
)
SELECT DISTINCT A.Cust_id,
				SUM(A.Order_Quantity) OVER(PARTITION BY A.Cust_id ORDER BY A.Prod_id) P11,
				SUM(C.Order_Quantity) OVER(PARTITION BY C.Cust_id ORDER BY C.Prod_id) P14,
			
				SUM(C.Order_Quantity) OVER(PARTITION BY T1.Cust_id ORDER BY A.Prod_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) TOTAL_PRODUCT,
				CONVERT(NUMERIC(3,2), 1.0 * (CASE WHEN A.Prod_id ='Prod_11' THEN A.Order_Quantity END)/(SUM(A.Order_Quantity) OVER(PARTITION BY A.Cust_id))),
				CONVERT(NUMERIC(3,2), 1.0 * (CASE WHEN C.Prod_id ='Prod_14' THEN C.Order_Quantity END)/(SUM(C.Order_Quantity) OVER(PARTITION BY C.Cust_id)))
FROM combined_table A, T1, combined_table C
WHERE A.Cust_id=C.Cust_id
AND C.Cust_id=T1.Cust_id
AND A.Prod_id='Prod_11'
AND C.Prod_id='Prod_14'



--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.*/

CREATE VIEW Cust_Log AS
SELECT Cust_id, DATEPART(YEAR,Order_Date) [Year], DATEPART(MONTH,Order_Date) [Month]
FROM combined_table

SELECT DISTINCT cust_id, [Year], [Month]
FROM Cust_Log


--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.


SELECT cust_id, [Year],[Month]
FROM Cust_Log
ORDER BY Cust_id, [YEAR]

CREATE VIEW Monthly_Visit AS
SELECT DISTINCT Cust_id, [Year], [Month],
		COUNT(*) OVER(PARTITION BY Cust_id,[Year],[Month] ORDER BY Cust_id,[Year],[Month]) AS Num_of_Log  --COUNT([Month]) ile COUNT(*) burada ayný sonucu veriyor.
FROM Cust_Log


--2.yöntem:

CREATE VIEW Monthly_Visit AS
SELECT  Cust_id, [Year],[Month], COUNT(*) Num_of_Log
FROM    Cust_Log
GROUP BY Cust_id,[Year],[Month]



--Eðer sadece aya göre gruplandýrýrsak ayný cust_id içindeki ayný ay sayýlarýný yazýyor.
--Eðer sadece yýla göre gruplandýrýrsak ayný cust_id içindeki ayný yýl sayýlarýný yazýyor.
--Eðer sadece cus_id göre gruplandýrýrsak ayný aylara göre kümülatif bir toplam veriyor.
--Bundan dolayý 



--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.


SELECT *
FROM Monthly_Visit
ORDER BY 1,2,3,4
---

SELECT  *,
        DENSE_RANK () OVER (ORDER BY [YEAR] , [MONTH]) CURRENT_MONTH
FROM    Monthly_Visit
ORDER BY 1,2,3,4
---

CREATE VIEW Next_Month_Visit AS
SELECT *, 
		LEAD(Current_Month,1) OVER(PARTITION BY Cust_id ORDER BY Current_Month)  Next_Month_Visit
FROM (
		SELECT *,
				DENSE_RANK() OVER(ORDER BY [Year],[Month] ASC) AS Current_Month
		FROM Monthly_Visit
) A



--2.Yöntem:

CREATE VIEW Next_Month_Visit AS
SELECT *, 
		LEAD(Current_Month,1) OVER(PARTITION BY Cust_id ORDER BY Current_Month) AS Next_Výsýt_Month
FROM(
SELECT DISTINCT Cust_id, [Year], [Month],
		COUNT([Month]) OVER(PARTITION BY Cust_id,[Year],[Month] ORDER BY Cust_id,[Year],[Month]) AS Num_of_Log,
		DENSE_RANK() OVER(ORDER BY [Year],[Month] ASC) AS Current_Month
FROM Cust_Log
) A


--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.


CREATE VIEW Time_Gaps AS
SELECT *, (Next_Month_Visit-Current_Month) Time_Gap
FROM Next_Month_Visit

SELECT * 
FROM Time_Gaps

--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.

CREATE VIEW Label_Gap AS
SELECT DISTINCT Cust_id,
		AVG(Time_Gap) OVER(PARTITION BY Cust_id) Avg_Time_Gap,
		CASE WHEN AVG(Time_Gap) OVER(PARTITION BY Cust_id) > 0 THEN 'Irregular' ELSE 'Churn' END  Cust_Label
FROM Time_Gaps


SELECT *
FROM Label_Gap



--/////////////////////////////////////




--MONTH-WÝSE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

CREATE VIEW Retention_Month_Val AS
SELECT * ,
	COUNT(Cust_id) OVER(PARTITION BY [Year],Current_Month,Next_Month_Visit) Retention_Month
FROM(SELECT *
	FROM Time_Gaps
	WHERE Time_Gap=1) A
--ORDER BY Cust_id


--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.


SELECT *
FROM Time_Gaps

SELECT *
FROM Label_Gap

SELECT *
FROM Next_Month_Visit
ORDER BY Current_Month


CREATE VIEW Retention_Rate_Month AS
SELECT [Year],[Month], C.Current_Month,Count_Cust,Count_Cust_Previous,Retention_Month
FROM
(
SELECT *,
		LAG(Current_Month,1) OVER(ORDER BY [Year],[Month] ASC) AS Current_Month_Previous,
		LAG(Count_Cust,1) OVER(ORDER BY [Year],[Month] ASC) AS Count_Cust_Previous
FROM
(SELECT  [Year],[Month], Count(Cust_id) Count_Cust,
		DENSE_RANK() OVER(ORDER BY [Year],[Month] ASC) AS Current_Month
FROM   Time_Gaps A
GROUP BY [Year],[Month]
) A) B,
(SELECT DISTINCT Current_Month,Retention_Month
FROM Retention_Month_Val
) C
WHERE B.Current_Month=C.Current_Month


SELECT *
FROM(
SELECT [Year],[Month], CAST(ROUND((1.0*Retention_Month/Count_Cust_Previous),2) AS DECIMAL(16,2)) Retention_Rate
FROM Retention_Rate_Month
) A
WHERE Retention_Rate IS NOT NULL





/*
CREATE VIEW X AS
SELECT [Year],[Month], C.Current_Month,Count_Cust,Count_Cust_Previous,
		LEAD(Retention_Month,1) OVER(ORDER BY [Year],[Month] ASC) AS Retention_Month_Next
FROM
(
SELECT *,
		LAG(Current_Month,1) OVER(ORDER BY [Year],[Month] ASC) AS Current_Month_Previous,
		LAG(Count_Cust,1) OVER(ORDER BY [Year],[Month] ASC) AS Count_Cust_Previous
FROM
(SELECT  [Year],[Month], Count(Cust_id) Count_Cust,
		DENSE_RANK() OVER(ORDER BY [Year],[Month] ASC) AS Current_Month
FROM   Time_Gaps A
GROUP BY [Year],[Month]
) A) B,
(SELECT DISTINCT Current_Month,Retention_Month
FROM Retention_Month_Val
) C
WHERE B.Current_Month=C.Current_Month


SELECT *
FROM X

SELECT (1.0*Count_Cust_Previous/Retention_Month_Next)/100
FROM X





SELECT B.[Year],B.[Month], B.Current_Month,B.Count_Month_Previous,B.Count_Month_Next, C.Next_Month_Visit
,(1.0*Count_Month_Next/Count_Month_Previous)/100
FROM (
SELECT *,
		LAG(Count_Cust,1) OVER(ORDER BY [Year],[Month]) Count_Month_Previous,
		LEAD(Count_Cust,1) OVER(ORDER BY [Year],[Month]) Count_Month_Next
FROM (		
SELECT  [Year],[Month],Count(Cust_id) Count_Cust,
		DENSE_RANK() OVER(ORDER BY [Year],[Month] ASC) AS Current_Month
FROM   Time_Gaps
GROUP BY [Year],[Month]
) A
) B , Next_Month_Visit C
WHERE B.Current_Month=C.Current_Month
ORDER BY B.Current_Month




/*
CREATE VIEW Cust_Types AS
SELECT *,
		CASE
             WHEN time_gap=1 THEN 'retained'
             WHEN time_gap>1 THEN 'lagger'
             WHEN time_gap IS NULL THEN 'lost'
       END AS cust_type
FROM Time_Gaps


SELECT *
FROM Cust_Types


SELECT Current_Month,
	   COUNT(cust_id)
FROM Cust_Types
WHERE cust_type='retained'
GROUP BY Current_Month
ORDER BY Current_Month


---///////////////////////////////////
--Good luck!