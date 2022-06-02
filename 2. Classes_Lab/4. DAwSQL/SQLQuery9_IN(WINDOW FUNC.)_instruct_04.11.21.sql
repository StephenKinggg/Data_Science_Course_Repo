--------04.11.21---
--Windows Function

--First_Value/Last_Value:

--Question: 
--What is the name of the cheapest bike?
--Tüm bisikletler arasýnda En ucuz bisikletin adý(First value fonk. kullanýnýz.)

SELECT *
FROM product.product

SELECT DISTINCT FIRST_VALUE(product_name) OVER(ORDER BY list_price) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product

--Question: 
--What is the name of the cheapest bike in each category?
--Herbir kategorideki en ucuz bisikletin adý?

SELECT DISTINCT category_id, 
	   FIRST_VALUE(product_name) OVER(PARTITION BY category_id ORDER BY list_price) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product


--first_value ile last_value arasýndaki önemli fark last_value daki windows frame dir.

--Question:
--How to do the first question using last_value?


SELECT DISTINCT FIRST_VALUE(product_name) OVER(ORDER BY list_price) 
FROM product.product


--last_value en son satýrý getirmeye çalýþtýðý için burada default olan WF kullanamýyoruz.
SELECT DISTINCT product_name,list_price,
				LAST_VALUE(product_name) OVER(ORDER BY list_price DESC) AS F_V
FROM product.product


