--/*

-- Question_1:

Answer the following questions according to bikestore database
- What is the sales quantity of product according to the brands and sort them highest-lowest

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price;


- Select the top 5 most expensive products

select top 5 [product_name], [list_price]
from [production].[products]
order by [list_price] desc;

--What are the categories that each brand has

select b.[brand_name], c.[category_name]
from [production].[brands] b
inner join [production].[products] p
on b.brand_id = p.brand_id
inner join [production].[categories] c
on p.category_id = c.category_id
group by b.brand_name, c.category_name


- Select the avg prices according to brands and categories

select b.[brand_name], c.[category_name], avg(p.[list_price]) as [Avg Price]
from [production].[brands] b
inner join [production].[products] p
on b.brand_id = p.brand_id
inner join [production].[categories] c
on p.category_id = c.category_id
group by b.brand_name, c.category_name



- Select the annual amount of product produced according to brands

select p.[model_year],b.[brand_name], count(p.[product_name])
from [production].[brands] b
inner join [production].[products] p
on b.brand_id = p.brand_id
group by p.[model_year],b.[brand_name]
order by p.[model_year]

select distinct b.brand_name, p.model_year,
	count(p.[product_id]) over (PARTITION BY  b.brand_name, p.model_year) as annual_amount_brands
from [production].[brands] b
inner join [production].[products] p
on b.brand_id=p.brand_id
order by b.brand_name, p.model_year



- Select the least 3 products in stock according to stores.

select  d.store_id, c.product_id, c.product_name, sum(c.toplam) top_stok
from
[production].[stocks] d
cross apply
		(
		select top(3) b.product_id, b.product_name, sum(a.quantity) toplam
		from
		[production].[stocks] a, [production].[products] b
		where
		a.product_id=b.product_id
		and
		a.store_id= d.store_id
		group by
		b.product_id, b.product_name
		order by
		toplam
		) c
group by
d.store_id, c.product_id, c.product_name
order by
store_id, top_stok

SELECT	*
FROM	(
		select ss.store_name, p.product_name, SUM(s.quantity) product_quantity,
		row_number() over(partition by ss.store_name order by SUM(s.quantity) ASC) least_3
		from [sales].[stores] ss
		inner join [production].[stocks] s
		on ss.store_id=s.store_id
		inner join [production].[products] p
		on s.product_id=p.product_id
		GROUP BY ss.store_name, p.product_name
		HAVING SUM(s.quantity) > 0
		) A
WHERE	A.least_3 < 4





with temp_cte
as(
select ss.[store_name], pp.[product_name],
row_number() over(partition by ss.[store_name] order by ss.[store_name]) as [row number]
from [production].[products] pp
inner join [production].[stocks] ps
on pp.product_id = ps.product_id
inner join [sales].[stores] ss
on ps.store_id = ss.store_id
)
select * from temp_cte
where [row number] < 4





- Select the store which has the most sales quantity in 2016

select top 1 s.[store_name], sum(i.[quantity])
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name] 
order by sum(i.[quantity]) desc;


- Select the store which has the most sales amount in 2016

select * from [sales].[order_items]

select top 1 s.[store_name], sum(i.[list_price]) as sales_amount_2016
from [sales].[stores] s
inner join [sales].[orders] o
on s.store_id = o.store_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016' -- year(o.[order_date])
group by s.[store_name] 
order by sum(i.[list_price]) desc;


- Select the personnel which has the most sales amount in 2016

select top 1 s.[first_name], s.[last_name], sum(i.[list_price]) as sales_amount_2016
from [sales].[staffs] s
inner join [sales].[orders] o
on s.staff_id = o.staff_id
inner join [sales].[order_items] i
on o.order_id = i.order_id
where  datename(year, o.[order_date]) = '2016'
group by s.[first_name], s.[last_name] 
order by sum(i.[list_price]) desc;


- Select the least 3 sold products in 2016 and 2017 according to city.

;with temp2_cte
as(
select p.[product_name], datename(year, o.[order_date]) as order_date,
row_number() over(partition by datename(year, o.[order_date]) order by datename(year, o.[order_date])) as [row number]
from [production].[products] p
inner join [sales].[order_items] i
on p.product_id = i.product_id
inner join [sales].[orders] o
on o.order_id = i.order_id
where  datename(year, o.[order_date]) in ('2016', '2017')
)
select * from temp2_cte
where [row number] < 4




--Select the least 3 sold products in 2016 and 2017 according to city. 

select e.city, d.product_id, d.product_name, sum(d.top_sat) toplam_satis
from
[sales].[stores] e
cross apply
		(
		select top (3) c.product_id, c.product_name, sum(b.quantity) top_sat
		from
		[sales].[orders] a, [sales].[order_items] b, [production].[products] c
		where
		a.order_id=b.order_id
		and
		b.product_id= c.product_id
		and
		a.store_id=e.store_id
		and
		(a.order_date LIKE '__16______' or a.order_date LIKE '__17______')
		group by
		c.product_id, c.product_name
		order by
		top_sat
		) d
group by
e.city, d.product_id, d.product_name
order by
e.city, toplam_satis

-- Question_2:

1. Find the customers who placed at least two orders per year. 

SELECT
    customer_id,
    YEAR (order_date),
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;


2. Find the total amount of each order which are placed in 2018. Then categorize them according to limits stated below.(You can use case when statements here)
If the total amount of order   
  less then 500 then “very low”
  between 500 - 1000 then “low”
  between 1000 - 5000 then “medium”
  between 5000 - 10000 then “high”
  more then 10000 then “very high” 

SELECT    
    o.order_id, 
    SUM(quantity * list_price) order_value,
    CASE
        WHEN SUM(quantity * list_price) <= 500 
            THEN 'Very Low'
        WHEN SUM(quantity * list_price) > 500 AND 
            SUM(quantity * list_price) <= 1000 
            THEN 'Low'
        WHEN SUM(quantity * list_price) > 1000 AND 
            SUM(quantity * list_price) <= 5000 
            THEN 'Medium'
        WHEN SUM(quantity * list_price) > 5000 AND 
            SUM(quantity * list_price) <= 10000 
            THEN 'High'
        WHEN SUM(quantity * list_price) > 10000 
            THEN 'Very High'
    END order_priority
FROM    
    sales.orders o
INNER JOIN sales.order_items i ON i.order_id = o.order_id
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    o.order_id;


3. By using Exists Statement find all customers who have placed more than two orders.

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) > 2
    )
ORDER BY
    first_name,
    last_name;


4. Show all the products and their list price, that were sold with more than two units in a sales order.

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
            sales.order_items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name;


5. Show the total count of orders per product for all times. (Every product will be shown in one line and the total order count will be shown besides it)

SELECT
    product_name,
    count(distinct order_id) aa
	FROM
    production.products p
left JOIN sales.order_items o ON o.product_id = p.product_id
group by
product_name
ORDER BY
    aa;

6. Find the products whose list prices are more than the average list price of products of all brands

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price;

--Question-3:

7. In how many ways, a group of 3 boys and 2 girls can be formed out of a total of 5 boys and 5 girls?
8.A woman has 6 blouses, 4 skirts, and 5 pairs of shoes. How many different outfits consisting of a blouse, a skirt, and a pair of shoes can she wear?
9. Serena Williams won the 2010 Wimbledon Ladies’ Singles Championship. For the seven matches she played in the tournament, her total number of first serves was 379, 
total number of good first serves was 256, and total number of double faults was 15.
a. Find the probability that her first serve is good.
b. Find the conditional probability of double faulting, given that her first serve resulted in a fault.
c. On what percentage of her service points does she double fault?
10. Suppose that in the world exist a very rare disease. The chance for anyone to have this disease is 0.1%. You want to know whether you are infected so you go 
take a test, and the test results come positive. The accuracy of the test is 99%, meaning that 99% of the people who have the disease will test positive,
and 99% of the people who do not have the disease will test negative. What is the chance that you are actually infected? .......Bayes Theory.....