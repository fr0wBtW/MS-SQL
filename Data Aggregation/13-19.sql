USE SoftUni

--13. Departments Total Salaries
SELECT DepartmentID,
SUM(Salary)
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14. Employees Minimum Salaries
SELECT DepartmentID,
MIN(Salary)
FROM Employees
WHERE DepartmentID IN(2, 5, 7)
AND HireDate > '01/01/2000'
GROUP BY DepartmentID

--15. Employees Average Salaries
SELECT * INTO SalaryOver30
FROM Employees
WHERE Salary > 30000

DELETE FROM SalaryOver30 WHERE ManagerID = 42

UPDATE SalaryOver30
SET Salary = Salary + 5000
WHERE DepartmentId = 1

SELECT DepartmentID,
AVG(Salary) AS AverageSalary
FROM SalaryOver30
GROUP BY DepartmentID

--16. Employees Maximum Salaries
SELECT DepartmentID,
MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17. Employees Count Salaries
SELECT COUNT(*) AS Count
FROM Employees
WHERE ManagerID IS NULL

--18. * 3rd Highest Salary
SELECT srt.DepartmentID,
		srt.Salary
FROM(
			SELECT DepartmentID,
				Salary,
				DENSE_RANK()
					OVER (PARTITION BY DepartmentID 
					ORDER BY SALARY DESC) AS SalaryRank
					FROM Employees) AS srt
					WHERE srt.SalaryRank = 3
					GROUP BY srt.DepartmentID, srt.Salary
			
--19. ** Salary Challenge 
SELECT TOP(10) FirstName,
	LastName,
	DepartmentID 
FROM Employees AS T
WHERE Salary > (SELECT AVG(Salary)
				FROM Employees
				WHERE DepartmentID = T.DepartmentID)
ORDER BY DepartmentID

