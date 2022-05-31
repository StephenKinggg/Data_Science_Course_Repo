---------- 25.10.2021 DAwSQL Session-5 (Date & String Functions)

--Date Functions
--Data Types

CREATE TABLE t_date_time
	(
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


SELECT *
FROM t_date_time


--DATEDIFF

SELECT GETDATE() --Þu anki local saati gösterir.

SELECT GETDATE() as [now]

/*
INSERT t_date_time
VALUES(Getdate(), Getdate(), Getdate(), Getdate(), Getdate(), Getdate())
*/

SELECT GETDATE() as [now]  --dtypes datetime

SELECT CONVERT(Varchar, GETDATE(), 6)  --convert datetim to varchar.

SELECT CONVERT(DATE, '25 Oct 21', 6) --Convert varchar to date, 6 burada tipi ifade ediyor.

--Functions for return date or time parts

SELECT A_date
FROM t_date_time

SELECT A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH (A_date) [month],
		YEAR (A_date) [year],
		DATEPART (WEEK, A_date) WEEKDAYS2,
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM t_date_time

***************************************

---------- 28.10.2021 DAwSQL Session-6 (Date & String Functions)

/*Soldaki Tables altýnda yer alan dbo.t_date_time üzerine sað týklayýp 
Script Table As-Create To-New Query Editon Window yapýnca bize tablonun script getiriyor.

USE [SampleSales]
GO

/****** Object:  Table [dbo].[t_date_time]    Script Date: 31.05.2022 14:34:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_date_time](
	[A_time] [time](7) NULL,
	[A_date] [date] NULL,
	[A_smalldatetime] [smalldatetime] NULL,
	[A_datetime] [datetime] NULL,
	[A_datetime2] [datetime2](7) NULL,
	[A_datetimeoffset] [datetimeoffset](7) NULL
) ON [PRIMARY]
GO

*/

SELECT *
FROM t_date_time

SELECT A_time, A_date, GETDATE(),
		DATEDIFF(MINUTE, A_time, GETDATE()) AS minute_diff,
		DATEDIFF(WEEK, A_date, '2021-11-30') AS week_diff
FROM t_date_time


SELECT *
FROM sale.orders

SELECT DATEDIFF(DAY, shipped_date, order_date) DATE_DIFF, order_date, shipped_date  
FROM sale.orders

SELECT DATEDIFF(MONTH, order_date, shipped_date) DATE_DIFF, order_date,shipped_date  -- startdate olarak tarihi küçük olaný önce yazmamýz gerekir. Aksi takdirde sonuç eksi çýkar.
FROM sale.orders

SELECT DATEDIFF(WEEK, order_date, shipped_date) DATE_DIFF, order_date, shipped_date
FROM sale.orders


-- ABS mutlak deðeri alýyor.

SELECT ABS(DATEDIFF(DAY, order_date, shipped_date)) DATE_DIFF, order_date, shipped_date  -- küçük olaný yani yeni olaný önce yazmamýz gerekir.
FROM sale.orders  


----DATEADD

SELECT order_date,
		DATEADD(YEAR, 5, order_date) new_date  --order_date 5 yýl ekledik. Bunlar tabloda bir deðiþiklik yapmýyor.
FROM sale.orders

SELECT order_date,
		DATEADD(DAY, 10, order_date) cargo_date --order date 10 gün ekledik.
FROM sale.orders


SELECT GETDATE(), DATEADD(HOUR, 5, GETDATE())  --þu andaki saate 5 saat ekledik.


--EOMONTH:  ayýn son gününü hesap etmek için kullanýlýyor.

SELECT EOMONTH(GETDATE()), EOMONTH(GETDATE(), 2) --içinde bulunduðumuz ayýn son gününün üzerine 2 ay ilave ettik.



-- ISDATE: Girdiðimiz deðer date ise 1, deðilse 0 döndürür.

SELECT ISDATE('2021-10-01')  --SONUC 1 ÝSE BU BÝR DATE TÝR. YOKSA 0 VERÝR. VARCHAR OLABÝLÝR. Bu tarih ise iþlem yap deðil ise tipini convert ile farklý birtipe çevirebiliriz.

SELECT ISDATE('SELECT')

SELECT ISDATE('2021-13-01')  -- 0 döndürür çünkü böyle bir date tipi yani 13 ay yok,


--Question:
--Orders tablosuna sipariþlerin teslimat hýzýyla ilgili bir alan ekleyin.

--Bu alanda eðer teslimat gerçekleþmemiþse 'Not Shipped',

--Eðer sipariþ günü teslim edilmiþse 'Fast',

--Eðer sipariþten sonraki iki gün içinde teslim edilmiþse 'Normal'

--2 günden geç teslim edilenler ise 'Slow'

--olarak her bir sipariþi etiketleyin.

SELECT *
FROM sale.orders


WITH T1 AS 
(
SELECT *,
		DATEDIFF(DAY, order_date, shipped_date) shipped_fast
FROM sale.orders
)

SELECT order_date, shipped_date,
		CASE  --YENÝ BÝR ALAN OLUÞTURMAYI CASE ÝLE YAPABÝLÝRÝM.
			WHEN shipped_fast IS NULL THEN 'Not Shipped'
			WHEN shipped_fast = 0 THEN 'Fast' --sipariþ günü ile teslimat günü arasýndaki fark 0 ise ayný gün teslim edilmiþ demektir.
			WHEN shipped_fast <= 2 THEN 'Normal'
			WHEN shipped_fast > 2 THEN 'Slow'
		END AS order_label
FROM T1




--2.yöntem:

select  order_id,  DATEDIFF ( day, order_date, shipped_date) DATE_DIFF,
		CASE
			WHEN shipped_date is null THEN 'Not Shipped'
			WHEN DATEDIFF ( day, order_date, shipped_date) = 0 THEN 'Fast'
			WHEN DATEDIFF ( day, order_date, shipped_date) <=2 THEN 'Normal'
			WHEN DATEDIFF ( day, order_date, shipped_date) > 2 THEN 'Slow'
		END AS Labels
from sale.orders


--3.yöntem:

select order_id, order_date, shipped_date, 
case when shipped_date is null then 'Not Shipped'
	when datediff(day, order_date, shipped_date) = 0 then 'Fast'
	when datediff(day, order_date, shipped_date) >=1 and datediff(day, order_date, shipped_date) <=2 then 'Normal'
	when datediff(day, order_date, shipped_date) >=3 then 'Slow' end as Shipping_Time
from sale.orders


--Write a query returns orders that are shipped more than two days after the ordered date.
-- 2 günden geç teslim edilen sipariþ bilgilerini getiriniz. 


WITH T1 AS 
(
SELECT *,
		DATEDIFF(DAY, order_date, shipped_date) shipped_fast
FROM sale.orders
)

SELECT *,
		CASE  --YENÝ BÝR ALAN OLUÞTURMAYI CASE ÝLE YAPABÝLÝRÝM.
			WHEN shipped_fast IS NULL THEN 'Not Shipped'
			WHEN shipped_fast = 0 THEN 'Fast' --sipariþ günü ile teslimat günü arasýndaki fark 0 ise ayný gün teslim edilmiþ demektir.
			WHEN shipped_fast <= 2 THEN 'Normal'
			WHEN shipped_fast > 2 THEN 'Slow'
		END AS order_label
FROM T1
WHERE T1.shipped_fast > 2


--2.yöntem:

SELECT *,
		DATEDIFF(DAY, order_date, shipped_date) shipped_fast
FROM sale.orders
WHERE DATEDIFF(day,order_date,shipped_date) >2 --Burada yukarýdaki alias kullanamadýk çünkü select from-where-groupby-having-select-orderby þeklindedir sýralama.


--Write a query that returns the number distributions of the orders in the previous query result, according to the days of the week.
--Yukarýdaki sipariþlerin haftanýn günlerine göre daðýlýmýný gösterelim.

SELECT order_date, DATENAME(weekday, order_date) [weekday]
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date)>2


