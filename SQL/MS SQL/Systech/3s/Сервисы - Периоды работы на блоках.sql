/****** Периоды работы сервисов на блоках (типа диагностика корректности выключения блоков)  ******/
SELECT TOP 1000
	[s].[Alias] AS [BlockSerialNo],
	[sv].Alias AS [Service_Name],
	[Started],
	[Finished],
	[Written],
	[Type_Id]
	--sv.*
	--s.*
FROM [Stages_Services] AS [ss]
	INNER JOIN [Services] AS [sv] ON sv.Guid = ss.Services_Guid
	INNER JOIN [Servers] AS [s] on [s].[Guid] = [sv].[Servers_Guid]
WHERE
	[s].[Alias] LIKE '%097'
ORDER BY ss.Finished DESC