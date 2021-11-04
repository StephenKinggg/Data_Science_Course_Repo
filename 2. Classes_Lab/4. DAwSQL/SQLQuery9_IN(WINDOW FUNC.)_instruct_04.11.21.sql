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