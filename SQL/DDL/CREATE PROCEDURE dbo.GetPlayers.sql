SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Get Players

	2 Params 
	   - @pitcherOnly 
		pitchers only bit value returns only pitchers
		else all players are returned
	   - teamId
*/

ALTER PROCEDURE dbo.getPlayers(
	  @pitcherOnly NVARCHAR(2) = NULL
	, @teamId INT = NULL
)
AS

--DECLARE @pitcherOnly NVARCHAR(2) = NULL

SELECT
	  P.playerId
	, CONCAT(P.lastName, ', ' , P.firstName) AS fullName
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
	(P.primaryPosition = @pitcherOnly OR @pitcherOnly IS NULL)
	AND (P.teamId = @teamId OR @teamId IS NULL)
	