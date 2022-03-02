USE [MLB]
DROP TABLE [MLB].[dbo].Pitch
CREATE TABLE [MLB].[dbo].[Pitch](
	[playId] varchar(100) NOT NULL,
	[gameId] int NOT NULL,			--6 digits long
	[pitcherId] int,				--6 digits long
	[batterId] int,
	[atBatIndex] int,
	[pitchNumber] int,	
	--details
	[isInPlay] varchar(10),
	[isStrike] varchar(10),
	[isBall] varchar(10),
	[callCode] varchar(10),
	[typeCode] varchar(10),
	--count
	[countBalls] int,
	[countStrikes] int,
	--pitchData
	[startSpeed] decimal(7,2),
	[endSpeed] decimal(7,2),
	[strikeZoneTop] decimal(7,2),
	[strikeZoneBottom] decimal(7,2),
	--pitchData coordinates
	[aY] decimal(7,2),
	[aZ] decimal(7,2),
	[pfxX] decimal(7,2),
	[pfxZ] decimal(7,2),
	[pX] decimal(7,2),
	[pZ] decimal(7,2),
	[vX0] decimal(7,2),
	[vY0] decimal(7,2),
	[vZ0] decimal(7,2),
	[x] decimal(7,2),
	[y] decimal(7,2),
	[x0] decimal(7,2),
	[y0] decimal(7,2),
	[z0] decimal(7,2),
	[aX] decimal(7,2),
	--breaks
	[breakAngle] decimal(7,2),
	[breakLength] decimal(7,2),
	[breakY] decimal(7,2),
	[spinRate] decimal(7,2),
	[spinDirection] decimal(7,2),
	[zone] int,
	[plateTime] decimal(7,2),
	--hit Data
	[launchSpeed] decimal(7,2),
	[launchAngle] decimal(7,2),
	[totalDistance] int,
	[trajectory] varchar(50),
	[hardness] varchar(50),
	[location] varchar(10),
	--hit Coordinates
	[coordX] decimal(7,2),
	[coordY] decimal(7,2),


) ON [PRIMARY]