USE [MLB]

CREATE TABLE [MLB].[fact].[Matchup](

	[gameId] INT,
	faceOffNumber INT ,
	[pitcherId] INT,
	[batterId] INT,
	[atBatIndex] INT
	
) ON [PRIMARY] -- this has something to do with where the data is stored - file group

