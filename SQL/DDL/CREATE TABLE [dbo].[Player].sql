USE [MLB];
Go

CREATE TABLE [dbo].[Player](
	playerId INT,
	firstName NVARCHAR(50),
	lastName NVARCHAR(50),
	jerseyNumber INT,
	weight INT,
	heightFeet INT,
	heightInches INT,
	teamId INT,
	throws NVARCHAR(3),
	bats NVARCHAR(3),
	primaryPosition NVARCHAR(4)
)
