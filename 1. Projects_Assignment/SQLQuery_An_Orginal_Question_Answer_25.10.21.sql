--Question:
-- Ayný sipariþte hem Electric Bikes, hem Comfort Bicycles hem de Children Bicycles ürünlerini sipariþ veren müþterileri bulunuz.


SELECT C.first_name, C.last_name
FROM sale.orders S, sale.customer C,
(SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Electric Bikes') E
WHERE O.product_id=E.product_id

INTERSECT

SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Comfort Bicycles') C
WHERE O.product_id=C.product_id

INTERSECT

SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Children Bicycles') C1
WHERE O.product_id=C1.product_id) ORD

WHERE ORD.order_id=S.order_id
AND S.customer_id=C.customer_id


--2.yöntem

WITH T1 AS
(
(SELECT order_id
  FROM sale.order_item O,
 (SELECT A.category_id, A.category_name, B.product_id
  FROM product.category A , product.product B
  WHERE A.category_id=B.category_id
  AND A.category_name='Children Bicycles') C1
  WHERE O.product_id=C1.product_id)

INTERSECT

(SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Comfort Bicycles') C1
WHERE O.product_id=C1.product_id)

INTERSECT

(SELECT order_id
FROM sale.order_item O,
(SELECT A.category_id, A.category_name, B.product_id
FROM product.category A , product.product B
WHERE A.category_id=B.category_id
AND A.category_name='Electric Bikes') C1
WHERE O.product_id=C1.product_id)
)

SELECT C.first_name, C.last_name
FROM sale.orders S, sale.customer C, T1 
WHERE T1.order_id=S.order_id
AND S.customer_id=C.customer_id