INSERT INTO [MLB].[fact].[GamePitcher] 
	SELECT
		*
	FROM
		(
		SELECT DISTINCT
			 PA.[GameId]
			--,PA.[batterId]
			,PA.[pitcherId]
			,E.[event]
			,E.[isOnBase]
	--		,COUNT(PA.[atBatIndex]) as [countAtBat]
		FROM
			dbo.[PlateAppearance] PA

			LEFT JOIN dbo.[Event] E ON
				PA.[event] = E.[event]
		
		--WHERE
		--	PA.[batterId] = 543105
		--	AND PA.[GameId] = 566508
		) t

		PIVOT
		(
			SUM([isOnBase])
			FOR [event] IN ([Single], [Double], [Triple], [Home Run], [Walk],[Intent Walk],[Catcher Interference], [Hit By Pitch] )
		) AS PivotTable
	




