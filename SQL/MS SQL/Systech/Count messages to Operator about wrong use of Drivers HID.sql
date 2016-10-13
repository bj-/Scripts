/*   ���������� ��������� ��������� � ������������� ��������� �������������� ������ �������� 
     �� �������� ���������� �������       */

SELECT
	CONCAT([p].[LastName], ' ', [p].[FirstName], ' ', [p].[MiddleName]) AS [���],
	COUNT(*) AS [���-�� ��������� ��������� � ������������� ��������� ���. ������]
	--, * 
FROM [Journal] AS [j]
INNER JOIN [Users] AS [u] ON [j].[ForeignGuid] = [u].[Guid]
INNER JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
WHERE [j].[Code] = 'JOURNAL_RRERROR'
	AND [j].[Created] BETWEEN '2016-09-10' AND '2016-09-21'
	--AND [p].[LastName] like '%'
GROUP BY [p].[LastName], [p].[FirstName], [p].[MiddleName]
