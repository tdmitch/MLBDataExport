USE MLB
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
	paul davis
	04/09/2022

	Get the unique list of teams from the Team table
	Use for parameters in reports etc.
*/
ALTER PROCEDURE dbo.GetTeams
AS
SELECT
	T.teamId
	, T.fullName
	, T.name
FROM
	dbo.Team T
ORDER BY
	T.fullName