/* ------------  Удаление пользователя (машиниста) из БД.  ------------- */


USE [Shturman_Metro]
GO
/*
select *
from Users u, Persons p
where u.PersonsGuId = p.Guid

-- список пользователей присутсвующих в анальной базе, но отсутвующих в оперативной.
-- для обратного поиска вероятно поменять right outer на лефт аутер

select u.Guid, ua.Guid, p.LastName, p.FirstName, p.MiddleName, pa.LastName, pa.FirstName, pa.MiddleName--, pa.LastName
from Shturman_Metro.dbo.users as u
inner join Shturman_Metro.dbo.Persons as p ON p.Guid = u.PersonsGuid
right outer join Shturman_Metro_Analytics.dbo.users as ua on u.Guid =  ua.Guid
left join Shturman_Metro_Analytics.dbo.Persons as pa ON pa.Guid = ua.PersonsGuid
where u.Guid is NULL
*/

begin
 declare 
 @userid uniqueidentifier = '31D1516A-0352-4ECB-8EA0-15D84D426B15'                -- GUID удаляемого пользователя

Update Vehicles Set UsersGuid = NULL where UsersGuid =  @userid    -- зачистка Vehicles

DELETE from Journal WHERE UserConfirmedGuid = @userid
DELETE from ServersOnBoardJournal WHERE UsersGuid = @userid
DELETE SensorsCardio WHERE UserGuid = @userid
DELETE Sessions WHERE UsersGuid = @userid
DELETE UsersJournal WHERE UsersGuid = @userid
DELETE UsersMedicalInspectionsSending WHERE UsersGuid = @userid
DELETE UsersMedicalInspections WHERE UsersGuid = @userid
DELETE DriversSignals WHERE UsersGuid = @userid
DELETE SensorsEJournalStatic WHERE UserGuid = @userid


DELETE Persons Where Guid = ( select PersonsGuId from Users where Guid = @userid )  -- удаление персоны

DELETE Users where Guid = @userid              -- удаление пользователя 


end
GO