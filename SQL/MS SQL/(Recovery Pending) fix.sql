/*
   How to fix Recovery Pending State in SQL Server Database?
   https://www.stellarinfo.com/blog/fix-sql-database-recovery-pending-state-issue/

   Other methods can see on page


   Once you have opened the db in EMERGENCY mode, 
   try repairing the database using the DBCC CHECKDB command with the ‘REPAIR_ALLOW_DATA_LOSS’ option. 
   To do so, open SSMS and execute the following set of queries:
*/

ALTER DATABASE [DBName] SET EMERGENCY;
GO
ALTER DATABASE [DBName] set single_user
GO
DBCC CHECKDB ([DBName], REPAIR_ALLOW_DATA_LOSS) WITH ALL_ERRORMSGS;
GO
ALTER DATABASE [DBName] set multi_user
GO