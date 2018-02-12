/*** Селект новых блоков на третьей линии для добавления в Shturman3Block */

select 1, 'USE [Shturman3Block]
GO

INSERT INTO [dbo].[Servers]
           ([Guid],[BlockSerialNo],[IpAddress],[ServerType_Guid])
     VALUES
	 '
union
SELECT 2,
	CONCAT('(''', [s88].[Guid], ''', ''',  [s88].[Alias], ''', ''',  [s88].[IpAddress], ''', ''F2585ED4-8D03-4E82-A895-3982E93B860C''),')
	--,[s88].[Guid]
      --,[s88].[Alias]
	  --,[s92].[Guid]
      --,[s92].[BlockSerialNo]
FROM [Shturman3].[dbo].[Servers] AS [s88]
LEFT JOIN [10.200.24.92].[Shturman3Block].[dbo].[Servers] AS [s92] ON [s92].[Guid] = [s88].[Guid]
where Alias like 'STB%'
AND Alias NOT IN ('STB8888','STB9999')
AND Alias NOT LIKE ('STB000%')
AND [s92].[BlockSerialNo] IS NULL
--ORDER BY Alias ASC
union
SELECT 3, 'GO'
ORDER BY 1 ASC

USE [master]
GO

/****** Object:  LinkedServer [10.200.24.92]    Script Date: 16.01.2018 13:51:51 ******/
EXEC master.dbo.sp_dropserver @server=N'10.200.24.92', @droplogins='droplogins'
GO


