/****** Нажатия на ЭЖУР  ******/
set nocount on;

SELECT /*
       [Guid]
      ,[UsersGuid]
      ,[UsersJournalTypesId]
      ,[Started]
      ,[Finished]
	  */
	 format(j.started ,'yyy.MM.dd') 'Дата',
	 p.LastName +' '+ p.FirstName +' '+ p.MiddleName ' ФИО ',
	 count(*) 'Количество'

  FROM [Shturman_Metro].[dbo].[UsersJournal] j, [Shturman_Metro].[dbo].[Users] u, [Shturman_Metro].[dbo].[Persons] p
  WHERE
  j.UsersGuid = u.guid
  and u.PersonsGuid = p.guid
  and UsersJournalTypesId in ( 7,8)
  and  DATEDIFF(DD, j.[Started], SYSDATETIME()) =1
  

  group by  format(j.started ,'yyy.MM.dd'),
      p.LastName, p.FirstName, p.MiddleName
    
  order by  'Дата',' ФИО '