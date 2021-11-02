---- 16.10.2021 Session-2 (Advanced Grouping Operations) ---------

---Join

-- Maðaza çalýþanlarýný yaptýklarý satýþlar ile birlikte listeleyin


SELECT S.staff_id, S.first_name, S.last_name, O.*
FROM sale.staff S
INNER JOIN sale.orders O ON S.staff_id=O.staff_id
ORDER BY O.order_id DESC

SELECT A.staff_id, A.first_name, A.last_name, B.*
FROM sale.staff A
LEFT JOIN sale.orders B ON A.staff_id=B.staff_id
ORDER BY B.order_id 

SELECT COUNT(A.staff_id), COUNT(B.staff_id)
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id=B.staff_id

SELECT COUNT(DISTINCT A.staff_id), COUNT(DISTINCT B.staff_id)
FROM sale.staff A
LEFT JOIN sale.orders B ON A.staff_id=B.staff_id