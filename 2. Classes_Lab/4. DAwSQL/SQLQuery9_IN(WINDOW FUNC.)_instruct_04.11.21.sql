--------04.11.21---
--Windows Function

--Question: Tüm bisikletler arasýnda En ucuz bisikletin adý(First value fonk. kullanýnýz.)

SELECT *
FROM product.product

SELECT DISTINCT FIRST_VALUE(product_name) OVER(ORDER BY list_price) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product

--Question: Herbir kategorideki en ucuz bisikletin adý?

SELECT DISTINCT category_id,
	   FIRST_VALUE(product_name) OVER(PARTITION BY category_id ORDER BY list_price) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product


--first_value ile last_value arasýndaki önemli fark last_value daki windows frame dir.

SELECT DISTINCT LAST_VALUE(product_name) OVER(ORDER BY list_price) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product

SELECT DISTINCT 
	   LAST_VALUE(product_name) OVER(ORDER BY list_price DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product            --ROWS YERÝNE RANGE de kullanýlabilir.

SELECT DISTINCT 
	   LAST_VALUE(product_name) OVER(ORDER BY list_price DESC RANGE BETWEEN 1 PRECEDING AND 4 FOLLOWING) --list_price larý sýraladý ve en ucuz olanýn ismini getirdik.
FROM product.product  

--Question: Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz(LAG fonksiyonu kullanýnýz.)

SELECT A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER(PARTITION BY A.staff_id ORDER BY order_id)  --order_date kullanmamýz uygun olmayabilir bunun yerine order_id ile bir sýralama yapmamýz gerekiyor.
FROM sale.staff A, sale.orders B                 --order_id ye göre sýraladýðýmýzda bir önceki satýrýn order_date getiriyor ancak bu gelen satýr o kiþiye ait olmayabilir. Bütün sipariþleri bütün olarak deðerlendirdi.
WHERE A.staff_id=B.staff_id                      --Bundan partition by yapmamýz gerekir.
ORDER BY A.staff_id

--Question: Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz.

SELECT B.order_id,A.staff_id, A.first_name, A.last_name, B.order_date,
		LEAD(order_date) OVER(PARTITION BY A.staff_id ORDER BY order_id)  --order_date kullanmamýz uygun olmayabilir bunun yerine order_id ile bir sýralama yapmamýz gerekiyor.
FROM sale.staff A, sale.orders B                 --order_id ye göre sýraladýðýmýzda bir önceki satýrýn order_date getiriyor ancak bu gelen satýr o kiþiye ait olmayabilir. Bütün sipariþleri bütün olarak deðerlendirdi.
WHERE A.staff_id=B.staff_id                      --Bundan partition by yapmamýz gerekir.
ORDER BY A.staff_id


-- Analytic Numbering Functions

--Question: herbir kategori içinbisikletLERÝN FÝYAT SIRALAMASINI yapýnýz.

SELECT category_id, list_price,
	   ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price)
FROM product.product

--Question: Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz.

SELECT category_id, list_price,
	   RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_Number
FROM product.product
--RANK VE DENSE_RANK arasýndaki farka dikkat!!!!!!
SELECT category_id, list_price,
	   DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_Number
FROM product.product


--Question: Müþterilerin sipariþ ettikleri ürün sayýlarýnýn kümülatif daðýlýmýný yazýnýz.

SELECT *
FROM sale.orders

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
SELECT DISTINCT prod_quantity, ROUND(CUME_DIST() OVER(ORDER BY prod_quantity),2) CUM_DIST
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

--Question: Yukarýdaki tabloya göre müþterileri sipariþ verdikleri ürün sayýsýna göre 5 farklý gruba bölün.

WITH T1 AS
(
SELECT A.customer_id,
	  SUM(quantity) prod_quantity  --müþterilerin sipariþlerinde verdiði toplam ürün sayýsý.
FROM sale.orders A, sale.order_item B
WHERE A.order_id=B.order_id
GROUP BY A.customer_id
)
SELECT DISTINCT customer_id, prod_quantity, NTILE(5) OVER(ORDER BY prod_quantity) CUM_DIST --Buradaki order by ise bize ntile func uygulanýrken bunun içinde sýralama yapar.
FROM T1
ORDER BY 1  --Buradaki order by en son karþýmýza gelen tabloyu sýralar.


-- Question: Sipariþlerin ortalama ürün fiyatlarýný ve tüm sipariþlerin ortalama net tutarý yani indirim düþülmüþ halini yazýnýz.


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

--Question : 2018 yýlýnda store larýn haftalýk kümülatif sipariþ sayýlarýný yazdýrýnýz

SELECT *
FROM sale.store

SELECT *
FROM sale.orders


SELECT B.store_id, B.store_name, A.order_date, DATEPART(WEEK, order_date) week_of_year,
		  COUNT(*) OVER(PARTITION BY B.store_id, DATEPART(WEEK, order_date))  cnt_order_per_week,
		  COUNT(*) OVER(PARTITION BY B.store_id ORDER BY DATEPART(WEEK, order_date))
FROM sale.orders A, sale.store B
WHERE A.store_id=B.store_id
AND DATEPART(YEAR,order_date)=2018  --YEAR(order_date)=2018 kullanýlabilir
ORDER BY 1,3
