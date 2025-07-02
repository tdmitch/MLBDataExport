DELETE [Pitch]
FROM
[Pitch]
INNER JOIN [Game] ON [Game].[GameId] = [Pitch].[GameId]

WHERE
	[Game].[Season] IN(2016,2017)
	