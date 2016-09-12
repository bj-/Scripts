
/* =====================================

	Перецепление вагонов между составами 

========================================== */

select v.Name, v.Guid, * from MetroTrains t
inner join Vehicles v on t.Guid = v.Guid
 order by v.Name 


select * from MetroWagons
order by name

-- Раскоментить то что ниже

---- 8625 -> 8624
--update MetroWagons
--set MetroTrainsGuid = 'F59D30A2-3826-43D9-8D48-2E0907008936' 
--where Guid = 'A0D9CAF9-606F-468E-843B-4A1FAF2117B5'

--update Vehicles
--set Name='8624-8625'
--where Guid = 'F59D30A2-3826-43D9-8D48-2E0907008936'

--update MetroTrains
--set StationsGuid = null,
--	TrainPositionStatesId = 1
--where Guid = '60C00828-BB0B-47FA-A04B-01844F999D8B' 

--update Vehicles
--set UsersGuid = null
--where Guid = '60C00828-BB0B-47FA-A04B-01844F999D8B'

 