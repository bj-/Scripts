USE [ShturmanDiag]
GO

/****** Object:  Table [dbo].[Clients]    Script Date: 11.02.2019 9:33:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE [dbo].[Clients]
CREATE TABLE [dbo].[Clients](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL
) ON [PRIMARY]

GO
INSERT INTO [dbo].[Clients]([Code],[Name],[Description])
     VALUES
           ('spbMetro3thLine','СПб Метро 3-я линия',NULL),
           ('spbMetro4thLine','СПб Метро 4-я линия',NULL),
           ('rzdNordRoad','РЖД Севераная дорога',NULL),
           ('MosGorTrans','Мосгортранс',NULL)
GO

-----------------------------------------------
DROP TABLE [dbo].[Server_Types]
CREATE TABLE [dbo].[Server_Types](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL
) ON [PRIMARY]

GO
INSERT INTO [dbo].[Server_Types]([Code],[Name],[Description])
     VALUES
           ('Olimex','Olimex','Одноплатиник Olimex с Linux'),
           ('Win','Windows Pad','Планшет с Windows'),
           ('LinuxPad','Linux Pad','Планшет с Linux'),
           ('Sh3','Shturman 3','Сервер на базе Штурман 3'),
           ('Sh4','Shturman 4','Сервер на базе Штурман 4')
GO
