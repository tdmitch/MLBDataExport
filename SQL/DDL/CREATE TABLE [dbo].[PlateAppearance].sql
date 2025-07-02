USE MLBData
GO


CREATE TABLE [dbo].[PlateAppearance](
	[GameId] INT,
	[halfInning] NVARCHAR(7),
	[inning] INT,
	[atBatIndex] INT,
	[pitcherId] INT,
	[pitchHand] NVARCHAR(2),
	[batterId] INT,
	[batSide] NVARCHAR(2),
	[startTime] DATETIME,
	[endTime] DATETIME,
	[isScoringPlay] NVARCHAR(6),
	[resultType] NVARCHAR(25),
	[event] NVARCHAR(50),
	[eventType] NVARCHAR(50),
	[rbi] INT,
	[awayScore] INT,
	[homeScore] INT

) ON [PRIMARY]