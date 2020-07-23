if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile -Debug;  break }
# Файл настроек скрипта BackUp.ps1

	# +==============+
	# |   Log Files  |
	# +==============+
	[switch] $Log                  = $TRUE 					     # Бэкап и обслуживание Log файлов ( бех этого колюча остальные из группы игнорируются)
	[string] $LogFilePath          = "D:\Shturman4\Bin\Log"
	[string] $LogFilePathOld       = "D:\Shturman4\Bin\Log\Old"  
	[switch] $PurgeLogFiles        = $TRUE		                     # похоронить архивы старше  $LogFilePurgeDays дней
	# Errors log Archiver 
	[switch] $Errors               = $TRUE						     # Архивирование Errors файлов
	[string] $ErrorsPath           = "D:\Shturman4\Bin\Errors"	  	 # Папка где лежат Errors, запакует все в каталог $LogFilePathOld\Errors с именем Errors_yyyy_MM_dd.7z

	# +==============+
	# |     SQL      |
	# +==============+
	[switch] $SQL                    = $TRUE					    # Бэкап и обслуживание SQL ( без этого колюча остальыне из группы SQL* игнорируются)
	[string] $SQLBackUpPath          = "D:\BackUp\MSSQL"
	[string] $SQLExportPath          = "D:\BackUp\2Tape"
	[array]  $SQLBackUpFileMask      = ("Shturman3_Anal_2*.bak")
	[array]  $SQLLimits              = (3, 30, 180, 365, 0)   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	#[array]  $SQLLimits              = $NULL                  # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]


	# +=========================+
	# |    Files and folders    |
	# +=========================+
	#[switch]$FilesON = $TRUE,		                                         # Создавать бекапы файлов/каталогов
	[switch] $FilesON = $TRUE		                                         # Создавать бекапы файлов/каталогов
	[string] $FilesBackUpPath = "D:\BackUp\Files"           # Место куда сладируются сделанные бекапы
	[array]  $FilesFileName = (
                                  # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, ID - на случай архивов с одинаковыми названиями, Compress | $FALSE - сжммать
                                  # --TODO --"Mask Include", "Mask Exclude" - маски файлов
                                ("", "D:\Shturman4\BIN\Shturman.ini", "Anal", "Compress"),
                                ("", "", "", "")
                             )		# единичные файлы
	[array]  $FilesFolderName =  (
                                      # имя фолдера задаваемого в $FilesBackUpPath , каталог который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9], Маска включаемых файлов, Маска исключаемых
                                      # "Mask Include", "Mask Exclude" - маски файлов
                                    #("", "C:\inetpub\wwwroot\dynamic", "",  "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\includes", "",  "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\request", "",   "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\script", "",    "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\templates", "", "Compress", "", ""), 
                                    ("", "D:\BackUp\Temp\Portal_Anal", "", "", "", ""), 
                                    ("", "", "", "", "", "")
#                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude")
                                )		# фолдеры целиком
	# Удаление старых архивов (как и логов) или нет?
	#[string] $FilesExportPath          = "D:\BackUp\2Tape"
	[string] $FilesExportPath          = "D:\BackUp\2Export"
	[switch] $FilesExport              = $TRUE			                  # Выложить последний файл в каталог для экспорта (хардлинк по возможности)


	# +===================================+
    # |    Purge Old Files/folders        |
	# +===================================+
	[switch]$Purge = $TRUE		                                         # Создавать бекапы файлов/каталогов
	#[switch] $Purge = $FALSE,		                                         # Создавать бекапы файлов/каталогов
	[array]  $PurgeList = (
                                  # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, ID - на случай архивов с одинаковыми названиями, Compress | $FALSE - сжммать
                                  # "Path" - "Путь к месту хранения", "Mask" - маски файлов, ("Limits") - правила удаления (10, 60, 180, 365, 0) - d / 10d / m / q / y
                                ("D:\BackUp\MSSQL", "Shturman3Diag_", ($NULL)),
                                ("D:\BackUp\MSSQL", "ShturmanDiagnostics", ($NULL)),
                                ("D:\BackUp\MSSQL\sRoot", "Shturman3_sRoot", ($NULL)),
                                ("D:\BackUp\Files", "Portal_Anal", ($NULL)),
                                ("D:\BackUp\Files", "Shturman3.ini", ($NULL))
                        )
	# +==========================================+
	# |     Collect BackUp's from Computers      |
	# +==========================================+
	[switch] $Collect = $FALSE				           # Сбор бекапов с разнеызх компов и складирование их у себя
	[array]  $Collect_Data = (
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", (14,60,365,720,0) ),
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", $NULL )
                            )
	[string] $Collect_Folder = "D:\BackUp\FromComputers"


	# +==============+
	# |    Common    |
	# +==============+

	[string]$BackUpPath = "D:\BackUp"          # каталог для бекапов по умолчанию
	[string]$ExportPath = "D:\BackUp\2Export"    # каталог для экспорта бекапов по умолчанию
	[string]$Export = $TRUE                    # Если включено то все бэкапы будут экспортиться. независимо от местных настроек


function Custom_Scenario()
{
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    WriteLog "Start Custom Scenario [Before Basic] " "INFO"
    #===================================================
    #$currDate
    #Scenario
    $x_folders = (
                    ("", "C:\inetpub\wwwroot\dynamic", "",  "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\includes", "",  "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\request", "",   "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\script", "",    "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\templates", "", "Compress", "", "")
                 )
    BackUp_FilesAndFolders -BackUpPath "D:\BackUp\Temp\Portal_Anal" -FolderList $x_folders
    $Mask = "Portal_Anal"
    $path = "D:\BackUp\Temp\Portal_Anal"
    $arcPath = "$FilesBackUpPath\$Mask" + "_" + $CurrDateTime + ".7z"
    ArchiveFiles -Path $path -arcPath $arcPath -StoreArchive -DelSource -Verbose
    export_backup -Source $arcPath -Target $ExportPath -Mask $Mask -Verbose
    #purge_oldBackUp -Path $FilesBackUpPath -FileMask $Mask -Limits $Limits -Verbose

    #break
    #===================================================
    WriteLog "End Custom Scenario [Before Basic] " "INFO"



    #Basic Scenario
    BackUp_MSSQL;             # MS SQL
    BackUp_Logs;              # Log files
    BackUp_Errors;            # Error files (Special for shturman)
    #BackUp_MySQL;             # MySQL
    #BackUp_Redmine;           # Redmine
    #BackUp_SVN;               # SVN Repositories
    # Файлы и каталоги
    #"fffffffffffffffffffff"
    #BackUp_FilesAndFolders -BackUpPath $FilesBackUpPath -DateFormat $FilesDateFormat -FilesList $FilesFileName -FolderList $FilesFolderName -Limits $FilesLimits -ExportPath $FilesExportPat -Export $FilesExport
    BackUp_Purger;            # Purger old backup (bastd on files and folders)
    #BackUp_Collect;           # Сбор бекапов с других серверов




    WriteLog "Start Custom Scenario [After Basic] " "INFO"
    #===================================================

    #Scenario

    #===================================================
    WriteLog "End Custom Scenario [After Basic] " "INFO"
    
}