SELECT order_date,
	CASE 
		WHEN DATENAME(WEEKDAY, order_date) ='Monday' THEN 1 
		END MONDAY
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2 



SELECT	SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Monday' THEN 1 END) MONDAY, 
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Tuesday' THEN 1 END) TUESDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Wednesday' THEN 1 END) WEDNESDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Thursday' THEN 1 END) THURSDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Friday' THEN 1 END) FRIDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Saturday' THEN 1 END) SATURDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Sunday' THEN 1 END) SUNDAY
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2



--Aþaðýdaki ayrýmlara dikkat!!!!

SELECT SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Monday' THEN 1 ELSE 0 END) AS MONDAY -- SUM 1 OLANLARI TOPLUYOR.
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2  


SELECT COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) ='Monday' THEN 1 ELSE 0 END) AS MONDAY -- COUNT ÝÇÝ DOLAN OLAN TÜM SATIRLARI SAYAR.BURADA SATIRLARA 1 VE 0 YAZDIK.
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2  

SELECT COUNT(CASE WHEN DATENAME(WEEKDAY, order_date) ='Monday' THEN 1  END) AS MONDAY -- BURADA MONDAY ÝÇÝN 1 YAZDIÐIMIZDAN COUNT ÝÇÝ DOLAN OLAN TÜM SATIRLARI SAYAR.BURADA 1 OLANLARI SAYDIK.
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2 


--2.YÖNTEM:

WITH T1 AS
(
SELECT	*, DATEDIFF(DAY, order_date, shipped_date) Delivery_Time_Day
FROM	sale.orders),
T2 AS
(
SELECT	*,
		CASE
		WHEN Delivery_Time_Day IS NULL THEN 'Not Shipped'
		WHEN Delivery_Time_Day = 0 THEN 'Fast'
		WHEN Delivery_Time_Day <= 2 THEN 'Normal'
		WHEN Delivery_Time_Day > 2 THEN 'Slow'
		END AS Order_Label
FROM	T1),
T3 AS(
SELECT	*
FROM	T2
WHERE	ORDER_LABEL = 'Slow'),
T4 AS(
SELECT	DATENAME(WEEKDAY, ORDER_DATE) DAY
FROM	T3)
SELECT	DAY, COUNT(T4.DAY)
FROM	T4
GROUP BY DAY


