USE [MLB];
GO

CREATE TABLE [fact].[Game](
	gameID INT,
	gameDate DATE,
	homeTeamID INT,
	awayTeamID INT ,
	totalPlateAppearances INT,
	totalPitches INT
)