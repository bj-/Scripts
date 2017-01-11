
/* Хит парад появления сообщений "поправте гарнитуру по машинистам" за последние несколько дней  
    ОТ БЛОКА */


SELECT 
	--sobj.Started, sobj.Finished, sobj.Text, sobj.UsersGuid,
	s.SerialNo,
	Count(*) AS [CheckHIDCnt]
FROM 
	[ServersOnBoardJournal] AS [sobj]
	INNER JOIN [ServersOnBoardComponents] AS [sobc] ON [sobj].[ServersOnBoardComponentsGuid] = [sobc].[Guid]
	INNER JOIN [Servers] AS [s] ON [sobc].[ServersGuid] = [s].[Guid]
WHERE 
	sobj.Text = 'Поправьте индивидуальный датчик'
	--AND [sobj].[Started] BETWEEN DateAdd(day,-18, convert(datetime,convert(date, GetDate()))) AND  DateAdd(day,-8, convert(datetime,convert(date, GetDate())))
	AND [sobj].[Started] BETWEEN '2016-10-01' AND '2016-10-25'
GROUP BY SerialNo
ORDER BY [CheckHIDCnt] DESC
