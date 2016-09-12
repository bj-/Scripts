/****** ������ ��� ������ ����������, �������� � ������� �� �����  ******/
SELECT p.LastName, p.FirstName, p.MiddleName
, s.SerialNo '����� ���������'
, s.BatteryLevel '�����'
--, sc.IsConnected '����������'
--, sc.Connected 
--, sc.StateChanged
, sv.SerialNo '������'
, ve.Name '������'
, mt.Route '�������'

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