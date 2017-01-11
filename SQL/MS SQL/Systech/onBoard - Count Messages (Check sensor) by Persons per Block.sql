
/* Хит парад появления сообщений "поправте гарнитуру по машинистам" за последние несколько дней с разбивкой по блокам */

SELECT 
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [FIO],
	--[p].[LastName], [p].[FirstName], [p].[MiddleName],
	s.SerialNo,
	count(*) AS [cnt]
FROM [ServersOnBoardJournal] AS [sobj]
	INNER JOIN [ServersOnBoardComponents] AS [sobc] ON [sobj].[ServersOnBoardComponentsGuid] = [sobc].[Guid]
	INNER JOIN [Servers] AS [s] ON [sobc].[ServersGuid] = [s].[Guid]
	LEFT JOIN [Users] AS [u] ON [sobj].[UsersGuid] = [u].[Guid]
	LEFT JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
WHERE
	[sobj].[Text] LIKE '%Поправьте%'
	--AND [sobj].[Started] BETWEEN DateAdd(day,-18, convert(datetime,convert(date, GetDate()))) AND  DateAdd(day,-8, convert(datetime,convert(date, GetDate())))
	AND [sobj].[Started] BETWEEN '2016-10-01' AND '2016-10-25'
	--AND [p].[LastName] LIKE '%Кутузов%'

GROUP BY [p].[LastName], [p].[FirstName], [p].[MiddleName], s.SerialNo
ORDER BY [p].[LastName], [p].[FirstName], [p].[MiddleName], s.SerialNo