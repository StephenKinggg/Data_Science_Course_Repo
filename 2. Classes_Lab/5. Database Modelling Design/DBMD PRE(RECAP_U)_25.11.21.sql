
--SQL CASE INSESITIVE dir yani büyük küçük harften etkilenmez.

USE TestDB    --Yukarýda soldan DB seçmeden bu commit ile direkt olarak o DB ye gitmemize yarar.

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] NOT NULL,
	[EmployeeName] [varchar](255) NULL,
	[EmployeeSurName] [varchar](255) NULL,
	[EmployeeDepartment] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Students](
	[StudentID] [int] NOT NULL,
	[StudentName] [varchar](25) NULL,
	[Courses] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/*
--Constraint ler;

Bir alanýn NULL, NOT NULL olmasý durumu,

DEFAULT olmasý durumu,(Yani boþ veya girilmemiþse bunun bir default deðeri olabilir.)

PRIMARY KEY, FOREIGN KEY 

CHECK (Mesela bir deðerden daha yüksek bir deðer girilmemesini istiyor olabiliriz.)

UNIQUE(Tek bir deðer girilebilmesini istiyor olabiliriz.)
*/




CREATE TABLE Products(
ProductID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
ProductName VARCHAR(255) DEFAULT('Other Products'),
ProductPrice INT CHECK(ProductPrice >=0),
ProductDiscount INT CHECK(ProductDiscount <=0),
ProductSerialNumber INT,
UNIQUE(ProductSerialNumber)
)

CREATE TABLE SalesTable (
SalesID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
SalesHeader NVARCHAR(25),
CustomerBankType NVARCHAR(30)
)


/*SalesTable ve SalesDetailTable diye iki table oluþturduk. Bunlarý birbirine baðladýk. 
Ýkinci tabloya bir veri girdiðimizde ilk table da PRIMARY KEY kýsmýnda bu veri olmadýðý durumlarda hata verir.
*/


CREATE TABLE SalesDetailTable(
SalesDetailID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
SalesID INT FOREIGN KEY REFERENCES SalesTable(SalesID),
ProductName VARCHAR(25),
Quantity INT,
Price INT,
LineNumber INT
)

--ALTER TABLE Table_Name ADD, DROP COLUMN, ALTER COLUMN ile deðiþiklik yapabiliyoruz.

ALTER TABLE dbo.Employee ADD UNIQUE(EmployeeName)   --EmployeeName Unique yaptýk. Bu durumda ayný isimli bir baþka kiþi buraya girilemez.

ALTER TABLE dbo.Employee DROP COLUMN EmployeeDepartment  --Bu column table dan sildik.

ALTER TABLE dbo.Employee ALTER COLUMN EmployeeSurname VARCHAR(20)  --EmloyeeSurName veri tipini deðiþtirdik.


--DROP

DROP TABLE dbo.Employee

DROP DATABASE

--TRUNCATE TABLE: Hiç geri dönüþü olmadan table içindeki tüm verileri siler. ROLL BACK yapýp veriyi geri çaðýramam artýk.

TRUNCATE TABLE dbo.SalesDetailTable

--DELETE TABLE: TRUNCATE ten farký bu da veriyi siler ancak ROLL BACK ile geri çaðýrabilirim.


--SELECT

SELECT * FROM [dbo].[SalesTable]  --Buradaki * ayný zamanda wildcard iþlevi görüyor. 

SELECT DD.[EmployeeName] AS 'FName', DD.[EmployeeSurName]  AS 'LName'
FROM [dbo].[Employee]  AS DD  --Burada görüldüðü gibi hem column ler için hem de table için Alias kullandýk.

--SELECT yanýna Aggregate func. da alýyor.

USE [AdventureWorks2014]

SELECT *
FROM [Sales].[SalesOrderDetail] A
WHERE A.UnitPrice>2000 AND A.OrderQty>1

SELECT *
FROM [Sales].[SalesOrderDetail] A
WHERE A.ProductID IN (777,753)    --WHERE A.ProductID=777 OR A.ProductID=753
							      --LIKE '%R%' Kullanýmý ile R içerenleri verir.
								  --NOT LIKE 'R%' R ile baþlamayanlarý verir.

--INSERT 

SELECT *
FROM [Person].[CountryRegion]

INSERT INTO  [Person].[CountryRegion] --EÐER TÜM COLUMN LER ÝÇÝN DEÐER GÝRECEKSEK AYRI AYRI COLUMN ÝSMÝ YAZMAYA GEREK YOK. 
									 --AKSÝ TAKDÝRDE COLUMN ÝSÝMLERÝNÝ BELÝRTMEK GEREKÝR.
VALUES (XX, MACONA, 2008-04-30 00:00:00.000)


/*
 UPDATE Table_Name
 SET Column1='value1', Column2='value2' WHERE conditions
 */

 UPDATE [Person].[CountryRegion]
 SET Name='Andora' WHERE CountryRegionCode=1

CREATE TABLE [Orderr](
OrderID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
OrderNumber VARCHAR(25),
TotalAmount INT
)

CREATE TABLE Customer(
CustomerID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
FirstName VARCHAR(25),
LastName VARCHAR(25),
City VARCHAR(25),
Country VARCHAR(25)
)

SELECT OrderID, FirstName, LastName, City, Country
FROM Orderr O JOIN Customer C ON O.CustomerID=C.CustomerID

CREATE TABLE RENK(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
C1 VARCHAR(25),
C2 VARCHAR(25),
C3 VARCHAR(25)
)

SELECT * FROM RENK
WHERE 'Yellow' IN (C1, C2, C3)

--DISTINCT 

SELECT DISTINCT StoreID
FROM [Sales].[Customer]
ORDER BY StoreID ASC   --DESC

SELECT *, FirstName+ ' '+ MiddleName+ ' ' + LastName AS Name,
		CAST((AccountKey AS VARCHAR) + AccountDescription) AS 'KEY' --BURADA CAST ÝLE AccountKey veri tipini VARCHAR çevirdik.
FROM [Person].[Person]

