USE [MLB]
-- DROP TABLE [MLB].[dbo].Pitch
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
	-- ax, ay, az: the acceleration of the pitch, in feet per second per second, in three dimensions, measured at the initial point.
	-- https://fastballs.wordpress.com/category/pitchfx-glossary/
	
	[aY] decimal(7,2),
	[aZ] decimal(7,2),
	-- pfx_x: the horizontal movement, in inches, of the pitch between the release point and home plate, 
	-- as compared to a theoretical pitch thrown at the same speed with no spin-induced movement. 
	-- This parameter is measured at y=40 feet regardless of the y0 value.
	[pfxX] decimal(7,2),
	--pfx_z: the vertical movement, in inches, of the pitch between the release point and home plate, 
	-- as compared to a theoretical pitch thrown at the same speed with no spin-induced movement. 
	-- This parameter is measured at y=40 feet regardless of the y0 value.
	[pfxZ] decimal(7,2),
	-- px: the left/right distance, in feet, of the pitch from the middle of the plate as it crossed home plate. 
	-- The PITCHf/x coordinate system is oriented to the catcher’s/umpire’s perspective, with distances to the right being positive and to the left being negative.
	[pX] decimal(7,2),
	-- the height of the pitch in feet as it crossed the front of home plate.
	[pZ] decimal(7,2),

	[vX0] decimal(7,2),
	[vY0] decimal(7,2),
	[vZ0] decimal(7,2),

	[x] decimal(7,2),
	[y] decimal(7,2),
	-- the left/right distance, in feet, of the pitch, measured at the initial point.
	-- to me this is pitcher's release point in x (horizontal) axis
	[x0] decimal(7,2),
	-- y0: the distance in feet from home plate where the PITCHf/x system is set to measure the initial parameters. This parameter has been variously set at 40, 50, or 55 feet (and in a few instances 45 feet) from the plate at different times throughout the 2007 season as Sportvision experiments with optimal settings for the PITCHf/x measurements. Sportvision settled on 50 feet in the second half of 2007, and this value of y0=50 feet has been used since. Changes in this parameter impact the values of all other parameters measured at the release point, such as start_speed.
	[y0] decimal(7,2),
	-- z0: the height, in feet, of the pitch, measured at the initial point.
	-- this is the vertical release point
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