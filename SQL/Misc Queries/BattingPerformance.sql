DECLARE
	  @TeamName NVARCHAR(25) = 'Giants'
	, @Season INT = 2020

SELECT
	T.[name]
	,G.gameId
	,G.[gameDate]
	,PL.[playerId]
	,PL.[firstName]
	,PL.[lastName]

	,GB.*

FROM
	dbo.[Team] T

	LEFT JOIN dbo.[Player] PL ON
	T.[teamId] = PL.[teamId]

	LEFT JOIN fact.[GameBatter] GB ON
	PL.[playerId] = GB.[batterId]

	LEFT JOIN dbo.[Game] G ON
	GB.[gameID] = G.[gameId]

WHERE
	--T.[name] = @TeamName
	--AND 
	G.[season] = @Season

--GROUP BY
--	 T.[name]
--	,G.gameId
--	,G.[gameDate]
--	,PL.[playerId]
--	,PL.[firstName]
--	,PL.[lastName]
	
ORDER BY
	G.[gameDate]