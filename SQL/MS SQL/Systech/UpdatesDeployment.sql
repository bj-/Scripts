/******  Проверка разливки апдейтов по блокам   ****/

SELECT 
	upj.Server_Serial_No, 
	[upj0151].Version AS [0.15.01],
	[upj0152].Version AS [0.15.02],
	[upj0153].Version AS [0.15.03],
	[upj0153].Result AS [0.15.03s],
	[upj0153].Version AS [0.15.04],
	FORMAT(MAX([upj].Update_Time), 'HH:mm d MMM')  AS [LastUpdate]
	--(SELECT Component FROM update_journal WHERE 
	--(SELECT [Version] where [Version] = '0.15.1') AS [v0151]
	--(SELECT Component from Update_Journal AS [upj2] WHERE [upj2].Server_Serial_No = [upj].Server_Serial_No and [upj2].Update_Time = max([upj2].Update_Time))
	--Component, 
	--Update_Time
FROM update_journal AS [upj]
--INNER JOIN update_journal AS [upjc] ON upj.Server_Serial_No = [upjc].Server_Serial_No AND max([upj].Update_Time) = [upjc].Update_Time
LEFT JOIN update_journal AS [upj0151] ON upj.Server_Serial_No = [upj0151].Server_Serial_No AND [upj0151].Version ='0.15.1'
LEFT JOIN update_journal AS [upj0152] ON upj.Server_Serial_No = [upj0152].Server_Serial_No AND [upj0152].Version ='0.15.2'
LEFT JOIN update_journal AS [upj0153] ON upj.Server_Serial_No = [upj0153].Server_Serial_No AND [upj0153].Version ='0.15.3'
LEFT JOIN update_journal AS [upj0154] ON upj.Server_Serial_No = [upj0154].Server_Serial_No AND [upj0154].Version ='0.15.4'
GROUP BY upj.Server_Serial_No, [upj0151].[Version], [upj0152].[Version], [upj0153].[Version], [upj0153].Result, [upj0154].[Version]
ORDER BY upj.Server_Serial_No ASC


/* 
0.15.01 = Заливка файлов (PSS, 7-Zip, BGInfo)
0.15.02 = Правка ini: Добавление DiagAlias во все PostingMessages в ролях
0.15.03 = Чистка мусора на диске \BIN\Errors\* | BIN\Log\* | C:\Logs\*.zip|*.7z|*.rar|old\*
0.15.04	= HubServer 1.5.7.3 + Def
*/
-- Select * from Update_Journal
-- Select distinct version from Update_Journal
-- select distinct Server_Serial_No from  Update_Journal

DECLARE @UpdVer nvarchar(20);
--set @UpdVer = 'dadasd';

SELECT 
	[uj].[Server_Serial_No],
--	(SELECT DISTINCT [uj1].[Version] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.1') AS [0.15.01],
	(SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.1' and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] and [Version] = '0.15.1')) AS [0.15.01],
	--(SELECT  DISTINCT [uj1].[Version] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.1') AS [0.15.01],
--	(SELECT DISTINCT [uj1].[Version] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.2') AS [0.15.02],
	(SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.2' and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] and [Version] = '0.15.2')) AS [0.15.02],
--	(SELECT DISTINCT [uj1].[Version] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.3') AS [0.15.03],
	(SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.3' and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] and [Version] = '0.15.3')) AS [0.15.03],
--	(SELECT DISTINCT [uj1].[Version] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.4') AS [0.15.04],
	(SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.4' and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] and [Version] = '0.15.4')) AS [0.15.04],
--	(SELECT DISTINCT [uj1].[Version] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.5') AS [0.15.05],
	(SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.5' and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] and [Version] = '0.15.5')) AS [0.15.05],
--	(SELECT DISTINCT [uj1].[Version] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.6') AS [0.15.06],
	(SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] AND [Version] = '0.15.6' and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] and [Version] = '0.15.6')) AS [0.15.06],
	(SELECT FORMAT(MAX([uj1].[Update_Time]), 'HH:mm d MMM') FROM [Update_Journal] AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No]) AS [LastUpdated],
	IIF((SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] )) = '0', '', CONCAT('[FAILED] Code: ', (SELECT [uj1].[Result] FROM Update_Journal AS [uj1] WHERE [uj1].[Server_Serial_No] = [uj].[Server_Serial_No] and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = [uj].[Server_Serial_No] )))) AS [LastStatus]
FROM [Update_Journal] AS [uj]
GROUP BY [uj].[Server_Serial_No]
ORDER BY [uj].[Server_Serial_No] ASC



/*
DECLARE @UpdVer nvarchar(20);

SELECT @UpdVer = '0.15.3', [uj1].[Result]
--, uj1.Update_Time
 FROM Update_Journal AS [uj1] WHERE Server_Serial_No = 'STB10280' and [Version] = '0.15.3' and uj1.Update_Time = (select max(Update_Time) from Update_Journal where  Server_Serial_No = 'STB10280' and [Version] = '0.15.3')

*/

--select * from Update_Journal where Server_Serial_No = 'STB08692'
--update Update_Journal set Result = 0 where id = 97