SELECT product_name, B.category_id
FROM product.product AS A
INNER JOIN product.category AS B ON A.category_id = B.category_id

SELECT A.first_name, A.last_name, B.store_name
FROM sale.staff AS A
INNER JOIN sale.store AS B ON A.store_id = B.store_id

SELECT P.product_id, P.product_name, O.order_id
FROM product.product AS P
LEFT JOIN sale.order_item AS O ON P.product_id = O.product_id

SELECT P.product_id, P.product_name, O.order_id
FROM product.product AS P
LEFT JOIN sale.order_item AS O ON P.product_id = O.product_id
WHERE O.order_id = NULL

SELECT P.product_id, P.product_name, S.store_id, S.quantity
FROM product.product AS P
LEFT JOIN product.stock AS S ON P.product_id = S.product_id
WHERE P.product_id > 310
ORDER BY store_id ASC

SELECT P.product_id, P.product_name, S.store_id, S.quantity
FROM product.stock AS S
RIGHT JOIN product.product AS P ON P.product_id = S.product_id
WHERE P.product_id > 310
ORDER BY store_id ASC

SELECT *
FROM SALE.staff

SELECT COUNT (staff_id)
FROM SALE.staff

SELECT COUNT(DISTINCT A.staff_id)
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id = B.staff_id


SELECT S.staff_id, S.first_name, S.last_name
FROM sale.orders AS O
INNER JOIN sale.staff AS S ON S.staff_id = O.staff_id
ORDER BY order_id ASC

SELECT 20 B.product_id, B.store_id, B.quantity,A.product_id, A.order_id, A.list_price
FROM SALE.order_item A
FULL OUTER JOIN product.stock B ON A.product_id=B.product_id
ORDER BY B.product_id, A.order_id

