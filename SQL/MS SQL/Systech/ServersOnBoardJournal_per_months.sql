/****   Количество сообщений (предупреждений) на блоке       ****/
/* с помошью параметров можно выбрать блок, ФИО машиниста/водителя, датчик, тип сообщения, техт сообщения, период  */

begin
 declare 
 @blc_no NVARCHAR(20) = '%%' ,               -- маска Номера блока например 'STB001' или '%001%' 
 @lbl    NVARCHAR(20) = 'Label%' ,    -- маска типа сообщения: 'GaugeBattery', 'LabelWarning', 'LabelDriver', 'LabelPosition', 'LabelRoute'
 @fio    NVARCHAR(80) = '%%' ,               -- маска ФИО        
 @text   NVARCHAR(20) = '%Поправьте%',                -- маска текста сообщения
 @mindate DATE = '2016-10-01',               -- дата От включительно
 @maxdate DATE = '2020-11-01';               -- дата По включительно 
 
SELECT  
  format(j.Started, 'MM.yyy') per_day
--  ,s.serialno server
  ,FIO = p.LastName + ' '+p.FirstName + ' '+p.MiddleName
  ,sen.Name sensor
--  ,c.ComponentName label
  ,j.Text Text
  ,count(*) quantity
FROM 
 ServersOnBoardJournal j, 
 ServersOnBoardComponents c, 
 Servers s ,
 users u,
 persons p,
 Sensors sen,
 Sensorscardio sec
WHERE 
 j.ServersOnBoardComponentsGuid = c.Guid
    and c.serversguid = s.guid
	and j.UsersGuid = u.Guid
	and u.PersonsGuid = p.Guid
	and j.UsersGuid  = sec.UserGuid
	and sec.Guid = sen.Guid
	and j.Text != ''

--	  and s.SerialNo like  @blc_no
	  and c.ComponentName like  @lbl
	  and p.LastName + ' '+p.FirstName + ' '+p.MiddleName like  @fio
	  and c.ComponentName like  @lbl
	  and j.Text like  @text
	  and CAST(j.Started AS DATE) >= @mindate
	  and CAST(j.finished AS DATE) <= @maxdate

group by
  --CAST(j.Started AS DATE)
    format(j.Started, 'MM.yyy')
 -- ,s.serialno 
  , p.LastName + ' '+p.FirstName + ' '+p.MiddleName
  , sen.Name
--  ,c.ComponentName 
  ,j.Text 

order by Text, FIO
--, server


end