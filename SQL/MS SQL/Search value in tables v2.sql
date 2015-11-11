
DECLARE @SearchString nvarchar(100);
DECLARE @SearchInColumn nvarchar(100);
--DECLARE @ExistRows;
SET @SearchString = '%FFFF%';
SET @SearchInColumn = '%Guid%';


-- обьявляем курсор  
declare some_cursor cursor 
--- sql запрос любой сложности, формирующий набор данных для курсора 
for 
	SELECT 
		TABLE_NAME, 
		COLUMN_NAME, 
		concat('SELECT [', [COLUMN_NAME], '] AS [SearchText] FROM [', [TABLE_NAME], '] WHERE [', [COLUMN_NAME], '] like ''', @SearchString, '''') AS [Query]
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE COLUMN_NAME LIKE @SearchInColumn;

-- открываем курсор 
open some_cursor 
-- курсор создан, обьявляем переменные и обходим набор строк в цикле 
declare  @counter int 
declare  @TableName varchar(100), @ColName varchar(100), @sQuery varchar(500)
set @counter = 0 
-- выборка первой  строки 
fetch next from some_cursor INTO  @TableName, @ColName, @sQuery
-- цикл с логикой и выборкой всех последующих строк после первой 
while @@FETCH_STATUS = 0 
begin 
--- логика внутри цикла 
	set @counter = @counter + 1 
	if @counter >= 25 break  -- возможный код для проверки работы, прерываем после пятой итерации 


/*
declare @lstr varchar(200)
set @lstr = 'declare @word varchar(20) select top 1 @word = name from sysobjects select @word'
exec(@lstr) 
--*/
	DECLARE @ExistRows nvarchar(10)

	
--	exec('INSERT INTO @ExistRows select TOP 1 count(*) FROM [' + @TableName + '] WHERE [' + @ColName + '] like ''' + @SearchString + '''');
	--exec('select TOP 1 count(*) FROM [' + @TableName + '] WHERE [' + @ColName + '] like ''' + @SearchString + '''');
	--print N'update select TOP 1 @ExistRows = count(*) FROM [' + @TableName + '] WHERE [' + @ColName + '] like ''' + @SearchString + '''';
	exec('DECLARE @ExistRows nvarchar(100) select TOP 1 @ExistRows = count(*) FROM [' + @TableName + '] WHERE [' + @ColName + '] like ''' + @SearchString + '''');
	--set @ExistRows = EXEC('select count(*) FROM [' + @TableName + '] WHERE [' + @ColName + '] like ''' + @SearchString + '''');
	
	select @ExistRows;

	if @ExistRows >=0
		print N'fff '+ @sQuery;
	
--	DECLARE @ExistRows nvarchar(10) select TOP 1 @ExistRows = count(*) FROM [DriversSignals] WHERE [ServersGuid] like '%FFFF%'
	print @ExistRows
	
	/*
	-- отладочный select, на большом количестве строк выборка данных  в  sql server management studio может привести к ошибке переполнения памяти 
	SELECT @int_var, @string_var 
	INSERT INTO OTHER_TABLE (SOME_FIELD1, SOME_FIELD2) VALUES (@string_var, 'Мегастрока') 
	DELETE FROM OTHER_TABLE2 WHERE ID_FIELD =  @int_var 
	*/
	-- выборка следующей строки 
fetch next from some_cursor INTO  @TableName, @ColName, @sQuery
-- завершение логики внутри цикла 
end 
select @counter as final_count 

-- закрываем курсор 
close some_cursor 
deallocate some_cursor 
