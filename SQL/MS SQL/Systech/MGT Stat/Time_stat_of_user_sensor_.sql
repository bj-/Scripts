set nocount on;

--use Shturman_Metro

  SELECT    
  REPLACE (MetroLines.Name, ' ��� ������������', '') '����' ,
  SessionsTime.dt '����',
  Persons.LastName+' '+SUBSTRING(Persons.FirstName, 1,1)+'. '+SUBSTRING(Persons.MiddleName, 1, 1) + '.'  '���',   
 format(dateadd ( SECOND,SessionsTime.sec,''),'HH:mm:ss') '������ �������, �����',  
 -- format(dateadd ( SECOND, RRsTime.sec,''),'HH:mm:ss') '������ � ����, �����',	 
 IIF (SessionsTime.sec > ISNULL( RRsTime.sec ,0) , format(dateadd ( SECOND, ISNULL( RRsTime.sec ,0),''),'HH:mm:ss') , format(dateadd ( SECOND,SessionsTime.sec,''),'HH:mm:ss')) '������ �����, �����',
 ISNULL( ejour.press_ej,0) '���������� ������� �� ����'
	

FROM  Users , Persons , Roles  ,
(
SELECT format(Received ,'yyy.MM.dd') dt , SensorsCardio.UserGuid , CAST(SUM(Value/1000.0) AS INT) * 1.5 sec
	FROM SensorsDataRRSO2 , SensorsCardio      
 WHERE 
 SensorsCardio.Guid=SensorsDataRRSO2.SensorsGuid
 and	((Validity > 70) and (Validity <= 100) and (Deactivated = 0)     and (FIRR > 0) and (FIRIR > 0) and (FIRIR / FIRR > 0.5) and (FIRIR / FIRR < 10))
GROUP BY format(Received ,'yyy.MM.dd')  , SensorsCardio.UserGuid    
) 	RRsTime
 right outer join
(
SELECT format(started ,'yyy.MM.dd') dt , UsersGuid , SUM(DATEDIFF(SECOND, Started, Finished))  sec FROM Sessions --WHERE  /*  AND Sessions.Started>='20160420 00:00:00.000'  AND Sessions.Started<='20160521 00:00:00.000'*/ 
GROUP BY format(started ,'yyy.MM.dd')  , UsersGuid 
) SessionsTime 
ON
  SessionsTime.dt = RRsTime.dt
 and SessionsTime.UsersGuid = RRsTime.UserGuid

 left outer join
(
SELECT 
	 format(j.started ,'yyy.MM.dd') dt,
	 UsersGuid,
	 count(*) press_ej

  FROM UsersJournal j
  WHERE
   UsersJournalTypesId in ( 7,8)
  group by  format(j.started ,'yyy.MM.dd'),
      UsersGuid

) ejour  ON SessionsTime.dt = ejour.dt
 and SessionsTime.UsersGuid = ejour.UsersGuid
 , MetroLines

WHERE Roles.Code = dbo.GetRolesCodeDriver() 
 and Persons.Guid=PersonsGuid
 and Roles.Guid=Users.RolesGuid
 and SessionsTime.UsersGuid = Users.Guid

 and MetroLines.Guid = '00000000-0000-0000-0000-000000000004'
ORDER BY 1, 2 ,3

