/*********   Статистика самостоятельной перепрошивки Гарнитур в результате слета прошивки    **********/

SELECT 
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [FIO],
	[sn].[SerialNo],
	[scj].[BLEFWVersion],
	[scj].[FWUpdateCount],
	[scj].[Written],
	[scj].[Created]
FROM [SensorsCardioJournal] AS [scj]
	INNER JOIN [Sensors] AS [sn] ON [sn].[Guid] = [scj].[SensorsGuid]
	INNER JOIN [SensorsCardio] AS [sc] ON [sc].[Guid] = [scj].[SensorsGuid]
	INNER JOIN [Users] AS [u] ON [u].[Guid] = [sc].[UserGuid]
	INNER JOIN [Persons] AS [p] ON [p].[Guid] = [u].[PersonsGuid]
WHERE 1=1
	AND [p].[LastName] LIKE '%цыпу%'
	--AND [sn].[SerialNo] = 'STH00-064'
ORDER BY [p].[LastName] ASC, [scj].[Written] DESC
