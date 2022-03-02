USE [MLB]
GO

/****** Object:  StoredProcedure [dbo].[LOAD_fact.Season]    Script Date: 8/20/2020 3:03:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Paul Davis>
-- Create date: <08/20/20>
-- Description:	<Loads the season table with fact values>
-- =============================================
ALTER PROCEDURE [dbo].[LOAD_fact.Season]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    TRUNCATE TABLE [fact].[Season]
	INSERT INTO 
	[MLB].[fact].[Season]
	SELECT DISTINCT
		G.[Season],
		G.[gameType],
		COUNT(G.[gameId]) OVER (PARTITION BY G.[season], G.[gameType]) AS [gameCount]
	FROM
		Game [G]	

	WHERE
		G.[detailedState] NOT IN ('Postponed', 'Cancelled')
	ORDER BY G.[Season]
END
GO


