# Файл настроек скрипта BackUp.ps1

[bool]$Debug = $TRUE


	# Log Files
	[switch]$Log = $TRUE				# Бэкап и обслуживание Log файлов ( бех этого колюча остальные из группы игнорируются)
	[string]$DateFormatLog = "yy-MM-dd"
	[string]$LogFilePath = "D:\Shturman\Bin\Log"
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old"
	[string]$LogFilePurgeDays = "30"    # Days
	[switch]$PurgeLogFiles = $TRUE     # похоронить архивы старше  $LogFilePurgeDays дней
	[switch]$UploadLogFiles = $FALSE    # Заливка лог файлов на сервер.
	[switch]$FastArcive = $FALSE        # более легковесный упаковщик. без флага - пакует по максимому, что в Х раз дольше. но немного меньше места занимает
	[switch]$LogFileAll2Arc = $FALSE    # заставляет упаковывать все лог файлы. включая сегоднящние

# SQL

	[bool]$SQL = $TRUE				# Бэкап и обслуживание SQL ( бех этого колюча остальыне из группы SQL* игнорируются)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS"
#	[string]$SQLDBName = "Shturman_Metro"
#	[string]$SQLUsername = "BackUpOperator"
#	[string]$SQLPassword = "diF80noY"
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro"
	[array]$SQLBackUpFileMask = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_*.bak")
	[int]$SQLBackUpDaily = "7" # Days
	[int]$SQLBackUp10days = "60" # Days
	[int]$SQLBackUpMontly = "100" # Days