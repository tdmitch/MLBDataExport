USE [MLB]
GO

/****** Object:  StoredProcedure [dbo].[DeleteDuplicates]    Script Date: 9/11/2020 4:55:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Paul Davis>
-- Create date: <Create Date,,08/06/2020>
-- Description:	<Description,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteDuplicatePlayers] 

AS
BEGIN
	SET NOCOUNT ON;
	WITH [DuplicatesNumbered]
	AS (
		SELECT
			P.[playerId],
			ROW_NUMBER() OVER (PARTITION BY P.[playerId] ORDER BY P.[playerId]) AS [RowNumber]
		FROM
			[MLB].[dbo].[player] P
	)
	DELETE [DuplicatesNumbered]
	WHERE [DuplicatesNumbered].[RowNumber] > 1;

END
GO


