USE SoftUni

--1. Employees with Salary Above 35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name]
FROM Employees AS e
WHERE e.Salary > 35000
END

EXEC usp_GetEmployeesSalaryAbove35000

--2. Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18,4)
AS
BEGIN
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name]
FROM Employees AS e
WHERE e.Salary >= @Number
END

EXEC usp_GetEmployeesSalaryAboveNumber 48100

--3. Town Names Starting With
CREATE PROCEDURE usp_GetTownsStartingWith @TownStartsWith NVARCHAR(50)
AS
BEGIN
SELECT t.Name
FROM Towns AS t
WHERE t.Name LIKE(@TownStartsWith + '%')
END

EXEC usp_GetTownsStartingWith b

--4. Employees From Town
CREATE PROCEDURE usp_GetEmployeesFromTown(@TownName NVARCHAR(50))
AS 
BEGIN
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name]
FROM Employees AS e
JOIN Addresses AS a
ON e.AddressID = a.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID
WHERE t.Name = @TownName
END

EXEC usp_GetEmployeesFromTown Sofia

--5. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
DECLARE @SalaryLevel NVARCHAR(10)

IF(@salary < 30000)
BEGIN 
	SET @SalaryLevel = 'Low'
END
 
ELSE IF(@salary <= 50000)
BEGIN
	SET @SalaryLevel = 'Average'
END

ELSE IF(@salary > 50000)
BEGIN
	SET @SalaryLevel = 'High'
END

RETURN @SalaryLevel
END

SELECT [dbo].ufn_GetSalaryLevel(510000)

--6. Employees by Salary Level
CREATE PROCEDURE usp_EmployeesBySalaryLevel(@SalaryLevel NVARCHAR(50))
AS
BEGIN
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name]
FROM Employees AS e
WHERE [dbo].ufn_GetSalaryLevel(e.Salary) = @SalaryLevel
END

EXEC usp_EmployeesBySalaryLevel 'high'

--7. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50) , @word NVARCHAR(50))
RETURNS BIT
BEGIN
DECLARE @count INT = 1

WHILE(@count <= LEN(@word))
BEGIN
	DECLARE @currentLetter CHAR(1) = SUBSTRING(@word, @count, 1)
	DECLARE @charIndex INT = CHARINDEX(@currentLetter, @setOfLetters)

	IF(@charIndex = 0)
	BEGIN
		RETURN 0
	END

	SET @count +=1
	END
RETURN 1
END

SELECT dbo.ufn_IsWordComprised('dsksdisaovfia', 'Sofia')

