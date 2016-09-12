SELECT p.Lastname AS [Фамилия],
	p.firstname AS [Имя],
	p.MiddleName AS [Отчество],
CONCAT(p.Lastname, ' ', p.firstname, ' ', p.MiddleName)  AS [ФИО]
, DRS.*
from
(
SELECT 
	  ds.[UsersGuid]
--      ,[ServersGuid]
--      ,[VehiclesGuid]
--      ,[SubVehiclesGuid]
--      ,[PlayType]
--      ,[Volume]
--      ,[Duration]
--      ,[Played]
--      ,[SignalDestination]
--      ,[SignalValidity]
,sum( ((ds.PlayType -2)* -1) ) AS [Монотония в кабине]--* (( ds.SignalDestination -2)* -1)) mc
,sum( ((ds.PlayType -2)* -1) * ( ds.SignalDestination  -1)) [Монотония Оператору]
,sum( (ds.PlayType -1)  ) [Гиперактивация в кабине] -- * (( ds.SignalDestination -2)* -1))
,sum( (ds.PlayType -1) * ( ds.SignalDestination  -1)) [Гиперактивация Оператору]

  FROM [DriversSignals] ds
  where ds.Played between '2016-04-01 00:00:00.0000000' and '2016-07-30 00:00:00.0000000'
  group by  ds.[UsersGuid]
) 
 DRS right outer join Users u on DRS.UsersGuid = u.Guid
 inner join Persons p on u.Personsguid = p.Guid
 where 
 u.RolesGuid = '00000000-0000-0000-0000-000000000003'
 /*
where
DRS.UsersGuid = u.Guid
and u.Personsguid = p.Guid
*/
order by p.Lastname