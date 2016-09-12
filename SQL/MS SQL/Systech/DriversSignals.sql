select 
srv.SerialNo,
s.SerialNo,
tr.Route,
v.Name,
FIO = p.LastName + ' '+p.FirstName + ' '+p.MiddleName,
ms.Name,
pos.Code,
tr.WayNo,
LastActivity = 
(select max(ses.Finished) from Sessions ses where ses.ServersGuid = srv.Guid and ses.SensorsGuid = s.Guid),
s.BatteryLevel
from MetroTrains tr
inner join Vehicles v on tr.Guid = v.Guid
inner join SensorsCardio sc on sc.UserGuid = v.UsersGuid
inner join Sensors s on s.Guid = sc.Guid
inner join Users u on u.Guid = sc.UserGuid
inner join Persons p on p.Guid = u.PersonsGuid
inner join Servers srv on srv.Guid = sc.ServersGuid
inner join MetroStations ms on ms.Guid = tr.StationsGuid
inner join TrainPositionStates pos on pos.Id = tr.TrainPositionStatesId
where
tr.IsActive = 1 
and tr.IsIncorrect = 0
and sc.IsConnected = 1
and sc.UserJournalTypesId <> 1
and pos.Code in (dbo.GetTrainPositionStateCodeStation(),
 dbo.GetTrainPositionStateCodeTunnel())
and
( (tr.WayNo = 2 and ms.OrderNo in (6,5,4)) 
or (tr.WayNo = 1 and ms.OrderNo in (3,4,5)))
and datediff(second,sc.Connected,GetDate()) > 120
and 
datediff(second,
(select max(ses.Finished) from Sessions ses where ses.ServersGuid = srv.Guid and ses.SensorsGuid = s.Guid),
GetDate()) < 30 
order by tr.Route


select 
top 10 
p.LastName, s.played, s.PlayType, s.SignalDestination, s.Volume from DriversSignals s
inner join Users u on u.Guid = s.UsersGuid
inner join Persons p on p.Guid = u.PersonsGuid
--where SignalDestination = 2
order by Played desc


--delete DriversSignals
--where Played < '20160422 10:30:00' and SignalDestination = 2

--delete Journal 
--where Created < '20160422 10:30:00' and Code in (dbo.GetJournalCodeSleep(), dbo.GetJournalCodeStress())
--and NeedConfirmation = 1 and Confirmed is not null


--select count(*) from UsersJournal

--select min(Started) from UsersJournal
















