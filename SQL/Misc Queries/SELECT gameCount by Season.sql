USE [MLB];
GO

INSERT INTO 
	[MLB].[fact].[Season]
	SELECT DISTINCT
		G.[Season],
		G.[gameType],
		COUNT(G.[gameId]) OVER (PARTITION BY G.[season], G.[gameType]) AS [gameCount]

	FROM
		Game [G]	

	ORDER BY G.[Season]
GO