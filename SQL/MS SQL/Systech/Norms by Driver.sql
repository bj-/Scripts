/****** Нормы по машинисту (те что хочет Арс)  ******/
SELECT TOP 1000
		[sn].[Name]
		,[svn].[calculated]
		,svn.Validity
      --,[StateValuesNormalGuid]
      ,[StateValuesTypeId]
      ,[NormalValueMin]
      ,[NormalValueMax]
      ,[NormalValueAverage]
  FROM [StateValuesNormalStorage] AS [svnv]
inner join StateValuesNormal as svn on svn.Guid = [svnv].StateValuesNormalGuid
inner join Sensors as sn on sn.guid = svn.SensorsGuid
WHERE 
	[sn].[Name] like 'STH00-098'
	AND [svn].[calculated] BETWEEN '2018-05-10' AND '2018-05-20'


/****** Нормы Групповые (те что хочет Арс)  ******/
SELECT TOP 1000
		[svn].[calculated]
		,svn.Validity
      --,[StateValuesNormalGuid]
      ,[StateValuesTypeId]
      ,[NormalValueMin]
      ,[NormalValueMax]
      ,[NormalValueAverage]
  FROM [StateValuesNormalStorage] AS [svnv]
inner join StateValuesNormal as svn on svn.Guid = [svnv].StateValuesNormalGuid

WHERE 
	svn.SensorsGuid IS NULL
	AND [svn].[calculated] BETWEEN '2018-05-14' AND '2018-05-18'


--select * from StateValuesNormal