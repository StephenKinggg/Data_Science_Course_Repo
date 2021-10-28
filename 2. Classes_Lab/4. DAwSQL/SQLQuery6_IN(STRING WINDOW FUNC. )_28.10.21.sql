--28.10.21

SELECT *
FROM t_date_time

SELECT GETDATE()

SELECT A_time, A_date, GETDATE()
		DATEDIFF(MINUTE, A_time, GETDATE()) AS minute_diff
		DATEDIFF(WEEK, A_TIME, '2011-11-30') AS week_diff
FROM t_date_time


SELECT DATEDIFF(DAY,shipped_date, order_date) DATE_DIFF, order_date,shipped_date  -- büyük olaný önce yazmamýz gerekir.
FROM sale.orders

SELECT DATEDIFF(MONTH,shipped_date, order_date) DATE_DIFF, order_date,shipped_date  -- büyük olaný önce yazmamýz gerekir.
FROM sale.orders


-- ABS mutlak deðeri alýyor.

SELECT ABS(DATEDIFF(DAY,order_date, shipped_date)) DATE_DIFF, order_date,shipped_date  -- küçük olaný yani yeni olaný önce yazmamýz gerekir.
FROM sale.orders  

SELECT ORDER_DATE,
		DATEADD(YEAR, 5, order_date)  --order date 5 yýl ekledik. Bunlar tabloda bir deðiþiklik yapmýyor.
FROM sale.orders

SELECT ORDER_DATE,
		DATEADD(DAY, 10, order_date)  --order date 10 gün ekledik.
FROM sale.orders


SELECT GETDATE(), DATEADD(HOUR, 5, GETDATE())  --þu andaki saate 5 saat ekledik.

--EOMONTH  ayýn son gününü hesap etmek için kullanýlýyor.

SELECT EOMONTH(GETDATE()), EOMONTH(GETDATE(),2) --içinde bulunduðumuz ayýn son gününü bulduk. Bunun üzerine 2 ay ilave ettik.

-- ISDATE

SELECT ISDATE('2021-10-01')  --SONUC 1 ÝSE BU BÝR DATE TÝR. YOKSA 0 VERÝR. VARCHAR OLABÝLÝR. Bu tarih ise iþlem yap deðil ise tipini convert ile farklý birtipe çevirebiliriz.

SELECT ISDATE('SELECT')

SELECT ISDATE('2021-10-01')  -- 0 döndürür çünkü böyle bir date tipi yani 13 ay yok,

----Orders tablosuna sipariþlerin teslimat hýzýyla ilgili bir alan ekleyin.

--Bu alanda eðer teslimat gerçekleþmemiþse 'Not Shipped',

--Eðer sipariþ günü teslim edilmiþse 'Fast',

--Eðer sipariþten sonraki iki gün içinde teslim edilmiþse 'Normal'

--2 günden geç teslim edilenler ise 'Slow'

--olarak her bir sipariþi etiketleyin.

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
		WHEN DATEDIFF ( day, order_date, shipped_date) <3 THEN 'Normal'
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
WHERE DATEDIFF(day,order_date,shipped_date) >2

-- önceki sonuca göre günlere göre daðýlýmýný gösterelim.

SELECT *, DATENAME(weekday, order_date)
FROM sale.orders

SELECT CASE WHEN DATENAME(WEEKDAY, order_date) ='Monday' THEN 1 END AS MONDAY
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2  -- BUNUN ÝLE SÝPARÝÞÝN VERÝLDÝÐÝ GÜNÜN PTESÝ OLANLARI ÝÇÝN YAZDIK.

SELECT SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Monday' THEN 1 END) MONDAY,   --Buna göre 
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Tuesday' THEN 1 END) TUESDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Wednesday' THEN 1 END) WEDNESDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Thursday' THEN 1 END) THURSDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Friday' THEN 1 END) FRIDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Saturday' THEN 1 END) SATURDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) ='Sunday' THEN 1 END) SUNDAY
FROM sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2  -- BUNUN ÝLE SÝPARÝÞÝN VERÝLDÝÐÝ GÜNÜN PTESÝ OLANLARI ÝÇÝN YAZDIK.

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


--Question: Aylara göre state lerin sipariþ sayýlarýný döndürelim.

--STRING

SELECT LEN('WELCOME')

--CHARINDEX

SELECT CHARINDEX('C','CHARACTER') --ÝLK GÖRDÜÐÜ C YÝ GETÝRÝR.

SELECT CHARINDEX('C','CHARACTER',2) --2.KARAKTERDEN SONRAKÝ C NÝN YERÝNÝ GETÝRÝR.

SELECT CHARINDEX('CT','CHARACTER') --BÝRDEN FAZLA KARAKTER SORGULAYABÝLÝRÝZ ANCAK BÝR PATERN SORGULAYAMAYIZ.

SELECT CHARINDEX('CT%','CHARACTER') --BURADA % ÝÞARETÝNÝ BÝR PATERN OLARAK DEÐÝLDE BÝR KARAKTER OLARAK ALGILIYOR.

--PATINDEX

SELECT PATINDEX('R', 'CHARACTER')

SELECT PATINDEX('R%', 'CHARACTER')

SELECT PATINDEX('%R%', 'CHARACTER')

SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('_R', 'CHARACTER')

SELECT PATINDEX('___R%', 'CHARACTER')

SELECT PATINDEX('%E%', 'CHARACTER')

SELECT PATINDEX('_______E%', 'CHARACTER') 

SELECT PATINDEX('%E_', 'CHARACTER') --E den önce sayýsýný bilmediðimiz kadar sonra ise bir karakter var.

--LEFT

SELECT LEFT ('CHARACTER', 3)

SELECT LEFT ('  CHARACTER', 3) -- BOÞLÜK OLUP OLMADIÐINI BU ÞEKÝLDE GÖREBÝLÝRÝZ.

RIGHT

SELECT RIGHT ('CHARACTER', 1)

SELECT RIGHT ('  CHARACTER', 3)

--SUBSTRING

SELECT SUBSTRING('CHARACTER', 1,3)  --1 DEN ÝTÝBAREN 3 KARAKTER ALMAK ÝSTÝYORUM.

SELECT SUBSTRING('CHARACTER', -1,3)  --ÝLK KARAKTER 1 DEN BAÞLAR ÖNCESÝ 0 VE -1 DÝYE DEVAM EDER.


