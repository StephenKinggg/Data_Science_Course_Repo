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


CREATE TABLE Student (
  StudentID int NOT NULL IDENTITY(1,1),
  StudentFirstName varchar(255) NOT NULL,
  StudentLastName varchar(255) NOT NULL,
  RegisteredDate datetime NOT NULL,
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
	SELECT @EnrolledCredit = SUM(Credit) FROM Course WHERE CourseCode IN (
	SELECT CourseCode FROM Enrollment WHERE StudentID = @StudentID
	)
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

--GO




--------///////////////////


--2. The student's region and the counselor's region must be the same.

SELECT *
FROM Course


ALTER FUNCTION check_volume6()
RETURNS INT
AS
BEGIN
DECLARE @ret int
IF EXISTS(SELECT Count(s.StudentID)
FROM Staff r JOIN Student s ON s.StaffNo=r.StaffNo
JOIN Course c ON C.StaffNo=s.StaffNo
WHERE c.StaffNo = NULL AND s.StudentRegion=r.StaffRegion
GROUP BY s.StudentID
HAVING Count(s.StudentID) != 1)
SELECT @ret =1 ELSE SELECT @ret = 0;
RETURN @ret;
END;

ALTER TABLE Staff
ADD CONSTRAINT square_volume6 CHECK(dbo.check_volume6() = 0);


/*
ALTER TABLE Staff
DROP CONSTRAINT square_volume6 --CHECK(dbo.check_volume6() = 0);
*/

--ALTER TABLE Staff DROP CONSTRAINT square_volume6
--///////////////////////////////



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



--//////////////////////////


--6. Try to set Tom Garden as counsel of Alec Hunter (You should get an error.)

UPDATE Student SET StaffNo=9 WHERE StudentFirstName='Alec' AND StudentLastName= 'Hunter'


--/////////////////////////

--7. Swap counselors of Ursula Douglas and Bronwin Blueberry.






--///////////////////


--8. Remove a staff member from the staff table.
--	 If you get an error, read the error and update the reference rules for the relevant foreign key.


DELETE FROM staff WHERE StaffNo = 3


 














