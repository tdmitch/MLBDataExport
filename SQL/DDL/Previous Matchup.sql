/*
	Previous Matchups Stored Procedure
*/

DECLARE
	  @pitcherId NVARCHAR(MAX) = 621107
	, @batterId NVARCHAR(MAX) = 502671

SELECT
	  G.season
	, G.gameDate
	
	--, P.playId
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

	, HT.fullName AS HomeTeam
	, AT.fullName AS AwayTeam
	
	, CONCAT(PITCH.lastName, ', ' , PITCH.firstName) AS Pitcher
	, CONCAT(BAT.LastName, ', ', BAT.FirstName) AS Batter

FROM
	MLB.dbo.Pitch P
	LEFT JOIN MLB.dbo.Player BAT ON BAT.playerId = P.batterId
	LEFT JOIN MLB.dbo.Player PITCH ON PITCH.playerId = P.pitcherId
	LEFT JOIN MLB.dbo.Game G ON G.GameId = P.gameId
	LEFT JOIN MLB.dbo.Team HT ON HT.teamId = G.homeTeam
	LEFT JOIN MLB.dbo.Team AT ON AT.teamId = G.awayTeam

WHERE
	P.batterId = @batterId
	AND P.pitcherId = @pitcherId
ORDER BY
	  G.gameDate
	, G.gameId
	, P.atBatIndex
	, P.pitchNumber

