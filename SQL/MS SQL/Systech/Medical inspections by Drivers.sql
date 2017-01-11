 /*
     Медосмотры Водителей донесенные до системы Штурман.
 */


 SELECT 
	[p].[LastName],
	[p].[FirstName],
	[p].[MiddleName],
	[umi].[InspectionsCreated],
	[umi].[InspectionsDate],
--	[umi].[InspectionsGuid],
	[umi].[InspectionsType],
--	[umi].[SystolicPressure],
--	[umi].[DiastolicPressure],
--	[umi].[RRData],
	[umi].[ExamResult],
	[umi].[RecordingState],
	[umi].[InterShiftExamTime],
	[umi].[InterShiftExamType],
	[umi].[InterShiftExamResult],
	[umi].[Received]
 FROM
	UsersMedicalInspections AS [umi]
	INNER JOIN [Users] AS [u] ON [umi].[UsersGuid] = [u].[Guid]
	INNER JOIN [Persons] AS [p] ON [u].[PersonsGuid] = [p].[Guid]
WHERE 
	[umi].[InspectionsCreated] BETWEEN '2016-12-01' AND '2016-12-31'
	AND [p].[LastName] LIKE '%%'
ORDER BY 
	[umi].[InspectionsCreated] DESC
	



       
      