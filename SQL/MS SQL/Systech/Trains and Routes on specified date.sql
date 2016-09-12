/***** Актуальные сцепки и маршруты на указанный промежуток времени  ***/ 

 select distinct v.Name, t.Route from TrainsTimeTables s
 inner join MetroTrains t on s.TrainsGuid = t.Guid
 inner join Vehicles v on t.Guid = v.Guid
 where s.Started between '20160817 09:00:00' and '20160817 10:00:00'
 order by 1