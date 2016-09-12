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
  --and c.Changed like  '%���%'
  --and c.Text like  '%��������%'
  and c.Text not in ('�������� >
�����������', '����������� >
��������� ��������', '�������������� >
���������', '��.���������� �������� - 2 >
��������� ��������', '��������� �������� >
��.���������� �������� - 2', '�������������� >
��.���������� �������� - 2', '��������� �������� >
�����������', '�������� ����������� >
����� �������', '��������� >
�������� �����������','����������� >
��������', '��.���������� �������� - 2 >
��������������', '����� ������� >
�������� �����������', '�������� ����������� >
���������','��������� >
��������������', '�������� >
��������', '����� ������� >
����� �������')

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
	--and j.Text like '%���%'
--  and j.Text in ('��������', '����� �������')
  and j.Text not in ('�������� >
�����������', '����������� >
��������� ��������', '�������������� >
���������', '��.���������� �������� - 2 >
��������� ��������', '��������� �������� >
��.���������� �������� - 2', '�������������� >
��.���������� �������� - 2', '��������� �������� >
�����������', '�������� ����������� >
����� �������', '��������� >
�������� �����������','����������� >
��������', '��.���������� �������� - 2 >
��������������', '����� ������� >
�������� �����������', '�������� ����������� >
���������','��������� >
��������������', '�������� >
��������', '����� ������� >
����� �������')
--order by server asc, start desc
order by start desc

--Select * from users where guid = 'A074F10E-5DA9-463E-8D68-3FA2BCE858B4'
--select * from Persons where Guid = 'DB8AB0DF-1413-435F-BF42-F2306D611045'
/*
select * from persons where LastName like '%������%'
Select * from users where PersonsGuid = 'D2AD42E3-797D-4623-8EC0-6DD8EB4B86C6'
select * from SensorsCardio where UserGuid = '40BD2A46-8551-4C7B-9787-462A0643E644'
*/

/*
select * from ServersOnBoardJournal
where [text] not in ('�������� >
�����������', '����������� >
��������� ��������', '�������������� >
���������', '��.���������� �������� - 2 >
��������� ��������', '��������� �������� >
��.���������� �������� - 2', '�������������� >
��.���������� �������� - 2', '��������� �������� >
�����������', '�������� ����������� >
����� �������', '��������� >
�������� �����������','����������� >
��������', '��.���������� �������� - 2 >
��������������', '����� ������� >
�������� �����������', '�������� ����������� >
���������','��������� >
��������������')
*/