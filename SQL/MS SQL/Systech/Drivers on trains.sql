/****** Скрипт для выбора мешинистов, гарнитур и поездов нп линии  ******/
SELECT p.LastName, p.FirstName, p.MiddleName
, s.SerialNo 'номер гарнитуры'
, s.BatteryLevel 'заряд'
--, sc.IsConnected 'подключено'
--, sc.Connected 
--, sc.StateChanged
, sv.SerialNo 'сервер'
, ve.Name 'состав'
, mt.Route 'маршрут'

  FROM SensorsCardio sc, Sensors s, Servers sv, Vehicles ve, MetroTrains mt,
  users u, persons p
  where
  sc.Guid = s.guid
  and sc.UserGuid = u.Guid
  and u.PersonsGuid = p.Guid
  and sc.ServersGuid =sv.Guid
  and sv.VehiclesGuid = ve.Guid
  and ve.Guid = mt.Guid and mt.IsActive = 1
  and sc.IsConnected = 1
  and sc.UserGuid = ve.UsersGuid

  and p.LastName like '%'
  and s.SerialNo like 'STH00-%'
  and sv.SerialNo like 'STB%'
  and mt.Route like '%'