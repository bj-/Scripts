USE [Shturman_Metro_2016-05-05_2016-05-12]
GO
DBCC SHRINKDATABASE(N'Shturman_Metro_2016-05-05_2016-05-12' )
GO



/* Change the recovery model from full to simple, and then back to full. Shrink the file using DBCC SHRINKFILE with the TRUNCATEONLY argument */

/* The following command will change the recovery model from full to simple */
ALTER DATABASE <databse_name> SET RECOVERY SIMPLE

/* To find the name of the log file you can use the following query
SELECT name  */
FROM sys.master_files
WHERE database_id = DB_ID('<databse_name>')

/* Shrink the file */
DBCC SHRINKFILE (N'<logical_file_name_of_the_log>' , 0, TRUNCATEONLY)

/* The following command will change the recovery model to full */
ALTER DATABASE <databse_name> SET RECOVERY FULL