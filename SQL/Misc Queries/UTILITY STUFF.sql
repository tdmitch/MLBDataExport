--dbo
--TRUNCATE TABLE Game
--TRUNCATE TABLE Pitch
--TRUNCATE TABLE Team

--fact
--TRUNCATE TABLE [fact].[Game]
--TRUNCATE TABLE [fact].[Season]
--TRUNCATE TABLE [fact].[Matchup]
SELECT
	*
FROM
	Game

--TRUNCATE TABLE Game
--DROP TABLE [dbo].[Game]

SELECT
	*
FROM
	Pitch
--TRUNCATE TABLE Pitch

SELECT
	*
FROM
	[fact].[Season]
--TRUNCATE TABLE [fact].[Season]

SELECT
	*
FROM
	[fact].[Game]

SELECT
	*
FROM
	[fact].[Matchup]
	