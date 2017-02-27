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

DECLARE @cols AS NVARCHAR(4000), @sql AS NVARCHAR(4000)

set @cols =''
select  @cols =  @cols + '['+ Version +'],' FROM (select distinct  Version  FROM [Shturman_Update].[dbo].[Update_Journal]) v
--set @cols = REPLACE( @cols + '*', ',*', '')
set @cols =  @cols + 'LastUpdate'

--select @cols

set @sql=

'select Server_Serial_No AS ''SerialNo'',  '+ @cols +' 
FROM 
(
SELECT 
	  uj.[Server_Serial_No]
      ,uj.[Version]
      ,str(uj.[Result]) Result
  FROM [Shturman_Update].[dbo].[Update_Journal] uj ,
  (select t.[Server_Serial_No], t.[Version], max(t.[Update_Time]) Update_Time FROM [Shturman_Update].[dbo].[Update_Journal] t group by t.[Server_Serial_No], t.[Version])  uj1
  where uj.[Server_Serial_No]= uj1.[Server_Serial_No] and uj.[Version] = uj1.[Version] and uj.[Update_Time] = uj1.[Update_Time]

UNION

SELECT 
	  j.[Server_Serial_No]
      ,''LastUpdate'' Version
      ,format(max(j.[Update_Time]),''HH:mm - d MMM'') Result
  FROM [Shturman_Update].[dbo].[Update_Journal] j 
  group by j.[Server_Serial_No], j.[Version]
) u
PIVOT
(
min([Result]) --, [Update_Time]
for
[Version] 
 IN ('+ @cols +')) pvt
 ORDER BY pvt.[Server_Serial_No]'
 
exec sp_executesql @sql;


