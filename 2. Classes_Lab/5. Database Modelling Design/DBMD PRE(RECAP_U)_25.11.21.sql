
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

/*
	(),
	=,
	<, >,
	<= ve >=,
	<>, !=

	AND: Her ikisininde doðru olmasý gerekir. Mesela maaþ<2000 AND department='IT'

	OR : Ýkisinden herhangi birinin doðru olmasý yeterli.  Mesela maaþ<2000 OR department='IT'

	NOT : NOT firstname ='John' adý john olmayanlarý getirir.
	*/

SELECT *
FROM [HumanResources].[Employee]
WHERE BirthDate>'1974-01-01' AND HireDate < '2008-01-01'

SELECT *
FROM [HumanResources].[Employee]
WHERE BirthDate>'1974-01-01' OR HireDate < '2008-01-01'

SELECT *
FROM [HumanResources].[Employee]
WHERE 
(BirthDate>'1974-01-01' AND HireDate < '2008-01-01')
AND OrganizationLevel=3

SELECT *
FROM [HumanResources].[Employee]
WHERE 
(BirthDate>'1974-01-01' AND HireDate < '2008-01-01')
OR OrganizationLevel=3

SELECT *
FROM [HumanResources].[Employee]
WHERE 
(BirthDate>'1974-01-01' AND HireDate < '2008-01-01')
AND OrganizationLevel!=3  --AND NOT kullanabiliriz ancak OrganizationLevel=3 yazýlmalý.

SELECT *
FROM [HumanResources].[Employee]
WHERE 
(BirthDate>'1974-01-01' AND HireDate < '2008-01-01')
AND JobTitle IN('Marketing Assistant')

SELECT *
FROM [HumanResources].[Employee]
WHERE 
(BirthDate>'1974-01-01' AND HireDate < '2008-01-01')
AND JobTitle NOT IN('Marketing Assistant')

SELECT *
FROM [HumanResources].[Employee]
WHERE 
(BirthDate>'1974-01-01' AND HireDate < '2008-01-01')
AND BusinessEntityID BETWEEN 3 AND 16 

SELECT *
FROM [HumanResources].[Employee]
WHERE JobTitle LIKE 'M%'     --'%M', '%M%'

SELECT *
FROM [HumanResources].[Employee]
WHERE JobTitle LIKE '%S_'   --SONU S VE YANINA BÝR KARAKTER ALARAK OLANLARI ÇAÐIRIR.

SELECT *
FROM [HumanResources].[Employee]
WHERE JobTitle LIKE '[A-C]%'   --ÝLK karakteri A-C arasýnda baþlayanlarý getirir.

SELECT *
FROM [HumanResources].[Employee]
WHERE BusinessEntityID LIKE '[1-2]%' --ÝLK karakteri 1 ve 2 ile baþlayanlarý getirir.

SELECT *
FROM [HumanResources].[Employee]
WHERE OrganizationLevel IS NULL  

SELECT *
FROM [HumanResources].[Employee]
WHERE OrganizationLevel IS NOT NULL 


SELECT SalesOrderID, ProductID, SUM(OrderQty) SumQuanty
FROM [Sales].[SalesOrderDetail]
WHERE SalesOrderID>5000 AND ProductID>750 --BURADAKÝ WHERE GROUP BY YAPILMADAN ÖNCEKÝ TABLE DA ÝÞLEM YAPAR VE GROUP BY BUNUN ÜZERÝNE YAPILIR.
GROUP BY SalesOrderID, ProductID
HAVING SalesOrderID>50000  --HAVING ÝSE GROUP BY DAN SONRAKÝ TABLE ÜZERÝNDE ÝÞLEM YAPAR.
ORDER BY SalesOrderID

-------DATABASE-----


USE UniversityCourseDB

--DROP TABLE Course
CREATE TABLE Course(
CourseID NVARCHAR(10) PRIMARY KEY,
CourseTitle NVARCHAR(50),
TutorID NVARCHAR(10),
ClassID NVARCHAR(10)
)

CREATE TABLE Student(
StudentID INT PRIMARY KEY,
StudentName NVARCHAR(50),
StudentAdress NVARCHAR(50),
StudentBirtDate DATE,
ClassID NVARCHAR(10),
EnrollDate DATE,
GraduateDate DATE
)

--DROP TABLE Class
CREATE TABLE Class(
ClassID NVARCHAR(10) PRIMARY KEY,
ClassName NVARCHAR(50)
)

