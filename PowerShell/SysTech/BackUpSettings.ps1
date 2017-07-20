# Файл настроек скрипта BackUp.ps1

<#
	# Log Files
	[switch]$Log = $TRUE				# Бэкап и обслуживание Log файлов ( бех этого колюча остальные из группы игнорируются)
	[string]$DateFormatLog = "yy-MM-dd"
	[string]$LogFilePath = "D:\Shturman\Bin\Log"
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old"
#    [string]$LogFolderForArchives = $env:computername
	[string]$LogFilePurgeDays = "30"    # Days
	[switch]$PurgeLogFiles = $TRUE     # похоронить архивы старше  $LogFilePurgeDays дней
	[switch]$UploadLogFiles = $FALSE    # Заливка лог файлов на сервер.
	[switch]$FastArcive = $FALSE        # более легковесный упаковщик. без флага - пакует по максимому, что в Х раз дольше. но немного меньше места занимает
	[switch]$LogFileAll2Arc = $FALSE    # заставляет упаковывать все лог файлы. включая сегоднящние

    # Errors log Archiver 
	[switch]$Errors = $FALSE				# Архивирование Errors файлов
	[string]$ErrorsPath = "D:\Shturman\Bin\Errors"		# Папка где лежат Errors, запакует все в каталог $LogFilePathOld\Errors с именем Errors_yyyy_MM_dd.7z
#>

    # SQL
	[switch]$SQL = $FALSE,				# Бэкап и обслуживание SQL ( без этого колюча остальыне из группы SQL* игнорируются)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro",
	[string]$SQLExportPath = "D:\BackUp\2Tape",
	[switch]$SQLExport = $FALSE # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
	[array]$SQLBackUpFileMask = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_*.bak")
	#[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm"
	[int]$SQLBackUpDaily = "7" # Days
	[int]$SQLBackUp10days = "60" # Days
	[int]$SQLBackUpMontly = "180" # Days

<#
# SVN
	[switch]$SVN = $TRUE				# Бэкап и обслуживание SVN ( без этого колюча остальные из группы SVN* игнорируются)
	[string]$SVNRepoPath = "D:\Repositories"
	[string]$SVNBackUpPath = "D:\BackUp\SVN"
	[int]$SVNBackUpDaily = "7"          # Days
	[int]$SVNBackUp10days = "30"        # Days
	[int]$SVNBackUpMontly = "90"        # Days

#>
        # Common
        [switch]$HighestPrivelegesIsRequired = $FALSE
