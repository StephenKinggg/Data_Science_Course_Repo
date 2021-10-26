
SELECT C.brand_name as Brand, D.category_name as Category,B.model_year as Model_Year, 
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO sale.sales_summary  -- Creates New table
FROM sale.order_item A  -- total sales
JOIN product.product B  ON A.product_id = B.product_id-- model year
JOIN product.brand C ON  C.brand_id = B.brand_id -- brand name
JOIN product.category D ON D.category_id = B.category_id -- category names
GROUP BY C.brand_name, D.category_name,B.model_year ;


select * from sale.sales_summary

--1. Calculate the total sales price.

SELECT SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary

--Calculate the total sales price by categories
SELECT category, SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary
GROUP BY category

SELECT Brand, SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary
GROUP BY Brand

-- group by category and brand
SELECT brand, category, SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary
GROUP BY
	brand, category
ORDER BY 1, 2

--GROUPING SETS
--Perform the above variations in a single query using 'Grouping Sets'.
SELECT	brand, category, SUM(total_sales_price) as Total_Sales
FROM	sale.sales_summary
GROUP BY
	GROUPING SETS (
					(brand,category),
					(brand),
					(Category),
					()
					)
ORDER BY Brand, Category;

--ROLLUP
SELECT	brand, category,model_year, SUM(total_sales_price) as Total_Sales
FROM	sale.sales_summary
GROUP BY
	GROUPING SETS (
					(brand,category,model_year),
					(brand,category),
					(brand),
					()
					)
ORDER BY Brand, Category;

--Same result can be achieved by ROLLUP

SELECT	brand, category,model_year, SUM(total_sales_price) as Total_Sales
FROM	sale.sales_summary
GROUP BY
	ROLLUP (brand,category,model_year				
					)
ORDER BY Brand, Category;

--CUBE
--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
SELECT	brand, category, model_year, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		CUBE (brand,category, model_year)
ORDER BY
	brand, category;

----------------------------------------------------------------
--PIVOT---
----------------------------------------------------------------
--1. Create a Derived Table
--2. Create the PIVOT
--3. Create SELECT

SELECT  *
FROM
(SELECT category, total_sales_price ,model_year
FROM sale.sales_summary) A

PIVOT (
	 SUM(total_sales_price)  -- aggregation
	 FOR category            -- spreading
		IN (	
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE
	------------------------------------------

	SELECT  *
FROM
(SELECT category, total_sales_price ,model_year
FROM sale.sales_summary) A

PIVOT (
	 SUM(total_sales_price)  -- aggregation
	 FOR category            -- spreading
		IN (	
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE


