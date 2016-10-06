/****** Script for SelectTopNRows command from SSMS  ******/
set nocount on;

select Name from [Shturman_Metro].[dbo].[MetroLines]
  where guid = '00000000-0000-0000-0000-000000000004'

SELECT 
	CONCAT(
		'�������� ��� ��������� ��� �����������: ',
		FORMAT([Connected], 'dd.MM.yyy HH:mm:ss') ,
		'. � ��������� �����: ',
		IIF([isConnected] = 1 , '���������', '��������') 
	)

  FROM [Shturman_Metro].[dbo].[Servers]
  Where SerialNo = 'OperatorZDC'


  