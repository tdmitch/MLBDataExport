USE MLB
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
	paul davis
	04/09/2022

	Get the unique list of seasons from the Game table
	Use for parameters in reports etc.
*/
CREATE PROCEDURE dbo.GetSeasons
AS
SELECT
	DISTINCT
	G.season
FROM
	dbo.Game G