/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
      [Alias],
      [Is_Connected],
      [Connected],
      [IpAddress],
      [Changed]
  FROM [Shturman3].[dbo].[Servers]
  where 
  Alias not in ('STB01110','STB01111','STB01112','STB01119','STB01155','STB01156',
  'STB22001','STB22002','STB22003','STB22004','STB22005','STB22006','STB22007','STB22008','STB22013','STB22015','STB22016',
  'STB22019','STB22021','STB22022','STB22064','STB22066','STB22067','STB22068','STB22071','STB22072',
  'STB56005','STB56006','STB56007','STB56008','STB56011','STB56012','STB56015','STB56016','STB56019','STB56020','STB56021','STB56023','STB56024',
	'STB56028','STB56017','STB56018','STB22020', 'STB01146',  'STB01151','STB01109','STB56034', 'STB56014','STB56013','STB22010', 'STB22009',
	'STB56009','STB56003','STB56004','STB01117','STB01153','STB08493','STB10253','STB22018','STB01116','STB22017','STB10404','STB10405',
	'STB22014','STB01136','STB56010','STB01154', 'STBEKA-06-1','STBEKA-06-2','STBEKA-07-1','STBEKA-07-2','STB01118','STB01142','STB01135',
	'STB22011','STB22012',
  'STB56025','STB56026','STB56027','STB56029','STB56030','STB56031','STB56032', 'GUI_LP_BolshevikiST', 'GUI_DA_AN1', 'GUI_DA_AN2')
  --and Alias not like '2200?'
  and (Is_Connected = 1 or Connected >= '2017-12-08')


  order by Is_Connected DESC, Connected DESC



/******
SELECT [Alias],[Is_Connected],[Connected],[IpAddress],[Changed]
  FROM [Shturman3].[dbo].[Servers]
  where (Is_Connected = 1 or Connected >= '2017-11-27')
  order by Is_Connected DESC, Connected DESC


  -- */