
/* ��� ����� ��������� ��������� "�������� ��������� �� ����������" �� ��������� ��������� ���� */

SELECT 
	[p].[LastName], [p].[FirstName], [p].[MiddleName],
	count(*) AS [cnt]
FROM [ServersOnBoardJournal] AS [sobj]
	LEFT JOIN [Users] AS [u] ON [sobj].[UsersGuid] = [u].[Guid]
	LEFT JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
WHERE
	[sobj].[Text] LIKE '%���������%'
	AND [sobj].[Started] BETWEEN DateAdd(day,-10, convert(datetime,convert(date, GetDate()))) AND  DateAdd(day,2, convert(datetime,convert(date, GetDate())))
	--AND [p].[LastName] LIKE '%�������%'
GROUP BY [p].[LastName], [p].[FirstName], [p].[MiddleName]
ORDER BY [cnt] DESC