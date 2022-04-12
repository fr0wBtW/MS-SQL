--1.One-To-One Relationship
CREATE TABLE Persons(
PersonID INT NOT NULL,
FirstName NVARCHAR(30) NOT NULL,
Salary DECIMAL NOT NULL,
PassportID INT NOT NULL
);

CREATE TABLE Passports(
PassportID INT NOT NULL,
PassportNumber VARCHAR(10) NOT NULL
);

INSERT INTO Persons(PersonID, FirstName, Salary, PassportID)
VALUES (1, 'Roberto' , 43300.00, 102),
       (2, 'Tom', 56100.00, 103),
       (3, 'Yana', 60200.00, 101);

INSERT INTO Passports
VALUES (101, 'N34FG21B'),
	   (102, 'K65LO4R7'),
	   (103, 'ZE657QP2');

ALTER TABLE Persons
ADD CONSTRAINT PK_Persons PRIMARY KEY(PersonID)

ALTER TABLE Passports
ADD CONSTRAINT PK_Passports PRIMARY KEY(PassportID)

ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

--2. One-To-Many Relationship
CREATE TABLE Models(
ModelID INT PRIMARY KEY NOT NULL,
Name NVARCHAR(10) NOT NULL,
ManufacturerID INT NOT NULL
)

CREATE TABLE Manufacturers(
ManufacturerID INT NOT NULL,
Name NVARCHAR(30) NOT NULL,
EstablishedOn DATE NOT NULL,
CONSTRAINT PK_ManufacturerID PRIMARY KEY(ManufacturerID)
)

ALTER TABLE Models
ADD CONSTRAINT FK_ManufacturerID FOREIGN KEY(ManufacturerID) REFERENCES Manufacturers(ManufacturerID)

INSERT INTO Manufacturers
VALUES (1, 'BMW', '07/03/1916'),
       (2, 'Tesla', '01/01/2003'),
	   (3, 'Lada', '01/01/1966'); 

INSERT INTO Models
VALUES(101, 'X1', 1),
	  (102, 'i8', 1),
	  (103, 'Model S', 2),
	  (104, 'Model X', 2),
	  (105, 'Model 3', 2),
	  (106, 'Nova', 3);
	
--3. Many-To-Many Relationship
CREATE TABLE Students(
StudentID INT NOT NULL,
Name NVARCHAR(10) NOT NULL
CONSTRAINT PK_StudentID PRIMARY KEY(StudentID)
)

CREATE TABLE Exams(
ExamID INT NOT NULL,
Name NVARCHAR(30) NOT NULL
CONSTRAINT PK_ExamID PRIMARY KEY(ExamID)
)

CREATE TABLE StudentsExams(
StudentID INT NOT NULL,
ExamID INT NOT NULL,
CONSTRAINT PK_StudentExamID PRIMARY KEY(StudentID, ExamID),
CONSTRAINT FK_StudentID FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_ExamID FOREIGN KEY(ExamID) REFERENCES Exams(ExamID)
);

INSERT INTO Students
VALUES (1, 'Persi'),
       (2, 'Magi'),
	   (3, 'Niki')

INSERT INTO Exams
VALUES (101, 'SpringMVC'),
       (102, 'Neo4j'),
	   (103, 'Oracle 11g')

INSERT INTO StudentsExams
VALUES (1, 101),
       (1, 102),
	   (2, 101),
	   (3, 103),
	   (2, 102),
	   (2, 103)

--4. Self-Referencing
CREATE TABLE Teachers(
TeacherID INT NOT NULL,
Name NVARCHAR(50) NOT NULL,
ManagerID INT
)

INSERT INTO Teachers
VALUES (101, 'John', NULL),
       (102, 'Maya', 106),
	   (103, 'Silvia', 106),
	   (104, 'Ted', 105),
	   (105, 'Mark', 101),
	   (106, 'Greta', 101)
	   
ALTER TABLE Teachers
ADD CONSTRAINT PK_TeacherID PRIMARY KEY(TeacherID)

ALTER TABLE Teachers
ADD CONSTRAINT FK_Teachers_Managers FOREIGN KEY(ManagerID) REFERENCES Teachers(TeacherID)

--5. Online Store Database
CREATE TABLE Orders(
OrderID INT,
CustomerID INT,
CONSTRAINT PK_OrderID PRIMARY KEY(OrderID)
)

CREATE TABLE Customers(
CustomerID INT,
Name VARCHAR(50),
Birthday DATE,
CityID INT,
CONSTRAINT PK_CustomerID PRIMARY KEY(CustomerID)
)

CREATE TABLE Cities(
CityID INT,
Name VARCHAR(50)
CONSTRAINT PK_CityID PRIMARY KEY(CityID)
)

CREATE TABLE Items(
ItemID INT,
Name VARCHAR(50),
ItemTypeID INT,
CONSTRAINT PK_ItemID PRIMARY KEY(ItemID)
)

CREATE TABLE ItemTypes(
ItemTypeID INT,
Name VARCHAR(50)
CONSTRAINT PK_ItemTypeID PRIMARY KEY(ItemTypeID)
)

CREATE TABLE OrderItems(
OrderID INT,
ItemID INT,
CONSTRAINT PK_OrderItemID PRIMARY KEY(OrderID, ItemID),
CONSTRAINT FK_OrderID FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
CONSTRAINT FK_ItemID FOREIGN KEY(ItemID) REFERENCES Items(ItemID)
)

ALTER TABLE Orders
ADD CONSTRAINT FK_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)

ALTER TABLE Customers
ADD CONSTRAINT FK_CityID FOREIGN KEY(CityID) REFERENCES Cities(CityID)

ALTER TABLE Items
ADD CONSTRAINT FK_ItemTypeID FOREIGN KEY(ItemTypeID) REFERENCES ItemTypes(ItemTypeID)

--6. University Database
CREATE TABLE Majors(
MajorID INT,
Name NVARCHAR(50)
CONSTRAINT PK_MajorID PRIMARY KEY(MajorID)
)

CREATE TABLE Payments(
PaymentID INT,
PaymentDate DATE,
PaymentAmount DECIMAL(7,2),
StudentID INT,
CONSTRAINT PK_PaymentID PRIMARY KEY(PaymentID)
)

CREATE TABLE Students1(
StudentID INT,
StudentNumber NVARCHAR(10),
StudentName NVARCHAR(50),
MajorID INT
CONSTRAINT PK_Student1ID PRIMARY KEY(StudentID)
)

CREATE TABLE Agenda(
StudentID INT,
SubjectID INT,
CONSTRAINT PK_CompositeStudentSubjectID PRIMARY KEY(StudentID, SubjectID)
)

CREATE TABLE Subjects(
SubjectID INT,
SubjectName NVARCHAR(50),
CONSTRAINT PK_SubjectID PRIMARY KEY(SubjectID)
)

ALTER TABLE Students1
ADD CONSTRAINT FK_MajorID FOREIGN KEY(MajorID) REFERENCES Majors(MajorID)

ALTER TABLE Payments
ADD CONSTRAINT FK_Student1ID FOREIGN KEY(StudentID) REFERENCES Students1(StudentID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_Students1ID FOREIGN KEY(StudentID) REFERENCES Students1(StudentID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_SubjectID FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)


--9. * Peaks In Rila
SELECT Mountains.MountainRange, Peaks.PeakName, Peaks.Elevation
FROM Peaks
JOIN Mountains ON Peaks.MountainId = Mountains.Id
WHERE Mountains.MountainRange = 'Rila'
ORDER BY Peaks.Elevation DESC