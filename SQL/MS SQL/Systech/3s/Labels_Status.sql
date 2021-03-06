/****** Состояние меток станций  ******/
SELECT
	[sl].[Guid],
	--[sl].[Stations_Guid],
	[l].[Line_Number],
	[l].[Name] AS [Line_Name],
	[st].[Name] AS [Station_Name],
	[sn].[SerialNo],
	[sn].[Name],
	[sn].[MacAddress],
	[sn].[FW_Version],
	[sn].[Battery_Level],
	--[sn].[Battery_Time],
	FORMAT([sn].[Battery_Time], 'dd.MM.yyy') AS [Battery_Time],
	DATEDIFF(day,[sn].[Battery_Time], SYSUTCDATETIME() ) AS [Battery_Time_DayAgo],
	--[sn].[Activity], -- Поле не заполняется
	--FORMAT([sn].[Activity], 'dd.MM.yyy') AS [Activity],
	--DATEDIFF(day,[sn].[Activity], SYSUTCDATETIME() ) AS [Activity_DayAgo],
	--(SELECT TOP 1 MAX([Happend]) FROM [Events_Sensors_1] AS [es1] WHERE [sl].[Guid] = [es1].[Sensors_Guid]) AS [Last_WeekActivity],
	--FORMAT((SELECT TOP 1 MAX([Happend]) FROM [Events_Sensors_1] AS [es1] WHERE [sl].[Guid] = [es1].[Sensors_Guid]), 'dd.MM.yyy') AS [ActivityInWeek],
	IIF (DATEDIFF(day,(SELECT TOP 1 MAX([Happend]) FROM [Events_Sensors_1] AS [es1] WHERE [sl].[Guid] = [es1].[Sensors_Guid]), SYSUTCDATETIME() ) IS NOT NULL, '1', NULL) AS [Activity_AtLastWeek],
	--[st].Lines_Guid--
	[st].[OrderNo] AS [Station_OrderNo],
	[st].[Stations_Types_Id] AS [Station_Types_Id],  
	IIF ([st].[Stations_Types_Id] = 1, 
		IIF ([l].[Line_Number] = 4, 
			IIF ([sl].[WayNo] = 1, 
				'Спасская', 
				IIF ([sl].[WayNo] = 2, 'Дыбенко', NULL )
				), 
			IIF ([l].[Line_Number] = 3, 
				IIF ([sl].[WayNo] = 1, 
					'Рыбацкое', 
					IIF ([sl].[WayNo] = 2, 'Беговая', NULL )
					), 
				NULL
				)
			), 
			NULL
		) AS [Way_Direction],
	[sl].[WayNo],
	[sl].[TxPwr],
	[sl].[TxPwr_Required],
	--[sl].[TxPwr_Changed],
	FORMAT([sl].[TxPwr_Changed], 'dd.MM.yyy') AS [TxPwr_Changed]
FROM [Sensors_Labels] AS [sl]
LEFT JOIN [Stations] AS [st] ON [st].[Guid] = [sl].[Stations_Guid]
LEFT JOIN [Lines] AS [l] ON [l].[Guid] = [st].[Lines_Guid]
LEFT JOIN [Sensors] AS [sn] ON [sn].[Guid] = [sl].[Guid]
--LEFT JOIN [Events_Sensors_1] AS [es1] ON [es1].[Sensors_Guid] = [sl].[Guid]
WHERE 1=1
	AND [l].[Name] IS NOT NULL
	AND [sn].[FW_Version] IS NOT NULL
	--AND [l].[Line_Number] = 3
	--[sl].[TxPwr] = 5
ORDER BY 
	[st].[Stations_Types_Id] ASC, 
	[l].[Line_Number] ASC,
	[st].[OrderNo] ASC

--select * from Sensors_Labels_TxPwr

/*
update [Sensors_Labels] set TxPwr_Required = 2
where Guid = '00000000-0000-0000-0005-000000000020'
*/