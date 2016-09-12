USE [Shturman_Metro]
GO

INSERT INTO [dbo].[StateValuesNormal]
           ([Guid]
           ,[SensorsGuid]
           ,[Calculated]
           ,[Validity])

	 SELECT [Guid]
      ,[SensorsGuid]
      ,[Calculated]
      ,[Validity]
  FROM [172.16.0.105].[Shturman_Metro_2016-03-30].[dbo].[StateValuesNormal]





INSERT INTO [dbo].[StateValuesNormalStorage]
           ([Guid]
           ,[StateValuesNormalGuid]
           ,[StateValuesTypeId]
           ,[NormalValueMin]
           ,[NormalValueMax]
           ,[NormalValueAverage])
     
SELECT [Guid]
      ,[StateValuesNormalGuid]
      ,[StateValuesTypeId]
      ,[NormalValueMin]
      ,[NormalValueMax]
      ,[NormalValueAverage]
  FROM [172.16.0.105].[Shturman_Metro_2016-03-30].[dbo].[StateValuesNormalStorage]
