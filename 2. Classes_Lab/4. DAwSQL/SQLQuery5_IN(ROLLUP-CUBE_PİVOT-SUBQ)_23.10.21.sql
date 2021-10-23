--23.10.21
--Trek Remedy 9.8 -2019 ürünün sipariþ verilmediði state/stateleri getiriniz.
-- önce bu ürünün tablosundan sipariþ bilgileri tablosuna oradan sipariþin müþteri numarasýndan bunun verenlerin ülke bilgilerine gideceðim.

SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D. *
FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE A.product_id=B.product_id 
AND B.order_id=C.order_id
AND C.customer_id=D.customer_id
AND A.product_name='Trek Remedy 9.8 - 2019'

SELECT *
FROM sale.customer X
WHERE NOT EXISTS ( SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D. *
					FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE A.product_id=B.product_id 
					AND B.order_id=C.order_id
					AND C.customer_id=D.customer_id
					AND A.product_name='Trek Remedy 9.8 - 2019'
					)
				
SELECT *
FROM sale.customer X
WHERE NOT EXISTS ( SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D. *
					FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE A.product_id=B.product_id 
					AND B.order_id=C.order_id
					AND C.customer_id=D.customer_id
					AND A.product_name='Trek Remedy 9.8 - 2019'
					AND X.state=D.state
					)

--VÝEWS

-- 2019 yýlýnda üretilen ürünlerin bulunduðu bir NEW_PRODUCTS view oluþturun

CREATE VIEW NEW_PRODUCTS AS
SELECT A.*
FROM product.product A
WHERE A.model_year =  '2019'

SELECT * 
FROM NEW_PRODUCTS

--CTE(Common Table Expression)

--Sharyn Hopkins isimli müþterinin son sipariþinden önce sipariþ vermiþ ve San Diego þehrinde ikamet eden müþterileri listeleyin.


SELECT *
FROM sale.customer

-- önce Sharyn Hopkins isimli müþterinin son sipariþ tarihini bulduk. Order_id büyük olan veya order_date yeni olan

SELECT TOP 1 A.order_date last_purchase    -- max(order_date) bana buradan tarih almam lazým.
FROM sale.customer B, sale.orders A   -- Burada bir join yapmýþ olduk.
WHERE A.customer_id=B.customer_id
AND B.first_name='Sharyn' 
AND B.last_name='Hopkins'
ORDER BY order_date DESC


WITH T1 AS  --Aþaðýdaki query bir sonraki query de yani bir üst query de kullanacaðým. Buna T1 dedim.
(SELECT TOP 1 A.order_date last_purchase    -- max(order_date) bana buradan tarih almam lazým.
FROM sale.customer B, sale.orders A   -- Burada bir join yapmýþ olduk.
WHERE A.customer_id=B.customer_id
AND B.first_name='Sharyn' 
AND B.last_name='Hopkins'
ORDER BY order_date DESC
)
SELECT DISTINCT A.order_date, A.order_id, B.customer_id, B.first_name, B.last_name, B.city
FROM sale.orders A, sale.customer B, T1
WHERE A.customer_id=B.customer_id
AND A.order_date < T1.last_purchase   --order_date nin T1 den gelen order_date büyük olanlarý aldýk.
AND B.city='San Diego' 

--2.çözüm

with last_cust 
as 
(
    select max(o.order_date) as aaa
    from sale.customer c join sale.orders o on c.customer_id=o.customer_id
    where first_name = 'Sharyn' and last_name = 'Hopkins'
)
select a.first_name, a.last_name, b.order_date, a.city
from sale.customer a join sale.orders b on a.customer_id=b.customer_id
where b.order_date < (select * from last_cust) and a.city = 'San Diego'


--Question:
--Abby	Parks isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
--Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.

WITH T1 AS  --Aþaðýdaki query bir sonraki query de yani bir üst query de kullanacaðým. Buna T1 dedim.
(SELECT A.order_date purchase    -- max(order_date) bana buradan tarih almam lazým.
FROM sale.customer B, sale.orders A   -- Burada bir join yapmýþ olduk.
WHERE A.customer_id=B.customer_id
AND B.first_name='Abby' 
AND B.last_name='Parks'

)
SELECT DISTINCT A.order_date, B.first_name, B.last_name
FROM sale.orders A, sale.customer B, T1
WHERE A.customer_id=B.customer_id
AND A.order_date IN (T1.purchase)   --order_date, T1 den gelen order_dateleri içerecek. = kullanýlabilir. 

