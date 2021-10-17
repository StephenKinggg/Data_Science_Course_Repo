SELECT product_id, COUNT(*) CNT_ROW
FROM product.product 
GROUP BY product_id
HAVING COUNT(*) > 1

SELECT category_id, MAX(list_price) MAX_PRICE, MIN(list_price) MIN_PRICE
FROM product.product
GROUP BY category_id

SELECT category_id, list_price
FROM product.product
ORDER BY 1,2 

SELECT category_id, MAX(list_price) MAX_PRICE, MIN(list_price) MIN_PRICE
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500

SELECT category_id, MAX(list_price) MAX_PRICE, MIN(list_price) MIN_PRICE
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 AND MIN(list_price) < 500

SELECT A.brand_id, A.brand_name, AVG(B.list_price) AVG_PRICE
FROM product.brand A
INNER JOIN product.product B ON A.brand_id=B.brand_id
GROUP BY A.brand_id, A.brand_name
ORDER BY AVG(B.list_price) DESC

SELECT A.brand_name, AVG(B.list_price) AVG_PRICE
FROM product.brand A
INNER JOIN product.product B ON A.brand_id=B.brand_id
GROUP BY A.brand_name
HAVING AVG(B.list_price) > 1000
ORDER BY AVG(B.list_price) ASC

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year

SELECT brand, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY brand

SELECT Category, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY Category


SELECT brand, Category, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY brand, Category
ORDER BY brand

SELECT brand, category, SUM(total_sales_price) total_sales
FROM sale.sales_summary
GROUP BY 
	GROUPING SETS(
	         (brand, category),
			 (brand),
			 (category),
			 ()
			 )
ORDER BY brand, category


