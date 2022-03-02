SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE getPlateAppearancesByPlayer
	@playerID INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	*
	FROM
		[dbo].[PlateAppearance] PA 
	WHERE
		PA.[batterId] = @playerID
END
GO
