/*** Выявление паровозов где падает метролокейшен при старте, и не показывает ничего на Борд ***/
select 
c.ServersGuid, s.SerialNo, convert(date, j.Started) as 'Когда случилось (день)', datepart(HOUR,j.Started) as 'Когда случилось (час)', count(*)  as 'кол-во сообщений за сек'
from ServersOnBoardJournal j
inner join ServersOnBoardComponents c on c.Guid = j.ServersOnBoardComponentsGuid
inner join Servers as [s] ON s.Guid = c.ServersGuid
where c.ComponentName = 'LabelPosition' and DATEDIFF(SECOND, Started, Finished) = 0 
and (not j.Text like '%>%')
group by c.ServersGuid, s.SerialNo, convert(date, j.Started), datepart(HOUR,j.Started) having count(*) > 1
order by c.ServersGuid, convert(date, j.Started), datepart(HOUR,j.Started)


/* 
Лекарство:
На блоке в опциях БД выставить READ_COMMITTED_SNAPSHOT в ТРУ

ALTER DATABASE SHTURMAN_METRO
SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE
GO

*/