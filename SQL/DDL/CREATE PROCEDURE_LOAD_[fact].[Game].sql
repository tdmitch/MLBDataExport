USE [MLB]
GO

/****** Object:  StoredProcedure [dbo].[LOAD_fact.Game]    Script Date: 8/20/2020 12:35:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Paul Davis>
-- Create date: <08/20/20>
-- Description:	<Loads the fact.Game table with data>
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_fact.Game]
--	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--TRUNCATE TABLE [fact].[Game]
	INSERT INTO 
		[MLB].[fact].[Game]
	SELECT
		G.[gameId],
		G.[gameDate],
		NULL AS homeTeamId,
		NULL AS awayTeamID,
		MAX(P.[atBatIndex]) AS totalPlateAppearances,
		COUNT(P.[playId]) AS totalPitches --**NOTE* if any of these plays are not pitch plays (like how is a pick off attempt logged?) it will throw off the count
	FROM
		[MLB].[dbo].[Game] G

		LEFT JOIN [MLB].[dbo].[Pitch] P ON
			P.gameId = G.[gameId]
	GROUP BY
		G.[gameId],
		G.[gameDate]
END
GO


