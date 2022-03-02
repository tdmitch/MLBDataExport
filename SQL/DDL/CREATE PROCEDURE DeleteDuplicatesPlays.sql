USE [MLB]
GO

/****** Object:  StoredProcedure [dbo].[DeleteDuplicates]    Script Date: 8/6/2020 4:34:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Paul Davis>
-- Create date: <Create Date,,08/06/2020>
-- Description:	<Description,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteDuplicatePlays] 

AS
BEGIN
	SET NOCOUNT ON;
	WITH [DuplicatesNumbered]
	AS (
		SELECT
			P.[PlayId],
			ROW_NUMBER() OVER (PARTITION BY P.[PlayId] ORDER BY P.[PlayId]) AS [RowNumber]
		FROM
			[MLB].[dbo].[Pitch] P
	)
	DELETE [DuplicatesNumbered]
	WHERE [DuplicatesNumbered].[RowNumber] > 1;

END
GO

EXEC [DeleteDuplicatePlays]


