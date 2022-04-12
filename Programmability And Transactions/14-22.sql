USE Bank

--14. Create Table Logs
CREATE TABLE Logs(
LogId INT PRIMARY KEY IDENTITY,
AccountId INT NOT NULL FOREIGN KEY REFERENCES Accounts(Id),
OldSum MONEY ,
NewSum MONEY
)

CREATE TRIGGER tr_LogsEntry ON Accounts FOR UPDATE
AS
BEGIN
INSERT INTO Logs
SELECT a.Id, d.Balance, a.Balance
FROM deleted AS d
JOIN Accounts AS a ON a.Id = d.Id
END

UPDATE Accounts
SET Balance = 113.12
WHERE Id = 1


--15. Create Table Emails
CREATE TABLE NotificationEmails(
Id INT IDENTITY,
Recipient INT NOT NULL,
Subject NVARCHAR(MAX),
Body NVARCHAR(MAX),
CONSTRAINT PK_NotificationEmails PRIMARY KEY(Id)
)

CREATE OR ALTER TRIGGER tr_EmailNotification ON Logs FOR INSERT
AS
BEGIN
INSERT INTO NotificationEmails
SELECT
a.Id,
CONCAT('Balance change for account: ', a.Id), 
CONCAT('On ', GETDATE() , ' your balance was changed from ', i.OldSum, ' to ', i.NewSum, '.')
FROM Accounts AS a
JOIN inserted AS i
ON a.Id = i.AccountId
END

UPDATE Accounts
SET Balance += 100
WHERE Id = 2

SELECT * FROM Accounts WHERE Id = 2

SELECT * FROM Logs
SELECT * FROM NotificationEmails 

--16. Deposit Money
CREATE OR ALTER PROCEDURE usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(15,4))
AS
BEGIN TRANSACTION
	DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @AccountId)

IF(@account IS NULL)
BEGIN
	ROLLBACK
	RAISERROR('Invalid account!', 16, 1)
	RETURN
END
IF(@MoneyAmount < 0)
BEGIN
	ROLLBACK	
	RAISERROR('Negative amount!', 16, 2)
	RETURN
END

UPDATE Accounts
SET Balance += @MoneyAmount
WHERE Id = @AccountId
COMMIT

EXEC usp_DepositMoney 1, 10

SELECT * FROM Accounts
SELECT * FROM Logs
SELECT * FROM NotificationEmails

--17. Withdraw Money
CREATE OR ALTER PROC usp_WithdrawMoney(@AccountId INT, @MoneyAmount DECIMAL(15,4))
AS 
BEGIN TRANSACTION
	DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @AccountId)
	DECLARE @accountBalance DECIMAL(15,4) = (SELECT Balance FROM Accounts WHERE Id = @AccountId)

	IF(@account IS NULL)
	BEGIN
		ROLLBACK
		RAISERROR('Invalid Account.', 16, 1)
		RETURN
	END

	IF(@accountBalance - @MoneyAmount < 0)
	BEGIN 
		ROLLBACK
		RAISERROR('Insuffiecient funds.', 16, 2)
		RETURN
	END
	
	IF(@MoneyAmount < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Negative amount.', 16, 3)
		RETURN
	END

UPDATE Accounts
SET Balance -= @MoneyAmount
WHERE Id = @AccountId

COMMIT

EXEC usp_WithdrawMoney 1, 10

SELECT * FROM Accounts
SELECT * FROM Logs
SELECT * FROM NotificationEmails

--18. Money Transfer
CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18,4))
AS
BEGIN TRANSACTION
	DECLARE @sender INT = (SELECT Id FROM Accounts WHERE Id = @SenderId)
	DECLARE @receiver INT = (SELECT Id FROM Accounts WHERE Id = @ReceiverId)
	DECLARE @moneySender DECIMAL(18,4) (SELECT Balance FROM Accounts WHERE Id = @SenderId)
	DECLARE @moneyReceiver DECIMAL(18,4) (SELECT Balance FROM Accounts WHERE Id = @ReceiverId)

IF(@sender IS NULL OR @receiver IS NULL)
BEGIN
ROLLBACK
RAISERROR('Sender Or Receiver cannot be null', 16, 1)
RETURN
END

IF(@moneySender - @Amount) < 0
BEGIN
ROLLBACK
RAISERROR('Insufficient balance', 16, 2)
RETURN 
END

IF(@Amount <= 0)
BEGIN
ROLLBACK
RAISERROR('Amount cannot be 0 or less than zero.', 16, 3)
RETURN
END

UPDATE [Accounts]
	SET [Balance] -= @Amount
	WHERE [Id] = @sender

	UPDATE [Accounts]
	SET [Balance] += @Amount
	WHERE [Id] = @receiver

COMMIT

EXEC usp_TransferMoney 1, 2, 10
SELECT * FROM Accounts WHERE Id = 1
SELECT * FROM Accounts WHERE Id = 2

--18. Money Transfer Second Solution
CREATE PROC usp_TransferMoney1(@SenderId INT, @ReceiverId INT, @Amount Decimal(15,2))
AS
BEGIN TRANSACTION
	EXEC usp_WithdrawMoney @SenderId, @Amount

	EXEC usp_DepositMoney @ReceiverId, @Amount
COMMIT

EXEC usp_TransferMoney 2, 1, 10

SELECT * FROM Accounts WHERE Id IN(1, 2)


--21. Employees With Three Projects
USE SoftUni

CREATE OR ALTER PROCEDURE usp_AssignProject(@employeeId INT, @projectID INT)
AS
BEGIN TRANSACTION
	DECLARE @numberOfEmployeesProject INT;
	SET @numberOfEmployeesProject = (SELECT COUNT(ep.[EmployeeID])
	FROM [EmployeesProjects] AS ep
	WHERE ep.[EmployeeID] = @employeeId)

IF(@numberOfEmployeesProject >= 3)
BEGIN
	ROLLBACK
	RAISERROR('The employee has too many projects!', 16, 1)
	RETURN
END

INSERT INTO EmployeesProjects VALUES (@employeeId, @projectID)

COMMIT

EXEC usp_AssignProject 2,4
SELECT * FROM EmployeesProjects WHERE EmployeeID = 3

--22. Delete Employees
CREATE TABLE Deleted_Employees(
EmployeeId INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(50),
LastName VARCHAR(50),
MiddleName VARCHAR(50),
JobTitle VARCHAR(50),
DepartmentId INT NOT NULL,
Salary MONEY NOT NULL
)

CREATE OR ALTER TRIGGER tr_DeletedEmployees ON [Employees] FOR DELETE
AS
BEGIN
	INSERT INTO [Deleted_Employees]
	SELECT 
			d.[FirstName],
			d.LastName,
			d.MiddleName,
			d.JobTitle,
			d.DepartmentId,
			d.Salary
			FROM deleted AS d
END
