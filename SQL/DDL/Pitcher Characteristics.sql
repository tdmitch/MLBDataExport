/*
	Pitcher Characteristics
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.PitcherCharacheristics(
	@pitcherId NVARCHAR(MAX)
)
AS

--DECLARE
--	@pitcherId NVARCHAR(MAX) =  NULL -- if null select all
	
SELECT
	  P.pitcherId
	, CONCAT(PL.lastName, ', ' , PL.firstName) AS Pitcher
	, P.typeCode 
	-- FC - Cutter
	-- FF - Fastball
	-- CU - ChangeUp
	-- FS - Splitter
	-- SL - Slider
	, COUNT(*) AS PitchesThrown
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
	LEFT JOIN MLB.dbo.Player PL ON PL.playerId = P.pitcherId
	
WHERE
	(P.pitcherId = @pitcherId OR @pitcherId IS NULL)
	--PL.lastName = 'Musgrove'
	--PL.lastName = 'Cobb'
	--PL.lastName = 'Winckowski'
GROUP BY
	  P.pitcherId
	, CONCAT(PL.lastName, ', ' , PL.firstName) --AS Pitcher
	, P.typeCode
ORDER BY
	  P.pitcherId
	, P.typeCode