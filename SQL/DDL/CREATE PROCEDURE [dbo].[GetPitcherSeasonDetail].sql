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



--ALTER PROCEDURE [dbo].[GetPitcherSeasonDetail]
--	  @Season NVARCHAR(MAX)
--	, @gameType NVARCHAR(MAX)

--AS

BEGIN

DECLARE 
	@Season NVARCHAR(MAX) = '2021'
	, @gameType NVARCHAR(MAX) = 'S'

SELECT
	 PIT.[playerId]
	,PIT.[firstName] AS [PitcherFirstName]
	,PIT.[lastName] AS [PitcherLastName]
	,PA.[pitchHand]
	,G.[season]
	,PA.[GameId]
	,G.[homeTeam]
	,HT.[name]
	,G.[awayTeam]
	,AT.[name]
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
		
WHERE
	PIT.[primaryPosition] = '1' -- player is a pitcher
		AND G.[season] IN(@Season)
		AND G.gameType IN(@gameType) --Regular Season
	
	-- TEST --
	AND PIT.[playerId] = '669214'

ORDER BY 
	PIT.[playerId]
	,PA.[GameId]	
	,PA.[atBatIndex]

	
END
GO


