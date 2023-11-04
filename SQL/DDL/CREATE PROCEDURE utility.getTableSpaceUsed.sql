USE MLB
GO
/*
	paul davis
	11/04/2023

	get the space used for each database tabe
*/
CREATE PROCEDURE utility.getTableSpaceUsed
AS
BEGIN
DECLARE
	  @dbName			NVARCHAR(50) = (SELECT DB_NAME())
	, @tableName		NVARCHAR(50) = NULL
	, @tableShortName	NVARCHAR(50) = NULL

DROP TABLE IF EXISTS #Results
CREATE TABLE #Results(
	  name		nvarchar(50)
	, rows		bigint
	, reserved  nvarchar(50)
	, data		nvarchar(50)
	, indexSize nvarchar(50)
	, unused	nvarchar(50)
	
)

DECLARE tableCursor CURSOR FOR 
SELECT	  
	    CONCAT(SCHEMA_NAME(T.schema_id) , '.', T.name)	tableName
	  , T.Name											tableShortName
FROM
	sys.tables T
ORDER BY
	  SCHEMA_NAME(T.schema_id) -- schemaName
	, T.name					-- tableName

OPEN tableCursor
FETCH NEXT FROM tableCursor 
INTO @tableName, @tableShortName

WHILE @@FETCH_STATUS = 0
BEGIN		
	INSERT INTO #Results
	EXEC sp_spaceused @tableName
	
	UPDATE #Results
	SET name = @tableName
	WHERE @tableShortName = name

	FETCH NEXT FROM tableCursor 
	INTO @tableName, @tableShortName
END

SELECT
	*
FROM
	#RESULTS

CLOSE tableCursor
DEALLOCATE tableCursor

END