--2.çözüm:

with new_query as 
(
    select o.order_date
    from sale.orders o join sale.customer c on o.customer_id=c.customer_id
    where c.first_name = 'Abby' and c.last_name = 'Parks'
)
select a.first_name, a.last_name, b.order_date
from sale.customer a join sale.orders b on a.customer_id=b.customer_id
where b.order_date in (select * from new_query)



WITH T1 AS   -- AS unutma
(SELECT 1 AS NUM  --ilk olarak 1 atadýk. Bu birinci query
 UNION ALL     --bunun ile iki query birleþtiriyoruz.
 SELECT NUM+1   -- Bu ikinci query
 FROM T1
 WHERE NUM < 9   --Iterasyonu sonlandýracak rakamý yazmamýz lazým yoksa sonsuza kadar gider.
)
SELECT *
FROM T1

--SET OPERATORS
--Sacramento þehrindeki müþteriler ile Monroe þehrindeki müþterilerin soyisimlerini listeleyin.


--UNION ALL

SELECT last_name   -- 1.tablo
FROM sale.customer
WHERE city='Sacramento'

UNION ALL          -- iki tabloyu birleþtirdik. Ayný olanlarý getirir.

SELECT last_name   --2.tablo
FROM sale.customer
WHERE city='Monroe'
ORDER BY last_name   -- sýralamayý en sona yazdýk.

--UNION

SELECT last_name   -- 1.tablo
FROM sale.customer
WHERE city='Sacramento'

UNION           -- iki tabloyu birleþtirdik. Ayný olanlarý getirmedi. Sýralamayý kendi yaptý.

SELECT last_name   --2.tablo
FROM sale.customer
WHERE city='Monroe'  

-- ADI CARTER VEYA SOYADI CARTER OLAN MÜÞTERÝLERÝ LÝSTELEYÝN ANCAK OR KULLANMAYIN.

SELECT first_name,last_name   -- 1.tablo
FROM sale.customer
WHERE first_name='Carter' 

UNION ALL  --Bu örnekte UNION da ayný sonucu veriyor.    

SELECT first_name,last_name   --2.tablo
FROM sale.customer
WHERE last_name='Carter'

SELECT first_name,last_name, customer_id   -- 1.tablo
FROM sale.customer
WHERE first_name='Carter' 

UNION ALL  --Bu örnekte UNION da ayný sonucu veriyor.    

SELECT first_name,last_name,customer_id   --2.tablo
FROM sale.customer
WHERE last_name='Carter'

--INTERSECT

-- hem 2018 hem 2019 yýlýnda ürünü olan markalarý listeleyiniz.


SELECT B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id=B.brand_id
AND A.model_year='2018'

INTERSECT  --hem 18 hem de 19 da ürünü olan markalar dediði için kesiþim olmalý.

SELECT B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id=B.brand_id
AND A.model_year='2019'

SELECT B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id=B.brand_id
AND A.model_year='2018'

UNION  --iki yýlda da ürünü olan markalarI DUPLÝCATE eleyerek getiriyor.

SELECT B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id=B.brand_id
AND A.model_year='2019'

--Question:
--2018,2019 VE 2020 yýllarýnýn tümünde sipariþi olan müþterilerin bilgilerini getiren bir liste.

--Bu þekilde çözünce 3 kere customer tablosuna gittiðimizden dolayý bu alltakine göre daha uzun sürüyor.
SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B  
WHERE A.customer_id=B.customer_id
AND B.order_date BETWEEN '2018-01-01' AND '2018-12-31'

INTERSECT

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B  
WHERE A.customer_id=B.customer_id
AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

INTERSECT

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B  
WHERE A.customer_id=B.customer_id
AND B.order_date BETWEEN '2020-01-01' AND '2020-12-31'


SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31'

-- Bu çözümde ise sadece customer tablosuna bir kez gidiyoruz. 
SELECT first_name, last_name
FROM sale.customer
WHERE customer_id IN( SELECT customer_id
					FROM sale.orders
					WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
					INTERSECT
					SELECT customer_id
					FROM sale.orders
					WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31'
					INTERSECT
					SELECT customer_id
					FROM sale.orders
					WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31')