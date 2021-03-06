/****** время водителя на ТС  ******/
set nocount on;

SELECT /*
       [Guid]
      ,[ServersGuid]
      ,[SensorsGuid]
      ,[UsersGuid]
      ,[VehiclesGuid]
      ,[SubVehiclesGuid]
	  ,[Route]
	  */
	  format(se.started ,'yyy.MM.dd') 'Дата',
--	  sum( DATEDIFF(ss, se.[Started], se.[Finished])),
      p.LastName +' '+ p.FirstName +' '+ p.MiddleName ' ФИО ',
     format(dateadd ( ss,sum( DATEDIFF(ss, se.[Started], se.[Finished])),''),'hh:mm:ss') 'Время работы'
  FROM [Shturman_Metro].[dbo].[Sessions] se, [Shturman_Metro].[dbo].[Users] u, [Shturman_Metro].[dbo].[Persons] p
  WHERE
  se.UsersGuid = u.guid
  and u.PersonsGuid = p.guid
  and  DATEDIFF(DD, se.[Started], SYSDATETIME()) =1


  group by  format(se.started ,'yyy.MM.dd'),
      p.LastName, p.FirstName, p.MiddleName
 
  order by  'Дата',' ФИО '