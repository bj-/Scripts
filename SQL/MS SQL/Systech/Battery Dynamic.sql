/****** Скрипт для проверки состояния батарейки  ******/
select
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [FIO],
	[s].[SerialNo],
	[sbj].[BatteryLevel],
	[sbj].[Changed]
	--, *
FROM [SensorsBatteryJournal] AS [sbj]
INNER JOIN [SensorsCardio] as [sc] ON [sbj].[SensorsGuid] = [sc].[Guid]
INNER JOIN [users] AS [u] ON [sc].[UserGuid] = [u].[Guid]
INNER JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
INNER JOIN [Sensors] AS [s] ON [s].[Guid] = [sbj].[SensorsGuid]

where 
	[p].[LastName] like '%саре%'
	--[s].[SerialNo] = 'STH00-196'
	--AND [sbj].[Changed] BETWEEN '2016-03-20' AND '2016-04-12'
	-- SerialNo = 'STH00-122'

ORDER BY [sbj].[Changed] DESC

