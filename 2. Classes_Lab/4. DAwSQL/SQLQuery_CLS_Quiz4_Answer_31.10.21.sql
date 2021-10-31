/*
Practice Question:
In the customers table, there is a column holding the email address for each customer. An email address has three parts: local-part, @ symbol, and domain (local-part@domain). 
Write a query to pull just domain part (ex. 'yahoo.ca', 'uol.com.br')  and provide how many of each domain type exist in the customers table. 
Your result set should include two columns: domain type and the number of domains and is ordered by number of domains from highest to lowest. 
Create alias as "domain_type", "num_domains".*/


SELECT *
FROM sale.customer

SELECT email, CHARINDEX('@', email)-1 as ýndex
FROM sale.customer

SELECT email, CHARINDEX('@', email)+1 as ýndex
FROM sale.customer

SELECT LEN(email)
FROM sale.customer


WITH T1 AS 
(
SELECT email,
		SUBSTRING(email,1,CHARINDEX('@',email)-1) as leftPart,  --@ iþaretinin solundaki kýsmý bunun yerini bulduktan sonra -1 ile alýyoruz.
		SUBSTRING(email,CHARINDEX('@',email)+1,LEN(email)) as rightPart   --@ iþaretinin saðýndaki kýsmý bunun yerini bulduktan sonra +1 ile alýyoruz. email uzunluðu kadar gidiyoruz.
FROM sale.customer
)

SELECT rightPart, count(email) num_domains
FROM T1
GROUP BY rightPart
ORDER BY num_domains DESC

--2.yöntem:

SELECT SUBSTRING(email, CHARINDEX('@',email)+1, LEN(email)) AS domain_type, COUNT(email) num_domains
FROM sale.customer
GROUP BY domain_type
ORDER BY num_domains DESC;

--3.yöntem:
-- Bu kodlar SQL lite çalýþýyor.

SELECT SUBSTR(Email, INSTR(Email, '@')+1) AS domain_type, COUNT(*) num_domains
FROM customers
GROUP BY 1
ORDER BY 2 DESC;


/*Practice Question:
In the customers table, there is a column holding the phone number for each customer. 
Although the meaning of parts of phone numbers varies from country to country usually, 
the number group with the + symbol at the beginning of the phone number shows the phone number's country phone code.
Write a query to pull just country code (ex. '+55', '+420','+1')  with customer's country. Y
our result set should include two columns: 'Country' and 'Country_phone_code'. 
If there is no phone number record about a country, show the country phone code as 'Unknown'.*/

SELECT *
FROM sale.customer

WITH T1 AS 
(
SELECT state,
    SUBSTRING(phone,1,CHARINDEX((TRIM('()' FROM phone)),' ',phone)-1) as Country_phone_code   --boþluk iþaretinin yerini bulduktan sonra -1 ile alýyoruz. email uzunluðu kadar gidiyoruz.
FROM sale.customer
)
SELECT T1.state, T1.Country_phone_code, count(state) count_code,
	   CASE WHEN T1.Country_phone_code= 'NULL' THEN 'Unknown'
	   END 
FROM T1
GROUP BY T1.state
ORDER BY T1.count_code DESC;

SELECT TRIM(')' from phone)
FROM sale.customer



--2.yöntem:

SELECT DISTINCT Country, COALESCE (SUBSTR(phone, 0, INSTR(phone, ' ')+1), 'Unknown') AS Country_phone_code
FROM customers