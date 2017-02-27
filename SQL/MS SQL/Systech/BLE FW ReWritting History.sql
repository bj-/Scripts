SELECT 
--	[p].[FirstName],
--	[p].[LastName],
--	[p].[MiddleName],
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [FIO],
	[sn].[SerialNo],
	[scj].[BLEFWVersion],
	[scj].[FWUpdateCount],
	[scj].[Written],
	[scj].[Created]

	--[u].PersonsGuid
FROM [SensorsCardioJournal] AS [scj]
	INNER JOIN [Sensors] AS [sn] ON [sn].[Guid] = [scj].[SensorsGuid]
	INNER JOIN [SensorsCardio] AS [sc] ON [sc].[Guid] = [scj].[SensorsGuid]
	INNER JOIN [Users] AS [u] ON [u].[Guid] = [sc].[UserGuid]
	INNER JOIN [Persons] AS [p] ON [p].[Guid] = [u].[PersonsGuid]