USE MLB
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Box Score Report

	This will be helpful in validating a game

	created by: paul davis
	created on: 04/08/2022

	TODO
		[ ] Batters - Home Team | Away Team
		[ ] At Bats
		[ ] Runs
		[ ] Hits
		[ ] RBIs
		[ ] Base on Balls
		[ ] Strike Outs
		[ ] Left on Base

		[] Indicator of outcome of a hit? 1,2,3,4? isOnBase could be changed to be a ordinal val instead of bool

*/
CREATE PROCEDURE dbo.BoxScore
	@gameId INT
AS
-------------------------------------------------------------------------------------------------------
--DECLARE	@gameId INT = 634474

-------------------------------------------------------------------------------------------------------
-- #PlateAppearances
SELECT
	DISTINCT
	  PA.GameId
	, PA.inning 
	, PA.halfInning
	, PA.atBatIndex
	, CONCAT(BT.lastName,' ', BT.firstName, ': ', BT.jerseyNumber) AS Batter
	, PA.batSide
	, CONCAT(PT.lastName,' ', PT.firstName,': ', PT.jerseyNumber) AS Pitcher
	, PA.pitchHand
	, PA.isScoringPlay
	, PA.event
	, E.isOnBase
	, PA.rbi
	, PA.awayScore
	, PA.homeScore
INTO
	#PlateAppearances
FROM
	MLB.dbo.Game							G
	LEFT JOIN MLB.dbo.Team					HT ON HT.teamId = G.homeTeam
	LEFT JOIN MLB.dbo.Team					AT ON AT.teamId = G.awayTeam
	LEFT JOIN MLB.dbo.PlateAppearance		PA ON PA.GameId = G.gameId
	LEFT JOIN MLB.dbo.Player				BT ON BT.playerId = PA.batterId 
	LEFT JOIN MLB.dbo.Player				PT ON PT.playerId = PA.pitcherId 
	LEFT JOIN MLB.dbo.Event					E ON E.event = PA.event
WHERE
	G.gameId = @gameId
ORDER BY
	PA.atBatIndex

-------------------------------------------------------------------------------------------------------
-- main
SELECT
	  PA.GameId
	, PA.inning 
	, PA.halfInning
	, PA.atBatIndex
	, PA.Batter
	, PA.batSide
	, PA.Pitcher
	, PA.pitchHand
	, PA.isScoringPlay
	, PA.event
	, PA.isOnBase
	, PA.rbi
	, PA.awayScore
	, PA.homeScore
	, P.pitchNumber
	, CASE P.isBall   WHEN 'TRUE' THEN 1 WHEN 'FALSE' THEN 0 END AS isBall
	, CASE P.isStrike WHEN 'TRUE' THEN 1 WHEN 'FALSE' THEN 0 END AS isStrike
	, CASE P.isInPlay WHEN 'TRUE' THEN 1 WHEN 'FALSE' THEN 0 END AS isInPlay
	, P.typeCode AS pitchType
	, P.startSpeed
	, P.endSpeed
	, (P.startSpeed - P.endSpeed) AS speedLoss
	, P.spinRate
	, P.spinDirection
	, P.x
	, P.y
FROM
	#PlateAppearances PA
	LEFT JOIN MLB.dbo.Pitch P ON PA.GameId = P.gameId AND PA.atBatIndex = P.atBatIndex

ORDER BY
	  PA.atBatIndex
	, P.pitchNumber
-------------------------------------------------------------------------------------------------------
DROP TABLE #PlateAppearances