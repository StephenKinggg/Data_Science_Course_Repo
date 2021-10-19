SELECT A.brand_name, SUM(C.quantity) as total_of_sales
FROM product.brand A, product.product B, sale.order_item C
WHERE B.product_id = C.product_id and 
      A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY total_of_sales DESC

SELECT A.brand_name, SUM(C.quantity) as total_of_sales 
FROM sale.order_item C
INNER JOIN product.product B ON C.product_id = B.product_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY total_of_sales DESC


SELECT TOP 5 A.product_id, A.product_name, A.list_price
FROM product.product A
ORDER BY A.list_price DESC


SELECT A.brand_name, COUNT(DISTINCT B.category_id) as count_of_category
FROM product.category C
INNER JOIN product.product B ON C.category_id = B.category_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY count_of_category DESC

SELECT A.brand_name, C.category_name
FROM product.category C, product.product B, product.brand A
WHERE C.category_id = B.category_id AND A.brand_id = B.brand_id
GROUP BY A.brand_name, C.category_name
ORDER BY A.brand_name DESC

SELECT A.brand_name, C.category_name, AVG(B.list_price) as avg_list_price
FROM product.category C
INNER JOIN product.product B ON C.category_id = B.category_id
INNER JOIN product.brand A ON A.brand_id = B.brand_id
GROUP BY A.brand_name, C.category_name
ORDER BY avg_list_price DESC