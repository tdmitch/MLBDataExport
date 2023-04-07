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
-- Create date: <Create Date,,08/06/2020>
-- Description:	<Description,>
-- =============================================
CREATE PROCEDURE DeleteDuplicateTeams

AS
BEGIN
	SET NOCOUNT ON;
	WITH [DuplicatesNumbered]
	AS (
		SELECT
			T.teamId
			, ROW_NUMBER() OVER (PARTITION BY T.[TeamId] ORDER BY T.TeamId) AS [RowNumber]
		FROM
			[MLB].[dbo].[Team] T
	)
	DELETE [DuplicatesNumbered]
	WHERE [DuplicatesNumbered].[RowNumber] > 1;

END
GO
