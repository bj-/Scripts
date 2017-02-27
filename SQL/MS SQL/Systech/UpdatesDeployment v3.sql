/****** Последние установленные версии с кодами ошибок установки  ******/
/*
SELECT [Id]
      ,[Server_Serial_No]
      ,[Component]
      ,[Version]
      ,[Publication_Time]
      ,[Update_Time]
      ,[Result]
  FROM [Shturman_Update].[dbo].[Update_Journal]

*/

DECLARE @cols AS NVARCHAR(4000), @cols2 AS NVARCHAR(4000), @sql AS NVARCHAR(4000)

set @cols =''
select  @cols = substring((select distinct ',['+ Version +']' FROM [Shturman_Update].[dbo].[Update_Journal] group by Version for xml path('')),2,4000)
select  @cols2 = substring((select distinct ',ISNULL(['+ Version +'],'''') as ['+ Version +']' FROM [Shturman_Update].[dbo].[Update_Journal] group by Version for xml path('')),2,4000)

set @cols =  @cols + ',[LastUpdate]'
set @cols2 =  @cols2 + ',ISNULL([LastUpdate],'''') as [LastUpdate]'

set @sql=

'SELECT SerialNo,  '+ @cols2 +' 
FROM 
(
SELECT 
	  uj.[Server_Serial_No] SerialNo
      ,uj.[Version]
      ,str(uj.[Result]) Result
  FROM [Shturman_Update].[dbo].[Update_Journal] uj ,
  (select t.[Server_Serial_No], t.[Version], max(t.[Update_Time]) Update_Time FROM [Shturman_Update].[dbo].[Update_Journal] t group by t.[Server_Serial_No], t.[Version])  uj1
  where uj.[Server_Serial_No]= uj1.[Server_Serial_No] and uj.[Version] = uj1.[Version] and uj.[Update_Time] = uj1.[Update_Time]

UNION

SELECT 
	  j.[Server_Serial_No] SerialNo
      ,''LastUpdate'' Version
      ,format(max(j.[Update_Time]),''dd.MM.yyyy hh.mm.ss'') Result
  FROM [Shturman_Update].[dbo].[Update_Journal] j 
  group by j.[Server_Serial_No], j.[Version]
) u
PIVOT
(
min([Result]) 
for
[Version] 
 IN ('+ @cols +')) pvt
ORDER BY pvt.[SerialNo]'
 
exec sp_executesql @sql;


