 SELECT [s].[Alias], [s].[Is_Connected], [s].[IpAddress], [s].[Changed], [svc].[Alias], MAX([svca].[Value]) AS [UpdVersion] --, MAX([svca].[Modified]) AS [Updated at] 
  FROM
  (
SELECT [s].[Alias]/*, [s].[Is_Connected], [s].[IpAddress], [s].[Changed], [svc].[Alias]*/, MAX([svca].[Value]) mv, MAX([svca].[Modified]) md
  FROM [Servers] AS [s]
  LEFT JOIN [Services] AS [svc] ON [svc].[Servers_Guid] = [s].[Guid]
  LEFT JOIN [Services_Attributes] AS [svca] ON [svca].[Services_Guid] = [svc].[Guid]
--  WHERE [s].[Is_Connected] = 1
  GROUP BY [s].[Alias]/*, [s].[Is_Connected], [s].[IpAddress], [s].[Changed], [svc].[Alias]*/
  ) ssa,
   [Servers] AS [s]
  LEFT JOIN [Services] AS [svc] ON [svc].[Servers_Guid] = [s].[Guid]
  LEFT JOIN [Services_Attributes] AS [svca] ON [svca].[Services_Guid] = [svc].[Guid]
  WHERE --[s].[Is_Connected] = 1
 --and 
 [s].[IpAddress] IS NOT NULL AND
 [s].[Alias] not in ('STB0001', 'STB8888', 'STB9999', 'STB01148', 'STB01131', 'STB01132') AND
  ssa.[Alias] = [s].[Alias]
  and ssa.mv = [svca].[Value]
  GROUP BY [s].[Alias], [s].[Is_Connected], [s].[IpAddress], [s].[Changed], [svc].[Alias]
--order by [s].[Alias]
order by MAX([svca].[Value]), [s].[Alias] ASC

