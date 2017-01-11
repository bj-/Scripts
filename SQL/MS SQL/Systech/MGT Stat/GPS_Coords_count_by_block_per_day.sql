/*    Количество полученных GPS координат вагоном по дням */

/*   Скрипт показывает Количество полученных координат на блоке по дням.
           С помощью фильтров можно выбрать/исключить блок.               */


set nocount on;

SELECT
	[s].[SerialNo],
	CAST([sph].[Received] AS DATE) AS [Date],
	COUNT (*) AS [GPS Count]
FROM [ServersPositionsHistory] AS [sph]
INNER JOIN [Servers] AS [s] ON [s].[Guid] = [sph].[ServersGuid]
WHERE 
	[sph].[Valid] = 1
	AND [s].[SerialNo] NOT IN ('MCK0111', 'MCK02805', 'MCK02801') -- Убираем ненужные вагоны
	AND [s].[SerialNo] LIKE '%'			-- Фильтр по вагонам если необходимо
--	AND [s].[SerialNo] IN ('', '')		-- Фильтр по вагонам если необходимо
GROUP BY [s].[SerialNo], CAST([sph].[Received] AS DATE)
ORDER BY 
	[s].[SerialNo] ASC, 
	[Date] ASC