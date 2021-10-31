/* Practice Question:
In the customers table, there is a column holding the email address for each customer. 
An email address has three parts: local-part, @ symbol, and domain (local-part@domain). 
Write a query to pull just domain part (ex. 'yahoo.ca', 'uol.com.br')  and provide how many of each domain type exist in the customers table. 
Your result set should include two columns: domain type and the number of domains and is ordered by number of domains from highest to lowest. 
Create alias as "domain_type", "num_domains".*/

WITH T1 AS 
(
SELECT Email,
    SUBSTR(Email,CHARINDEX('@',Email)+1,LEN(Email)) as domain_type   --@ işaretinin sağındaki kısmı bunun yerini bulduktan sonra +1 ile alıyoruz. email uzunluğu kadar gidiyoruz.
FROM customers
)
SELECT T1.domain_type, count(Email) num_domains
FROM T1
GROUP BY T1.domain_type
ORDER BY T1.num_domains DESC;

/*2.Yöntem:*/

SELECT SUBSTR(Email, INSTR(Email, '@')+1) AS domain_type, COUNT(*) num_domains
FROM customers
GROUP BY 1
ORDER BY 2 DESC;


/*Practice Question:
In the customers table, there is a column holding the phone number for each customer. 
Although the meaning of parts of phone numbers varies from country to country usually, 
the number group with the + symbol at the beginning of the phone number shows the phone number's country phone code.
Write a query to pull just country code (ex. '+55', '+420','+1')  with customer's country. 
Your result set should include two columns: 'Country' and 'Country_phone_code'. If there is no phone number record about a country, 
show the country phone code as 'Unknown'.*/

SELECT *
FROM customers

WITH T1 AS 
(
SELECT Country,
    SUBSTR(Phone,1,CHARINDEX(' ',Phone)-1) as Country_phone_code   --boşluk işaretinin yerini bulduktan sonra -1 ile alıyoruz. email uzunluğu kadar gidiyoruz.
FROM customers
)
SELECT T1.Country, T1.Country_phone_code, count(Country) count_code
	   WHEN CASE T1.Country_phone_code='NULL' THEN 'Unknown'
	   END 
FROM T1
GROUP BY T1.Country
ORDER BY T1.count_code DESC;

/*2.Yöntem:*/

SELECT DISTINCT Country, COALESCE (SUBSTR(phone, 0, INSTR(phone, ' ')+1), 'Unknown') AS Country_phone_code
FROM customers

SELECT INSTR(phone, ' ')  --boşluğa kadar olan yeri bulduk.
FROM customers