--DROP TABLE Tutor
CREATE TABLE Tutor(
TutorID NVARCHAR(10) PRIMARY KEY,
TutorName NVARCHAR(50),
TutorTitle NVARCHAR(15),
ClassID NVARCHAR(10)
)
--DROP TABLE Enrollment
CREATE TABLE Enrollment(
EnrollID INT PRIMARY KEY,
StudentID INT,
CourseID NVARCHAR(10),
SessionID INT
)

--DROP TABLE Success
CREATE TABLE Success(
SuccessID INT PRIMARY KEY,
CourseID NVARCHAR(10),
StudentID INT,
MidtermExam INT,
FinalExam INT,
MakeupExam INT
)

INSERT INTO [dbo].[Course] VALUES('EM220', 'Data Science','DS001', '02')
INSERT INTO [dbo].[Course] VALUES('EM250', 'Statistics','DS002', '03')
INSERT INTO [dbo].[Course] VALUES('EK300', 'Tableau','DS003', '04')
INSERT INTO [dbo].[Course] VALUES('EK310', 'SQL','DS004', '05')
INSERT INTO [dbo].[Course] VALUES('EK350', 'DBMD','DS005', '06')

INSERT INTO [dbo].[Student] VALUES(1212, 'Carry Spielberg', 'Washington','1994-12-15', '02', '2010-01-01', NULL)
INSERT INTO [dbo].[Student] VALUES(1214, 'Carl Hanz', 'Utah','1992-12-15', '02', '2010-05-01', NULL)
INSERT INTO [dbo].[Student] VALUES(1216, 'Mary Hely', 'California','1996-12-15', '04', '2010-03-01', NULL)
INSERT INTO [dbo].[Student] VALUES(1218, 'Catherine Spiel', 'Washington','1995-12-15', '06', '2010-03-01', NULL)

INSERT INTO [dbo].[Class] VALUES('02', 'Machine Engineering')
INSERT INTO [dbo].[Class] VALUES('04', 'Electronic Engineering')
INSERT INTO [dbo].[Class] VALUES('06', 'Robotic Engineering')

INSERT INTO [dbo].[Tutor] VALUES('EM220', 'Prof','Alex Hunter', '02')
INSERT INTO [dbo].[Tutor] VALUES('EM250', 'Prof','George Michael', '03')
INSERT INTO [dbo].[Tutor] VALUES('EK300', 'Prof','Karl Hansek', '04')
INSERT INTO [dbo].[Tutor] VALUES('EK310', 'Prof','Mary Island', '05')


ALTER TABLE [dbo].[Tutor]
ADD CONSTRAINT FKClassTutor        --Burayý rastgele veriyoruz. Hangi tablolar arasýnda olacaksa ona yakýn bir isim verebiliriz.
FOREIGN KEY (ClassID) REFERENCES [dbo].[Class](ClassID)  --Ýki table daki classýd sayýlarý farklý olursa hata veriyor.


ALTER TABLE [dbo].[Course]
--DROP FOREIGN KEY FKClassCourse
ADD CONSTRAINT FKClassCourse      
FOREIGN KEY (ClassID) REFERENCES [dbo].[Class](ClassID)


ALTER TABLE [dbo].[Course]
ADD CONSTRAINT FKCourseTutor     
FOREIGN KEY (TutorID) REFERENCES [dbo].[Tutor](TutorID)

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT FKClassStudent   
FOREIGN KEY (ClassID) REFERENCES [dbo].[Class](ClassID)


select TutorID from Tutor    --HATA VERÝNCE NEREDEN KAYNAKLANDIÐINI BULMAK ÝÇÝN KULLANDIK.
WHERE TutorID IN
(SELECT TutorID from Course)

ALTER TABLE [dbo].[Enrollment]
ADD CONSTRAINT FKStudentClassEnroll   
FOREIGN KEY (StudentID) REFERENCES [dbo].[Student](StudentID) 

ALTER TABLE [dbo].[Enrollment]
ADD CONSTRAINT FKStudentClassEnroll   
FOREIGN KEY (StudentID) REFERENCES [dbo].[Student](StudentID) 

ALTER TABLE [dbo].[Success]
ADD CONSTRAINT FKStudentSuccess  
FOREIGN KEY (StudentID) REFERENCES [dbo].[Student](StudentID) 

ALTER TABLE [dbo].[Enrollment]
ADD CONSTRAINT FKCourseEnroll   
FOREIGN KEY (CourseID) REFERENCES [dbo].[Course](CourseID)

ALTER TABLE [dbo].[Success]
ADD CONSTRAINT FKCourseSuccess  
FOREIGN KEY (CourseID) REFERENCES [dbo].[Course](CourseID)

