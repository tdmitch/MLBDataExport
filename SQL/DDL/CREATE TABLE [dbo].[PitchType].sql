USE MLBData
GO

--https://www.kaggle.com/pschale/mlb-pitch-data-20152018

CREATE TABLE [dbo].[PitchType](
	code varchar(5),
	description varchar(25)
)

INSERT INTO [dbo].[PitchType]
VALUES
	 ('FF', 'Four-Seam Fastball')
	,('KC', 'Knuckle Curve') 
	,('KN', 'Knuckeball')
	,('SL', 'Slider')
	,('EP', 'Eephus')
	,('CU', 'Curveball')
	,('SI', 'Sinker')
	,('CH', 'Changeup')
	,('FC', 'Cutter')
	,('FT', 'Two-seam Fastball')
	,('FS', 'Splitter')
	,('FO', 'Pitchout (also PO)*')
	--Not present in the 2019 R Season Dataset
	,('PO', 'Pitchout (also FO)*')
	,('SC', 'Screwball*')
	,('UN', 'Unknown*')
	,('IN', 'Intentional ball')

 --SELECT	* FROM [dbo].[PitchType]