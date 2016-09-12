/*                          Перенос базы tempdb на другой диск
   В случае возникновения необходимости перенесения базы данных tempdb необходимо выполнить данную команду        */

use master
alter database tempdb
modify file(
name = tempdev,
filename = N'C:\Новое_место\tempdb.mdf')
go

alter database tempdb
modify file(
name = templog,
filename = N'C:\Новое_место\templog.ldf')
go

/*   и перезапустить MS SQL Server. При перезапуске сервер баз данных создаст базу tempdb в новом месте, а старые файлы необходимо удалить вручную.  */
