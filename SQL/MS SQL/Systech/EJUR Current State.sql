/******      Время последней активности ЭЖУРов, и текущий статус подключения      ******/

SELECT 
	[s].[SerialNo] AS [Block],
	--[s].[IsConnected] AS [Block Conn],
	REPLACE([s].[IsConnected], '1', 'Connected') AS [Block Conn],
	FORMAT([s].[Connected], 'dd.MM.yyyy HH:mm:ss') AS [Block State Changed],
	'|' AS [|],
	[sen].[SerialNo] AS [EJUR],
    --[sejs].[IsOnAir] AS [EJUR Conn],
	REPLACE([sejs].[IsOnAir], '1', 'Connected') AS [EJUR Conn],
    FORMAT([sejs].[StateChanged], 'dd.MM.yyyy HH:mm:ss') AS [EJUR State Changed],
	[sen].[BatteryLevel] [EJUR Bat (Useless)],
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ',[p].[MiddleName]) AS [FIO]
    --FORMAT([sejs].[Appeared], 'dd.MM.yyyy HH:mm:ss') AS [Appeared],
FROM [SensorsEJournalStatic] AS [sejs]
INNER JOIN [Sensors] AS [sen] ON [sen].[Guid] = [sejs].[Guid]
INNER JOIN [Servers] AS [s] ON [s].[Guid] = [sejs].[ServersGuid]
LEFT JOIN [Users] AS [u] ON [u].[Guid] = [sejs].[UserGuid]
LEFT JOIN [Persons] AS [p] ON [p].[Guid] = [u].[PersonsGuid]
WHERE 
	[sen].[SerialNo] NOT IN ('STJM002-0002')
ORDER BY [s].[SerialNo] ASC
