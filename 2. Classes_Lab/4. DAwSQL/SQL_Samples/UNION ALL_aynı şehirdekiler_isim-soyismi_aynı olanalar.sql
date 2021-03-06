-- Sacramento şehrindeki müşteriler ile Monroe şehrindeki müşterilerin soyisimlerini listeleyin

--UNION ALL
SELECT	last_name FROM	sale.customer WHERE	city = 'Sacramento'
UNION ALL
SELECT	last_name FROM	sale.customer WHERE	city = 'Monroe'
ORDER BY last_name

---UNION

SELECT	last_name FROM	sale.customer WHERE	city = 'Sacramento'
UNION 
SELECT	last_name FROM	sale.customer WHERE	city = 'Monroe'
ORDER BY last_name

--adı carter veya soyadı carter olan müşterileri listeleyin (or kullanmayınız)

select first_name, last_name from sale.customer where first_name= 'Carter'
UNION ALL
select first_name, last_name from sale.customer where last_name= 'Carter'

----
select first_name, last_name, customer_id from sale.customer
where first_name= 'Carter'
UNION ALL
select first_name, last_name, customer_id from sale.customer
where last_name= 'Carter'

---
WITH T1 AS
(
SELECT 0 AS NUM
UNION ALL
SELECT NUM + 2 
FROM	T1
WHERE	NUM < 9
)
SELECT *
FROM T1
;
