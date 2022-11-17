/*
	Pitcher Characteristics
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- CREATE PROCEDURE dbo.getPitcherCharacheristics(
-- 	  @pitcherId NVARCHAR(MAX) = NULL -- if null select all
-- 	, @batterId NVARCHAR(MAX) = NULL	-- for matchups
-- 	, @batterHand VARCHAR(MAX) = NULL	-- for L/R splits
-- 	, @pitcherHand VARCHAR(MAX) = NULL	-- for L/R splits
-- )
-- AS

DECLARE
	  @pitcherId NVARCHAR(MAX) = 657277 -- NULL -- if null select all
	, @batterId NVARCHAR(MAX) = 657108	-- for matchups
	, @batterHand VARCHAR(MAX) = NULL	-- for L/R splits
	, @pitcherHand VARCHAR(MAX) = NULL	-- for L/R splits
----------------------------------------------------------------------------------------
-- get at bat count
DROP TABLE IF EXISTS #AtBatCount 
SELECT
	  AtBats.pitcherId
	, COUNT(*) AS AtBatCount
INTO
	#AtBatCount
FROM
	(
	SELECT
		DISTINCT
		  P.pitcherId
		, P.gameId
		, P.atBatIndex
	FROM
		MLB.dbo.Pitch P
		LEFT JOIN MLB.dbo.Player BAT	ON BAT.playerId = P.batterId
		LEFT JOIN MLB.dbo.Player PITCH  ON PITCH.playerId = P.pitcherId
	WHERE
		(P.pitcherId = @pitcherId		OR @pitcherId  IS NULL)
		AND (P.batterId = @batterId		OR @batterId   IS NULL)
		AND (BAT.bats = @batterHand		OR @batterHand IS NULL)
	) AS AtBats
GROUP BY
	AtBats.pitcherId
----------------------------------------------------------------------------------------
-- main
SELECT
	  P.pitcherId
	, CONCAT(PITCH.lastName, ', ' , PITCH.firstName) AS Pitcher
	, PT.fullName AS pTeamName
	----
	, P.batterId
	, CONCAT(BAT.lastName, ', ', BAT.FirstName) AS Batter
	, BT.fullName AS bTeamName


	, P.typeCode 
	-- FC - Cutter
	-- FF - Fastball
	-- CU - ChangeUp
	-- FS - Splitter
	-- SL - Slider
	, COUNT(*) AS PitchesThrown
	,  MAX(AB.AtBatCount) AS AtBatsPitched
	, SUM(IIF(P.isInPlay = 'TRUE', 1, 0)) AS isInPlay
	, CAST(SUM(IIF(P.isInPlay= 'TRUE', 1, 0)) AS DECIMAL) / CAST( SUM(1) AS DECIMAL) AS isInPlayRate
	, SUM(IIF(P.isStrike = 'TRUE', 1, 0)) AS isStrike
	, CAST(SUM(IIF(P.isStrike= 'TRUE', 1, 0)) AS DECIMAL) / CAST( SUM(1) AS DECIMAL) AS isStrikeRate
	, SUM(IIF(P.isBall= 'TRUE', 1, 0)) AS isBall
	, CAST(SUM(IIF(P.isBall= 'TRUE', 1, 0)) AS DECIMAL) / CAST( SUM(1) AS DECIMAL) AS isBallRate
	
	, MAX(P.startSpeed) AS MaxStartSpeed
	, MIN(P.startSpeed) AS MinStartSpeed
	, AVG(P.startSpeed) AS AvgStartSpeed

	, MAX(P.spinRate) AS MaxSpinRate
	, MIN(P.spinRate) AS MinSpinRate
	, AVG(P.spinRate) AS AvgSpinRate

	, MAX(P.spinDirection) AS MaxSpinDirection
	, MIN(P.spinDirection) AS MinSpinDirection
	, AVG(P.spinDirection) AS AvgSpinDirection

	-- , P.zone -- this would make a good pivot
FROM
	MLB.dbo.Pitch P 
	
	LEFT JOIN MLB.dbo.Player BAT	ON BAT.playerId = P.batterId
	LEFT JOIN MLB.dbo.Player PITCH  ON PITCH.playerId = P.pitcherId

	LEFT JOIN MLB.dbo.Team   PT		ON PT.teamId = PITCH.teamId
	LEFT JOIN MLB.dbo.Team   BT		ON BT.teamId = BAT.teamId

	LEFT JOIN #AtBatCount	 AB		ON AB.pitcherId = P.pitcherId
	
WHERE
	(P.pitcherId = @pitcherId		OR @pitcherId  IS NULL)
	AND (P.batterId = @batterId		OR @batterId   IS NULL)
	AND (BAT.bats = @batterHand	OR @batterHand IS NULL)
	AND (PITCH.throws = @pitcherHand OR @pitcherHand IS NULL)

GROUP BY
	  P.pitcherId
	, CONCAT(PITCH.lastName, ', ' , PITCH.firstName) --AS Pitcher
	, PT.fullName --AS pTeamName
	----
	, P.batterId
	, CONCAT(BAT.lastName, ', ', BAT.FirstName) --AS Batter
	, BT.fullName --AS bTeamName


	, P.typeCode 
ORDER BY
	  P.pitcherId
	, P.typeCode


	