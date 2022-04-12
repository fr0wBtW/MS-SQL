CREATE DATABASE CarRental
USE CarRental

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
CategoryName NVARCHAR(30) NOT NULL,
DailyRate DECIMAL(5,2) NOT NULL,
WeeklyRate DECIMAL(5,2) NOT NULL,
MonthlyRate DECIMAL(5,2) NOT NULL,
WeekendRate DECIMAL(5,2) NOT NULL
)

CREATE TABLE Cars(
Id INT PRIMARY KEY IDENTITY,
PlateNumber NVARCHAR(30) NOT NULL,
Manufacturer NVARCHAR(30) NOT NULL,
Model NVARCHAR(30) NOT NULL,
CarYear DATE,
CategoryId INT NOT NULL,
Doors INT,
Picture VARBINARY(MAX),
Condition VARCHAR(10),
Available BIT
)

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
Title NVARCHAR(20) NOT NULL,
Notes TEXT
)

CREATE TABLE Customers(
Id INT PRIMARY KEY IDENTITY,
DriverLicenceNumber NVARCHAR(30) NOT NULL,
FullName NVARCHAR(30) NOT NULL,
Address NVARCHAR(50) NOT NULL,
City NVARCHAR(20) NOT NULL,
ZIPCode INT,
Notes Text
)

CREATE TABLE RentalOrders(
Id INT PRIMARY KEY IDENTITY,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
TankLevel DECIMAL(15,2) NOT NULL,
KilometrageStart DECIMAL(15,2) NOT NULL,
KilometrageEnd DECIMAL(15,2) NOT NULL,
TotalKilometrage DECIMAL(15,2) NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
TotalDays INT NOT NULL,
RateApplied NVARCHAR(20),
TaxRate NVARCHAR(20),
OrderStatus NVARCHAR(20),
Notes TEXT
)

INSERT INTO [Categories] 
VALUES ('Bus', 1.2, 2.2, 3.3, 4.4),
('Car', 1.2, 2.2, 3.3, 4.4),
('MiniVan', 1.2, 2.2, 3.3, 4.4)

INSERT INTO Cars 
VALUES ('12RET45TF', 'BMW', '750', NULL, 1, NULL, NULL, NULL, NULL),
('12RET45TF', 'Audi', 'A8', NULL, 2, NULL, NULL, NULL, NULL),
('12RET45TF', 'Mercedes', 'S-Class', NULL, 3, NULL, NULL, NULL, NULL)

INSERT INTO Employees
VALUES ('Misho', 'Mishev', 'Misho', NULL),
('Pesho', 'Petrov', 'Peshko', NULL),
('Aleksandar', 'Dinev', 'Dinko', NULL)

INSERT INTO Customers
VALUES ('23RE3434', 'Mishev', 'Sofia', 'Sofia', NULL, NULL),
('23R434', 'Mishev', 'Sofia', 'Sofia', NULL, NULL),
('2353434', 'Mishev', 'Sofia', 'Sofia', NULL, NULL)

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel,
KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes) 
VALUES
(1, 2, 3, 64.64, 365.20, 76577.20, 86446.76, '2013-08-06', '2013-08-26', 10, NULL, NULL, NULL, NULL),
(2, 3, 1, 65.80, 856.00, 36645.20, 86767.54, '2017-01-08', '2017-01-18', 10, NULL, NULL, NULL, NULL),
(3, 1, 2, 87.98, 855.65, 76555.20, 98643.98, '2009-12-24', '2009-12-30', 6, NULL, NULL, NULL, NULL)