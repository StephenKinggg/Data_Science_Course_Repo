/* Session: 5: Oct 25th

------ CASE EXPRESSION ------

------ Simple Case Expression -----

-- Generate a new column containing what the mean of the values in the Order_Status column.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
*/

SELECT order_id, order_status,
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
		ELSE 'Unknown'
		END order_status_desc
FROM sale.orders
;

-- Add a column to the sales.staffs table containing the store names of the employees.

SELECT *,
	CASE store_id
		WHEN 1 THEN 'Sacramento Bikes'
		WHEN 2 THEN 'Buffalo Bikes'
		WHEN 3 THEN 'San Angelo Bikes'
	 END Store_name
FROM sale.staff
;

------ Searched Case Expression -----


-- Generate a new column containing what the mean of the values in the Order_Status column. (use searched case ex.)
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_id, order_status,
	CASE 
		WHEN order_status = 1 THEN 'Pending'
		WHEN order_status = 2 THEN 'Processing'
		WHEN order_status = 3 THEN 'Rejected'
		WHEN order_status = 4 THEN 'Completed'
		ELSE 'Unknown'
		END order_status_desc
FROM sale.orders
;


-- Create a new column containing the labels of the customers' email service providers 
--( "Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT first_name, last_name,email,
	CASE
		WHEN email LIKE '%gmail.com' THEN 'Gmail'
		WHEN email LIKE '%yahoo.com' THEN 'Yahoo'
		WHEN email LIKE '%hotmail.com' THEN 'hotmail'
		ELSE 'Other' 
		END email_service_provider
FROM sale.customer
;

select * from 
sale.customer
WHERE last_name LIKE '%ro%k%'

-- If you have extra time you can ask following question.

-- List customers who bought both 
--'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.
SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND B.order_id IN (


SELECT order_id
FROM sale.order_item A JOIN
	product.product B ON A.product_id = B.product_id
WHERE B.category_id IN (
					SELECT category_id
					FROM product.category
					WHERE category_name = 'Electric Bikes')
INTERSECT

SELECT order_id
FROM sale.order_item A JOIN
	product.product B ON A.product_id = B.product_id
WHERE B.category_id IN (
					SELECT category_id
					FROM product.category
					WHERE category_name = 'Comfort Bicycles')
INTERSECT

SELECT order_id
FROM sale.order_item A JOIN
	product.product B ON A.product_id = B.product_id
WHERE B.category_id IN (
					SELECT category_id
					FROM product.category
					WHERE category_name = 'Children Bicycles')
					);
