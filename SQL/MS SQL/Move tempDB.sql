/*                          ������� ���� tempdb �� ������ ����
   � ������ ������������� ������������� ����������� ���� ������ tempdb ���������� ��������� ������ �������        */

use master
alter database tempdb
modify file(
name = tempdev,
filename = N'C:\�����_�����\tempdb.mdf')
go

alter database tempdb
modify file(
name = templog,
filename = N'C:\�����_�����\templog.ldf')
go

/*   � ������������� MS SQL Server. ��� ����������� ������ ��� ������ ������� ���� tempdb � ����� �����, � ������ ����� ���������� ������� �������.  */
