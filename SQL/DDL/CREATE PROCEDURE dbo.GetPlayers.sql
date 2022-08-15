SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Get Players

	1 Param 

	pitchers only bit value returns only pitchers
	else all players are returned
*/

CREATE PROCEDURE dbo.getPlayers(
	@playerType CHAR = NULL
)
AS

--DECLARE @pitcherOnly NVARCHAR(2) = NULL

SELECT
	  P.playerId
	, P.firstName
	, P.lastName
	, P.jerseyNumber
	, P.weight
	, P.heightFeet
	, P.heightInches
	, P.teamId
	, P.throws
	, P.bats
	, P.primaryPosition
FROM
	dbo.Player P 
WHERE
	P.primaryPosition = @pitcherOnly OR @pitcherOnly IS NULL
	