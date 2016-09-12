
/* 

Вагоны не сцепленные в составы, но ездящие по линии (замечают метки (любое мерцание метки) 
За период времени с 5:00 текущего дня до текущего времени

*/

select 
	srv.SerialNo AS [Block], 
	count(*) AS [Stations Count], 
	max(sj.Changed) AS [Last]
from Shturman_Metro.dbo.SensorsJournal sj with(NOLOCK)
	inner join Shturman_Metro.dbo.Servers srv with(NOLOCK) on srv.Guid = sj.ServersGuid
	inner join Shturman_Metro.dbo.Sensors s with(NOLOCK) on s.Guid = sj.SensorsGuid
	inner join Shturman_Metro.dbo.SensorsLabels l with(NOLOCK) on s.Guid = l.Guid
	inner join Shturman_Metro.dbo.MetroStations st with(NOLOCK) on st.Guid = l.StationsGuid
where 
	sj.Changed >= DateAdd(hour,5, convert(datetime,convert(date, GetDate())))
	and not exists(select * from Shturman_Metro.dbo.MetroTrains t where t.Guid = srv.VehiclesGuid and t.IsActive = 1) 
group by srv.SerialNo


/*

Составы у которых одна из голов видела меток сильно меньше чем другая.

DifferentAbsolute = абсолютная разница в замеченных метках между головами
DifferentPercent = разница в попугаях

DifferentPercent = 0 - читать как разница в 100%, т.е. одна из голов не видела меток вообще. но только при условии что [First Block] и [Second Block] одинаковые.
И надо смотреть существует ли второй вагон из состава в природе.
Если существуют оба - значит второй сдох.

*/

select 
	TrainName =
	(
		select max(v.Name) from Shturman_Metro.dbo.Vehicles v with(NOLOCK)
		inner join Servers ss with(NOLOCK) on ss.VehiclesGuid = v.Guid
		where ss.SerialNo = srv.SerialNo  
	),
	srv.SerialNo AS [Block], 
	count(*) AS [StationsCount], 
	max(sj.Changed) AS [Last]
INTO #temp1
from Shturman_Metro.dbo.SensorsJournal sj with(NOLOCK)
	inner join Shturman_Metro.dbo.Servers srv with(NOLOCK) on srv.Guid = sj.ServersGuid
	inner join Shturman_Metro.dbo.Sensors s with(NOLOCK) on s.Guid = sj.SensorsGuid
	inner join Shturman_Metro.dbo.SensorsLabels l with(NOLOCK) on s.Guid = l.Guid
	inner join Shturman_Metro.dbo.MetroStations st with(NOLOCK) on st.Guid = l.StationsGuid

where 
	sj.Changed >= DateAdd(hour,5, convert(datetime,convert(date, GetDate())))
	and exists(select * from Shturman_Metro.dbo.MetroTrains t where t.Guid = srv.VehiclesGuid and t.IsActive = 1) 
group by srv.SerialNo
order by 1,2

-- select * from #temp1


select 
TrainName, 
[First Block] = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName),
[Second Block] = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName),
[First Count] = (Select StationsCount from #temp1 as t2 where t2.Block = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)),
[Second Count] = (Select StationsCount from #temp1 as t2 where t2.Block = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)),
DifferentAbsolute = 
	abs(
		(Select StationsCount from #temp1 as t2 where t2.Block = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)) - (Select StationsCount from #temp1 as t2 where t2.Block = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName))
	),
DifferentPercent = 
	abs(
		((Select StationsCount from #temp1 as t2 where t2.Block = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)) - (Select StationsCount from #temp1 as t2 where t2.Block = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)))*100
		/
		((Select StationsCount from #temp1 as t2 where t2.Block = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)) + (Select StationsCount from #temp1 as t2 where t2.Block = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)))
	)
From #temp1 as t
where abs(
		((Select StationsCount from #temp1 as t2 where t2.Block = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)) - (Select StationsCount from #temp1 as t2 where t2.Block = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)))*100
		/
		((Select StationsCount from #temp1 as t2 where t2.Block = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)) + (Select StationsCount from #temp1 as t2 where t2.Block = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)))
	) > 10
	OR
	abs(
		(Select StationsCount from #temp1 as t2 where t2.Block = (Select min(Block) from #temp1 as t1 where t1.TrainName = t.TrainName)) - (Select StationsCount from #temp1 as t2 where t2.Block = (Select max(Block) from #temp1 as t1 where t1.TrainName = t.TrainName))
	) = 0
group by TrainName
order by DifferentPercent DESC

--select (10)*100 / ((10))

-- select * from #temp1 order by TrainName
--select 1383*0.28

drop table #temp1