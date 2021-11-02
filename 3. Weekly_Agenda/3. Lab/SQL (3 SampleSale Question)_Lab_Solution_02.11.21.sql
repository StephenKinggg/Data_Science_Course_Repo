--

--Find the weekly order count for the city of San Angelo for the last 52 weeks, and also the cumulative total.

--Desired output: [week_start, order_count, cuml_order_count]

SELECT *     --Buradan order_date
FROM sale.orders


SELECT *       --Buradan city 
FROM sale.store

SELECT *
FROM sale.store S
WHERE city='San Angelo'


SELECT MAX(order_date)
FROM sale.orders

SELECT DATEADD(WEEK, -8, '2020-12-28')

SELECT *     
FROM sale.orders A, sale.store B
WHERE A.store_id=B.store_id
	AND B.city='San Angelo'
	AND A.order_date BETWEEN DATEADD(WEEK, -52, '2020-12-28') AND '2020-12-28'

SELECT DATEPART(WEEK, A.order_date) AS week_number, A.order_id     --datepart order_date haftasýný aldý.
FROM sale.orders A, sale.store B
WHERE A.store_id=B.store_id
	AND B.city='San Angelo'
	AND A.order_date BETWEEN DATEADD(WEEK, -52, '2020-12-28') AND '2020-12-28'


SELECT DISTINCT DATEPART(WEEK, A.order_date) AS week_number, --A.order_id,
	   COUNT(A.order_id) OVER(PARTITION BY DATEPART(WEEK, A.order_date)) AS week_total,  --haftalýk sipariþ toplamlarýný bulduk.
	   COUNT(A.order_id) OVER(ORDER BY DATEPART(WEEK, A.order_date)) AS cuml_order_count  -- haftalýk sipariþleri birbirine ilave ederek saydýrdýk.
FROM sale.orders A, sale.store B-- over içerisinde order by kullanmasaydýk toplamlarýn tümünü alýp yan tarafa bunu yazacaktý.
WHERE A.store_id=B.store_id
	AND B.city='San Angelo'
	AND A.order_date BETWEEN DATEADD(WEEK, -52, '2020-12-28') AND '2020-12-28'

--2.yöntem:

select distinct datename(week, o.order_date) as week_number,
count(o.order_id) over(partition by datename(week, o.order_date)) as total,
count(o.order_id) over(order by datename(week, o.order_date)) as weekly_cumulative
from sale.orders o join sale.store ss on o.store_id=ss.store_id
where ss.city = 'San Angelo' and
o.order_date between dateadd(year, -1, '2020-12-28') and '2020-12-28'

--3.yöntem:

select distinct datename(week, o.order_date) as week_number,
count(o.order_id) over(partition by datename(week, o.order_date)) as total,
count(o.order_id) over(order by datename(week, o.order_date)) as weekly_cumulative
from sale.orders o join sale.store ss on o.store_id=ss.store_id
where ss.city = 'San Angelo' and
o.order_date between dateadd(year, -1, (select distinct max(order_date) over() from sale.orders)) 
and (select distinct max(order_date) over() from sale.orders)

--2.Question:

/*
--In the street column, clear the string characters that were accidentally added to the end of the initial numeric expression.

--street sütununda baþtaki rakamsal ifadenin sonuna yanlýþlýkla eklenmiþ string karakterleri temizleyin
--önce boþluða kadar olan kýsmý alýnýz
--sonra where ile sonunda harf olan kayýtlarý bulunuz
--bu harfi kaldýrýn
*/

SELECT *
FROM sale.customer

SELECT street
FROM sale.customer


SELECT A.*, REPLACE(A.street, A.TARGET_CHARS, A.NUMERICAL_CHARS) new_column
FROM
	(
	SELECT street, 
		LEFT(street, CHARINDEX(' ', street)-1) TARGET_CHARS,   --SUBSTRING (street,1, CHARINDEX(' ', street)-1)
		RIGHT(LEFT(street, CHARINDEX(' ', street)-1),1) AS STRING_CHARS,
		LEFT(street, CHARINDEX(' ', street)-2) AS NUMERICAL_CHARS
	FROM sale.customer
	WHERE ISNUMERIC(RIGHT(LEFT(street, CHARINDEX(' ', street)-1),1))=0
	) A


