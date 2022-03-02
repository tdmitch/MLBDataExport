USE [MLB];
GO

CREATE TABLE [fact].[GameBatter](
	gameID INT,
	batterId INT,
	Single INT,
	[Double] INT,
	Triple INT,
	HomeRun INT,
	Walk INT,
	[Intent Walk] INT,
	[Catcher Interference] INT,
	[Hit By Pitch] INT

)