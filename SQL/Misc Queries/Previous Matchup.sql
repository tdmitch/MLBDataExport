USE MLBData
GO


DECLARE
	    @pitcherId NVARCHAR(MAX) = 657277 -- NULL -- if null select all
	  , @batterId NVARCHAR(MAX) = NULL

SELECT
	  G.season
	, G.gameDate
	
	--, P.playId
	, P.atBatIndex
	, P.pitchNumber
	, P.pitcherId
	, CONCAT(PITCH.lastName, ', ' , PITCH.firstName) AS PitcherName
	, PITCH.throws AS throwingHand
	, P.batterId
	, CONCAT(BAT.lastName, ', ' , BAT.firstName) AS BatterName
	, BAT.bats AS battingHand
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
	LEFT JOIN MLB.dbo.Player BAT	ON BAT.playerId = P.batterId
	LEFT JOIN MLB.dbo.Player PITCH  ON PITCH.playerId = P.pitcherId
	LEFT JOIN MLB.dbo.Game	 G		ON G.GameId = P.gameId
	LEFT JOIN MLB.dbo.Team   HT		ON HT.teamId = G.homeTeam
	LEFT JOIN MLB.dbo.Team   AT		ON AT.teamId = G.awayTeam

WHERE
	(P.pitcherId = @pitcherId OR @pitcherId IS NULL)
	AND (P.batterId = @batterId or @batterId IS NULL)

ORDER BY
	  G.gameDate
	, G.gameId
	, P.atBatIndex
	, P.pitchNumber

