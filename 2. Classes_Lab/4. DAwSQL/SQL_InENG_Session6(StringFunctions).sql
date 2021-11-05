/* Session: 6:
Oct 28 2021
String Functions
*/
--LENGTH
SELECT LEN('Miray')

select MAX(LEN(product_name)) 
from product.product

SELECT LEN(12345)

SELECT LEN('OCTOBER')

SELECT LEN('OCTOBER')

--CHARINDEX
SELECT CHARINDEX('RA','CHARACTER')

SELECT CHARINDEX('C', 'CHARACTER', 2)
SELECT CHARINDEX('C', 'CHARACTER', 1)

SELECT CHARINDEX('C', 'CHARACTERC', 3)

SELECT CHARINDEX('@','sheetal.instructor@gmail.com')

--PATINDEX
SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('R%', 'CHARACTER')

SELECT PATINDEX('%R%', 'CHARACTER')

SELECT PATINDEX('R', 'CHARACTER')

SELECT CHARINDEX('R', 'CHARACTER')

SELECT PATINDEX('__H%', 'CHARACTER')

--LEFT

SELECT LEFT('OCTOBER',3)

SELECT LEFT('  OCTOBER',3)

--RIGHT
SELECT RIGHT('OCTOBER',4)

SELECT RIGHT('OCTOB ER',4)

--SUBSTRING
SELECT SUBSTRING('CHARACTER',3,2)

SELECT SUBSTRING ('CHARACTER',0,3)

SELECT SUBSTRING ('CHARACTER',-1, 3)
----------------------------
select email,
SUBSTRING(email,CHARINDEX('@',email)+1,LEN(email)-CHARINDEX('@',email))as emailDomain
from sale.customer 

--select top 1 email
--from sale.customer 

--'emily.brooks@yahoo.com'

--LOWER
SELECT LOWER('OCTOBER')

SELECT UPPER('october')

--'character'

SELECT UPPER(LEFT('character',1)) + RIGHT('character',LEN('character')-1)

--STRING_SPLIT

SELECT * 
FROM string_split('cat,bat,hat',',')

--LTRIM, RTRIM, TRIM
select 'Mcdonald'

select 'Mcdonald '

SELECT LTRIM('      CHARACTER')

SELECT RTRIM('CHARACTER     ')

SELECT LTRIM(RTRIM('    CHARACTER   '))

SELECT TRIM('    CHARACTER   ')

SELECT TRIM('    CHARA CTER   ')

SELECT TRIM('CTER' FROM '    CHARA CTER')


select email, TRIM('.com' FROM email) as nodotcom
from sale.customer

--REPLACE

SELECT REPLACE('CHARACTER STRING', ' ','/')

select REPLACE('CHARACTER STRING','CHARACTER STRING','OCTOBER')

--STR
SELECT STR(12345)

SELECT STR(2345266976907)

SELECT STR(5454,5)

SELECT '$' + STR(5454,10,2)

SELECT STR(133215.456456, 6)

SELECT STR(133215.456456, 10,3)

--CAST, CONVERT

SELECT CAST(12345 AS CHAR)

SELECT SUBSTRING(CAST(12345 AS CHAR),1,3)

SELECT CAST(123.45 AS INT)

SELECT CONVERT (int, 30.67)

SELECT CONVERT(VARCHAR(10),'2021-10-28')

SELECT CONVERT (DATETIME, '2021-10-28')

SELECT CONVERT (CHAR(15), GETDATE(),103)

SELECT GETDATE()

--COALESCE
SELECT COALESCE(NULL, NULL,'Hi','Hello', NULL) result;

SELECT COALESCE (NULL,NULL,NULL,1);

--NULLIF
SELECT NULLIF(1,1)

SELECT NULLIF(1,0)

--ROUND

SELECT ROUND(432.345, 2)
SELECT ROUND(432.345, 2, 0)

SELECT ROUND(432.345, 2, 1)

SELECT ROUND(432.345, 3, 0)

SELECT ROUND(432.34545, 2, 1)
-----------------------------
-- How many yahoo mails in customer’s email column?

SELECT SUM(CASE WHEN PATINDEX('%yahoo%',email)> 0 THEN 1 ELSE 0 END) num_of_domain
FROM sale.customer

SELECT COUNT(*)
FROM sale.customer
WHERE email like '%yahoo.com'

SELECT SUM(CASE 
			WHEN PATINDEX('%yahoo%',email)> 0 
			THEN 1 ELSE 0 END) num_of_domain
FROM sale.customer


select email, PATINDEX('%yahoo%',email)
FROM sale.customer

--Write a query that returns the characters before the '.' character 
--in the email column.

SELECT email,  LEFT(email,CHARINDEX('.',email)-1)
FROM sale.customer

---Add a new column to the customers table that contains the customers' contact information. 
--If the phone is available, the phone information will be printed, if not, the email information will be printed.

SELECT *,COALESCE(phone,email) contact
FROM sale.customer

----Write a query that returns streets. 
--The third character of the streets is numerical.

SELECT street, SUBSTRING(street,3,1)
FROM sale.customer
WHERE SUBSTRING(street,3,1) LIKE '[0-9]'

SELECT street, SUBSTRING(street,3,1)
FROM sale.customer
WHERE SUBSTRING(street,3,1) NOT LIKE '[^0-9]'

SELECT street, SUBSTRING(street,3,1)
FROM sale.customer
WHERE ISNUMERIC(SUBSTRING(street,3,1)) = 1

--Split the values in the mail column into two parts with '@'

SELECT email, SUBSTRING(email,1,CHARINDEX('@',email)-1) as leftPart,
RIGHT(email,LEN(email)-CHARINDEX('@',email)) as rightPart
FROM sale.customer

SELECT email, SUBSTRING(email,1,CHARINDEX('@',email)-1) as leftPart,
SUBSTRING(email,CHARINDEX('@',email)+1,LEN(email)) as rightPart
FROM sale.customer


--In the street column, clear the string characters that were 
--accidentally added to the end of the initial numeric expression.

select street 
from sale.customer


