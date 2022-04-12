USE Bank

--9. Find Full Name
CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM AccountHolders
END

EXEC usp_GetHoldersFullName

--10. People with Balance Higher Than
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@GivenBalance DECIMAL(18,4))
AS
BEGIN
SELECT ah.FirstName AS [First Name], ah.LastName AS [Last Name]
FROM AccountHolders AS ah
JOIN Accounts AS a
ON ah.Id = a.AccountHolderId
GROUP BY ah.Id, ah.FirstName, ah.LastName
HAVING SUM(a.Balance) > @GivenBalance
ORDER BY ah.FirstName, ah.LastName
END

EXEC usp_GetHoldersWithBalanceHigherThan 7000

--11. Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18,4)
BEGIN
	RETURN @sum * POWER((1 + @yearlyInterestRate), @numberOfYears)
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)


--12. Calculating Interest
CREATE PROC usp_CalculateFutureValueForAccount @accountId INT, @interestRate FLOAT
AS
BEGIN
SELECT a.Id AS [Account Id], ah.FirstName AS [First Name], ah.LastName AS [Last Name], a.Balance AS [Current Balance], dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5) AS [Balance in 5 years]
	FROM Accounts AS a
	JOIN AccountHolders AS ah
	ON ah.Id = a.AccountHolderId
	WHERE a.Id = @accountId
END

EXEC usp_CalculateFutureValueForAccount 1, 0.1

	
