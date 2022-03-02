/*
	Write a stored procedure to return the pitchers for a team during a given season

	Giants - 137

	-- TODO --
	1. Add Season to dbo.Game
*/

--EXEC [dbo].[getPitchersByTeamSeason] 137, 2020

--ALTER PROCEDURE [dbo].[getPitchersByTeamSeason]
--	@team INT
--	, @season INT
--AS

DECLARE 
	 @team INT = 137
	, @season INT = 2020

SELECT
	P.[playerId]
	, P.[firstName]
	, P.[lastName]
	, P.[throws]
FROM
	[MLB].[dbo].[Player] P

WHERE
	P.[primaryPosition] = '1'
	AND P.[teamId] = @team


--SELECT * FROM [MLB].[dbo].[Player]