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
USE [MLB];
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Paul Davis
-- Create date: <8/20/20>
-- Description:	<Loads Pitcher Batter Matchup Data>
-- =============================================
CREATE PROCEDURE [LOAD_fact.Matchup]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


	--Pitcher Batter Matchup
	SELECT 
		DISTINCT
		P.[gameId],
	--	ROW_NUMBER() OVER(PARTITION BY P.[gameId], P.[pitcherId], P.[BatterId], P.[atBatIndex] ORDER BY P.[gameId], p.[atBatIndex]) AS faceOffNumber,
		P.[pitcherId],
		P.[batterId],
		P.[atBatIndex]
	INTO 
		#matchup
	FROM
		[MLB].[dbo].[Pitch] P

	INSERT INTO
			[MLB].[fact].[Matchup]
	SELECT
		M.[gameId],
		ROW_NUMBER() OVER(PARTITION BY M.[gameId], M.[pitcherId], M.[BatterId] ORDER BY M.[gameId], M.[pitcherId], M.[atBatIndex]) AS faceOffNumber,
		M.[pitcherId],
		M.[batterId],
		M.[atBatIndex]

	FROM
		#matchup M
	ORDER BY
		M.[gameId],
		M.[PitcherId]

	DROP TABLE #matchup

END
GO
