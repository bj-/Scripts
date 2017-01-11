SELECT Persons.LastName, Persons.FirstName, Persons.MiddleName, DATEPART(MONTH, Started) [�����], COUNT(*) [���-��], UsersGuid FROM ServersOnBoardJournal
 INNER JOIN Users ON Users.Guid = ServersOnBoardJournal.UsersGuid
 INNER JOIN Persons ON Persons.Guid = Users.PersonsGuid
WHERE Text='��������� �������������� ������'
GROUP BY UsersGuid, DATEPART(MONTH, Started), Persons.LastName, Persons.FirstName, Persons.MiddleName
ORDER BY Persons.LastName, Persons.FirstName, Persons.MiddleName, DATEPART(MONTH, Started)