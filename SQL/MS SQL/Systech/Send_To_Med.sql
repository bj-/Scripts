declare @SerNo nvarchar(20) = 'STH00-251'
declare @UserGuid uniqueidentifier = null
select @UserGuid = sc.UserGuid from SensorsCardio sc
inner join Sensors s on s.Guid = sc.Guid where s.SerialNo = @SerNo

declare @SendDate datetime2 = GetDate()
declare @G uniqueidentifier

exec Server_UserMedInspections_Send @UserGuid, @SendDate, @G output