SELECT Persons.LastName, Persons.FirstName, Persons.MiddleName, DATEPART(MONTH, Started) [Месяц], COUNT(*) [Кол-во], UsersGuid FROM ServersOnBoardJournal
 INNER JOIN Users ON Users.Guid = ServersOnBoardJournal.UsersGuid
 INNER JOIN Persons ON Persons.Guid = Users.PersonsGuid
WHERE Text='Поправьте индивидуальный датчик'
GROUP BY UsersGuid, DATEPART(MONTH, Started), Persons.LastName, Persons.FirstName, Persons.MiddleName
ORDER BY Persons.LastName, Persons.FirstName, Persons.MiddleName, DATEPART(MONTH, Started)