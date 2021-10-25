--25.10.21 
-- EXCEPT
-- 2018 model bisiklet markalarýndan hangilerinin 2019 model bisikleti yoktur?



SELECT COUNT(DISTINCT brand_id)
FROM product.product
WHERE model_year= 2018

SELECT COUNT(DISTINCT brand_id)
FROM product.product
WHERE model_year= 2019

SELECT brand_id, brand_name    --Sonra brand tablosundan brand_id lerin isimlerini buluyoruz.
FROM product.brand
WHERE brand_id IN(
SELECT brand_id          --2018 yýlýnda üretilen markalarýn id sine baktýk.
FROM product.product
WHERE model_year= 2018

EXCEPT                  -- 2018 den 2019 çýkardýk.

SELECT brand_id           --2019 yýlýnda ürütelin markalarýn id sine baktýk.
FROM product.product
WHERE model_year= 2019)

SELECT DISTINCT model_year
FROM product.product
WHERE brand_id=5

--Question:
--Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda verilmeyen ürünler hangileridir?


SELECT C.product_id, C.product_name  --Çýkan sonucu product tablosu ile ýnner join yapýp buradan product_id ve name çekiyoruz.
FROM product.product C
INNER JOIN(
SELECT A.product_id  --2019 yýlýnda sipariþ verilen ürünleri bulduk.
FROM sale.order_item A, sale.orders B
WHERE A.order_id=B.order_id
AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'  --LIKE '2019%' da kullanabiliriz.

EXCEPT

SELECT A.product_id  --2019 yýlý dýþýnda sipariþ verilen ürünleri bulduk.ve bunu 2019 yýlýndan çýkarýnca kalan sadece 2019 yýlýnda verilen diðer yýllarda verilmeyenlerdir.
FROM sale.order_item A, sale.orders B
WHERE A.order_id=B.order_id
AND B.order_date NOT BETWEEN '2019-01-01' AND '2019-12-31'
) D
ON C.product_id=D.product_id

--Question:
--