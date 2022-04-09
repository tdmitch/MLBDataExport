USE MLB
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
	paul davis
	04/09/2022

	Get the games played for a team, or the whole season
*/
ALTER PROCEDURE dbo.GetGames
	  @season		INT  
	, @teamId		INT  
	, @startDate	DATE 
	, @endDate		DATE 
AS
--DECLARE
--	  @season INT = 2021
--	, @teamId INT = 145
--	, @startDate DATE = '9/1/2021'
--	, @endDate DATE = '9/8/2021'
	
SELECT
	  G.gameId
	, G.season
	, G.gameDate
	, G.homeTeam	AS homeTeamId
	, HT.name		AS homeTeamName
	, G.awayTeam	AS awayTeamId
	, AT.name		AS awayTeamName
	, REPLACE(CONCAT(G.homeTeam, G.awayTeam),@teamId,'') AS OponentTeamId
	, OP.name		AS oponentTeamName
	, CONCAT(AT.name, ' @ ', HT.name, ' ', G.gameDate) AS gameDescription
FROM
	dbo.Game G
	LEFT JOIN MLB.dbo.Team					HT ON HT.teamId = G.homeTeam
	LEFT JOIN MLB.dbo.Team					AT ON AT.teamId = G.awayTeam
	LEFT JOIN MLB.dbo.Team					OP ON OP.teamId = REPLACE(CONCAT(G.homeTeam, G.awayTeam),@teamId,'') --AS OponentTeamId
WHERE
	G.detailedState = 'Final'
	AND (G.season = @season OR @season IS NULL)
	AND (
		(G.awayTeam = @teamId OR G.homeTeam = @teamId)
		OR @teamId IS NULL)
	AND (G.gameDate >= @startDate OR @startDate IS NULL)
	AND (G.gameDate <= @endDate OR @endDate IS NULL)
ORDER BY
	G.gameDate
	