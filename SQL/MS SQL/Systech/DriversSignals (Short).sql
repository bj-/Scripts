/*****  Сигналы выданные водителям (монотония и стресс)  ****/
Select 
	-- [ds].[UsersGuid], 
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [FIO],
	--[ds].[VehiclesGuid], 
	[v].[Name],
	--[ds].[ServersGuid],
	[s].[SerialNo],
	[ds].[PlayType],
	[ds].[Volume],
	[ds].[Duration],
	[ds].[Played],
	[ds].[SignalDestination],
	[ds].[SignalValidity]
	from DriversSignals AS [ds]
	INNER JOIN [Users] AS [u] ON [ds].[UsersGuid] = [u].[GuiD]
	INNER JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
	INNER JOIN [Servers] AS [s] ON [ds].[ServersGuid] = [s].[Guid]
	INNER JOIN [Vehicles] AS [v] ON [ds].[VehiclesGuid] = [v].[Guid]
WHERE 
	played BETWEEN '2016-08-13 05:00:00' AND '2016-08-13 07:00:00'
	--AND SerialNo = ''
	--AND [p].[LastName] like '%%'
