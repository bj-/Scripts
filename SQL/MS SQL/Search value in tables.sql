/****** Script for SelectTopNRows command from SSMS  ******/
USE [Shturman_Metro];

DECLARE @TblList nvarchar(1000);

/*

--COALESCE(
SELECT 	
		concat('SELECT [Guid] FROM ', [TABLE_NAME], 'WHERE [Guid] like ''%FFFFFFFFFF29''')AS [UnionSelect]
	FROM information_schema.tables;

--, ' UNION ', '')
--*/
/*
DECLARE @SearchString nvarchar(100);
set @SearchString = '%FFFFFFFFFF29%';

DECLARE @Names VARCHAR(8000) 
SELECT @Names = COALESCE(@Names + ' WHERE [Guid] like ''' + @SearchString + ''' UNION SELECT [Guid] FROM ', 'SELECT [Guid] FROM ') + [TABLE_NAME]
FROM information_schema.tables
WHERE [TABLE_NAME] IS NOT NULL;

set @Names = @Names + ' WHERE [Guid] like ''' + @SearchString + '''';

select @Names;
EXEC(@Names);
--*/

--------------------------

DECLARE @SearchString nvarchar(100);
DECLARE @SearchInColumn nvarchar(100);
SET @SearchString = '%FFFFFFFFFF29%';
SET @SearchInColumn = '%Guid%';

DECLARE @SearchQuery varchar(8000);

/*
--SELECT @SearchQuery = COALESCE(@SearchQuery + ' WHERE [Guid] like ''' + @SearchString + ''' UNION SELECT [Guid] FROM ', 'SELECT [Guid] FROM ') + [TABLE_NAME]
SELECT @SearchQuery = 
--COALESCE(@SearchQuery + ' WHERE ' + [COLUMN_NAME] + ' like ''' + @SearchString + ''' UNION SELECT [' + [COLUMN_NAME] + '] AS [SearchText] FROM ' + [TABLE_NAME], 'SELECT [' + [COLUMN_NAME] + '] AS [SearchText] FROM [' + [TABLE_NAME] + ']')
COALESCE(@SearchQuery + ' UNION SELECT [' + [COLUMN_NAME] + '] AS [SearchText] FROM [' + [TABLE_NAME] + '] WHERE [' + [COLUMN_NAME] + '] like ''' + @SearchString + '''', 
	'SELECT [' + [COLUMN_NAME] + '] AS [SearchText] FROM [' + [TABLE_NAME] + '] WHERE [' + [COLUMN_NAME] + '] like ''' + @SearchString + '''' 
	)
--*/

SELECT 
	TABLE_NAME, 
	COLUMN_NAME, 
--	exec('SELECT count(*) FROM [' + [TABLE_NAME] + '] WHERE [' + [COLUMN_NAME] + '] like ''', @SearchString, '''') AS [sss],
	concat('SELECT [', [COLUMN_NAME], '] AS [SearchText] FROM [', [TABLE_NAME], '] WHERE [', [COLUMN_NAME], '] like ''', @SearchString, '''') AS [Query],

	--(exec('SELECT count(*) FROM [', [TABLE_NAME], '] WHERE [', [COLUMN_NAME], '] like ''', @SearchString, ''''))
	NULL
	AS [Results] 
INTO #result
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE COLUMN_NAME LIKE @SearchInColumn;



--SELECT COLUMN_NAME, TABLE_NAME 
/*
SELECT @SearchQuery;
exec(@SearchQuery);
--*/

/*
CREATE TABLE #result(
  id      INT IDENTITY, -- just for register seek order
  tblName VARCHAR(255),
  colName VARCHAR(255),
  ResultRow  VARCHAR(1000)
)
go
--*/

/*
SELECT COLUMN_NAME AS [colName], TABLE_NAME AS [tblName]
INTO #result
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE COLUMN_NAME LIKE '%Guid%'

--*/
DECLARE @ttt nvarchar(200);

Print N'UPDATE #result SET [Results] = SELECT count(*) FROM #result';
--UPDATE #result SET [Results] = (SELECT count(*) FROM #result);

--'DECLARE @ttt nvarchar(200) SELECT TOP 1 @ttt = [query] FROM #result');

select @ttt;

select * from #result;

DROP TABLE #result;
--*/

--COALESCE(@Names + ', ', '')

/*
BEGIN
    CREATE TABLE dbo.My_Table (...)
END

SELECT [Guid]
	FROM [Persons]
	WHERE [Guid] like '%FFFFFFFFFF29'
UNION
SELECT [Guid]
	FROM [Users]
	WHERE [Guid] like '%FFFFFFFFFF29'


  --FFFFFFFF-FFFF-FFFF-0000-FFFFFFFFFF29

  --*/

/*
SELECT COLUMN_NAME, TABLE_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE COLUMN_NAME LIKE '%Guid%'

--*/