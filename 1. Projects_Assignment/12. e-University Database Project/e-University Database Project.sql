--DBMD LECTURE
--UNIVERSITY DATABASE PROJECT 



--CREATE DATABASE

CREATE DATABASE UniversityDataBase;

--/////////////////////////////

USE UniversityDatabase

--CREATE TABLES 

CREATE TABLE Staff (
  StaffNo int NOT NULL IDENTITY(1,1),
  StaffFirstName varchar(255) NOT NULL,
  StaffLastName varchar(255) NOT NULL,
  StaffRegion varchar(255) NOT NULL,
  PRIMARY KEY (StaffNo)
);

--DROP TABLE Student
CREATE TABLE Student (
  StudentID int NOT NULL IDENTITY(1,1),
  StudentFirstName varchar(255) NOT NULL,
  StudentLastName varchar(255) NOT NULL,
  RegisteredDate date NOT NULL,
  StudentRegion varchar(255) NOT NULL,
  StaffNo int NOT NULL,
  CONSTRAINT fk1_staff_no FOREIGN KEY (StaffNo) REFERENCES Staff (StaffNo),
  PRIMARY KEY (StudentID)
);

--DROP TABLE Course
CREATE TABLE Course (
  CourseCode int NOT NULL IDENTITY(1,1),
  Title varchar(255) NOT NULL,
  Credit int NOT NULL CONSTRAINT check_credit CHECK (Credit=15 OR Credit=30),
  Quota int NOT NULL,
  StaffNo int,
  CONSTRAINT fk2_staff_no FOREIGN KEY (StaffNo) REFERENCES Staff (StaffNo),
  PRIMARY KEY (CourseCode)
);


--DROP TABLE Enrollment
CREATE TABLE Enrollment (
  StudentID int NOT NULL,
  CourseCode int NOT NULL,
 -- EnrolledDate datetime NOT NULL,
 -- CONSTRAINT fk1_student_id FOREIGN KEY (StudentID) REFERENCES Student (StudentID),
  CONSTRAINT fk1_course_code FOREIGN KEY (CourseCode) REFERENCES Course (CourseCode),
  PRIMARY KEY (StudentID, CourseCode)
);



INSERT INTO Staff
VALUES  ('October', 'Lime', 'Wales'),
        ('Ross', 'Island', 'Scotland'),
        ('Hary', 'Smith', 'England'),
        ('Neil', 'Mango', 'Scotland'),
        ('Kellie', 'Pear', 'England'),
        ('Margaret', 'Nolan', 'England'),
		('Yavette', 'Berry', 'Northern Ireland'),
		('Tom', 'Garden', 'Northern Ireland');


INSERT INTO Course
VALUES  ('Fine Arts', 15, 180, 4),
        ('German', 15,180,3),
        ('Chemistry', 30,180,7),
        ('French', 30, 180,5),
        ('French', 30, 180,7),
        ('Physics', 30, 180,3),
        ('Physics', 30, 180,5),
		('History', 30, 180, NULL),
		('Music', 30, 180, NULL),
		('Psychology', 30, 180, NULL),
		('Biology', 15, 180,8);


INSERT INTO Enrollment
VALUES (1, 1),
       (1, 2),
       (2, 1),
       (2, 2),
       (3, 1),
       (3, 2),
       (4, 1),
       (4, 2);


INSERT INTO Student
VALUES  ('Alec', 'Hunter', '12.05.2020','Wales',1),
        ('Bronwin', 'Blueberry', '12.05.2020','Scotland',2),
        ('Charlie', 'Apricot', '12.05.2020','England',3),
        ('Ursula', 'Douglas', '12.05.2020','Scotland', 4),
        ('Zorro', 'Apple', '12.05.2020','England',5),
        ('Debbie', 'Orange', '12.05.2020','England',6);







--Make sure you add the necessary constraints.
--You can define some check constraints while creating the table, but some you must define later with the help of a scalar-valued function you'll write.
--Check whether the constraints you defined work or not.
--Import Values (Use the Data provided in the Github repo). 
--You must create the tables as they should be and define the constraints as they should be. 
--You will be expected to get errors in some points. If everything is not as it should be, you will not get the expected results or errors.
--Read the errors you will get and try to understand the cause of the errors.



--////////////////////


--CONSTRAINTS

--1. Students are constrained in the number of courses they can be enrolled in at any one time. 
--	 They may not take courses simultaneously if their combined points total exceeds 180 points.

