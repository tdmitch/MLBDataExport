USE [MLB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Paul Davis>
-- Create date: <02/26/21>
-- Description:	<Returns a transformed data set designed to calculate some sabermeteric pitching stats - i hope
-- =============================================
/*	Pitcher Career Stats Summary
														-- Season '21 --	--Season '20 --		-- Season '19 --	-- Career --
		G    - Games
			Sum of games where pitches thrown> 0

		GS   - Games Started
			Sum of games where atBatIntex 0 pitcherId = @pitcherId

		IP   - Innings Pitched
			Count of innings where pitchesThrown > 0

		K/9  - Strikeouts per 9 innings
			Grain: Season 

		BB/9 - Walks per 9 innings
			Grain: Season

		K/BB - Strikeout to Walk Ratio
			Grain: Season
		HR/9 - Home Runs  per 9 innings
			Grain: Season

		K%   - Strikeout Percentage
			Grain: Season
		BB%  - Walk Percentage
			Grain: Season
		K%-BB% - Strikout Percentage - Walk Percentage
			Grain: Season

		WHIP - Walks Plus Hits per Innings Pitched
			Sum(Walks) + Sum(InningsPitched)

		BABIP - Batting Average on Balls in Play

	Pitcher Profile
		Hand - 
		G    - Games
		GS   - Games Started
		IP   - Innings Pitched

		Pitch Count
			Average
		
		Pitches								-- vs. LHB --		-- vs. RHB --
			Type - frequency (count) | % 
*/



--ALTER PROCEDURE [dbo].[GetPitcherSeasonSummary]
--	@Season NVARCHAR(MAX)
--	, @gameType NVARCHAR(MAX)

--AS

BEGIN

DECLARE 
	@Season NVARCHAR(MAX) = '2021'
	, @gameType NVARCHAR(MAX) = 'S'

SELECT
	 T1.[season]
	,T1.[league]
	,T1.[division]
	,T1.[TeamName]
	,T1.[playerId]
	,T1.[PitcherFirstName]
	,T1.[PitcherLastName]

	,MAX(T1.[GamesPitched]) AS [GamesPitchedSeason]
	,SUM(T1.[IsStart]) AS [GamesStarted]
	,MAX(T1.[InningsPitchedSeason]) AS [InningsPitched]
	,MAX(T1.[BattersFacedSeason]) AS [BattersFaced]

	,SUM(T1.[isStrikeOut]) AS [Strikeouts]
	,SUM(T1.[IsWalk]) AS [Walks]
	,SUM(T1.[IsHomeRun]) AS [HomeRuns]

	--AS [InningsPitched]
	,ROUND(MAX(T1.[InningsPitchedSeason]) / CONVERT(decimal(5,2),9),2)  AS [InningsPitched/9]		
	-- K/9
	,ROUND(SUM(T1.[isStrikeOut]) /(MAX(T1.[InningsPitchedSeason]) / CONVERT(decimal(5,2),9)),2) AS [K/9]
	-- BB/9
	,ROUND(SUM(T1.[isWalk]) /(MAX(T1.[InningsPitchedSeason]) / CONVERT(decimal(5,2),9)),2) AS [BB/9]
	-- K/BB
	,SUM(T1.[isStrikeOut])/CONVERT(decimal(5,2),NULLIF(SUM(T1.[isWalk]),0)) AS [K/BB]
	-- HR/9
	,ROUND(SUM(T1.[isHomeRun]) / (MAX(T1.[InningsPitchedSeason]) / CONVERT(decimal(5,2),9)),2) AS [HR/9]
	-- K%
	, SUM(T1.[isStrikeOut]) / CONVERT(decimal(5,2),MAX(T1.[BattersFacedSeason])) AS [K%]
	-- BB%
	, SUM(T1.[isWalk]) / CONVERT(decimal(5,2),MAX(T1.[BattersFacedSeason])) AS [BB%]
	-- K% - BB%

	--,T1.*
FROM
	(
	SELECT
		 G.[season]
		,PT.[name]	AS [TeamName]
		,PT.[league]
		,PT.[division]
		,PIT.[playerId]
		,PIT.[lastName] AS [PitcherLastName]
		,PIT.[firstName] AS [PitcherFirstName]
		,PIT.[jerseyNumber]
		,PA.[pitchHand]
		,PA.[GameId]
		,G.[homeTeam]
		,HT.[name] AS [HomeTeamName]
		,G.[awayTeam]
		,AT.[name] AS [AwayTeamName]
		,PA.[halfInning]
		,PA.[inning]
		,PA.[atBatIndex]
		,PA.[batterId]	
		,BAT.[firstName] AS [BatterFirstName]
		,BAT.[lastName] AS [BatterLastName]
		,PA.[batSide]
		, PA.[eventType]
		, PA.[event]

		, ' ' AS [space]

		-- Window Function
		-- take the max of this field
		, DENSE_RANK() OVER(PARTITION BY G.[Season], PIT.[playerId] ORDER BY G.[GameId]) AS [GamesPitched]

		--Sum this field
		, IIF(PA.[atBatIndex] = 0, 1, 0) AS [isStart]

		--innings pitched season 
		, DENSE_RANK() OVER(PARTITION BY G.[Season], PIT.[playerId] ORDER BY  PA.[GameId], PA.[inning]) AS [InningsPitchedSeason]

		--innings pitched game 
		, DENSE_RANK() OVER(PARTITION BY G.[Season], PIT.[playerId], PA.[GameId] ORDER BY PA.[inning]) AS [InningsPitchedGame]

		-- take the max of these fields
		, COUNT(PA.[GameId]) OVER(PARTITION BY G.[Season], PIT.[playerId]) AS [BattersFacedSeason]
		, COUNT(PA.[GameId]) OVER(PARTITION BY G.[Season], PIT.[playerId], PA.[GameId]) AS [BattersFacedGame]
		, COUNT(PA.[GameId]) OVER(PARTITION BY G.[Season], PIT.[playerId], PA.[GameId], PA.[inning]) AS [BattersFacedInning]

		, CASE WHEN PA.[event] = 'Strikeout' THEN 1 ELSE 0 END AS [isStrikeOut] 
		, CASE WHEN PA.[event] = 'Walk' THEN 1 ELSE 0 END AS [isWalk]
		, CASE WHEN PA.[event] = 'Home Run' THEN 1 ELSE 0 END AS [isHomeRun]


	
	--G    - Games
	--GS   - Games Started
	--IP   - Innings Pitched 
		--	** NOTE **
		-- This could be some wierd logic - lookup how this is technically supposed to be calculated. Is it based on outs? An inning in 3rds?
	
	FROM
		[MLB].[dbo].[Player] PIT -- Pitcher

		LEFT JOIN [MLB].[dbo].[PlateAppearance] PA ON PIT.[playerId] = PA.[pitcherId]

		LEFT JOIN [MLB].[dbo].[Game] G ON PA.[GameId] = G.[gameId]					-- Game

		LEFT JOIN [MLB].[dbo].[Player] BAT ON PA.[batterId] = BAT.[playerId]		-- Batter

		LEFT JOIN [MLB].[dbo].[Team] HT ON G.[homeTeam] = HT.[teamId]				-- Home Team
		
		LEFT JOIN [MLB].[dbo].[Team] AT ON G.[awayTeam] = AT.teamId					-- Away Team

		LEFT JOIN [MLB].[dbo].[Team] PT ON PIT.[teamId] = PT.[teamId]				-- Pitcher Team

		LEFT JOIN [MLB].[dbo].[Team] BT ON BAT.teamId = BT.[teamId]					-- Batter Team
		
	WHERE
		PIT.[primaryPosition] = '1' -- player is a pitcher
			AND G.[season] IN(@Season)
			AND G.gameType IN(@gameType)--Regular Season
		--TEST

		AND PIT.[playerId] = '669214'
		--AND BAT.[playerId] = '605141'
		--AND G.[gameId] = '567112'

	) AS T1

	GROUP BY
	 T1.[season]
	,T1.[league]
	,T1.[division]
	,T1.[TeamName]
	,T1.[playerId]
	,T1.[PitcherFirstName]
	,T1.[PitcherLastName]

	ORDER BY
		T1.season
		, T1.[league]
		, T1.[division]
		, T1.[TeamName]
		, T1.[PitcherLastName]

		



		

END
GO


