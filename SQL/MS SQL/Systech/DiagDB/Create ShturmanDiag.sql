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
           ('spbMetro3thLine','��� ����� 3-� �����',NULL),
           ('spbMetro4thLine','��� ����� 4-� �����',NULL),
           ('rzdNordRoad','��� ��������� ������',NULL),
           ('MosGorTrans','�����������',NULL)
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
           ('Olimex','Olimex','������������ Olimex � Linux'),
           ('Win','Windows Pad','������� � Windows'),
           ('LinuxPad','Linux Pad','������� � Linux'),
           ('Sh3','Shturman 3','������ �� ���� ������� 3'),
           ('Sh4','Shturman 4','������ �� ���� ������� 4')
GO