CREATE PROCEDURE [dbo].[uspCourseEnrollment] (
@StudentID int,
@CourseCode int
--@EnrolledDate datetime
)
AS
BEGIN
	DECLARE @EnrolledCredit INT, @TotalCredit INT, @CourseCredit INT
	SELECT @EnrolledCredit = SUM(Credit) FROM Course WHERE CourseCode IN (SELECT CourseCode FROM Enrollment WHERE StudentID = @StudentID)
	SELECT @CourseCredit = Credit FROM Course WHERE CourseCode = @CourseCode
	SELECT @TotalCredit = @EnrolledCredit + @CourseCredit
	IF @TotalCredit > 180
		BEGIN
		PRINT 'You have exceeded the total credit you can receive!'
		RETURN 1
		END
	IF EXISTS(SELECT 1 FROM Enrollment WHERE StudentID = @StudentID AND CourseCode = @CourseCode)
	BEGIN
		PRINT 'You have already registered for this course!'
		RETURN 1
	END

INSERT INTO Enrollment (StudentID, CourseCode)   --EnrolledDate
VALUES (@StudentID, @CourseCode)                --@EnrolledDate
RETURN 0
END;


--------///////////////////


--2. The student's region and the counselor's region must be the same.

SELECT *
FROM Course



CREATE PROCEDURE [dbo].[StudentCounsel] (
@StudentID int,
@StaffID int
)
AS
BEGIN


DECLARE @StaffRegion VARCHAR(255), @StudentRegion VARCHAR(255)
	SELECT @StaffRegion = StaffRegion FROM Staff WHERE StaffNo IN (SELECT StaffNo FROM Student WHERE StudentID = @StudentID)
	SELECT @StudentRegion = StudentRegion FROM Student WHERE StaffNo = @StaffID

IF @studentregion = @staffregion

	BEGIN 
		PRINT 'Your region and your counselor region is the same. A counselor assigned to you.'
		RETURN 1
	END 
IF EXISTS(SELECT 1 FROM Student WHERE StudentID = @StudentID AND StaffNo = @StaffID)
	BEGIN
		PRINT 'Your region and your counselor region must be the same. You select another counselor please.'
		RETURN 1
	END


INSERT INTO Student (StudentID, StaffNo)  
VALUES (@StudentID, @StaffID)              
RETURN 0
END;



------ADDITIONALLY TASKS



--1. Test the credit limit constraint.

DECLARE @StudentID int, @CourseCode int   --, @EnrolledDate datetime
SELECT @StudentID = 1,
@CourseCode = 3
--@EnrolledDat e = '20201030'

EXEC uspCourseEnrollment @StudentID, @CourseCode


SELECT *
FROM Enrollment

--//////////////////////////////////

--2. Test that you have correctly defined the constraint for the student counsel's region. 


SET IDENTITY_INSERT Student ON

DECLARE @StudentID int, @StaffID int   
SELECT @StudentID = 5,
@StaffID = 7
--@EnrolledDat e = '20201030'

EXEC StudentCounsel @StudentID, @StaffID



--/////////////////////////


--3. Try to set the credits of the History course to 20. (You should get an error.)

UPDATE Course SET Credit=20 WHERE Title ='History'


--/////////////////////////////

--4. Try to set the credits of the Fine Arts course to 30.(You should get an error.)

UPDATE Course SET Credit=30 WHERE Title ='Fine Arts'

SELECT *
FROM Course

--////////////////////////////////////

--5. Debbie Orange wants to enroll in Chemistry instead of German. (You should get an error.)


INSERT INTO Enrollment VALUES((SELECT StudentID FROM Student WHERE StudentFirstName='Debbie' AND StudentLastName= 'Orange'), (SELECT CourseCode FROM Course WHERE Title='German'))

UPDATE Enrollment SET CourseCode=3 WHERE StudentID IN (SELECT StudentID FROM Student WHERE StudentFirstName='Debbie' AND StudentLastName= 'Orange')


select * from Enrollment

--//////////////////////////


--6. Try to set Tom Garden as counsel of Alec Hunter (You should get an error.)

UPDATE Student SET StaffNo=9 WHERE StudentFirstName='Alec' AND StudentLastName= 'Hunter'


--/////////////////////////

--7. Swap counselors of Ursula Douglas and Bronwin Blueberry.


CREATE TABLE #tempstudent
(
	StudentID INT,
	StudentFirstName varchar(255),
	StudentLastName varchar(255),
	StaffNo INT
)
insert into #tempstudent
select StudentID, StudentFirstName, StudentLastName, StaffNo
from Student
where StudentFirstName='' AND StudentLastName='Blueberry'

select * from #tempstudent


UPDATE Student SET StaffNo= (SELECT StaffNo FROM Student WHERE StudentFirstName='Ursula') WHERE StudentID IN (SELECT StudentID FROM Student WHERE StudentFirstName='Bronwin')

UPDATE Student SET StaffNo= (SELECT StaffNo FROM #tempstudent WHERE StudentFirstName='Bronwin') WHERE StudentID IN (SELECT StudentID FROM student WHERE StudentFirstName='Ursula')


SELECT * FROM Student


--///////////////////


--8. Remove a staff member from the staff table.
--	 If you get an error, read the error and update the reference rules for the relevant foreign key.


DELETE FROM staff WHERE StaffNo = 3


 














