SELECT s.serialno server
      ,c.ComponentName label
      ,c.Text Text
      ,c.Changed Start
      , NUll  as Finish
	  , NUll as UserGuid
	  --, NUll as FIO
  FROM ServersOnBoardComponents c, Servers s
  WHERE c.serversguid = s.guid
	and s.serialno  in ('STB10303')--, 'STB08627')
  --and c.Changed like  '%нет%'
  --and c.Text like  '%Воронков%'
  and c.Text not in ('Спасская >
Достоевская', 'Достоевская >
Лиговский проспект', 'Новочеркасская >
Ладожская', 'пл.Александра Невского - 2 >
Лиговский проспект', 'Лиговский проспект >
пл.Александра Невского - 2', 'Новочеркасская >
пл.Александра Невского - 2', 'Лиговский проспект >
Достоевская', 'Проспект Большевиков >
улица Дыбенко', 'Ладожская >
Проспект Большевиков','Достоевская >
Спасская', 'пл.Александра Невского - 2 >
Новочеркасская', 'улица Дыбенко >
Проспект Большевиков', 'Проспект Большевиков >
Ладожская','Ладожская >
Новочеркасская', 'Спасская >
Спасская', 'улица Дыбенко >
улица Дыбенко')

union

SELECT  s.serialno server
      ,c.ComponentName label
      ,j.Text Text
      ,j.Started Start
      ,j.Finished as Finish
	  ,j.UsersGuid as UserGuid
	  --,CONCAT(p.LastName, ' ', p.FirstName, ' ', p.MiddleName) as FIO
FROM 
	ServersOnBoardJournal j, 
	ServersOnBoardComponents c, 
	Servers s /*, 
	users u, 
	Persons p */
	--inner join users AS u ON j.UsersGuid = u.Guid
	--inner join Persons AS p ON u.PersonsGuid = p.Guid
WHERE 
	j.ServersOnBoardComponentsGuid = c.Guid
    and c.serversguid = s.guid
	--and j.UsersGuid = u.Guid
	--and u.PersonsGuid = p.Guid
	and s.serialno  in ('STB10303')--, 'STB08627')
	--and j.Text like '%нет%'
--  and j.Text in ('Спасская', 'улица Дыбенко')
  and j.Text not in ('Спасская >
Достоевская', 'Достоевская >
Лиговский проспект', 'Новочеркасская >
Ладожская', 'пл.Александра Невского - 2 >
Лиговский проспект', 'Лиговский проспект >
пл.Александра Невского - 2', 'Новочеркасская >
пл.Александра Невского - 2', 'Лиговский проспект >
Достоевская', 'Проспект Большевиков >
улица Дыбенко', 'Ладожская >
Проспект Большевиков','Достоевская >
Спасская', 'пл.Александра Невского - 2 >
Новочеркасская', 'улица Дыбенко >
Проспект Большевиков', 'Проспект Большевиков >
Ладожская','Ладожская >
Новочеркасская', 'Спасская >
Спасская', 'улица Дыбенко >
улица Дыбенко')
--order by server asc, start desc
order by start desc

--Select * from users where guid = 'A074F10E-5DA9-463E-8D68-3FA2BCE858B4'
--select * from Persons where Guid = 'DB8AB0DF-1413-435F-BF42-F2306D611045'
/*
select * from persons where LastName like '%никола%'
Select * from users where PersonsGuid = 'D2AD42E3-797D-4623-8EC0-6DD8EB4B86C6'
select * from SensorsCardio where UserGuid = '40BD2A46-8551-4C7B-9787-462A0643E644'
*/

/*
select * from ServersOnBoardJournal
where [text] not in ('Спасская >
Достоевская', 'Достоевская >
Лиговский проспект', 'Новочеркасская >
Ладожская', 'пл.Александра Невского - 2 >
Лиговский проспект', 'Лиговский проспект >
пл.Александра Невского - 2', 'Новочеркасская >
пл.Александра Невского - 2', 'Лиговский проспект >
Достоевская', 'Проспект Большевиков >
улица Дыбенко', 'Ладожская >
Проспект Большевиков','Достоевская >
Спасская', 'пл.Александра Невского - 2 >
Новочеркасская', 'улица Дыбенко >
Проспект Большевиков', 'Проспект Большевиков >
Ладожская','Ладожская >
Новочеркасская')
*/