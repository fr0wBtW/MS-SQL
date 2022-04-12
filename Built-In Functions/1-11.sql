USE SoftUni


SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE 'SA%';

SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%ei%'

SELECT FirstName
FROM Employees
WHERE DepartmentID = 3 OR DepartmentId = 10
AND YEAR([HireDate]) BETWEEN 1995 AND 2005

SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

SELECT Name 
FROM Towns
WHERE LEN(Name) = 5 OR LEN(Name) = 6
ORDER BY Name

SELECT TownID, Name
FROM Towns
WHERE Name LIKE 'M%' OR Name LIKE 'K%' OR Name LIKE 'B%' OR NAME LIKE 'E%'
ORDER BY Name

SELECT TownId, Name
FROM Towns
WHERE Name NOT LIKE 'R%' AND NAME NOT LIKE 'B%' AND NAME NOT LIKE 'D%'
ORDER BY Name


CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) > 2000

SELECT * FROM V_EmployeesHiredAfter2000

SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5


SELECT EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER(partition by Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

SELECT *
	FROM (
		SELECT e.[EmployeeID], e.[FirstName],[LastName], [Salary],
		DENSE_RANK() OVER(partition by [Salary] ORDER BY [EmployeeID]) as 'Rank'
		FROM[Employees] AS e
		WHERE [Salary] BETWEEN 10000 AND 50000 ) AS t
	WHERE t.[Rank] = 2
	ORDER BY t.[Salary] DESC