/* Сообщения отображаемые на блоках в вагонах  */
SELECT 
	[s].[SerialNo],
	[sobc].[ComponentName],
	[sobj].[Text], 
	--[sobj].[Text],
	[sobj].[Started],
	[sobj].[Finished],
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [FIO],
	[Sensors].[SerialNo],
	--[sobj].[UsersGuid],
	[sobc].[Changed]
	--,* 
FROM [ServersOnBoardJournal] AS [sobj]
	INNER JOIN [ServersOnBoardComponents] AS [sobc] ON [sobj].[ServersOnBoardComponentsGuid] = [sobc].[Guid]
	INNER JOIN [Servers] AS [s] ON [sobc].[ServersGuid] = [s].[Guid]
	LEFT JOIN [Users] AS [u] ON [sobj].[UsersGuid] = [u].[Guid]
	LEFT JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
	LEFT JOIN [SensorsCardio] AS [sc] ON [u].[Guid] = [sc].[UserGuid]
	LEFT JOIN [Sensors] AS [Sensors] ON [sc].[Guid] = [Sensors].[Guid]
WHERE
	[sobj].[Text] not like '%fff%'
	--AND [sobj].[Text] LIKE '%ПТО%'
	and [sobj].[Text] != ''
	AND [sobj].[Started] BETWEEN '2016-08-17 10:00:00' AND '2016-08-17 11:00:00'
	--AND [sobj].[Started] BETWEEN DateAdd(day,-10, convert(datetime,convert(date, GetDate()))) AND  DateAdd(day,2, convert(datetime,convert(date, GetDate())))
	--AND [s].[SerialNo] IN ('STB08739', 'STB08740')
	--AND [s].[SerialNo] IN ('STB10304','STB10305', 'STB08481', 'STB08474', 'STB08739', 'STB08740')
	--AND [s].[SerialNo] IN ('STB08583')
	--AND [p].[LastName] LIKE '%прохор%'
	--AND [Sensors].[SerialNo] IN ('')
	--AND [sobc].[ComponentName] IN ('LabelWarning', 'LabelPosition', 'LabelDriver', 'LabelRoute')
	AND [sobc].[ComponentName] IN ('LabelWarning')
	--AND [sobc].[ComponentName] IN ('LabelDriver')
	--AND [sobc].[ComponentName] IN ('LabelRoute')
	--AND [Sensors].[SerialNo] = 'STH00-227'
	
ORDER BY
	--[sobj].[Started] DESC
	[p].[LastName] ASC,  [sobj].[Started] ASC
