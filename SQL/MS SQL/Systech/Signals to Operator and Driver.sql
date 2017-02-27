select p.LastName + ' '+ p.FirstName+' '+ p.MiddleName, j.PlayType, j.SignalDestination, j.Played, j.Duration  from DriversSignals j
inner join Users u on u.Guid = j.UsersGuid
inner join Persons p on p.Guid = u.PersonsGuid
where Played between '20170101 00:00:00' and '20170201 00:00:00' 
order by j.Played