SELECT DISTINCT 
	   LAST_VALUE(product_name) OVER(ORDER BY list_price DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product            --ROWS YERÝNE RANGE de kullanýlabilir.


SELECT DISTINCT 
	   LAST_VALUE(product_name) OVER(ORDER BY list_price DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product


SELECT DISTINCT 
	   LAST_VALUE(product_name) OVER(ORDER BY list_price DESC ROWS BETWEEN 1 PRECEDING AND 4 FOLLOWING) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product  




--Question: 
--Write a query that returns the order date of the one previous sale of each staff(use the lag function)
--Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz(LAG fonksiyonu kullanýnýz.)

SELECT *
FROM sale.staff A

SELECT *
FROM sale.orders B

SELECT A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date
FROM sale.staff A, sale.orders B
WHERE A.staff_id=B.staff_id 
ORDER BY A.staff_id


/*Aþaðýdaki gibi yapýnca bize bir sonraki sipariþin tarihini getirmedi 2.satýrda olduðu gibi.
Buraya getirdiði deðer order_id göre sýraladýktan sonra bir sonraki order_id nin sipariþ tarihidir.
Tüm çalýþanlarýn sipariþlerini birlikte deðerlendiriyor.
*/

SELECT A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER(ORDER BY order_id)
FROM sale.staff A, sale.orders B
WHERE A.staff_id=B.staff_id 
ORDER BY A.staff_id


--Yukarýdaki sorunu çözmek için her bir çalýþaný ayrý ayrý deðerlendireceðiz.

SELECT A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER(PARTITION BY A.staff_id ORDER BY order_id)
FROM sale.staff A, sale.orders B                 
WHERE A.staff_id=B.staff_id                      


--Write a query that returns the order date of the one next sale of each staff(use the LEAD function)

SELECT A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LEAD(order_date) OVER(PARTITION BY A.staff_id ORDER BY order_id)
FROM sale.staff A, sale.orders B                 
WHERE A.staff_id=B.staff_id 



-- Analytic Numbering Functions

--Question: 
--Write a query that assign an ordinal number to the bike prices for each category in ascending order.
--herbir kategori içinbisikletlerin fiyat sýralamasýný yapýnýz.

SELECT category_id, list_price,
	   ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price)
FROM product.product

--Question: Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz(RANK funct. kullanýnýz.)

SELECT category_id, list_price,
	   RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_Number
FROM product.product

--RANK VE DENSE_RANK arasýndaki farka dikkat!!!!!!

SELECT category_id, list_price,
	   DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_Number
FROM product.product


--Question: 
--Müþterilerin sipariþ ettikleri ürün sayýlarýnýn kümülatif daðýlýmýný yazýnýz.

SELECT *
FROM sale.orders --Buradan her bir müþterinin toplam kaç ürün siparis ettiðini bulamýyorum.Aþaðýdaki table ile join yaptým.

SELECT *
FROM sale.order_item


WITH T1 AS
(
SELECT A.customer_id,
	  SUM(quantity) prod_quantity  --müþterilerin sipariþlerinde verdiði toplam ürün sayýsý.
FROM sale.orders A, sale.order_item B
WHERE A.order_id=B.order_id
GROUP BY A.customer_id
)
SELECT DISTINCT prod_quantity, ROUND(CUME_DIST() OVER(ORDER BY prod_quantity),2) CUM_DIST --Cume_Dýst ile ürünlerin kümülatif daðýlýmýný getirdik.
FROM T1
ORDER BY 1



WITH T1 AS
(
SELECT A.customer_id,
	  SUM(quantity) prod_quantity  --müþterilerin sipariþlerinde verdiði toplam ürün sayýsý.
FROM sale.orders A, sale.order_item B
WHERE A.order_id=B.order_id
GROUP BY A.customer_id
)
SELECT DISTINCT prod_quantity, ROUND(PERCENT_RANK() OVER(ORDER BY prod_quantity),2) CUM_DIST
FROM T1
ORDER BY 1


--Question: 

--Divide customers into 5 groups based on the quantity of product they order.
--Yukarýdaki tabloya göre müþterileri sipariþ verdikleri ürün sayýsýna göre 5 farklý gruba bölün.

WITH T1 AS
(
SELECT A.customer_id,
	  SUM(quantity) prod_quantity  --müþterilerin sipariþlerinde verdiði toplam ürün sayýsý.
FROM sale.orders A, sale.order_item B
WHERE A.order_id=B.order_id
GROUP BY A.customer_id
)
SELECT DISTINCT customer_id, prod_quantity, NTILE(5) OVER(ORDER BY prod_quantity) grp_cust --Buradaki order by ise bize ntile func uygulanýrken bunun içinde sýralama yapar.
FROM T1
ORDER BY 3,1  --Buradaki ile WF içindeki order by farklýdýr. Buradaki en son karþýmýza gelen tabloyu sýralar.


--Question: 
--Write a query that returns both of the followings:
-- * The average product price of orders.
-- * Average net amount of orders.
--Sipariþlerin ortalama ürün fiyatlarýný ve tüm sipariþlerin ortalama net tutarý yani indirim düþülmüþ halini yazýnýz.

SELECT *
FROM sale.order_item


SELECT *, list_price*quantity*(1-discount)
FROM sale.order_item


SELECT DISTINCT order_id, 
AVG(list_price) OVER(PARTITION BY order_id) Avg_Price,
AVG(list_price*quantity*(1-discount)) OVER() Avg_Net_Amount  --Tüm tablonun ortalama net tutarlarýný getirdik.
FROM sale.order_item


SELECT DISTINCT order_id, 
AVG(list_price) OVER(PARTITION BY order_id) Avg_Price,
AVG(list_price*quantity*(1-discount)) OVER(PARTITION BY order_id) Avg_Net_Amount   --Burada ise sipariþlerin ortalama net tutarlarýný getirdik.
FROM sale.order_item


--Ortalama ürün fiyatlýnýn ortalama net tutardan yüksek olduðu sipariþleri listeleyiniz.

WITH T1 AS
(
SELECT DISTINCT order_id, 
AVG(list_price) OVER(PARTITION BY order_id) Avg_Price,
AVG(list_price*quantity*(1-discount)) OVER() Avg_Net_Amount   --Burada ise sipariþlerin ortalama net tutarlarýný getirdik.
FROM sale.order_item
)
SELECT *
FROM T1
WHERE Avg_Price > Avg_Net_Amount 
ORDER BY 1

--Question : 
--Write a query that calculate the stores weekly cumulative number of orders for 2018.
--2018 yýlýnda store larýn haftalýk kümülatif sipariþ sayýlarýný yazdýrýnýz.

SELECT *
FROM sale.store

SELECT *
FROM sale.orders


SELECT B.store_id, B.store_name, A.order_date, DATEPART(WEEK, A.order_date) week_of_year 
FROM sale.orders A, sale.store B
WHERE A.store_id=B.store_id
AND DATEPART(Year, order_date)=2018  --YEAR(order_date)=2018 kullanýlabilir.
ORDER BY 1



SELECT DISTINCT B.store_id, B.store_name, DATEPART(WEEK, order_date) week_of_year, --A.order_date kullanmýþtýk bu durumda tekrar getiriyor. DISTINCT kullaným farkýna dikkat edelim.
		  COUNT(*) OVER(PARTITION BY B.store_id, DATEPART(WEEK, order_date))  cnt_order_per_week, --store_id ve week göre gruplandýrma yaptýk.
		  COUNT(*) OVER(PARTITION BY B.store_id ORDER BY DATEPART(WEEK, order_date))  cnt_cumulative
FROM sale.orders A, sale.store B
WHERE A.store_id=B.store_id
AND DATEPART(YEAR,order_date)=2018  --YEAR(order_date)=2018 kullanýlabilir
ORDER BY 1


--Question: 
--Calculate 7-day moving average of the number of products sold between '2018-03-12' ve '2018-04-12'.
--2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn. Yani satýra bakacak ve kendisi ve öncesi 6 günün ortalamasýný hesaplayacak.

SELECT *
FROM sale.orders


SELECT *
FROM sale.order_item

SELECT DISTINCT A.order_date, SUM(B.quantity) OVER(PARTITION BY A.Order_date) AS Sum_Qua
FROM sale.orders A, sale.order_item B
WHERE A.order_date BETWEEN '2018-03-12' AND '2018-04-12'



SELECT A.order_date, A.Sum_Qua, AVG(A.Sum_Qua) OVER(ORDER BY A.order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Mov_7_days
FROM
(SELECT DISTINCT O.order_date, SUM(T.quantity) OVER(PARTITION BY O.Order_date) AS Sum_Qua
FROM sale.orders O 
JOIN sale.order_item T ON O.order_id=T.order_id
WHERE O.order_date BETWEEN '2018-03-12' AND '2018-04-12') A