-- 3.yöntem:

WITH T1 AS
(
SELECT	*, DATENAME(weekday, order_date) day_name
FROM	sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2 
)
SELECT day_name, count(day_name)
FROM T1
GROUP BY day_name




--Question: 
--Write a query that returns the order numbers of the states by months.
--Aylara göre state lerin sipariþ sayýlarýný döndürelim.

WITH T1 AS
(
SELECT	*, DATENAME(YEAR, order_date) years, DATEPART(MONTH, order_date) months
FROM	sale.orders
)

SELECT state, years, months, count(order_id) num_of_orders
FROM T1, sale.customer A
WHERE T1.customer_id=A.customer_id
GROUP BY months, state, years
ORDER BY state, years, months



-------String Functions

--LEN

SELECT LEN(1231354658)


SELECT LEN('WELCOME')


--CHARINDEX

SELECT CHARINDEX('C','CHARACTER') --ÝLK GÖRDÜÐÜ C YÝ GETÝRÝR.

SELECT CHARINDEX('C','CHARACTER',2) --2.KARAKTERDEN SONRAKÝ C NÝN YERÝNÝ GETÝRÝR.

SELECT CHARINDEX('CT','CHARACTER') --BÝRDEN FAZLA KARAKTER SORGULAYABÝLÝRÝZ ANCAK BÝR PATERN SORGULAYAMAYIZ.

SELECT CHARINDEX('CT%','CHARACTER') --BURADA % ÝÞARETÝNÝ BÝR PATERN OLARAK DEÐÝLDE C% OLARAK BÝR KARAKTER ARAR. PATINDEX gibi kullanamýyoruz.


--PATINDEX

SELECT PATINDEX('R', 'CHARACTER')  --SADECE R OLARAK ARAYAMIYORUZ.

SELECT PATINDEX('R%', 'CHARACTER')  --R ÝLE BAÞLAYAN OLARAK ARIYOR.

SELECT PATINDEX('%R%', 'CHARACTER')

SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('_R', 'CHARACTER')  --R DEN ÖNCE BÝR KAREKTER VAR MI ARAR.

SELECT PATINDEX('___R%', 'CHARACTER')

SELECT PATINDEX('%E%', 'CHARACTER')

SELECT PATINDEX('_______E%', 'CHARACTER') 

SELECT PATINDEX('%E_', 'CHARACTER') --E den önce sayýsýný bilmediðimiz kadar sonra ise bir karakter var.


--LEFT

SELECT LEFT ('CHARACTER', 3)

SELECT LEFT ('  CHARACTER', 3) -- BOÞLÜK OLUP OLMADIÐINI BU ÞEKÝLDE GÖREBÝLÝRÝZ.


--RIGHT

SELECT RIGHT ('CHARACTER', 1)

SELECT RIGHT ('  CHARACTER', 3)


--SUBSTRING

SELECT SUBSTRING('CHARACTER', 1, 3)  --1 DEN ÝTÝBAREN 3 KARAKTER ALMAK ÝSTÝYORUM.

SELECT SUBSTRING('CHARACTER', -1, 3)  --ÝLK KARAKTER 1 DEN BAÞLAR ÖNCESÝ 0 VE -1 DÝYE DEVAM EDER. YANÝ -1,0,1 OLMAK ÜZERE 3 KAREKTER ALIR.

SELECT SUBSTRING('CHARACTER', 0, 1) -- BOÞ GELDÝ ÇÜNKÜ SUBSTRING 1 DEN BAÞLAR.



--LOWER

SELECT LOWER ('CHARACTER')

--UPPER

SELECT UPPER(LEFT('character', 1)) + LOWER(SUBSTRING('character', 2, LEN('character'))) -- + string ifadeleri yanyana birleþtirir.


--STRING_SPLIT
--- Bir tablo oluþturduðundan kurallý yazýlýr.

SELECT value 
FROM string_split('ALÝ,MEHMET,AYÞE',',') --virgülle ayrýlmýþ olanlarý sütun halinde yazar.



--TRIM iki taraftaki boþluklarý yok eder ancak aradakilere dokunmaz.
--LTRIM soldaki boþluklarý yok eder.
--RTRIM saðdaki boþluklarý yok eder.

SELECT TRIM('  CHA  RACTER  ') --ÝKÝ TARAFTAKÝ BOÞLUÐU ATAR ANCAK ARADAKÝLERE DOKUNMAZ.

SELECT LTRIM('  CHARACTER  ') --SOLDAKÝ BOÞLUKLARI ATAR.

SELECT RTRIM('  CHARACTER  ')

SELECT TRIM('&' FROM '& CHARACTER %&') --HER ÝKÝ TARAFTAKÝ & ÝÞARETÝNÝ ATTI.


