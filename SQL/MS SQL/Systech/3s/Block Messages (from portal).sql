/****** Сообщения с блоков  ******/
SELECT TOP 500 
	--[t].[Guid],
	--[Server_Guid],
	[s].[Alias] AS [BlockSerNo],
	[t].[Source] AS [Type],
	--[t].[Happend],
	FORMAT([t].[Happend], 'dd.MM.yyy HH:mm:ss') AS [HappendF],
	--[t].[Written],
	FORMAT([t].[Written], 'dd.MM.yyy HH:mm:ss') AS [WrittenF],
	[t].[Text]
FROM [dbo].[Events_Onbtext] AS [t]
INNER JOIN [Servers] AS [s] ON [s].[Guid] = [t].[Server_Guid]
WHERE 1=1
	AND [s].[Alias] IN ('STB01146')
	--%%2%%
	--AND [t].[Source] IN ('Местоположение', 'Машинист', 'Качество сигнала', 'Тревожное сообщение', 'Нажатие кнопки', 'Состояние') -- Местоположение Машинист  Качество сигнала
	--AND [t].[Source] NOT IN ('Местоположение', 'Машинист', 'Качество сигнала', 'Тревожное сообщение', 'Нажатие кнопки', 'Состояние') -- Местоположение Машинист  Качество сигнала
	-- AND [t].[Happend] BETWEEN '' AND ''
	-- AND [t].[Happend] BETWEEN '' AND ''
	 AND [t].[Text] LIKE '%211%'
	-- AND [t].[Text] NOT LIKE '%>%'
ORDER BY 
	[t].[Happend] DESC