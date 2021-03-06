/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Guid]
      ,[Created]
      ,[Code]
      ,[Description]
      ,[NeedConfirmation]
      ,[Confirmed]
      ,[ForeignGuid]
      ,[UserConfirmedGuid]
  FROM [Shturman_Metro].[dbo].[Journal]
  where NeedConfirmation = 1 and Confirmed is null

/*
update Journal set ForeignGuid = 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFF19' where [guid] = 'AB960CC6-6B24-4107-8F03-1DC945B3C036'
6A0CAA42-F415-4C85-A6E2-06A1656E2421
AB960CC6-6B24-4107-8F03-1DC945B3C036
*/
  /*
  update [Journal] set Confirmed = NULL, userconfirmedguid = NULL
  where [Guid] in ('C743247C-AB55-4D8C-89DF-E8D521D9EA69', '58EBE72D-BB68-4087-A6F5-A49A38F66C9E', '6A0CAA42-F415-4C85-A6E2-06A1656E2421', '6A0CAA42-F415-4C85-A6E2-06A1656E2421', 'AB960CC6-6B24-4107-8F03-1DC945B3C036')
  --*/

  /*
  select * from Users where [guid] = '95D4DCF0-0946-48FC-A642-BFB7324D54CA'
  --*/

  /*
  update [Users] set [Rights] = 'SUPERVISOR,ANALYST_ID,CONNECT_AS_GARNITURE,CONNECT_AS_CLIENT,EDIT_OPTIONS,EDIT_DICTIONARIES,VIEW_STATE,VIEW_HISTORY_STATE,JOURNAL_ALL_EVENTS,VIEW_ALARM,'
  where [guid] = '95D4DCF0-0946-48FC-A642-BFB7324D54CA';

  update [Users] set [Rights] = 'CONNECT_AS_CLIENT,'
  where [guid] = '95D4DCF0-0946-48FC-A642-BFB7324D54CA';

  --*/


  /*
  select * from users
  where PersonsGuid in ('FFFFFFFF-FFFF-FFFF-0000-FFFFFFFFFF19','FFFFFFFF-FFFF-FFFF-0000-FFFFFFFFFF42')

  select * from Persons where LastName in ('Андреев', 'Ефремов')
   
FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFF19  Ефремов
FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFF42  Андреев

*/