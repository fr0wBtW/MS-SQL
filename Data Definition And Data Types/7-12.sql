USE Minions
CREATE TABLE People(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(200) NOT NULL,
Picture VARBINARY(2),
Height DECIMAL (5,2),
Weight DECIMAL (5,2),
Gender NVARCHAR (1) NOT NULL,
Birthdate DATE NOT NULL,
Biography NTEXT
)
SET IDENTITY_INSERT People OFF

INSERT INTO People(Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Pesho', NULL, 33.555555, 55.20, 'm', '2021-02-14', 'HEY'),
       ('Gosho', NULL, 123.555555, 55.20, 'm', '2021-02-14', 'HEY, LOVE YOU.'),
	    ('Persi', NULL, 1.555555, 55.20, 'f', '2021-02-14', 'HEY, LOVE YOU.'),
		 ('Kolio', NULL, 123.555555, 55.20, 'm', '2021-02-19', 'HEY.'),
		  ('Budov', NULL, 123.345, 55.20, 'm', '2021-02-14', 'HEYYYY')


CREATE TABLE Users(
Id INT IDENTITY(1,1),
Username VARCHAR(30) NOT NULL UNIQUE,
Password VARCHAR(26) NOT NULL,
ProfilePicture VARBINARY(MAX),
LastLoginTime DATETIME,
IsDeleted VARCHAR(5)
)

INSERT INTO USERS(Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES ('fr0wBtW', 123456, 300, '05-02-2012', 'false'),
('Niki', 123, NULL, '10-02-2012', 'true'),
('Az', 1234567, NULL, '10-02-2014', 'false'),
('fr0wBtW1', 123456,NULL, '10-02-2012', 'true'),
('Persi', 123456, NULL, '10-02-2012', 'false')

ALTER TABLE Users
DROP CONSTRAINT UQ__Users__536C85E4278673F0

ALTER TABLE Users
ADD CONSTRAINT PK_UserId
PRIMARY KEY ([Id], [Username])

ALTER TABLE Users
ADD CHECK (LEN([Password]) >= 5)

ALTER TABLE USERS
ADD DEFAULT GETDATE() FOR LastLoginTime

ALTER TABLE Users
DROP PK_UserId

ALTER TABLE Users
ADD CONSTRAINT PK_Id
PRIMARY KEY ([Id])

ALTER TABLE Users
ADD UNIQUE ([Username])

ALTER TABLE Users
ADD CONSTRAINT CH_Username
CHECK (LEN(Username) > 3)

