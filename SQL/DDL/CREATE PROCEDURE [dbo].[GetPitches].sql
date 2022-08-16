-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC dbo.getPitches 2021

--ALTER PROCEDURE getPitches(
--	@Season INT
--)
--AS
DECLARE 
	@Season INT = 2021
SELECT
	  P.playId
	, P.atBatIndex
	, P.pitchNumber
	, P.pitcherId
	, P.batterId
	, P.typeCode
	, P.isInPlay
	, P.isStrike
	, P.isBall
	, P.countBalls
	, P.countStrikes
	, P.startSpeed
	, P.zone
	, P.spinRate
	, P.spinDirection
	, P.trajectory
	, P.totalDistance
	, P.hardness
	, P.location
	, P.callCode  
		-- F - Foul Ball
		-- B - Ball
		-- *B - Called Ball in Strike Zone?
		-- C - Called Strike
		-- ? - Swinging Strike
		-- D - Double
		-- X Out
FROM
	MLB.dbo.Pitch P
	INNER JOIN MLB.dbo.Game G ON G.gameId = P.gameId
WHERE
	G.season = @Season

	AND G.gameId = 634474
	AND P.atBatIndex = 1

ORDER BY
	P.pitchNumber
GO
