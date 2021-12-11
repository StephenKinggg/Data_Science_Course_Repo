--/////////////////

--CUSTOMER SEGMENTATION

--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW customer_logs
AS
SELECT 
	Cust_id,
	YEAR(Order_date) [YEAR],
	MONTH(Order_date) [MONTH]
FROM 
	combined_table


	select * from customer_logs
	order by 1,2,3

--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.

CREATE VIEW NUMBER_OF_VISITS 
AS

SELECT 
	Cust_id,
	[YEAR],
	[MONTH],
	COUNT(*) Num_Of_LOG
FROM customer_logs
GROUP BY
	Cust_id,
	[YEAR],
	[MONTH];

SELECT * FROM NUMBER_OF_VISITS

--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
CREATE VIEW NEXT_VISIT 
AS
SELECT *,
		LEAD(CURRENT_MONTH,1) OVER (PARTITION BY Cust_Id ORDER BY CURRENT_MONTH) NEXT_VISIT_MONTH

FROM (

		SELECT *,
		DENSE_RANK() OVER (ORDER BY [YEAR], [MONTH]) CURRENT_MONTH
		FROM NUMBER_OF_VISITS
		) A;

SELECT * FROM NEXT_VISIT
WHERE Cust_id = 'Cust_100'
order by 1,2,3

--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

CREATE VIEW time_gaps
AS
SELECT *,
	NEXT_VISIT_MONTH - CURRENT_MONTH AS TIME_GAPS

FROM NEXT_VISIT


select * from time_gaps

--/////////////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.
SELECT Cust_id, AVG_TIME_GAP,
	CASE 
		WHEN AVG_TIME_GAP = 1 THEN 'retained'
		WHEN AVG_TIME_GAP > 1 THEN 'irregular'
		WHEN AVG_TIME_GAP IS NULL THEN 'churn'
		ELSE 'Unknown data' END CUST_LABELS
FROM (
		SELECT Cust_id, AVG(TIME_GAPS) AVG_TIME_GAP
		FROM time_gaps
		GROUP BY Cust_id 
		) A

--ORDER BY 3 desc

--MONTH-WISE RETENTION RATE

--Find month-by-month customer retention rate  since the start of the business.

--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

SELECT * FROM time_gaps

SELECT distinct
--Cust_id,
		[YEAR],
		[MONTH],
		[CURRENT_MONTH],
		[NEXT_VISIT_MONTH],
		[TIME_GAPS],
		COUNT(Cust_id) OVER (PARTITION BY NEXT_VISIT_MONTH) RETENTION_MONTH_WISE

FROM 	time_gaps
where	TIME_GAPS =1
order by 5


------------------------------
select count(distinct B.cust_id)
FROM
(SELECT cust_id FROM time_gaps where CURRENT_MONTH = 15) A 
LEFT JOIN 
(SELECT cust_id FROM time_gaps where CURRENT_MONTH = 16) B
ON A.cust_id = B.cust_id
-----------------------------

--2. Calculate the month-wise retention rate.
--Basic formula: 	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Next Nonth / Total Number of Customers in The Previous Month

drop VIEW CURRENT_NUM_OF_CUST
CREATE VIEW CURRENT_NUM_OF_CUST AS

SELECT	DISTINCT 
		--Cust_id, 
		[YEAR],
		[MONTH],
		Current_Month, 
		COUNT (Cust_id) OVER (PARTITION BY CURRENT_MONTH) CURR_CUST
FROM	time_gaps


CREATE VIEW NEXT_NUM_OF_CUST AS
SELECT	DISTINCT 
		--Cust_id,
		[YEAR],
		[MONTH],
		Current_Month,
		NEXT_VISIT_MONTH,
 
		COUNT (Cust_id) OVER (PARTITION BY Current_Month) NEXT_CUST
FROM	time_gaps
WHERE	TIME_GAPS=1
AND		Current_Month>1



SELECT	DISTINCT 
		B.[YEAR],  
		B.[MONTH],
		B.Current_Month AS RETENTION_MONTH,
		1.0*NEXT_CUST/CURR_CUST AS RETENTION_RATE
FROM	CURRENT_NUM_OF_CUST A
		LEFT JOIN
		NEXT_NUM_OF_CUST B
ON	A.Current_Month + 1  = B.NEXT_VISIT_MONTH






