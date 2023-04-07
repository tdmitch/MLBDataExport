-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Paul Davis>
-- Create date: <Create Date,,04/06/2023>
-- Description:	<Description, Delete duplicate teams from the teams table>
-- =============================================
CREATE PROCEDURE DeleteDuplicateGames 

AS
BEGIN
	SET NOCOUNT ON;
	WITH [DuplicatesNumbered]
	AS (
		SELECT
			G.[GameId],
			ROW_NUMBER() OVER (PARTITION BY G.[GameId] ORDER BY G.[GameId]) AS [RowNumber]
		FROM
			[MLB].[dbo].[Game] G
	)
	DELETE [DuplicatesNumbered]
	WHERE [DuplicatesNumbered].[RowNumber] > 1;

END
GO
