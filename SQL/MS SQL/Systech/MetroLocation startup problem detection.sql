/*** ��������� ��������� ��� ������ ������������� ��� ������, � �� ���������� ������ �� ���� ***/
select 
c.ServersGuid, s.SerialNo, convert(date, j.Started) as '����� ��������� (����)', datepart(HOUR,j.Started) as '����� ��������� (���)', count(*)  as '���-�� ��������� �� ���'
from ServersOnBoardJournal j
inner join ServersOnBoardComponents c on c.Guid = j.ServersOnBoardComponentsGuid
inner join Servers as [s] ON s.Guid = c.ServersGuid
where c.ComponentName = 'LabelPosition' and DATEDIFF(SECOND, Started, Finished) = 0 
and (not j.Text like '%>%')
group by c.ServersGuid, s.SerialNo, convert(date, j.Started), datepart(HOUR,j.Started) having count(*) > 1
order by c.ServersGuid, convert(date, j.Started), datepart(HOUR,j.Started)


/* 
���������:
�� ����� � ������ �� ��������� READ_COMMITTED_SNAPSHOT � ���

ALTER DATABASE SHTURMAN_METRO
SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE
GO

*/