/****** ћинимальный и максимальный зар€д гарнитуры в течение дн€  + врем€ прошедшее между мин и макс зар€дом  ******/
select
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [FIO],
	[s].[SerialNo],
	--[sbj].[BatteryLevel],
	MAX([sbj].[BatteryLevel]) AS [MAXBat],
	MIN([sbj].[BatteryLevel]) AS [MinBat],
	format([sbj].[Changed] ,'yyy.MM.dd') AS [Date],
	format(MIN([sbj].[Changed]),'HH:mm:ss') AS [StartTime],
	format(MAX([sbj].[Changed]),'HH:mm:ss') AS [FinishTime],
	--dateadd(SECOND,MAX([sbj].[Changed]),MIN([sbj].[Changed]))
	format(dateadd(SECOND, DATEDIFF(SECOND, MIN([sbj].[Changed]), MAX([sbj].[Changed])), ''),'HH:mm:ss') AS [Working Time]
	--DATEDIFF(MAX([sbj].[Changed])-MIN([sbj].[Changed]))
	-- [sbj].[Changed]
	--, *
FROM [SensorsBatteryJournal] AS [sbj]
INNER JOIN [SensorsCardio] as [sc] ON [sbj].[SensorsGuid] = [sc].[Guid]
INNER JOIN [users] AS [u] ON [sc].[UserGuid] = [u].[Guid]
INNER JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
INNER JOIN [Sensors] AS [s] ON [s].[Guid] = [sbj].[SensorsGuid]

where 
	[p].[LastName] like '%саре%'
	--[s].[SerialNo] = 'STH00-196'
--	AND [sbj].[Changed] BETWEEN '2016-08-10 00:00:00.0000000' AND '2016-09-31 00:00:00.0000000'
	-- SerialNo = 'STH00-122'
Group BY format([sbj].[Changed] ,'yyy.MM.dd'), [p].[LastName], [p].[FirstName], [p].[MiddleName], [s].[SerialNo]
ORDER BY [Date] DESC

