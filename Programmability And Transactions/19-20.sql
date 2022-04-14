USE Diablo

--19. Trigger
--1

SELECT *
FROM Users AS u
JOIN UsersGames AS ug
ON ug.UserId = u.Id
WHERE ug.Id = 38

SELECT * 
	FROM Items
WHERE Id = 2

SELECT *
	FROM UserGameItems
	WHERE UserGameId = 38 AND ItemId = 14

INSERT INTO UserGameItems (ItemId, UserGameId) VALUES (14,38)

CREATE TRIGGER tr_RestrictItems ON UserGameItems INSTEAD OF INSERT
AS
DECLARE @itemId INT = (SELECT ItemId FROM inserted)
DECLARE @userGameId INT = (SELECT UserGameId FROM inserted)

DECLARE @itemLevel INT = (SELECT MinLevel FROM Items WHERE Id = @itemId)
DECLARE @userGameLevel INT = (SELECT Level FROM UsersGames WHERE Id = @userGameId)

IF (@userGameLevel >= @itemLevel)
BEGIN 
	INSERT INTO UserGameItems (ItemId, UserGameId)
	VALUES (@itemId, @userGameId)
END

--2
SELECT *
FROM Users AS u
JOIN UsersGames AS ug ON ug.UserId = u.Id
JOIN Games AS g ON g.Id = ug.GameId
WHERE g.Name = 'Bali' AND u.Username IN ('baleremuda', 'loosenoise', 'inguinalself',
'buildingdeltoid', 'monoxidecos')

UPDATE UsersGames
SET Cash += 50000
WHERE GameId = (SELECT Id FROM Games WHERE [Name] = 'Bali') AND
UserId IN (SELECT Id FROM Users WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself',
'buildingdeltoid', 'monoxidecos'))

--3
CREATE PROC usp_BuyItem @userId INT, @itemId INT, @gameId INT
AS
BEGIN TRANSACTION
DECLARE @user INT = (SELECT Id FROM Users WHERE Id = @userId)
DECLARE @item INT = (SELECT Id FROM Items WHERE Id = @itemId)

IF (@user IS NULL OR @item IS NULL)
BEGIN
	ROLLBACK
	RAISERROR ('Invalid user or item id!', 16,1)
	RETURN
END

DECLARE @userCash DECIMAL(15,2) = (SELECT Cash FROM UsersGames WHERE UserId = @userId AND GameId = @gameId)
DECLARE @itemPrice DECIMAL(15,2) = (SELECT Price FROM Items WHERE Id = @itemId)

IF (@userCash - @itemPrice < 0)
BEGIN 
	ROLLBACK
	RAISERROR ('Insufficient funds!', 16, 2)
	RETURN
END

UPDATE UsersGames
SET Cash -= @itemPrice
WHERE UserId = @userId AND GameId = @gameId

DECLARE @userGameId DECIMAL(15,2) = (SELECT Id FROM UsersGames WHERE UserId = @userId AND GameId = @gameId)

INSERT INTO UserGameItems (ItemId, UserGameId) VALUES (@itemId, @gameId)

COMMIT

DECLARE @itemId INT = 251;

WHILE (@itemId <= 299)
BEGIN
	EXEC usp_BuyItem 22, @itemId, 212
	EXEC usp_BuyItem 37, @itemId, 212
	EXEC usp_BuyItem 52, @itemId, 212 
	EXEC usp_BuyItem 61, @itemId, 212

	SET @itemId += 1;
END

SELECT * FROM UsersGames WHERE GameId = 212

DECLARE @counter INT = 501;

WHILE (@counter <= 539)
BEGIN
	EXEC usp_BuyItem 22, @counter, 212
	EXEC usp_BuyItem 37, @counter, 212
	EXEC usp_BuyItem 52, @counter, 212 
	EXEC usp_BuyItem 61, @counter, 212

	SET @counter += 1;
END

--4
SELECT u.Username, g.Name, ug.Cash, i.Name
	FROM Users AS u
	JOIN UsersGames AS ug ON ug.UserId = u.Id
	JOIN Games AS g ON g.Id = ug.GameId
	JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
	JOIN Items AS i ON i.Id = ugi.ItemId
WHERE g.Name = 'Bali'
ORDER BY u.Username, i.[Name]


--20.
DECLARE @userGameId1 INT = (SELECT Id FROM UsersGames WHERE UserId = 9 AND GameId = 87)

DECLARE @stamatCash DECIMAL (15,2) = (SELECT Cash FROM UsersGames WHERE Id = @userGameId1)
DECLARE @itemsPrice DECIMAL (15,2) = (SELECT SUM(Price) AS TotalPrice FROM Items WHERE MinLevel BETWEEN 11 AND 12)

IF (@stamatCash >= @itemsPrice)
BEGIN
	BEGIN TRANSACTION
	UPDATE UsersGames
	SET Cash -= @itemsPrice
	WHERE Id = @userGameId1

	INSERT INTO UserGameItems (ItemId, UserGameId)
	SELECT Id, @userGameId1 FROM Items WHERE MinLevel BETWEEN 11 AND 12

	COMMIT
END

SET @stamatCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId1)
SET @itemsPrice = (SELECT SUM(Price) AS TotalPrice FROM Items WHERE MinLevel BETWEEN 19 AND 21)

IF (@stamatCash >= @itemsPrice)
BEGIN
	BEGIN TRANSACTION
	UPDATE UsersGames
	SET Cash -= @itemsPrice
	WHERE Id = @userGameId1

	INSERT INTO UserGameItems (ItemId, UserGameId)
	SELECT Id, @userGameId1 FROM Items WHERE MinLevel BETWEEN 19 AND 21
	COMMIT
END

SELECT i.Name
	FROM Users AS u
	JOIN UsersGames AS ug ON ug.UserId = u.Id
	JOIN Games AS g ON g.Id = ug.GameId
	JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
	JOIN Items AS i ON i.Id = ugi.ItemId
	WHERE u.Username = 'Stamat' AND g.Name = 'Safflower'
	ORDER BY i.[Name]
	
