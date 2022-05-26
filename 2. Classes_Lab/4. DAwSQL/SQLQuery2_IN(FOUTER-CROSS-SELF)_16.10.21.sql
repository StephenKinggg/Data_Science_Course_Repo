---- 16.10.2021 Session-2 (Advanced Grouping Operations) ---------

---Join

-- Maðaza çalýþanlarýný yaptýklarý satýþlar ile birlikte listeleyin


SELECT *
FROM sale.staff S

SELECT *
FROM sale.orders O

--Aþaðýdaki query ile maðaza çalýþanlarýndan sadece sipariþ alanlarý getirdim. Çünkü Inner Join kullandým. 
--Sipariþ almayan maðaza çalýþanlarýný getirmedi. Bundan dolayý InnerJoin iþime yaramýyor.

SELECT A.staff_id, A.first_name, A.last_name, B.staff_id, B.order_id --id ler ile çalýþmak her zaman çalýþmamýzýn doðruluðunu artýrýr.
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id=B.staff_id
ORDER BY A.staff_id -- Default ASC

-- Maðaza çalýþanlarýndan hangileri satýþ yapýyor ona baktýk.

SELECT A.staff_id, A.first_name, A.last_name, B.staff_id, B.order_id 
FROM sale.staff A
LEFT JOIN sale.orders B ON A.staff_id=B.staff_id
ORDER BY A.staff_id


SELECT COUNT(A.staff_id), COUNT(B.staff_id) -- Satýr sayýsýný getirdi.
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id=B.staff_id


--INNER JOIN VE LEFT JOIN ile bakýnca aradaki farka dikkat edelim.
--INNER JOIN de ikiside ayný iken LEFT JOIN de staff tablosu tamamý gelirken yani 10, orders sipariþ alanlar geliyor.

SELECT COUNT(DISTINCT A.staff_id), COUNT(DISTINCT B.staff_id) --
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id=B.staff_id


SELECT COUNT(DISTINCT A.staff_id), COUNT(DISTINCT B.staff_id) --
FROM sale.staff A
LEFT JOIN sale.orders B ON A.staff_id=B.staff_id

------ CROSS JOIN ------

-- Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor

SELECT DISTINCT A.brand_id, A.brand_name, C.category_id, C.category_name
FROM product.brand A
LEFT JOIN product.product B ON A.brand_id=B.brand_id
CROSS JOIN product.category C
ORDER BY A.brand_id

------ SELF JOIN ------

-- Personelleri ve þeflerini listeleyin
-- Çalýþan adý ve yönetici adý bilgilerini getirin

SELECT *
FROM sale.staff

SELECT B.first_name, A.first_name AS manager_name
FROM sale.staff A
INNER JOIN sale.staff B ON A.staff_id=B.manager_id


