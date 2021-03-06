USE SoftUni

--1. Employee Address
SELECT TOP(5) e.EmployeeId, e.JobTitle, e.AddressID, a.AddressText 
FROM Employees AS e
JOIN Addresses AS a
ON e.AddressID = a.AddressID
ORDER BY e.AddressID

--2. Addresses with Towns
SELECT TOP(50) e.FirstName, e.LastName, t.[Name] AS Town, a.AddressText
FROM Employees AS e
JOIN Addresses AS a
ON e.AddressID = a.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName

--3. Sales Employees
SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] AS DepartmentName
FROM Employees as e
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY e.EmployeeID

--4. Employee Departments
SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.[Name] AS DepartmentName
FROM Employees as e
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID

--5. Employees Without Projects
SELECT TOP(3) e.EmployeeID, e.FirstName 
FROM Employees AS e
LEFT JOIN EmployeesProjects as p
ON p.EmployeeID = e.EmployeeID
WHERE p.ProjectID IS NULL
ORDER BY e.EmployeeID

--6. Employees Hired After
SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS DeptName
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > '1/1/1999' AND d.[Name] IN ('Sales','Finance')
ORDER BY e.HireDate

--7. Employees With Project
SELECT TOP(5) e.EmployeeID, e.FirstName, p.[Name] AS ProjectName
FROM Employees AS e
JOIN  EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p
ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '2002/08/13' 
AND p.EndDate IS NULL
ORDER BY e.EmployeeID

--8. Employee 24
SELECT e.EmployeeID, e.FirstName,
CASE
	WHEN YEAR(p.StartDate) >= 2005 THEN NULL
	ELSE p.[Name] END AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p
ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

--9. Employee Manager
SELECT e.EmployeeID, e.FirstName, e.ManagerID, ee.FirstName
FROM Employees AS e
JOIN Employees AS ee
ON e.ManagerID = ee.EmployeeID
WHERE e.ManagerID IN(3,7)
ORDER BY e.EmployeeID

--10. Employees Summary
SELECT TOP(50) e.EmployeeID, CONCAT(e.FirstName, ' ' ,e.LastName) AS EmployeeName, CONCAT(m.FirstName, ' ',m.LastName) AS ManagerName, d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m
ON e.ManagerID = m.EmployeeID
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

--11. Min Average Salary
SELECT MIN(dt.MinAverageSalary) FROM
(SELECT AVG(Salary) AS MinAverageSalary FROM Employees GROUP BY DepartmentID) AS dt





