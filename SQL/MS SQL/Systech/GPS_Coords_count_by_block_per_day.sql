/*    ���������� ���������� GPS ��������� ������� �� ���� */

/*   ������ ���������� ���������� ���������� ��������� �� ����� �� ����.
           � ������� �������� ����� �������/��������� ����.               */


set nocount on;

SELECT
	[s].[SerialNo],
	CAST([sph].[Received] AS DATE) AS [Date],
	COUNT (*) AS [GPS Count]
FROM [ServersPositionsHistory] AS [sph]
INNER JOIN [Servers] AS [s] ON [s].[Guid] = [sph].[ServersGuid]
WHERE 
	[sph].[Valid] = 1
	AND [s].[SerialNo] NOT IN ('MCK0111', 'MCK02805', 'MCK02801') -- ������� �������� ������
	AND [s].[SerialNo] LIKE '%'			-- ������ �� ������� ���� ����������
--	AND [s].[SerialNo] IN ('', '')		-- ������ �� ������� ���� ����������
GROUP BY [s].[SerialNo], CAST([sph].[Received] AS DATE)
ORDER BY 
	[s].[SerialNo] ASC, 
	[Date] ASC