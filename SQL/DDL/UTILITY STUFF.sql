--dbo
--TRUNCATE TABLE Game
--TRUNCATE TABLE Pitch

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
WHERE
	totalPlateAppearances IS NOT NULL

SELECT
	*
FROM
	[fact].[Matchup]
	
SELECT
	DISTINCT
	gameId
INTO
	#pitch
FROM
	[dbo].[Pitch]

SELECT
	--COUNT(*)
	*
FROM
	#pitch
ORDER BY
	gameId
DROP TABLE #pitch

--EXEC [dbo].[LOAD_fact.Game]