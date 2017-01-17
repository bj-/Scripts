set nocount on;

--use Shturman_Metro

-- соединяем все RR в одну таблицу

DECLARE @SQL NVARCHAR(MAX) = '', @TableName NVARCHAR(MAX) = '';
DECLARE @Template NVARCHAR(MAX) = 'SELECT * FROM %s';

DECLARE RRs CURSOR FOR
	SELECT name FROM sys.tables WHERE name LIKE 'SensorsDataRRSO2%'

OPEN RRs;

FETCH NEXT FROM RRs INTO @TableName;
WHILE @@FETCH_STATUS = 0 BEGIN
	
	IF @SQL = ''
		SET @SQL = REPLACE(@Template, '%s', @TableName)
	ELSE
		SET @SQL = @SQL + ' UNION ALL ' + REPLACE(@Template, '%s', @TableName)

	FETCH NEXT FROM RRs INTO @TableName;
END;

DEALLOCATE RRs;

CREATE TABLE #TempRRs(
	[Guid] [uniqueidentifier] NOT NULL,
	[SensorsGuid] [uniqueidentifier] NOT NULL,
	[ServersGuid] [uniqueidentifier] NOT NULL,
	[Received] [datetime2](7) NOT NULL,
	[TickCount] [bigint] NULL,
	[Value] [smallint] NULL,
	[FIRR] [bigint] NULL,
	[FIRIR] [bigint] NULL,
	[Validity] [tinyint] NULL,
	[Deactivated] [tinyint] NULL
)

SET @SQL = 'INSERT INTO #TempRRs SELECT * FROM (' + @SQL + ') RRs';

EXEC sp_executesql @SQL

-----------------------------------------


  SELECT    
  REPLACE (MetroLines.Name, ' ГУП «Мосгортранс»', '') 'Парк' ,
  SessionsTime.dt 'Дата',
  Persons.LastName+' '+SUBSTRING(Persons.FirstName, 1,1)+'. '+SUBSTRING(Persons.MiddleName, 1, 1) + '.'  'ФИО', SerialNo,  
 format(dateadd ( SECOND,SessionsTime.sec,''),'HH:mm:ss') 'Датчик включен, часов',  
 -- format(dateadd ( SECOND, RRsTime.sec,''),'HH:mm:ss') 'датчик н адет, часов',  
 IIF (SessionsTime.sec > ISNULL( RRsTime.sec ,0) , format(dateadd ( SECOND, ISNULL( RRsTime.sec ,0),''),'HH:mm:ss') , format(dateadd ( SECOND,SessionsTime.sec,''),'HH:mm:ss')) 'Датчик надет, часов',
 ISNULL( ejourSleep.press_ej,0) 'Количество нажатий Монотония на ЭЖУР',
 ISNULL( ejourStress.press_ej,0) 'Количество нажатий Гиперактивация на ЭЖУР',
 isnull(convert(varchar,(select max(umi.InspectionsDate) from UsersMedicalInspections umi where umi.UsersGuid = Users.Guid and SessionsTime.dt = convert(date, umi.InspectionsCreated) 
 and umi.InspectionsDate > '19100101' and DatePart(day, Umi.InspectionsDate) = DatePart(day, SessionsTime.DT) and DatePart(month, Umi.InspectionsDate) = DatePart(MONTH, SessionsTime.DT)),108),'Нет') 'Время прохождения медосмотра' ,
 (select count(*) from DriversSignals dsig where PlayType = 1 and convert(date,dsig.Played) = convert(date, SessionsTime.DT) and dsig.UsersGuid = Users.Guid) 'Количество монотоний в кабину',
 (select count(*) from DriversSignals dsig where PlayType = 2 and convert(date,dsig.Played) = convert(date, SessionsTime.DT) and dsig.UsersGuid = Users.Guid) 'Количество гиперактиваций в кабину',
 (select count(*) from DriversSignals dsig where PlayType = 1 and SignalDestination = 2 and convert(date,dsig.Played) = convert(date, SessionsTime.DT) and dsig.UsersGuid = Users.Guid) 'Количество монотоний Оператору',
 (select count(*) from DriversSignals dsig where PlayType = 2 and SignalDestination = 2 and convert(date,dsig.Played) = convert(date, SessionsTime.DT) and dsig.UsersGuid = Users.Guid) 'Количество гиперактиваций Оператору',
 (select count(*) from UsersMedicalInspectionsSending senmed where convert(date,senmed.Sended) = convert(date, SessionsTime.DT) and senmed.UsersGuid = Users.Guid) 'Количество Медосмотров'
-- (select count(*) from Journal where Journal.Code = 'JOURNAL_SENDTOMEDINS' and convert(date,Journal.Created) = convert(date, SessionsTime.DT) and Journal.ForeignGuid = Users.Guid) 'Количество Медосмотров'
FROM  Users , Persons , Roles  ,
(
SELECT format(Received ,'yyy.MM.dd') dt , SensorsCardio.UserGuid , CAST(SUM(Value/1000.0) AS INT) * 1.5 sec, Sensors.SerialNo
 FROM #TempRRs , SensorsCardio, Sensors      
 WHERE 
 SensorsCardio.Guid=#TempRRs.SensorsGuid and SensorsCardio.Guid=Sensors.Guid 
 and ((Validity > 70) and (Validity <= 100) and (Deactivated = 0)     and (FIRR > 0) and (FIRIR > 0) and (FIRIR / FIRR > 0.5) and (FIRIR / FIRR < 10))
GROUP BY format(Received ,'yyy.MM.dd')  , SensorsCardio.UserGuid, Sensors.SerialNo    
)  RRsTime
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
   UsersJournalTypesId = 7
  group by  format(j.started ,'yyy.MM.dd'),
      UsersGuid

) ejourSleep  ON SessionsTime.dt = ejourSleep.dt
 and SessionsTime.UsersGuid = ejourSleep.UsersGuid
  
 left outer join
(
SELECT 
  format(j.started ,'yyy.MM.dd') dt,
  UsersGuid,
  count(*) press_ej

  FROM UsersJournal j
  WHERE
   UsersJournalTypesId = 8
  group by  format(j.started ,'yyy.MM.dd'),
      UsersGuid

) ejourStress  ON SessionsTime.dt = ejourStress.dt
 and SessionsTime.UsersGuid = ejourStress.UsersGuid
 ,
 MetroLines

WHERE Roles.Code = dbo.GetRolesCodeDriver() 
 and Persons.Guid=PersonsGuid
 and Roles.Guid=Users.RolesGuid
 and SessionsTime.UsersGuid = Users.Guid

 and MetroLines.Guid = '00000000-0000-0000-0000-000000000004'
ORDER BY 1, 2 ,3

-- удаляем временную таблицу
DROP TABLE #TempRRs