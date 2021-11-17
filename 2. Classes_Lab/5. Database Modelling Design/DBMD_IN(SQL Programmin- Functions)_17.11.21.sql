--17.11.21 SQL Programming

CREATE PROCEDURE sp_sample1
AS
BEGIN

	SELECT 'HELLO WORLD' col1   --sütun ismi verdik, içine satýr olarak veriyi yazdýk. Begin-End arasýna yazdýk.

END

sp_sample1

EXEC sp_sample1

EXECUTE sp_sample1


ALTER PROCEDURE sp_sample1  --deðiþiklik yaptýk.
AS
BEGIN

	SELECT 'HELLO GUYS!' col1   --sütun ismi verdik, içine satýr olarak veriyi yazdýk. Begin-End arasýna yazdýk.

END

sp_sample1


CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);


INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )

SELECT * FROM ORDER_TBL



CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);


SET NOCOUNT ON    --Mesaj kýsmýnda kaç satýrýn etkilendiðini yazdýrmamak için bu kullanýlýr.
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

SELECT * FROM ORDER_DELIVERY


CREATE PROC sp_cnt_order (@DATE DATE)  --Prosedür parametresi girdik @ iþareti ile bunu parametre olduðunu anlýyor.
AS
BEGIN
	
	SELECT COUNT(ORDER_ID) TOTAL_ORDER FROM ORDER_TBL WHERE ORDER_DATE = @DATE    --istediðim bir tarihteki sipariþ miktarýný bulmak için girdiðim prosedür parametresini order_date eþitliyorum.
END


sp_cnt_order '2021-11-17'  --prosedürü çaðýrýnca içine argümaný girdim ve bu tarihteki sipariþ sayýsý getirdi.

--***parametre prosedür yanýnda üretilirse çaðýrýrken içine deðer alabilir. içeride üretilirse içine deðer almaz.

DECLARE @P1 INT, @P2 INT, @SUM INT

SET @P1 = 3

SELECT @P2 = 7 --SELECT ile hem deðer atayabilir hemde toplamýný çaðýrabiliriz.

SET @SUM = @P1+@P2

SELECT @SUM   --KODU BÜTÜN OLARAK ÇAÐIRABÝLÝRÝZ.

SELECT @P1 = 3, @P2 = 7 , @SUM = @P1 +@P2

DECLARE @P1 INT = 3 , @P2 INT = 7, @SUM  INT = @P1 +@P2

--
DECLARE @P3 INT =5 , @P4 INT = 7

PRINT @P3 +@P4

----

DECLARE @CUSTOMER VARCHAR(100)

SET @CUSTOMER ='Adam'

SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_NAME=@CUSTOMER

-- IF-ELSE
-- KODU BÜTÜN OLARAK ÇALIÞTIRALIM!!!
DECLARE @CUST INT

SET @CUST=5

IF @CUST=3   --IF ÝLE MUTLAKA BEGIN END KULLANILIR ANCAK BU ARAYA GELECEK OLAN TEK SATIRDA YAZILMIÞ ÝSE BEGIN END KULLANMAYA GEREK YOK. ANCAK HERÞEYE RAÐMEN KULLANMAKTA FAYDA VAR.
	BEGIN 

		SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID=@CUST
	END
ELSE IF @CUST =4   --ELSE IF ÝLEDE BEGIN END KULLANMAMIZ GEREKÝR.
	BEGIN
		SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID=@CUST
	END
ELSE
	PRINT('The number not equal to 3 or 4')


SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_ID=3


--WHILE

DECLARE @NUM INT=1

WHILE @NUM < 50  --BEGIN VE END ARASINA YAZILIR.
	BEGIN
		SELECT @NUM
		SET @NUM +=1
	END


--FUNCTIONS

CREATE FUNCTION fn_uppertext1
(@inputtext VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	RETURN UPPER(@inputtext)

END

SELECT dbo.fn_uppertext1('WELCOME')   --FUNC schema adý ile çaðýrmamýz gerekiyor.


SELECT dbo.fn_uppertext1(CUSTOMER_NAME) FROM ORDER_TBL --HEPSÝNÝ BÜYÜK HARF YAPTI.


CREATE FUNCTION fn_date_info
(@DATE DATE)
RETURNS TABLE  --BURADA TABLO DEÐÝÞKENÝ OLUÞTURMUYORSAK BEGIN END YAZMIYORUZ.
AS
	RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = @DATE

SELECT * FROM fn_date_info('2021-11-17')  --TABLO DÖNDÜRDÜÐÜ ÝÇÝN BU ÞEKÝLDE ÇAÐIRDIK. 

--AYNI VIEW GÝBÝ SANAL TABLO OLARAK DÜÞÜNEBÝLÝRÝZ. FUNC OBJECT OLARAK KAYDEDÝLÝYOR. SONRA TEKRAR TEKRAR KULLANABÝLÝYORUZ.

