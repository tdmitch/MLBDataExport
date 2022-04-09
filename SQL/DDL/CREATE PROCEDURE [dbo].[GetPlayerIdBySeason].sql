SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getPlayerIdBySeason] 
	@season INT
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

-- Insert statements for procedure here
-- GetPlayerIdBySeason
-- Returns all players 

-- all players Batters and Pitchers
SELECT
	P.playerId
	, SUM(P.isPitcher) AS isPitcher
FROM
	(
	-- Get Batters 1034
	SELECT
		DISTINCT
		P.batterId AS playerId
		, NULL AS isPitcher
	FROM
		MLB.dbo.Game G
		INNER JOIN MLB.dbo.Pitch P ON G.gameId = P.gameId
	WHERE
		G.season = @season
	UNION
	-- Get Pitchers 892
	SELECT
		DISTINCT
		P.pitcherId AS playerId
		, 1 AS isPitcher
	FROM
		MLB.dbo.Game G
		INNER JOIN MLB.dbo.Pitch P ON G.gameId = P.gameId
	WHERE
		G.season = @season
	) AS P
GROUP BY
	P.playerId
END
GO
