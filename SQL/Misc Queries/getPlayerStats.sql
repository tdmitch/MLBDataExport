/*
	TODO
		-get position names for primary positions and make a [dbo]
*/

--PARAMS
DECLARE
	 @season INT = 2020
	,@playerID INT = 543105 

SELECT
--	 PA.GameId
	PA.batterId
	,PL.[firstName]
	,PL.[lastName]
	,PA.*
--	,COUNT(PA.[atBatIndex]) AS [countPlateAppearances]

FROM
	[dbo].[PlateAppearance] PA
	
	INNER JOIN [dbo].[Game] G ON
		PA.[GameId] = G.[GameId]
		AND G.[detailedState] = 'Final'
		
	LEFT JOIN [dbo].[Player] PL ON
		PA.[batterId] = PL.[playerId]

WHERE	
	G.season = @season
	AND PA.[batterId] = @playerID
--GROUP BY
--	-- PA.GameId
--	PA.batterId
--	,PL.[firstName]
--	,PL.[lastName]