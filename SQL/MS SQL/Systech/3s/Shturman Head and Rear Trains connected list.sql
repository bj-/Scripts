/****** Script for SelectTopNRows command from SSMS  ******/
SELECT       [Alias],      [Is_Connected],      [Connected],      [IpAddress],      [Changed]
  FROM [Shturman3].[dbo].[Servers]
  where 
   Alias in ('STB22001','STB56005',
             'STB22002','STB56006','STB56022')
  and Is_Connected = 1
    order by Is_Connected DESC, Connected DESC

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT       [Alias],      [Is_Connected],      [Connected],      [IpAddress],      [Changed]
  FROM [Shturman3].[dbo].[Servers]
  where 
  Alias in (
  'STB56003','STB56007','STB56009','STB56011','STB56013','STB56015','STB56017','STB56019','STB56021',
  'STB56004','STB56008','STB56010','STB56012','STB56014','STB56016','STB56018','STB56020')
  and Is_Connected = 1
    order by Alias ASC
