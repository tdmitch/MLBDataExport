USE [MLB]

CREATE TABLE [MLB].[dbo].[Game](

	gameId INT NOT NULL, --This is a way of creating a primary key in tables
	season INT,
	gameType VARCHAR(2),
	gameDate DATE NOT NULL,
	detailedState VARCHAR(25),
	reason VARCHAR(25),
	homeTeam INT,
	awayTeam INT,
	venue INT
	
) ON [PRIMARY] -- this has something to do with where the data is stored - file group

-- DROP TABLE [MLB].[dbo].[Game]

-- INSERT INTO [MLB].[dbo].[Game](gameId, gameDate)VALUES (566371,'03-26-2019')

--TRUNCATE TABLE [MLB].[dbo].[Game]