/* Session: 5:
Date types
Oct 25th
*/

SELECT GETDATE();

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT * FROM t_date_time;

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
------------------------
--CONVERT(target,input,style)
SELECT GETDATE();

SELECT CONVERT(varchar, GETDATE(),101);

SELECT CONVERT(varchar, GETDATE(),7);

SELECT CONVERT(varchar, GETDATE(),112);

SELECT CONVERT(date,'25 Oct 21',6)

;
----- Function for construction of date and time

SELECT DATEFROMPARTS(2021, 10, 25)  AS TodaysDate;

SELECT DATETIMEFROMPARTS (2021, 10, 25,20,39,55,0);

SELECT DATETIMEOFFSETFROMPARTS(2021,10,25, 20,0,0,0, 2,0,0)
------------------------------------------------------

SELECT DATENAME(month, getdate());

SELECT DATEPART(month, getdate());
/*
year, yyyy, yy = Year
quarter, qq, q = Quarter
month, mm, m = month
dayofyear = Day of the year
day, dy, y = Day
week, ww, wk = Week
weekday, dw, w = Weekday
hour, hh = hour
minute, mi, n = Minute
second, ss, s = Second
millisecond, ms = Millisecond
*/

SELECT A_date,
 DATENAME(DW, A_date) [DayofWeek],
 DATEPART(DAY,A_date) [Day2],
 DAY('2021-02-15'),
 MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROm t_date_time


SELECT DATEPART(ms, GETDATE()), GETDATE()
--------------------------------
--DATEDIFF
SELECT DATEDIFF (DAY, '2021-10-01',GETDATE())
--25 -1 = 24

SELECT DATEDIFF (YEAR, '2001-10-01',GETDATE())
----------------------------------

SELECT DATEDIFF(DAY,order_date,shipped_date),order_date, shipped_date
FROM sale.orders

---
--AVG time to ship
SELECT AVG(DATEDIFF(DAY,order_date,shipped_date))
FROM sale.orders

-----
--DATEADD

SELECT DATEADD(YEAR,5,GETDATE()),GETDATE();

SELECT DATEADD(YEAR,-5,GETDATE()),GETDATE();

--EOMONTH

SELECT DAY(EOMONTH('2019-02-15')) end_of_month_feb2019

SELECT DAY(EOMONTH('2020-02-15')) end_of_month_feb2020

SELECT EOMONTH(getdate(),2)
------------------------
--ISDATE
SELECT ISDATE('2021-10-25')

SELECT ISDATE('abcdef')

SELECT CASE ISDATE ('123456')
WHEN 0 THEN 'THIS IS NOT A VALID DATE'
WHEN 1 THEN 'THIS IS VALID DATE'
END as CheckDate


SELECT CASE ISDATE ('9999')
WHEN 0 THEN 'THIS IS NOT A VALID DATE'
WHEN 1 THEN 'THIS IS VALID DATE'
END as CheckDate
--------------------------------------------
/*
Question: Create a new column that contains labels of the shipping speed of products.

If the product has not been shipped yet, it will be marked as "Not Shipped",
If the product was shipped on the day of order, it will be labeled as "Fast".
If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
If the product was shipped three or more days after the day of order, it will be labeled as "Slow"
*/

SELECT order_id, CASE
	WHEN shipped_date IS NULL THEN 'NOT SHIPPED'
	WHEN order_date = shipped_date THEN 'FAST'
	WHEN DATEDIFF(DAY,order_date,shipped_date) < 2 THEN 'NORMAL'
	ELSE 'SLOW'
	END as speed
FROM sale.orders
ORDER BY 2

--Write a query that returns orders that are shipped more than two days after the ordered date. 

SELECT order_id, order_date,shipped_date, DATEDIFF(DAY,order_date,shipped_date) asDaysToShip
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2

--------------------------------------------------
----Write a query that returns the number distributions of the orders in the previous query result, according to the days of the week.

SELECT SUM(CASE WHEN DATENAME(dw,order_date) = 'Monday' THEN 1 ELSE 0 END) AS Monday,
SUM(CASE WHEN DATENAME(dw,order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS Tuesday,
SUM(CASE WHEN DATENAME(dw,order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
SUM(CASE WHEN DATENAME(dw,order_date) = 'Thursday' THEN 1 ELSE 0 END) AS Thursday,
SUM(CASE WHEN DATENAME(dw,order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
SUM(CASE WHEN DATENAME(dw,order_date) = 'Saturday' THEN 1 ELSE 0 END) AS Saturday,
SUM(CASE WHEN DATENAME(dw,order_date) = 'Sunday' THEN 1 ELSE 0 END) AS Sunday
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2



SELECT  SUM(CASE WHEN DATENAME(dw,order_date)= 'Monday' THEN 1 ELSE 0 END)
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2

--------------------------------------------------
--Write a query that returns the order count of each state by month.

SELECT A.state,YEAR(B.order_date),MONTH(B.order_Date), COUNT(distinct order_id) as OrderCount
FROM sale.customer A JOIN sale.orders B ON A.customer_id = B.customer_id
GROUP BY A.state,YEAR(B.order_date),MONTH(B.order_Date)
ORDER BY 1,2,3
----------------------------------
--BONUS---
declare  --Declare a variable
@date date 

SET @Date = '9999-01-01' --Assign value to variable

IF (select YEAR(@Date)) < 2025 --Extract datepart and check if it is less than 2025
PRINT 'THIS IS A VALID  DATE'
ELSE PRINT 'BOO'

-- TRY the above with different dates or different conditions for validation