# Файл настроек скрипта BackUp.ps1

	# +==============+
	# |   Log Files  |
	# +==============+
	[switch] $Log                  = $FALSE 					     # Бэкап и обслуживание Log файлов ( бех этого колюча остальные из группы игнорируются)
	[string] $LogFilePath          = "D:\Shturman\Bin\Log"
	[string] $LogFilePathOld       = "D:\Shturman\Bin\Log\Old"  
	[switch] $PurgeLogFiles        = $TRUE		                     # похоронить архивы старше  $LogFilePurgeDays дней
	# Errors log Archiver 
	[switch] $Errors               = $TRUE						     # Архивирование Errors файлов
	[string] $ErrorsPath           = "D:\Shturman\Bin\Errors"	  	 # Папка где лежат Errors, запакует все в каталог $LogFilePathOld\Errors с именем Errors_yyyy_MM_dd.7z


	# +==============+
	# |    MySQL     |
	# +==============+
	[switch] $MySQL                    = $FALSE					                    # Бэкап и обслуживание MySQL ( без этого колюча остальыне из группы MySQL* игнорируются)
	[string] $MySQLDumperPath          = "C:\Redmine\mysql\bin\mysqldump.exe"		# То чем создавать дампы
	[array]  $MySQLCred                = ("login","password")		    # Логин и пароль для заливки
	[array]  $MySQL_DB                 = ("db_name_1","db_name_2")                        # Список баз для бэкапа

	# +==============+
	# |     SVN      |
	# +==============+
	[switch] $SVN            = $FALSE				    # Бэкап и обслуживание SVN ( без этого колюча остальные из группы SVN* игнорируются)
	[string] $SVNRepoPath    = "C:\Repositories"
	[string] $SVNBackUpPath  = "C:\BackUp\SVN"

	# +==============+
	# |    Redmine   |
	# +==============+
	[switch] $Redmine             = $FALSE			                        # Бэкап и обслуживание Redmine ( бех этого колюча остальные из группы Redmine* игнорируются)
	[string] $RedminePath         = "C:\redmine\apps\redmine\htdocs\files"  # Место где живут файлы которые необходимо забекапить (аттачи)


	# +=========================+
	# |    Files and folders    |
	# +=========================+
	#[switch]$FilesON = $TRUE,		                                         # Создавать бекапы файлов/каталогов
	[switch] $FilesON = $FALSE		                                         # Создавать бекапы файлов/каталогов
	[string] $FilesBackUpPahth = "D:\BackUp\Shturman_Metro\Files"           # Место куда сладируются сделанные бекапы
	[array]  $FilesFileName = (
                                  # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, ID - на случай архивов с одинаковыми названиями, Compress | $FALSE - сжммать
                                  # --TODO --"Mask Include", "Mask Exclude" - маски файлов
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress"), 
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress")
                             )		# единичные файлы
	[array]  $FilesFolderName =  (
                                      # имя фолдера задаваемого в $FilesBackUpPath , каталог который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9], Маска включаемых файлов, Маска исключаемых
                                      # "Mask Include", "Mask Exclude" - маски файлов
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude"), 
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude")
                                )		# фолдеры целиком
	# Удаление старых архивов (как и логов) или нет?
	[string] $FilesExportPath          = "D:\BackUp\2Tape"
	[switch] $FilesExport              = $TRUE			                  # Выложить последний файл в каталог для экспорта (хардлинк по возможности)



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

	[string]$BackUpPath = "C:\BackUp"          # каталог для бекапов по умолчанию
	[string]$ExportPath = "C:\BackUp\2Tape"    # каталог для экспорта бекапов по умолчанию
	[string]$Export = $TRUE                    # Если включено то все бэкапы будут экспортиться. независимо от местных настроек
