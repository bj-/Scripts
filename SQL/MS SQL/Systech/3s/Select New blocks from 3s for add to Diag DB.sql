/*** Селект новых блоков на третьей линии для добавления в Shturman3Block */

USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'10.200.24.92', @srvproduct=N'SQL Server'

GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'rpc', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'rpc out', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'10.200.24.92', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
USE [master]
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'10.200.24.92', @locallogin = NULL , @useself = N'False', @rmtuser = N'sa', @rmtpassword = N'P@ssw0rd'
GO

-- Require to create linked server from .88 to .92

select 1, 'USE [Shturman3Diag]
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
LEFT JOIN [10.200.24.92].[Shturman3Diag].[dbo].[Servers] AS [s92] ON [s92].[Guid] = [s88].[Guid]
where Alias like 'STB%'
AND Alias NOT IN ('STB8888','STB2278')
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


