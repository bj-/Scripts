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
	[switch]$SQL = $FALSE				# Бэкап и обслуживание SQL ( без этого колюча остальыне из группы SQL* игнорируются)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro"
	[string]$SQLExportPath = "D:\BackUp\2Tape"
	[switch]$SQLExport = $TRUE # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    [switch]$SQLExportUploadArc = $TRUE # Архивирование бэкапа для заливки на сервер
    [int]$SQLExportUploadArcPart = 1 # Нарезка архива на части = размер части в МБ, 0 = одним куском

    [switch]$SQLExportUpload = $TRUE # Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
    [string]$SQLExportUploadPath = ("\\172.16.30.139\Share\MCC_D"+(get-date -Format "yyyy-MM-dd")) # Путь куда заливать
    [array]$SQLExportUploadCred = ("Upload","Chi79Mai") # Логин и пароль для заливки

	[array]$SQLBackUpFileMask = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_*.bak")
	#[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm"
	[int]$SQLBackUpDaily = "7" # Days
	[int]$SQLBackUp10days = "60" # Days
	[int]$SQLBackUpMontly = "180" # Days
#>
<#
# SVN
	[switch]$SVN = $TRUE				# Бэкап и обслуживание SVN ( без этого колюча остальные из группы SVN* игнорируются)
	[string]$SVNRepoPath = "D:\Repositories"
	[string]$SVNBackUpPath = "D:\BackUp\SVN"
	[int]$SVNBackUpDaily = "7"          # Days
	[int]$SVNBackUp10days = "30"        # Days
	[int]$SVNBackUpMontly = "90"        # Days

#>

    # Files and folders
	#[switch]$FilesON = $TRUE		# Создавать бекапы файлов/каталогов
	[switch]$FilesON = $FALSE		# Создавать бекапы файлов/каталогов
    [string]$FilesDateFormat = "yyy-MM-dd_HHmm"
	[string]$FilesBackUpPahth = "D:\BackUp\Files"  # Место куда сладируются сделанные бекапы
	[array]$FilesFileName = (
                                # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, ID - на случай архивов с одинаковыми названиями, Compress | $FALSE - сжммать
                                  # --TODO --"Mask Include", "Mask Exclude" - маски файлов
                                ("", "FilePatch", "ID", "Compress"), 
                                ("D:\BackUp", "FilePatch", "ID", "Compress")
                             )		# единичные файлы
	[array]$FilesFolderName =  (
                                    # имя фолдера задаваемого в $FilesBackUpPath , каталог который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9], Маска включаемых файлов, Маска исключаемых
                                      # "Mask Include", "Mask Exclude" - маски файлов
                                    ("", "c:\temp\*", "", "Compress", "", ""), 
                                    ("D:\BackUp", "c:\temp", "ID", "Compress", "", "")
                                    ("D:\BackUp", "c:\temp", "ID", "Compress", "Mask Include", "Mask Exclude")
                                )		# фолдеры целиком
	# Удаление старых архивов (как и логов) или нет?
	[int]$FilesBackUpDaily = "7"			# Days
	[int]$FilesBackUp10days = "60"			# Days
	[int]$FilesBackUpMontly = "0"		# Days (0 - всегда)
	[string]$FilesExportPath = "D:\BackUp\2Tape"
    #[switch]$FilesExport = $TRUE			# Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    [switch]$FilesExport = $FALSE			# Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    [int]$FilesExportUploadArcPart = 100		# Нарезка архива на части = размер части в МБ, 0 = одним куском
    [switch]$FilesExportUpload = $FALSE		# Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
    [string]$FilesExportUploadPath = "\\172.16.30.139\Share\Exp"	# Путь куда заливать
    [array]$FilesExportUploadCred = ("UserName","password")		# Логин и пароль для заливки


    # Common
    [switch]$HighestPrivelegesIsRequired = $FALSE
