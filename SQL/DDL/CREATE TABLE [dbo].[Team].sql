USE [MLB];
Go

CREATE TABLE [dbo].[Team](
	teamId INT,
	name NVARCHAR(50),
	fullName NVARCHAR(MAX),
	abbrevName NVARCHAR(5),
	leagueId INT,
	league NVARCHAR(5),
	divisionId INT,
	division NVARCHAR(5),
	venueName NVARCHAR(MAX),
	venueId INT,
	city NVARCHAR(100),
	state NVARCHAR(5)
)
