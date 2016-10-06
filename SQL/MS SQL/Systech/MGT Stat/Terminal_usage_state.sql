/****** Script for SelectTopNRows command from SSMS  ******/
set nocount on;

select Name from [Shturman_Metro].[dbo].[MetroLines]
  where guid = '00000000-0000-0000-0000-000000000004'

SELECT 
	CONCAT(
		'Оператор ЗДЦ последний раз подключился: ',
		FORMAT([Connected], 'dd.MM.yyy HH:mm:ss') ,
		'. В настоящее время: ',
		IIF([isConnected] = 1 , 'Подключен', 'Отключен') 
	)

  FROM [Shturman_Metro].[dbo].[Servers]
  Where SerialNo = 'OperatorZDC'


  