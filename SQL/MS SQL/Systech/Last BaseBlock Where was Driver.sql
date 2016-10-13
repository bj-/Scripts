/*   

 Последний основной блок который видел Гарнитуру 
 
 Фильтр по гарнитуре - указывать конкретную гарнитуру. "все разом" не стоит серваку плохеет от такого запроса
 Фильтр по дате - для поиска в нужном диапазоне
*/

select  FORMAT(max(sj.Changed), 'dd.MM.yyyy HH:mm:ss') sc,p.LastName, p.FirstName, p.MiddleName, s.Name, sv.SerialNo 
 from SensorsJournal sj, Sensors s, servers sv, SensorsJournalTypes jt,
 sensorscardio sc,users u, persons p,
(select sj1.SensorsGuid sg1, max(sj1.Changed) ch1   from SensorsJournal sj1, Sensors s1, servers sv1 
where sj1.SensorsGuid = s1.Guid
and sj1.ServersGuid = sv1.Guid
--and sj.SensorsJournalTypesId = jt.Id
--and s.SerialNo like 'STL000-00-00-0'
and (s1.SerialNo like '%STH00-192%' /* or s.SerialNo like '%STL000%'*/)
--and (sv.SerialNo like '%8679%' or sv.SerialNo like '%8740%') 
and sj1.Changed < '2016-09-21 00:00:00.0000000'
group by sj1.SensorsGuid
)  sj2
where sj.SensorsGuid = s.Guid
and sj.ServersGuid = sv.Guid
and sj.SensorsJournalTypesId = jt.Id
--and s.SerialNo like 'STL000-00-00-0'
--and (s.SerialNo like '%STH%' /* or s.SerialNo like '%STL000%'*/)
--and (sv.SerialNo like '%8679%' or sv.SerialNo like '%8740%') 
--and sj.Changed > '2016-06-11 00:00:00.0000000'
and s.Guid = sc.Guid
and sc.UserGuid = u.Guid
and u.PersonsGuid = p.Guid

and sj.SensorsGuid = sj2.sg1
and sj.Changed = sj2.ch1

--and sj.Changed = (select  max(sj1.Changed) mch  from SensorsJournal sj1 where sj1.SensorsGuid = sj.SensorsGuid and sj1.ServersGuid = sj.ServersGuid)

group by  p.LastName, p.FirstName, p.MiddleName, s.Name, sv.SerialNo 

order by max(sj.Changed) desc ,p.LastName, p.FirstName, p.MiddleName, s.Name, sv.SerialNo-- max(sj.Changed) desc