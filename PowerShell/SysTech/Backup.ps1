<#
    1. Log Archiver
       - архивирование всех *.log файлов за исключением сегодняшних
       - в подпапку Old
       - по расписанию 1 раз в сутки в 03:30 (Шедульной таской)
       - удаление архивов старше [$LogFilePurgeDays] дней
       - Архивироване Errors папки
       - TODO Проверка открыт ли файл (дабы не трогать его т.к. его не выйдет удалить)
       - TODO заливка логов на сервер
       - TODO Выложить (хардлинг при возможности) в фолдрер для экспорта (на другой сервер/пленку), удаление старых копий.
       - TODO выборочное архивирование логов и заливка оных с блоков на сервак
       - TODO Создание Шедульной таски для автоматического запуска скрипта
       - TODO Копирование файлов по маске (вход через аргументы) перед архивированием "Blue*" "*17-04-03*" и т.п.
    2. MS SQL BackUP
       - бд Shturman_Metro полный бекап (Джобой в MS SQL)
       - в папку d:\BackUP
       - Выложить (хардлинг при возможности) в фолдер для экспорта (на другой сервер/пленку), удаление старых копий.
       - TODO Архивирование бэкапа
       - Архивирование бэкапа для заливки на сервер с нарезкой по ХХХ МБ
       - Удаление старых бэкапов по принципу ([$SQLBackUpDaily] дней - ежедневный; [$SQLBackUp10days] дней - "недельный" 1/10/20 числа кажд мес; [$SQLBackUpMontly] дней - месячный от 1 числа;  всегда - ежеквартальный от 1 числа)
       - TODO обработка старых архивов по расписанию 1 раз в сутки в 03:00
       - TODO Восстановление бэкапа и проверка оного
       - TODO Сообщение об ошибках в случае не прохождения проверки.
       - TODO Заливка последнего бекапа на сервак, если он отличается от предыдущего
    3. SVN BackUP
       - Поиск репозиториев и дамп всех найденных, бэкап настроек
       - TODO Нормальный (полный) бэкап настроек, включая права и правила коммитов, а не только список юзеров и групп
       - в папку d:\BackUP
       - Удаление старых бэкапов по принципу (1 нед - ежедневный, 1 месяц - недельный 1/15/21 числа кажд мес, всегда - ежемесячный от 1 числа)
       - Упаковыв дампов с конфигами в один архив (без сжатия)
       - TODO Восстановление бэкапа и проверка оного
       - TODO Сообщение об ошибках в случае не прохождения проверки.
       - TODO сделать проверку что скопировались кофигурационные файлы
       - TODO сделать проверку что бекап создался, а не только создался файл *.dump как сейчас
    4. Redmine BackUP
       - TODO Бэкап базы, файлохранилища, настроек
       - TODO в папку d:\BackUP
       - TODO Удаление старых бэкапов по принципу (1 нед - ежедневный, 1 месяц - недельный 1/15/21 числа кажд мес, всегда - ежемесячный от 1 числа)
       - TODO обработка старых архивов по расписанию 1 раз в сутки в 03:00
       - TODO Восстановление бэкапа и проверка оного
       - TODO Сообщение об ошибках в случае не прохождения проверки.
    5. Files and Folders
       - TODO бэкап конкретных файлов (масив из названия фолдера куда класть и имени файла который бэкапить)
       - TODO Бэкап фолдеров (масив из названия фолдера куда класть и пути который бэкапить) + маска по которйо блать файлы + маска которую эксклюдить из набора
       - TODO экспорт файлов на сервер
    6. MySQL BackUp
        -
    7. Collector
        - Сбор бекапов с произвольных компьютеров
        - складирование в указанный каталог в подкаталог = хостснейм | IP address 
    А. Создание шедульной таски
        - Создание шедульной таски (исключительно для облегчения установки). Название, время запуска - все хардкод.
    B. General настройки
        - SettingsFile - указать конкретный файл настроек (относительный путь от "c:\каталог_скрипта\")
        - TODO: Куда класть
        - TODO: Хранение (дневные / 10-ти дневки / месячные / квартальные / полугодовые / годовые
        - TODO: Указать имя конфигурационного файла



New:
1.0.11
    - Поддержка SVN
        - дамп всех найденных репозиториев
        - конфигурационных файлов
        - упаковывание дампов с конфигами в один архив
    - Поддержка MySQL
    - Поддержка Redmine
    - Сборщик с других компов
    - рефакторинг purge_backUp функции
    - Возможность указать кокретный файл настроек SettingsFile
1.0.10
    - Создание шедульной таски
        - Название, время запуска - все хардкод. если надо - исправлять на созданной таске уже.
          Создание шедульной таски -исключительно для облегчения установки
1.0.9
    - Бекапирование файлов и фолдеров
        - отдельных файлов
        - файлов по маске (по * на конце)
        - отдельных каталогов (путь полный указан)
        - всех подкаталогов в отдельные архивы (последний каталог указан как "*" )
        - выкладывание последней версии каждого бекапа в отдельный каталог (HardLink по возможности)
        - Archive prefix (can add)
1.0.8
    - функция ArchiveFiles: сделана поддержка разбития на тома, опциональное удаление исходных файлов, 3 типа сжатия - дефолт, нулевой и максимальный
    SQL
    - Архивирование бекапа SQL (в многотомный архив (опционально))
    - Upload файлов в шару.
1.0.7
    SQL
	- Выкладывает файл для экспорт на внешние хранилище в папку $SQLExportPath.
	  Включается функционал ключем $SQLExport, по умолчанию выключен.
	  Сначала пробует создать хардлинк, если не получается - создает копию. все предыдущие версии (по маске $SQLBackUpFileMask[$i]) удаляет
1.0.6
    Errors
        - мув и архивирование Error файлов в тот же каталог в который архивируются лог файлы
    Error+Log
        - Заархивирование по кладет в подкаталог $LogFolderForArchives. По умолчанию используется имя компьютера.
1.0.5
    SVN
        - Поиск репозиториев и дамп всех найденных, бэкап настроек в каталог [$SVNBackUpPath\SVN_yyyy-MM-dd_HHmm]. каждый репозиторий в свой файл.

1.0.4
    Common
        - Настройки подцепляются из файла BackUpSettings.ps1, при наличии ключа [-UseSettingsFile], Файл должен находиться в папке скрипта.
        - Настройки соответствует блоку PARAM. Все что будет в данной файле имеет приоритет на любыми входящими ключами
    2. MS SQL BackUP
        - Удаление старых бэкапов по принципу ([$SQLBackUpDaily] дней - ежедневный; [$SQLBackUp10days] дней - "недельный" 1/10/20 числа кажд мес; [$SQLBackUpMontly] дней - месячный от 1 числа;  всегда - ежеквартальный от 1 числа)
    1. Log Archiver
        - Включение архивирования логов по флагу [$Log]

1.0.3
    Все
#>


param (
	# +==============+
    # |   Log Files  |
	# +==============+  
	[switch] $Log                  = $FALSE,					     # Бэкап и обслуживание Log файлов ( бех этого колюча остальные из группы игнорируются)
	[string] $DateFormatLog        = "yy-MM-dd",
	[string] $LogFilePath          = "D:\Shturman\Bin\Log",
	[string] $LogFilePathOld       = "D:\Shturman\Bin\Log\Old",
    [string] $LogFolderForArchives = $env:computername,
	[string] $LogFilePurgeDays     = "30",		                     # Days
	[switch] $PurgeLogFiles        = $FALSE,		                 # похоронить архивы старше  $LogFilePurgeDays дней
#	[switch] $UploadLogFiles       = $FALSE,		                 # Заливка лог файлов на сервер.
	[switch] $FastArcive           = $FALSE,		                 # более легковесный упаковщик. без флага - пакует по максимому, что в Х раз дольше. но немного меньше места занимает
	[switch] $LogFileAll2Arc       = $FALSE,		                 # заставляет упаковывать все лог файлы. включая сегоднящние 

    # Errors log Archiver 
	[switch] $Errors               = $FALSE,						 # Архивирование Errors файлов
	[string] $ErrorsPath           = "D:\Shturman\Bin\Errors",	  	 # Папка где лежат Errors, запакует все в каталог $LogFilePathOld\Errors с именем Errors_yyyy_MM_dd.7z

	# +==============+
	# |     SQL      |
	# +==============+
	[switch] $SQL                    = $FALSE,					    # Бэкап и обслуживание SQL ( без этого колюча остальыне из группы SQL* игнорируются)
#	[string] $SQLServerInstance      = "localhost\SQLEXPRESS",
#	[string] $SQLDBName              = "Shturman_Metro",
#	[string] $SQLUsername            = "BackUpOperator",
#	[string] $SQLPassword            = "diF80noY",
	[string] $SQLBackUpPath          = "D:\BackUp\Shturman_Metro",
	[string] $SQLExportPath          = "D:\BackUp\2Tape",
	[switch] $SQLExport              = $FALSE,			            # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    [switch] $SQLExportUploadArc     = $FALSE,	                    # Архивирование бэкапа для заливки на сервер
    [int]    $SQLExportUploadArcPart = 100,		                    # Нарезка архива на части = размер части в МБ, 0 = одним куском
    [switch] $SQLExportUpload        = $FALSE,		                # Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
    [string] $SQLExportUploadPath    = "\\172.16.30.139\Share\Exp",	# Путь куда заливать
    [array]  $SQLExportUploadCred    = ("UserName","password"),		# Логин и пароль для заливки
	[array]  $SQLBackUpFileMask      = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),
    #[array] $SQLLimits              = (10, 60, 180, 365, 0),   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $SQLLimits              = $NULL,                  # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	#[string]$SQLDateFormatLog       = "yyyy-MM-dd_HHmm",

	# +==============+
	# |    MySQL     |
	# +==============+
	[switch] $MySQL                    = $FALSE,					                # Бэкап и обслуживание MySQL ( без этого колюча остальыне из группы MySQL* игнорируются)
    [string] $MySQLDumperPath          = "C:\Redmine\mysql\bin\mysqldump.exe",		# То чем создавать дампы
    [array]  $MySQLCred                = ("UserName","password"),		            # Логин и пароль для заливки
	[array]  $MySQL_DB                 = ("db_name_1","db_name_2"),                 # Список баз для бэкапа
	#[string]$SQLDateFormatLog         = "yyyy-MM-dd_HHmm",
	[string] $MySQLBackUpPath          = "\MySQL",
    [string] $MySQLBackUpPrefix        = "MySQL_",	                                # Префикс названия создаваемого файла
    #[array]  $MySQLLimits              = (10, 60, 180, 365, 0),                    # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array] $MySQLLimits              = $NULL,                                      # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	[switch] $MySQLExport              = $FALSE,			                        # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    [int]    $MySQLExportUploadArcPart = 0,		                                    # Нарезка архива на части = размер части в МБ, 0 = одним куском

	# +==============+
	# |     SVN      |
	# +==============+
	[switch] $SVN            = $FALSE,				    # Бэкап и обслуживание SVN ( без этого колюча остальные из группы SVN* игнорируются)
	[string] $SVNRepoPath    = "D:\Repositories",
	[string] $SVNBackUpPath  = "D:\BackUp\SVN",
    #[array] $SVNLimits      = (10, 60, 180, 365, 0),   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $SVNLimits      = $NULL,                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [switch] $SVNExport      = $FALSE,                  # Выкладывать последний архив в каталог для переноса на другую машину 

	# +==============+
	# |    Redmine   |
	# +==============+
	#[switch]$Redmine             = $TRUE			                         # Бэкап и обслуживание Redmine ( бех этого колюча остальные из группы Redmine* игнорируются)
	[switch] $Redmine             = $FALSE,			                         # Бэкап и обслуживание Redmine ( бех этого колюча остальные из группы Redmine* игнорируются)
    [string] $RedmineBackUpPrefix = "Redmine",
    [string] $RedmineBackUpPath   =  "\Redmine",                             # Место куда складывать бекапы
    #[array] $RedmineLimits       = (10, 60, 180, 365, 0),                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $RedmineLimits       = $NULL,                                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	[string] $RedmineDB           = "bitnami_redmine",			             # Бэкап и обслуживание Redmine ( бех этого колюча остальные из группы Redmine* игнорируются)
    [switch] $RedmineExport       = $FALSE,                                  # Запаковывать последний архив и выкладывать его в каталог для переноса на другую машину 
	[string] $RedminePath         = "C:\redmine\apps\redmine\htdocs\files",  # Место где живут файлы которые необходимо забекапить (аттачи)


	# +=========================+
    # |    Files and folders    |
	# +=========================+
	#[switch]$FilesON = $TRUE,		                                         # Создавать бекапы файлов/каталогов
	[switch] $FilesON = $FALSE,		                                         # Создавать бекапы файлов/каталогов
    [string] $FilesDateFormat = "yyy-MM-dd_HHmm",
	[string] $FilesBackUpPahth = "D:\BackUp\Shturman_Metro\Files",           # Место куда сладируются сделанные бекапы
	[array]  $FilesFileName = (
                                  # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, ID - на случай архивов с одинаковыми названиями, Compress | $FALSE - сжммать
                                  # --TODO --"Mask Include", "Mask Exclude" - маски файлов
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress"), 
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress")
                             ),		# единичные файлы
	[array]  $FilesFolderName =  (
                                      # имя фолдера задаваемого в $FilesBackUpPath , каталог который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9], Маска включаемых файлов, Маска исключаемых
                                      # "Mask Include", "Mask Exclude" - маски файлов
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude"), 
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude")
                                ),		# фолдеры целиком
	# Удаление старых архивов (как и логов) или нет?
    #[array] $FilesLimits              = (10, 60, 180, 365, 0),               # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $FilesLimits              = $NULL,                               # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	[string] $FilesExportPath          = "D:\BackUp\2Tape",
    [switch] $FilesExport              = $FALSE,			                  # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    [int]    $FilesExportUploadArcPart = 100,		                          # Нарезка архива на части = размер части в МБ, 0 = одним куском
    [switch] $FilesExportUpload        = $FALSE,		                      # Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
    [string] $FilesExportUploadPath    = "\\172.16.30.139\Share\Exp",	      # Путь куда заливать
    [array]  $FilesExportUploadCred    = ("UserName","password"),		      # Логин и пароль для заливки
	#[array] $FilesBackUpFileMask      = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),

	# +==========================================+
	# |     Collect BackUp's from Computers      |
	# +==========================================+
	[switch] $Collect = $FALSE,				           # Сбор бекапов с разнеызх компов и складирование их у себя
	[array]  $Collect_Data = (
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", (14,60,365,720,0) ),
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", $NULL )
                            ),
	[string] $Collect_Folder = "D:\BackUp\FromComputers",
    #[array] $CollectLimits = (10, 60, 180, 365, 0),   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $CollectLimits = $NULL,                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]


	# +==============+
    # |    Common    |
	# +==============+
    # Значения по умолчанию для хранения бекапов
    [int]$Store_Daily    = 14,                       # Дней хранятся ежедневные бэкапы
    [int]$Store_10days   = 60,                       # Дней хранятся бэкапы от 01, 10 и 20 числа
    [int]$Store_Montly   = 365,                      # Дней хранятся ежемесячные бэкапы (01.хх.хх)
    [int]$Store_Quartal  = 720,                      # Дней хранятся ежеквартальные бэкапы (01.01.хх 01.04.хх 01.07.хх 01.10.хх)
    [int]$Store_Years    = 0,                        # Дней хранятся ежегодовые бэкапы (01.01.хх)

	[switch]$SheduledTaskCreate = $FALSE,		     # Создание Шедульной таски для автоматического запуска скрипта
	[switch]$UseSettingsFile = $FALSE,			     # использоватать файл настроек BackUpSettings.ps1 (находится в фолдере скрипта). Настройки аналогичны данному блоку PARAM.
	[string]$SettingsFile = $NULL,			         # использоватать указанный файл настроек (копия BackUpSettings.ps1) файл либо находится в фолдере скрипта либо указать полный путь. 
	[switch]$HighestPrivelegesIsRequired = $FALSE,   # Проверять есть ли админские права. модт быть необходимо работы с файлами

    [string]$BackUpPath = "D:\BackUp",               # каталог для бекапов по умолчанию
    [string]$ExportPath = "D:\BackUp\2Tape",         # каталог для экспорта бекапов по умолчанию
    [string]$Export = $FALSE,                        # Если включено то все бэкапы будут экспортиться. независимо от местных настроек

	[string]$UploadCahnnelType = "VPN",		     	 # VPN | FTP | NO .... - Канал для загрузки файлов на внешний сервер
	[string]$VPNName = "ST",					     # 
#	[string]$VPNUserName = "username",			     # 
#	[string]$VPNPassword= "password",			     # 

	[switch]$Debug = $FALSE	    # в консоль все события лога пишет
#	[switch]$Debug = $TRUE		# в консоль все события лога пишет
)

$version = "1.0.11";

# +==================+
# |       Common     |
# +==================+
[array]$DefaultStoreLimits = ($Store_Daily, $Store_10days, $Store_Montly, $Store_Quartal, $Store_Years)   # теже лимиты но в массиве, для простоты обработки
$CurrDate = Get-Date -Format "yyyy-MM-dd"
$CurrTime = Get-Date -Format "HHmm"



# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptFullPath = $ScriptDir + "\" + $script:MyInvocation.MyCommand.Name

#Split-Path $script:MyInvocation.MyCommand.Path
#$script:MyInvocation.MyCommand.Source

#$ScriptDir
#$ScriptFullPath
#break

# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

clear;
WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
WriteLog "Script version: [$version]" "INFO"



[string]$ParamsPath = "$ScriptDir\BackUpSettings.ps1";
[string]$ParamsPathCustom = "$ScriptDir\$SettingsFile";

# Если в каталоге скрипта присуствует файл BackUpSettings.ps1 - подсасываем из него персонализинованные параметры
if ((test-path $ParamsPath) -and ($UseSettingsFile))
{
	# инклюдим параметры (список сервисов, инстанс SQL и пр что обычно в блоке params
	WriteLog "Чтение настроек скрипта [$ParamsPath]" "INFO"
	."$ParamsPath"
}
ElseIf ( ($SettingsFile.Length -gt 3) -and (test-path -Path $ParamsPathCustom) )
{
	WriteLog "Чтение настроек скрипта [$ParamsPathCustom]" "INFO"
    ."$ParamsPathCustom"
}
ElseIf (-not $UseSettingsFile)
{
	WriteLog "Скрипт запущен с дефолтными настройками" "INFO"
}
Else
{
	WriteLog "Скрипт запущен с дефолтными настройками (файл настроек [$ParamsPath] не найден)" "INFO"
}

#WriteLog "Debug Mode: [$Debug]" "MESS"
if ( $Debug )
{
    WriteLog "Debug Mode: [$Debug]" "MESS"
}


# проверка наличия административных привилегий. если их нет - отваливаемся
if ( $HighestPrivelegesIsRequired )
{
	if(isAdmin)
	{
		WriteLog "Админские права: есть." "MESS"
	};
}


# ===============================================
#                   Functions
# ===============================================

function FilePurge ()
{
# Удаление старых лог файлов
	param (
		[int]$PurgeDays = 30,
		[string]$Path = "",
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

	# вычисляем дату до которой надо все похерить.
	$PurgeDate = (Get-Date).AddDays(-$PurgeDays) 

	WriteLog "Purge old log files, older than [$Path] days" "INFO" -Verbose $Verbose

	$arr = Get-ChildItem -Path $Path -Force -Filter "*.7z"

	Foreach ($File in $arr) 
	{

		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # этот вариант красивше, но возвращает дату с точкой на конце
		$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		#$match = [regex]::Match($File,"(\d){2}-(\d){2}-(\d){2}") # тоже что и предыдущий, но более понятно.
#		$match
#		$match.Value


		# если в файле небыло ничего похожего на дату - пропустим этот файл
		if ($match.Value -ne "")
		{

			# добавляем 20 в начало, чтобы год был полностью указан и преобразовываем в дату
			$FileDate =  get-date ("20" + $match.Value)

			# сравниваем даты. если файл старше требуемой даты - убиваем его.
			if ($FileDate -lt $PurgeDate)
			{
				WriteLog "Try to delete file [$File]" "DUMP"

				Remove-Item -Path $File.FullName -Force

				# проверяем исходный файл на наличие, если все еще присутсвует - ругаемся
				if (test-path -Path $File.FullName -ErrorAction SilentlyContinue)
				{

					WriteLog "Old Log file [$File] doesn't removed" "ERRr"
				}
				else
				{
					WriteLog "File [$File] is deleted" "MESS" # а если нормально удалился - пишем что ремувед
				}


				
			}
		}
	}
}


function UploadFiles ()
{
# Заливка лог файлов на сервер
	param (
		[string]$Path = "",
		[string]$File = "",
        #[string]$UploadHost = "",
		[string]$UploadPath = "",
		[array]$UploadCred = ("UserName", "Password"),
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";
    #$UploadPath

    $UploadCred


    [object] $objCred = $null
    [string] $strUser = $UploadCred[0]
    [System.Security.SecureString] $strPass = $NULL 
    #[System.Security.SecureString] $strPass = '' 


    $strPass = ConvertTo-SecureString -String $UploadCred[1] -AsPlainText -Force
    $objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strPass)

    $username = $UploadCred[0]
    $pass = $UploadCred[1]
net use /D $UploadPath
net use $UploadPath /u:$username $pass
    #"net use $UploadPath /u:$username $pass"

    $MaxAttempts = 10

    for($i=0; $i -lt $MaxAttempts; $i++)
    {
        if ( TestFolderPath -Path $UploadPath -Create -ContinueOnError )
        {
        #$Path
        #break
           
            # Переливаем все содержимое фолдера
            if ($Path -ne "")
            {
                if ( TestFolderPath -Path $Path )
                {
                    $Files = $NULL;
                    $Files = Get-ChildItem -Path $Path -Recurse | % { $_.FullName }
                    #$Files
                    #break
                }

                foreach ($OneFile in $Files)
                {
                    if (Test-Path -Path $OneFile) 
                    {
                        WriteLog "try to Upload file [$OneFile] to [$UploadPath]" "DUMP"
                        Move-Item -Path $OneFile -Destination $UploadPath -Force # -Credential (Get-Credential $objCred)
                        #if (
                        WriteLog "Upload file [$OneFile] to [$UploadPath] (done)" "MESS"

                    }
                }
            }

            # Переливаем единичный файл
            if ($File -ne "")
            {
                if (Test-Path -Path $File) 
                {
                    WriteLog "try to Upload file [$OneFile] to [$UploadPath]" "DUMP"
                    Move-Item -Path $File -Destination $UploadPath -Force # -Credential (Get-Credential $objCred)
                    WriteLog "Upload file [$File] to [$UploadPath] (done)" "MESS"
                }
            }
        }
    }

# отконнекчиваемся
net use /D $UploadPath

    #$UploadPatch = "\\172.16.30.19\Share\"
    #Test-Path -Path $UploadPatch 
<#
"gogogogogogo"

#UploadFiles -Path "D:\BackUP\2Tape" -File "D:\BackUP\x\DelphiChromiumEmbedded.Local.dump" -UploadPatch ("\\172.16.30.139\Share\"+(get-date -Format "yyyy-MM-HH")) -UploadCred ("Upload","Chi79Mai") -Verbose

break;


	WriteLog "Upload Files to Server" "INFO";

	[string]$LogFilePathServer = "\\SHTURMAN-ROOT\Logs\test";
	[string]$BlockName = "aaa11";
#	[string]$ShareMarker = "$LogFilePathServer"; # проверяя наличие этого файла - проверяем доступность пути в шаре
	[string]$LogFilePathServerBlock = "$LogFilePathServer\$BlockName";

	# - создание и проверка существования фолдера для архивов
# "test-path -Patch $LogFilePathServer -ErrorAction SilentlyContinue"

	if (test-path -Path $LogFilePathServer -ErrorAction SilentlyContinue)
	{
		WriteLog "Log Store share [$LogFilePathServer] is exist" "DUMP"

		if (test-path -Path $LogFilePathServerBlock -ErrorAction SilentlyContinue)
		{
			WriteLog "Block's folder in log store share [$LogFilePathServerBlock] is exist" "DUMP"
			
		}
		Else
		{
			$res = New-Item -Path $LogFilePathServer -Name $BlockName -ItemType "directory"
			WriteLog "Create Folder: $res" "DUMP"

			if (test-path -Path $LogFilePathServerBlock -ErrorAction SilentlyContinue)
			{
				WriteLog "Block's folder in log store share [$LogFilePathServerBlock] created" "MESS"
			}
			Else
			{
				WriteLog "Create Folder [$BlockName] in [$LogFilePathServer] failed" "ERRr"
			}
		}	


"asasf"
break;
		


		# PowerShell's New-Item creates a folder
		if (-not (test-path $LogFilePathOld))
		{
			WriteLog "Path for Arcived Files [$LogFilePathOld] doesn't exist" "ERRr"
			break;
		}
		else
		{
			WriteLog "Created folder [$LogFilePathOld]" "MESS"
		}
	}
	else
	{
		WriteLog "Path for Arcived Files [$LogFilePathServer] doen't exist" "ERRr"
		break;
	}


	$arr = Get-ChildItem -Path $LogFilePathOld -Force -Filter "*.7z"


	Foreach ($File in $arr) 
	{
#		Copy-Item -Destination C:\Temp
		Copy-Item -Path $File.FullName -Destination \\SHTURMAN-ROOT\Logs\test
#		$File
	}
# Copy-Item -Destination C:\Temp
# Remove-Item C:\Scripts\*
#>
}

function ArchiveFiles ()
{
    # Архивирование файлов
	param (
		[string]$Path = "",
		[string]$arcPath = "",
		[switch]$FastArchive = $FALSE,		# Сжатие по дефолту (для архиватора) если флаг ни один флаг не взведен - пакуем по максимому, но долго-долго.
		[switch]$StoreArchive = $FALSE,		# Упаковка без сжатия (как правило с целью нарезки архива)
		[switch]$DelSource = $FALSE,		    # Удаление исходного файла
		   [int]$Size = 0,		                # нарезка на куски = в Мб,  0 - одним куском. 
		[switch]$Verbose = $FALSE		    # в консоль все события лога пишет
	)

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	WriteLog "$FuncName Archive file [$Path] to [$arcPath] DelSrc: [$DelSource] StoreArc [$StoreArchive] FastArch [$FastArchive] PartSize [$Size]" "DUMP"


    # на сколько сильно паковать. если флаг не взведен - пакуем по максимому, но долго-долго.
	if ($FastArchive -eq $TRUE)
	{
        $ArcivationDensity = ""
    } 
    elseif ($StoreArchive -eq $TRUE )
    {
	    $ArcivationDensity = "-mx=0"
    }
    else
    {
	    $ArcivationDensity = "-mx=9"
	}
    
    # Удаление исходного файла
	if ($DelSource -eq $TRUE)
	{
        $DelSourceFile = "-sdel"
    } 
    else 
    {
	    $DelSourceFile = ""
    }

    if ( $Size -gt 0 )
    {
        #-v{Size}[b|k|m|g] : Create volumes
        $SizeVolume = "-v"+$Size+"m";

    }
    else
    {
        $SizeVolume = "";
    }


 

 	WriteLog "$FuncName Exec[D:\Prog\7-zip\7za.exe $SizeVolume $ArcivationDensity a $arcPath $DelSourceFile $Path]" "DUMP"

    

    # Проверяем возможные пути расположения архиватора
    if (test-path -Path "D:\Prog\7-zip\7za.exe" -ErrorAction SilentlyContinue)
    {
		$res = D:\Prog\7-zip\7za.exe $ArcivationDensity $SizeVolume a $arcPath $DelSourceFile $Path
    }
    ElseIf (test-path -Path "C:\Prog\7-Zip\7za.exe" -ErrorAction SilentlyContinue)
    {
		$res = C:\Prog\7-Zip\7za.exe $ArcivationDensity $SizeVolume a `"$arcPath`" $DelSourceFile $Path
    }
    else 
    {
    	WriteLog "Archiver not found" "ERRr" # не нашли архиватор. делать нефиг, вываливаемся
        break;
	}

    WriteLog "$res" "DUMP"


    # подменяем имя файла архива для проверки его наличия
    if ( $Size -gt 0 )
    {
        # если архивбыл порезанный на части то добавляем .001 к названию
        # TODO каким-то макаром проверять сужествование и остальных частей (ХЗ как вычислить сколько их всего)
        $arcPath = $arcPath+".001"
    }

	if (test-path $arcPath)
    {
        if ($DelSource)
        {
		    # повторная попытка грохнуть файл. если архиватор не смог. бесполезная по сути... т.к. не помогает.
	        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
            #	$File.Delete()
        }
	    # проверяем исходный файл на наличие, если все еще присутсвует - ругаемся
	    if (test-path $Path -ErrorAction SilentlyContinue)
#	    if (test-path "c:\windows" -ErrorAction SilentlyContinue)
	    {
            if ($DelSource)  # Разные сообщения Ворнинг или Мессадж в зависимости от того надо было удалять или нет.
            {
		        WriteLog "File [$Path] added to archive [$arcPath]" "WARN" $Verbose # если исходный остался - пишем что файл _добавлен_
		        WriteLog "Source file [$Path] doesn't removed" "ERRr" $TRUE # И ругаемся чтоне удалось удалить
            }
            else
            {
		        WriteLog "File [$Path] added to archive [$arcPath]" "MESS" $Verbose # если исходный остался - пишем что файл _добавлен_
            }
	    }
	    else
	    {
			WriteLog "File [$Path] moved to archive [$arcPath]" "MESS" $Verbose # а если нормально удалился - пишем что ремувед
	    }
			
	}
    Else
    {
		WriteLog "Arcived File [$arcPath] doesn't exist" "ERRr" $TRUE
    }
}


function purge_oldBackUp ()
{
    # Архивирование файлов
	param (
		[string]$Path = "",
		[string]$FileMask = "",
        [array]$Limits = $NULL,                           #Array()  Daily / TenDays / Montly / Quartal / Years
        #[array]$DefaultLimits = (30, 90, 181, 365, 720),    # Daily / TenDays / Montly / Quartal / Years
		#[int]$Daily   = $NULL,		# days
		#[int]$TenDays = $NULL,		# days
		#[int]$Montly  = $NULL,		# days
        #[int]$Quartal = $NULL,	    # days
        #[int]$Years   = $NULL,		# days
		[switch]$Verbose = $FALSE		    # в консоль все события лога пишет
	)


	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    if ( $Limits )
    {
        $arr = $Limits
    }
    else
    {
        $arr = $DefaultStoreLimits
    }
        
    # заменить на это после искоренения
   	[int]$Daily   = $arr[0] 	# days
	[int]$TenDays = $arr[1]		# days
	[int]$Montly  = $arr[2]		# days
    [int]$Quartal = $arr[3]	    # days
    [int]$Years   = $arr[4]


    WriteLog "$FuncName Purge old BackUps [ $Daily / $TenDays / $Montly / $Quartal / $Years ] Daily / TenDays / Montly / Quartal / Years by mask [$FileMask]" "INFO" $Verbose

    #//echo "$Path\$FileMask"
    $Files = Get-ChildItem -Path "$Path\$FileMask*"

    ForEach ($file in $Files) 
    {
        $FileName = $file.Name
        $FileFullName = $file.FullName

        $match = [regex]::Match($FileName,"(\d){4}-(\d){2}-(\d){2}") # ищем в формате yyyy-MM-dd.
    	#$match
    	#$match.Value

    		# если в файле небыло ничего похожего на дату - пропустим этот файл
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

                <#
                if ($FileMaxDate -lt $FileDate) 
                { 
                    $FileMaxDate = $FileDate;
                    $LastFile = $File;
                }
                #>

    			# сравниваем даты. Пропускаем и не удаяем файлы младше требуемой даты.
			    if ($FileDate -lt (Get-Date).AddDays(-$Daily))
			    {
                    $delfile = $FALSE

                    #write-host $FileDate + "---" + $Years + "---" + ((Get-Date).AddDays(-$Years)) + ((Get-Date).AddDays(-$Quartal))

                    # Старше $Years - удаляем, но только если не 0 (т.е. анлимитед)
                    if ( ($Years -ne 0) -and ($FileDate -lt (Get-Date).AddDays(-$Years)) )    { $delfile = $TRUE }

                    # Оставаляем годовые - Старше $Quartal, но не 01.01.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Quartal)) -and ( ($FileDate.Day -notin 1) -or ($FileDate.Month -notin 1) ) )    { $delfile = $TRUE }

                    # Оставаляем квартальные - Старше $Montly, но не 01.хх.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Montly)) -and ( ($FileDate.Day -notin 1) -or ($FileDate.Month -notin 1,4,7,10) ) )    { $delfile = $TRUE }

                    # Оставаляем месячные - Старше $TenDays, но не 01.хх.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$TenDays)) -and ( ($FileDate.Day -notin 1) ) )    { $delfile = $TRUE }


                    # Оставаляем 10-тидневки - Старше $Daily, но не 01.хх.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Daily)) -and ( ($FileDate.Day -notin 1,10,20) ) )    { $delfile = $TRUE }

                    
                    if ( $delfile )
                    {
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] from [$FileDate]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                    }
                                        
                    <#
                    # если файл не от 1/10/20 числа месяца и находится в диапазоне дат от $SQLBackUpDaily до $SQLBackUp10days - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$Daily)) -and ($FileDate.Day -notin 1, 10, 20) )
                    {
                        #$File.Name;
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] by [if:1]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                        #$FileDate
                    }

                    # если файл не от первого числа месяца и находится в диапазоне дат от $SQLBackUp10days до $SQLBackUpMontly - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$TenDays)) -and ($FileDate.Day -notin 1) )
                    {
                        #$File.Name;
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] by [if:2]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                        #$File.Name;
                        #$FileDate
                    }

                    # если файл старше даты $SQLBackUpMontly - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Montly)) -and $Montly -gt 0 )
                    {
                        #$File.Name;
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] by [if:3]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                        #$FileDate
                    }


   	[int]$Daily   = $arr[0] 	# days
	[int]$TenDays = $arr[1]		# days
	[int]$Montly  = $arr[2]		# days
    [int]$Quartal = $arr[3]	    # days
    [int]$Years   = $arr[4]
    #>

                }
            }

    }
}
#$DefaultStoreLimits = (30, 90, 181, 365, 0)
#purge_oldBackUp -Path "C:\BackUp\FromComputers\st-nas\" -FileMask "" -Limits (10, 60, 180, 365, 0) -Verbose
#break 

function export_backup ()
{

    # Архивирование файлов
	param (
		[string]$Source = "",         # каталог - из которого взять
		[string]$Target = "",         # каталог - куда положить
		[string]$Mask = "",           #маска по которой будут удалены предыдущие
		[switch]$Verbose = $FALSE		    # в консоль все события лога пишет
	)

	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    WriteLog "$FuncName Export new Backup [$Source] to [$Target]" "INFO" $Verbose

    # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
	        #WriteLog "Create a latest copy of SQL backup(s) in Export folder [$SQLExportPath]" "DUMP"
    
    # Проверка наличия пути без создания оного.
    #TestFolderPath -Path $Target #-Verbose

    if ( (test-path -Path $Source -ErrorAction SilentlyContinue) -and (TestFolderPath -Path $Target) )
    {

        $file = Split-Path -Path $Source -Leaf  # имя файла

        #delete old by mask
        #echo "Get-ChildItem -Path $Target -filter $Mask*"
        $Files = Get-ChildItem -Path $Target -filter "$Mask*"
        
        foreach ( $File_d in $Files )
        {
            DeleteFile -File $File_d.FullName -Verbose
        }
        #$Files

        #echo "Remove-Item -Path `"$Target\*`" -include `"$Mask*`" -WhatIf"
        #Remove-Item -Path "$Target\*" -filter $Mask* -WhatIf
        #Get-ChildItem -Path $Target -Filter $Mask | Remove-Item -Path $_
        #DeleteFile -File "$Target\$Mask*" -Verbose

        # try to create hardlink
                   # Пробуем создать хардлинк

                    #WriteLog "Try to create New file for export is [$LastFile] will replace old file [$Target\$file]" "DUMP"
                    $command = "cmd /c mklink /H `"$Target\$file`" `"$Source`""
                    #echo $command
                    invoke-expression $command

                    if (-not (Test-Path -Path $Target\$file -ErrorAction SilentlyContinue) )
                    {
                        # Если не удалось создать хардлинк пробуем скопировать
                        WriteLog "Did not create HardLink of file for export [$Target\$file], try to create a copy" "DUMP"
                                
                        # Проверка наличия свободного места на диске под копию файла
                        if ( CheckFreeSpace -Path $Target -Size $Source.Length  ) #-Verbose
                        {
                            # Копирование файла если место есть
                            Copy-Item -Path $Source -Destination $Target
                        }
                    }
                    # Финальная проверка что создалась копия
                    if (Test-Path -Path $Target\$file -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created hardlink or copy of file for export (to Tape) [$Target\$file]" "MESS"
                    }
                    else 
                    {
                        # Если не удалось создать и копии тоже - ругаемся красненьким
                        WriteLog "Did not create file for export [$Target\$file] (HardLink or Copy)" "ERRr"
                    }
        # copy if impossible

        WriteLog "$FuncName Soource file [$Source] target folder [$Target] mask [$Mask]" "MESS" $Verbose

    }
    else
    {
        WriteLog "$FuncName Source file [$Source] or target folder [$Target] does not exist" "ERR" $Verbose
    }

     <#   
            # Проверка что есть более свежая версия файла, если нет, то дальнейшая работа не имеет смысла. 

    	    $arr = Get-ChildItem -Path $SQLExportPath -Force -Filter $SQLBackUpFileMask[$i]

            # Берем максимальную дату из имеющихся файлов (попавших под маску), если нет файлов в таргетном каталоге считаем что дата последней выкладки 01-01-1970.
            # Сбрасываем значение даты, заоодно если нет файлов в каталоге для экспорта - считаем что там очень старый файл.
            $FileDate = get-date ("1970/01/01");

       	    Foreach ($File in $arr) 
            {

                WriteLog ("Extract date from file name [" + $File.FullName + "]") "DUMP"             

                #Extract date from file name
                $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ищем в аормате yyyy-MM-dd.
                #$match
                #$match.Value
        
                # если в файле небыло ничего похожего на дату - пропустим этот файл
                if ($match.Value -ne "")
                {
                    $nfDate = get-date ($match.Value)
                    if ($FileDate -lt $nfDate)
                    {
                        $FileDate = $nfDate
                    }
                }
            }

#-------
            if ($FileDate -lt $FileMaxDate)
            {
                WriteLog "New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"

                $SQLBackUpFileMask[$i]
                # Удаляем неактуальную версию
                $File = $SQLExportPath + "\" + $SQLBackUpFileMask[$i]
                DeleteFile -File $File -Verbose

                #Test-Path -Path $SQLExportPath
                if (Test-Path -Path $SQLExportPath)
                {
                    # Пробуем создать хардлинк
                    #New-Item -ItemType HardLink -Name "$SQLExportPath\$LastFile" -Value "$SQLBackUpPath\$LastFile"
                    #$command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"

                    WriteLog "Try to create New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"
                    $command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"
                    invoke-expression $command

                    if (-not (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue) )
                    {
                        # Если не удалось создать хардлинк пробуем скопировать
                        WriteLog "Did not create HardLink of file for export [$SQLExportPath\$LastFile], try to create a copy" "DUMP"
                                
                        # Проверка наличия свободного места на диске под копию файла
                        if ( CheckFreeSpace -Path $SQLExportPath -Size $File.Length  ) #-Verbose
                        {
                            # Копирование файла если место есть
                            Copy-Item -Path $SQLBackUpPath\$LastFile -Destination $SQLExportPath\$LastFile
                        }
                    }
                    # Финальная проверка что создалась копия
                    if (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created copy of file for export (to Tape) [$SQLExportPath\$LastFile]" "MESS"
                    }
                    else 
                    {
                        # Если не удалось создать и копии тоже - ругаемся красненьким
                        WriteLog "Did not create file for export [$SQLExportPath\$LastFile] (HardLink or Copy)" "ERRr"
                    }
                }
                else
                {
                    WriteLog "Export folder does not exist [$SQLExportPath]" "ERRr"
                }
            }
            Else 
            {
                WriteLog "NO New file for export. Last file [$LastFile] is same as old file [$SQLExportPath\$File]" "DUMP"
            }
            <# #>
}


function add_Subfolder_to_Path ()
{
    # Add subfolder to path and create if not exist
    param (
		[string]$Path = "",             # Исходный фолдер
		[string]$SubFolderName = "",		    # Сабфолдер.
		[switch]$Create = $FALSE,		# Создать если такого нет.
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    $x = TestFolderPath -Path $Path

    if ( ($Path.Length -gt 3) -and ($SubFolderName.Length -gt 0) )
    {
        if ( $SubFolderName.Substring(0,1) -eq "\" ) 
        {
            $SubFolderName = $SubFolderName.Substring(1)
        }
        
        $CombinedPath = "$Path\$SubFolderName"
        
        if ( $Create )
        {
            $x = TestFolderPath -Path $CombinedPath -Create
        }
        else
        {
            $x = TestFolderPath -Path $CombinedPath
        }

        #$CombinedPath
        
        return $CombinedPath
    }
    else
    {
        WriteLog "$FuncName Path or SubfolderName is shortly [$Path] / [$SubFolderName]" "INFO" $Verbose

    }

    return $FALSE
    

}

#add_Subfolder_to_Path -Path "C:\BackUp" -SubFolderName "ffff5"
#break


function get_BackUpPath ()
{
    # из глобальной и локальной BackUpPath - выбирает актуальную либо склеивает в одну
    # - если не указана локальная - используется глобальная
    # - если локальная относительная "\addPath" (обязательно с ведущим бэк-слешем - добавит ее к глобальной
    # - если указана локальная и начинается не со слеша - она считается правильной и берется
	param (
		[string]$Path = "",
		[switch]$Create = $FALSE,		# Создать если такого нет.
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

    if ( ($Path.Length -gt 1) -and ( $Path.Substring(0,1) -eq "\") )
    {
        $CombinedPath = add_Subfolder_to_Path -Path $BackUpPath -SubFolderName $Path -Create -Verbose
        #$CombinedPath = $BackUpPath + $Path
    }
    elseif ( ($MySQLBackUpPath.Length -gt 0) -and ( $Path.Substring(0,1) -ne "\") )
    {
        $CombinedPath = $Path
    }
    else
    {
        $CombinedPath = $BackUpPath
    }

    if ( $Create )
    {
        $x = TestFolderPath -Path $CombinedPath -Create
    }

    return $CombinedPath

}


function MySQLBackUp ()
{
	param (
		[string]$User = "",
		[string]$Password = "",
		[string]$DataBase = "",
		[string]$File = "",
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)
	
    # имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";
    
    WriteLog "$FuncName Create MySQL dump from [$DataBase] to [$File]" "INFO" $Verbose

    TestFolderPath -Path (Split-Path -Path $File -Parent) -Create

    # Создать такой логин пач можно командой:
    # mysql_config_editor set --login-path="backup-lp" --host="localhost" --user="backup" --password

    $command = "cmd /c $MySQLDumperPath -u $User -p$Password $DataBase > $File"
    #$command = "cmd /c $MySQLDumperPath --login-path=backuplp $DataBase > $File"
    
    WriteLog "$FuncName Exec: [$command]" "DUMP" $Verbose
    #echo $command
    invoke-expression $command

    $FileCreated = Get-ChildItem -Path $File
    
    #$FileCreated.Length

    if ( (Test-Path -Path $File) -and ($FileCreated.Length -gt 0) )
    {
        WriteLog "$FuncName Succesfully created Back Up of DB [$DataBase] in to [$File]" "MESS" $Verbose
    }
    else
    {
        WriteLog "$FuncName Failed dump DB [$DataBase] in to [$File]" "ERRr" $Verbose
    }

}



function  SQLBackup ()
{
}


# Создание Шедульной таски для автоматического запуска скрипта
#$SheduledTaskCreate = $TRUE
if ($SheduledTaskCreate)
{

	if(isAdmin)
	{
		WriteLog "Админские права: есть." "MESS"
	};
	#WriteLog "NO FUNCTIONALE (c) Kuba's taxist" "ERRr"
    $Name = "BackUp Logs, Fileas and Folders, SQL DB"
    $Description = "Automatic BackUp and purge old BackUps"

    #WriteLog "Run with params: TaskName: [$Name]; Description: [$Description]; Execute: [$Execute] with Argument: [$Argument]" "INFO"
    WriteLog "Will Create Sheduled task for Script: TaskName: [$Name]" "INFO"

    # Проверяем существует ли уже таска с таким названием
    $ShTask = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

    #$ShTask

    if ( ($ShTask.TaskName -eq $Name) )
    {
        # удаляем существующую таску
        Unregister-ScheduledTask -TaskName $Name -Confirm:$false
      	WriteLog "Delete exist Sheduled task [$Name]" "MESS"

        $ShTask = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

        if ($ShTask.TaskName -eq $Name)
        {
            # Заканчиваем с ошибкой т.к. таска уже существует
      	    WriteLog "Sheduled task [$Name] already exist. And can't be delete" "WARN"
            break;
        }
    }


    # Create sheduled task 
 	$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
                                      -Argument "$ScriptFullPath -UseSettingsFile"
    
    #$RunAt = ParseDate -Date $Date -Time $Time -Verbose # Переводим то что дал пользователь в дату-время. либо берем сегодняшнюю если не сказал ничего
    #$RunAt = Get-Date
    #$RunAt = "10/10/2020"
    #ParseInterval -Interval $Interval

    #$RepetitionInterval = New-TimeSpan -Minutes 55
    #$RepetitionInterval = New-TimeSpan -Days 10
    #$RepetitionInterval = ParseInterval -Interval $Interval -verbose
    #$RepetitionInterval = New-TimeSpan -Days 1
    #$RepetitionInterval =  1

    #$RepetitionInterval

	#$trigger = New-ScheduledTaskTrigger `
	#    -Once `
	#    -At ($RunAt) `
	#    -RepetitionInterval ($RepetitionInterval) `
	#    -RepetitionDuration ([System.TimeSpan]::MaxValue)
    $trigger = New-ScheduledTaskTrigger -At 00:10:00 -Daily
	$option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
	# $option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$STSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
	#Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "Disable windows firewall" -User $AdminLogin -Password $AdminPassword -RunLevel Highest #-Principal $principal
	Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $Name -Description $Description -Principal $principal -Settings $STSettings #-ScheduledJobOption $option1


	#-User "$env:USERDOMAIN\$env:USERNAME" `
	#                       -Password 'P@ssw0rd' `

	# Enable-ScheduledTask 
	# Disable-ScheduledTask 
    #EnableFireWallRule -RuleName "RRAS-GRE-Out" -RuleDirection "Outbound"


    #"Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue"
    #Get-ScheduledTask -TaskName "$TaskName"

    $ShTask = Get-ScheduledTask -TaskName "$Name" -ErrorAction SilentlyContinue
    #$ShTask
    if ($ShTask.TaskName -eq $Name)
    {
      	WriteLog "Sheduled task [$Name] created." "MESS"
    
    }
    else
    {
    	WriteLog "Sheduled task [$Name] isn't created." "ERRr"
    }
}


#break

#GetFreeSpace -Path D:\BackUP\2Tape -Verbose
#GetFreeSpace -Path "\\st-nas\BackUp\SVN\SVN_2016-09-05" -Verbose


if ($SQL)
{
    TestFolderPath -Path $SQLBackUpPath #-Verbose

    writelog "SQL Settings: SQLBackUpPath: [$SQLBackUpPath], SQLBackUpFileMask: [$SQLBackUpFileMask], SQLBackUpDaily: [$SQLBackUpDaily], SQLBackUp10days: [$SQLBackUp10days], SQLBackUpMontly: [$SQLBackUpMontly], SQLDateFormatLog: [$SQLDateFormatLog]" "DUMP"

	WriteLog "Purge old SQL BackUp files, by settings D:[$SQLBackUpDaily];10d:[$SQLBackUp10days];M:[$SQLBackUpMontly]" "INFO"


#   [array]$SQLLastBackUpFile = @()


    for($i=0; $i -lt $SQLBackUpFileMask.Count; $i++)
    {
    	$arr = Get-ChildItem -Path $SQLBackUpPath -Force -Filter $SQLBackUpFileMask[$i]

        $FileMaxDate = ""; # максимальная дата файла
        $LastFile = ""; # файл с максимальной датой

    	Foreach ($File in $arr) 
    	{
            #$File.Name;

            #Extract date from file name
    		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # этот вариант красивше, но возвращает дату с точкой на конце
		    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ищем в аормате yyyy-MM-dd.
    		#$match
    		#$match.Value

    		# если в файле небыло ничего похожего на дату - пропустим этот файл
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

                if ($FileMaxDate -lt $FileDate) 
                { 
                    $FileMaxDate = $FileDate;
                    $LastFile = $File;
                }

    			# сравниваем даты. Пропускаем и не удаяем файлы младше требуемой даты.
			    if ($FileDate -lt (Get-Date).AddDays(-$SQLBackUpDaily))
			    {

                    # если файл не от 1/10/20 числа месяца и находится в диапазоне дат от $SQLBackUp10days до $SQLBackUpDaily  - удаляем
                    if (($FileDate -gt (Get-Date).AddDays(-$SQLBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл не от первого числа месяца и находится в диапазоне дат от $SQLBackUpMontly до $SQLBackUp10days - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SQLBackUpMontly))) -and ($FileDate.Day -notin 1) )
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }
                }
            }
        }



        # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
	    if ( $SQLExport )
        {
	        #WriteLog "Create a latest copy of SQL backup(s) in Export folder [$SQLExportPath]" "DUMP"
    
            # Проверка наличия пути без создания оного.
            TestFolderPath -Path $SQLExportPath #-Verbose
        
            # Проверка что есть более свежая версия файла, если нет, то дальнейшая работа не имеет смысла. 

    	    $arr = Get-ChildItem -Path $SQLExportPath -Force -Filter $SQLBackUpFileMask[$i]

            # Берем максимальную дату из имеющихся файлов (попавших под маску), если нет файлов в таргетном каталоге считаем что дата последней выкладки 01-01-1970.
            # Сбрасываем значение даты, заоодно если нет файлов в каталоге для экспорта - считаем что там очень старый файл.
            $FileDate = get-date ("1970/01/01");

       	    Foreach ($File in $arr) 
            {

                WriteLog ("Extract date from file name [" + $File.FullName + "]") "DUMP"             

                #Extract date from file name
                $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ищем в аормате yyyy-MM-dd.
                #$match
                #$match.Value
        
                # если в файле небыло ничего похожего на дату - пропустим этот файл
                if ($match.Value -ne "")
                {
                    $nfDate = get-date ($match.Value)
                    if ($FileDate -lt $nfDate)
                    {
                        $FileDate = $nfDate
                    }
                }
            }

#-------
            if ($FileDate -lt $FileMaxDate)
            {
                WriteLog "New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"

                $SQLBackUpFileMask[$i]
                # Удаляем неактуальную версию
                $File = $SQLExportPath + "\" + $SQLBackUpFileMask[$i]
                DeleteFile -File $File -Verbose

                #Test-Path -Path $SQLExportPath
                if (Test-Path -Path $SQLExportPath)
                {
                    # Пробуем создать хардлинк
                    #New-Item -ItemType HardLink -Name "$SQLExportPath\$LastFile" -Value "$SQLBackUpPath\$LastFile"
                    #$command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"

                    WriteLog "Try to create New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"
                    $command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"
                    invoke-expression $command

                    if (-not (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue) )
                    {
                        # Если не удалось создать хардлинк пробуем скопировать
                        WriteLog "Did not create HardLink of file for export [$SQLExportPath\$LastFile], try to create a copy" "DUMP"
                                
                        # Проверка наличия свободного места на диске под копию файла
                        if ( CheckFreeSpace -Path $SQLExportPath -Size $File.Length  ) #-Verbose
                        {
                            # Копирование файла если место есть
                            Copy-Item -Path $SQLBackUpPath\$LastFile -Destination $SQLExportPath\$LastFile
                        }
                    }
                    # Финальная проверка что создалась копия
                    if (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created copy of file for export (to Tape) [$SQLExportPath\$LastFile]" "MESS"
                    }
                    else 
                    {
                        # Если не удалось создать и копии тоже - ругаемся красненьким
                        WriteLog "Did not create file for export [$SQLExportPath\$LastFile] (HardLink or Copy)" "ERRr"
                    }
                }
                else
                {
                    WriteLog "Export folder does not exist [$SQLExportPath]" "ERRr"
                }
            }
            Else 
            {
                WriteLog "NO New file for export. Last file [$LastFile] is same as old file [$SQLExportPath\$File]" "DUMP"
            }
        }


        # Архивирование бекапа (как правило с целью нарезки на куски для заливки на сервак)
        if ($SQLExportUploadArc) 
        {
            WriteLog "Try to Arcive Backup file: [$SQLExportPath\$LastFile], ArcLevel: [0], Volume: [$SQLExportUploadArcPart]" "DUMP"

            # Архивирование файлов в папке в архив вида [исходное имя файла].7z
            #$acrPath = "$SQLExportPath\$LastFile"+".7z"
            ArchiveFiles -Path "$SQLExportPath\$LastFile" -arcPath ("$SQLExportPath\$LastFile"+".7z") -DelSource -Size $SQLExportUploadArcPart -StoreArchive -Verbose # -DelSource

            #$SQLExportUploadArcPart
        }

        if ( $SQLExportUpload ) 
        {
            UploadFiles -Path $SQLExportPath -UploadPath $SQLExportUploadPath -UploadCred $SQLExportUploadCred -Verbose
        }

    }
}

if ($Log)
{
    # проверки на существование путей
    # - фолдера для Лог файлов и фолдера для архивов
    TestFolderPath -Path $LogFilePath #-Verbose
    TestFolderPath -Path $LogFilePathOld -Create #-Verbose


    # Удаление старых заархивированных логов
    if ($PurgeLogFiles -eq $TRUE){ FilePurge -Path $LogFilePathOld -LogFilePurgeDays $LogFilePurgeDays <# -Verbose #>; };


#break;
    	# Текущая дата в формате который используется для именования файлов
    	$currDate = Get-Date -Format $DateFormatLog

    	WriteLog "Move Log Files to Archives" "INFO"

    	# массив всех файлов
    	# TODO: сделать как-то покрасивше. т.е. из набранного массива выпиливать лишнее, а не так как сейчас
    	if ($LogFileAll2Arc -eq $TRUE)
    	{
		    $arr = Get-ChildItem -Path $LogFilePath -Force -Filter "*.log" -Name;
	    }
	    Else
	    {
    		$arr = Get-ChildItem -Path $LogFilePath -Force -Filter "*.log" -Name | where {$_ -notmatch "$currDate.log" };
    	}

    #	echo "Service's Error Logs Sensor [version: $scriptver]`r`nMonitoring *.Error files in folder $ErrLogPath"
    
    #	$i = 0;

    	Foreach ($File in $arr) 
    	{
		    $path = $LogFilePath + "\" + $File;
		    $arcPath = "$LogFilePathOld\" + "$LogFolderForArchives\$File.7z"
    
		    WriteLog "Processing file [$File]" "DUMP"

            # Архивирование файлов в папке в архив вида Errors_yyyy-MM-dd_HHmm.7z с удалением файлов
            ArchiveFiles -Path $path -arcPath $arcPath -DelSource -Verbose

    	}
    # Заливка заархивированных логов на сервер
    if ($UploadLogFiles -eq $TRUE)
    {
    #	UploadFiles # -Verbose
    }
}

if ($Errors)
{
    # Errors log Archiver 
    # $ErrorsPath = "D:\Shturman\Bin\Errors",		# Папка где лежат Errors, запакует все в каталог $LogFilePathOld\Errors с именем Errors_yyyy-MM-dd_HHmm.7z

    # проверка существования файлов Error по исходному пути, если их там нет то и делать нечего
    if (Test-Path -Path "$ErrorsPath\*.Error")
    {
        # проверка/создание папки куда складывать архив ошибок
        TestFolderPath -Path "$LogFilePathOld\Errors" -Create #-Verbose

        # move ВСЕХ файлов из каталога Еррор, а не только еррор файлов. на всякий случай
      	WriteLog "Try to move ALL files from [$ErrorsPath] to [$LogFilePathOld\Errors]" "DUMP"
        Move-Item -Path "$ErrorsPath\*" -Destination "$LogFilePathOld\Errors" -Force

        # Проверка что смувилось все
        if (-not (Test-Path -Path "$ErrorsPath\*"))
#        if (-not (Test-Path -Path "$ErrorsPath\ddd"))
        {
           	WriteLog "All Error's files moved from [$LogFilePathOld\Errors]" "DUMP"
        }
        else
        {
           	WriteLog "NOT All Error's files moved to [$LogFilePathOld\Errors]" "WARN"
        }
        
        # Проверка что в новом месте что-то появилось и архивирование
        if (Test-Path -Path "$LogFilePathOld\Errors\*.Error")
        {
           	WriteLog "Error's Files does moved succesfully to [$LogFilePathOld\Errors]" "MESS" $FALSE

            # Архивирование файлов в папке в архив вида Errors_yyyy-MM-dd_HHmm.7z с удалением файлов
            $PathToArchive = "$LogFilePathOld\Errors\*.Error"
            $CurrDate = Get-Date -Format "yyyy-MM-dd"
            $ArchivePatch =   "$LogFilePathOld\" + "$LogFolderForArchives\Errors\Errors_$CurrDate.7z"
            ArchiveFiles -Path $PathToArchive -arcPath $ArchivePatch -Verbose
        }
        else
        {
           	WriteLog "Error's Files does not exit in [$LogFilePathOld\Errors]" "ERRr"
        }

        
        WriteLog "Remove folder [$LogFilePathOld\Errors]" "DUMP"
        Remove-Item "$LogFilePathOld\Errors"

        
    }
    else
    {
       	WriteLog "No Error's files found in [$ErrorsPath]" "INFO"
    }


}

<#
	# +==============+
	# |    MySQL     |
	# +==============+
	[switch]  $MySQL = $TRUE					# Бэкап и обслуживание MySQL ( без этого колюча остальыне из группы MySQL* игнорируются)
    [array]   $MySQLCred = ("backup","E5-Pk+Tz-rz=aT!Ze@Tw")		# Логин и пароль для заливки
	[array]   $MySQL_DB = ("bitnami_redmine","r2d2","shturman") # Список баз для бэкапа
	#[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm",
	[int]     $MySQLBackUpDaily = "7"			# Days
	[int]     $MySQLBackUp10days = "60"		# Days
	[int]     $MySQLBackUpMontly = "180"		# Days
	[switch]  $MySQLExport = $FALSE			# Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    $MySQLBackUpPath = "\MySQL"
    $Export = $TRUE

    [string]$BackUpPath = "C:\BackUp"          # каталог для бекапов по умолчанию
    [string]$ExportPath = "C:\BackUp\2Tape"    # каталог для экспорта бекапов по умолчанию

    #E5PkTzrzaTZeTw
    #>

if ( $MySQL )
{
    WriteLog "MySQL BackUp: DB list: [$MySQL_DB]" "INFO"

    $CurrentBackUpFolder = get_BackUpPath -Path $MySQLBackUpPath

    #WriteLog ("MySQL_DB.Length1:" + $MySQL_DB.Length) "DUMP"
    
    if ( $MySQL_DB.Length )
    {
        #WriteLog ("MySQL_DB.Length2:" + $MySQL_DB.Length) "DUMP"
        foreach ($db in $MySQL_DB)
        {
            WriteLog ("db:" + $db) "DUMP"
            $BackUpNameMask =  $MySQLBackUpPrefix + $db
            $BackUpName =  $BackUpNameMask + "_$CurrDate" + "_$CurrTime" + ".sql"
            $CurrentBackUpFilePath = "$CurrentBackUpFolder\$BackUpName"
            MySQLBackUp -User $MySQLCred[0] -Password $MySQLCred[1] -DataBase $db -File $CurrentBackUpFilePath -Verbose
            #MySQLBackUp -DataBase $db -File $CurrentBackUpFilePath -Verbose

            $FileCreated = Get-ChildItem -Path $CurrentBackUpFilePath
    
            if ( (Test-Path -Path $CurrentBackUpFilePath) -and ($FileCreated.Length -gt 0) )
            #if ( Test-Path -Path $CurrentBackUpFilePath )
            {
                WriteLog "MySQL: Created BackUp of DB [$db] in to [$CurrentBackUpFilePath]" "MESS"

                $arcPath = "$CurrentBackUpFilePath.7z"
                ArchiveFiles -Path $CurrentBackUpFilePath -arcPath $arcPath -DelSource -Verbose

                if ( $Export -or $MySQLExport )
                {
                    export_backup -Source $arcPath -Target $ExportPath -Mask $BackUpNameMask -Verbose
                }

            }
            else
            {
                WriteLog "MySQL: Can not create BackUp of DB [$db] in to [$CurrentBackUpFilePath]" "ERR"
            }

            #purge_oldBackUp -Path $CurrentBackUpFolder -FileMask $BackUpNameMask -Daily $MySQLBackUpDaily -TenDays $MySQLBackUp10days -Montly $MySQLBackUpMontly -Verbose
            purge_oldBackUp -Path $CurrentBackUpFolder -FileMask $BackUpNameMask -Limits $MySQLLimits -Verbose

        }
    }

}


if ( $Redmine )
{
    WriteLog "Redmine BackUp" "INFO"

    # Куда класть итоговый бекап
    # название файла/каталога бекапа
    # название архива
    # маска для удаления старья

    $Current_BackUpPath = get_BackUpPath -Path $RedmineBackUpPath -Create -Verbose
    #$Current_BackUpPath

    #Create folder
    $Current_BackUpNameMask =  $RedmineBackUpPrefix
    #$Current_BackUpName   = $Current_BackUpNameMask + "_$CurrDate" + "_$CurrTime"
    $Current_BackUpFolder = $Current_BackUpNameMask + "_$CurrDate" + "_$CurrTime"
    #$Current_BackUpFilePath = "$CurrentBackUpFolder\$BackUpName"
    $Current_BackUpFolderPath = add_Subfolder_to_Path -Path $Current_BackUpPath -SubFolderName $Current_BackUpFolder -Create -Verbose 
    #"$CurrentBackUpFolder\$BackUpName"
    $RedmineDB_DumpFileName = "$Current_BackUpFolderPath\RedmineDB" + "_$CurrDate" + "_$CurrTime" + ".sql"


    #Copy Files
    copy_files_and_folders -Path "$RedminePath\*" -Destination $Current_BackUpFolderPath -Recurse -Check -Verbose
    
    #Dump DB
    MySQLBackUp -User $MySQLCred[0] -Password $MySQLCred[1] -DataBase $RedmineDB -File $RedmineDB_DumpFileName -Verbose

    #Archive backup
    $arcPath = "$Current_BackUpPath\$Current_BackUpFolder.7z"
    ArchiveFiles -Path $Current_BackUpFolderPath -arcPath $arcPath -DelSource -Verbose

    #Purge if backup created
    #purge_oldBackUp -Path $Current_BackUpPath -FileMask $Current_BackUpNameMask -Daily $RedmineBackUpDaily -TenDays $RedmineBackUp10days -Montly $RedmineBackUpMontly -Verbose
    purge_oldBackUp -Path $Current_BackUpPath -FileMask $Current_BackUpNameMask -Limits $RedmineLimits -Verbose

    #Export
    export_backup -Source $arcPath -Target $ExportPath -Mask $Current_BackUpNameMask -Verbose

}

if ($SVN)     #BackUp SVN Repositories
{
    # SVN
    WriteLog "SVN BackUp: Repositories: [$SVNRepoPath]" "INFO"

    #BackUp SVN Repository
    $CurrDate = Get-Date -Format "yyyy-MM-dd"
    $CurrTime = Get-Date -Format "HHmm"
    $BackUpFolderName = "SVN_$CurrDate" + "_$CurrTime"
    $SVNBackUpPathCurrent = "$SVNBackUpPath\$BackUpFolderName"

    #TestFolderPath -Path $SVNBackUpPathCurrent  -Create #-Verbose
    TestFolderPath -Path "$SVNBackUpPathCurrent\Conf"  -Create #-Verbose


    # Purge old BackUp

   <#	
   $arr = Get-ChildItem -Path $SVNBackUpPath -Force -Directory

    #$arr

   	Foreach ($File in $arr) 
   	{
        #$File
        #$File.Name;

        #Extract date from file name
 		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # этот вариант красивше, но возвращает дату с точкой на конце
	    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
	    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ищем в аормате yyyy-MM-dd.
   		#$match
   		#$match.Value

   		# если в файле/каталоге небыло ничего похожего на дату - пропустим этот файл
	    if ($match.Value -ne "")
	    {
        }

   			$FileDate =  get-date ($match.Value)
            #$match.Value

  			# сравниваем даты. Пропускаем и не удаяем файлы младше требуемой даты.
		    if ($FileDate -lt (Get-Date).AddDays(-$SVNBackUpDaily))
		    {

                #$FileDate
                #$FileDate.Day -notin 1, 10, 20
                #$File.Name

                # если файл не от 1/10/20 числа месяца и находится в диапазоне дат от $SQLBackUp10days до $SQLBackUpDaily  - удаляем
                #($FileDate -gt (Get-Date).AddDays(-$SVNBackUp10days))
                #($FileDate.Day -notin 1, 10, 20)
                if (($FileDate -gt (Get-Date).AddDays(-$SVNBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                {
                    $File.Name;
                    #$File.FullName;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # если файл не от первого числа месяца и находится в диапазоне дат от $SQLBackUpMontly до $SQLBackUp10days - удаляем
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SVNBackUpMontly))) -and ($FileDate.Day -notin 1) )
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }


            }



    }
    #>

    #break;
    
    # Copy SVN Config Files
	WriteLog "Try to copy SVN configuration files" "DUMP"
    Copy-Item -Path "$SVNRepoPath\*.conf" -Destination "$SVNBackUpPathCurrent\Conf"
    Copy-Item -Path "$SVNRepoPath\*.pid" -Destination "$SVNBackUpPathCurrent\Conf"
    Copy-Item -Path "$SVNRepoPath\htpasswd" -Destination "$SVNBackUpPathCurrent\Conf"
   	WriteLog "SVN Configuration copied to [$SVNBackUpPathCurrent\Conf]" "MESS"
    
    # TODO сделать проверку что оно скопировалось


    # Получаем список репозиториев (один фолдер - один репозиторий)
    $arr = Get-ChildItem -Path $SVNRepoPath -Force -Directory -Name;
    
  	Foreach ($File in $arr) 
   	{
    	WriteLog "Try to create dump of repository [$SVNRepoPath\$File] to [$SVNBackUpPathCurrent\$File.dump]" "DUMP"

        # дампим репы средствами 

        $command = "cmd /c svnadmin dump $SVNRepoPath\$File > $SVNBackUpPathCurrent\$File.dump"
        WriteLog "exec [$command]" "DUMP"
        invoke-expression $command
        
        #svnadmin dump $SVNRepoPath\$File > $SVNBackUpPathCurrent\$File.dump

        # проверка бессмысленная т.к. файл оно создает в любом случае
        # TODO сделать осмысленую проверку
        if (Test-Path -Path "$SVNBackUpPathCurrent\$File.dump")
        {
        	WriteLog "Dump of repository [$SVNRepoPath\$File] Created" "MESS"
        }
        else
        {
        	WriteLog "Dump of repository [$SVNRepoPath\$File] is not Created" "ERRr"
        }
    }

    $arcPath = "$SVNBackUpPath\$BackUpFolderName.7z"

    ArchiveFiles -Path $SVNBackUpPathCurrent -arcPath $arcPath -Size 0 -StoreArchive -DelSource -Verbose

    # Export last BackUp
    if ( $SVNExport )
    {
        export_backup -Source $arcPath -Target $ExportPath -Mask "SVN_" -Verbose
    }

    # чистим старье
    #purge_oldBackUp -Path $SVNBackUpPath -FileMask "SVN_" -Daily $SVNBackUpDaily -TenDays $SVNBackUp10days -Montly $SVNBackUpMontly -Verbose 
    purge_oldBackUp -Path $SVNBackUpPath -FileMask "SVN_" -Limits $SVNLimits -Verbose



}



if ($FilesON)
{


	WriteLog "BackUp Files and folders" "INFO"


    WriteLog "`$FilesBackUpPath           [$FilesBackUpPath]" "DUMP"          # Место куда сладируются сделанные бекапы
    WriteLog "`$FilesDateFormat           [$FilesDateFormat]" "DUMP"          # формат даты бекапа
    WriteLog "`$FilesFileName             [$FilesFileName]" "DUMP"            # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9]
    WriteLog "`$FilesFolderName           [$FilesFolderName]" "DUMP"          # имя фолдера задаваемого в $FilesBackUpPath , каталог который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9], Маска включаемых файлов, Маска исключаемых
    WriteLog "`$FilesBackUpDaily          [$FilesBackUpDaily]" "DUMP"	      # Days
    WriteLog "`$FilesBackUp10days         [$FilesBackUp10days]" "DUMP"        # Days
    WriteLog "`$FilesBackUpMontly         [$FilesBackUpMontly]" "DUMP"        # Days
    WriteLog "`$FilesExportPath           [$FilesExportPath]" "DUMP"
    WriteLog "`$FilesExport               [$FilesExport]" "DUMP"              # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    WriteLog "`$FilesExportUploadArcPart  [$FilesExportUploadArcPart]" "DUMP" # Нарезка архива на части = размер части в МБ, 0 = одним куском
    WriteLog "`$FilesExportUpload         [$FilesExportUpload]" "DUMP"        # Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
    WriteLog "`$FilesExportUploadPath     [$FilesExportUploadPath]" "DUMP"    # Путь куда заливать
    WriteLog "`$FilesExportUploadCred     [$FilesExportUploadCred]" "DUMP"    # Логин и пароль для заливки
    WriteLog "`$FilesBackUpFileMask       [$FilesBackUpFileMask]" "DUMP"


    # идем по массиву $FilesFileName и пакуем индивидуальное файло
    for($i=0; $i -lt $FilesFileName.Count; $i++)
    {
        #echo $FilesFileName[$i] 

        if ( $FilesFileName[$i][0] -ne "" ) { $BackUpFolder = $FilesFileName[$i][0] } else {$BackUpFolder = $FilesBackUpPahth }
        #$BackUpFolder  = $FilesFileName[$i][0]
        $BackFile      = $FilesFileName[$i][1]
        $id            = $FilesFileName[$i][2]
        $Compress      = $FilesFileName[$i][3]
        #$CompressLevel = $FilesFileName[$i][3]
    
        WriteLog "`$i                         [$i]" "DUMP"            # порядковый номер элемента массива
        WriteLog "`$BackUpFolder              [$BackUpFolder]" "DUMP"            # имя фолдера задаваемого в $FilesBackUpPath 
        WriteLog "`$BackFile                  [$BackFile]" "DUMP"            #  файл который необходимо забекапить
        #WriteLog "`$CompressLevel             [$CompressLevel]" "DUMP"            #  Уровень сжатия [0-9]
        
        # пакуем

   	    # Текущая дата в формате который используется для именования файлов
    	$currDate = Get-Date -Format $FilesDateFormat
        
    	#WriteLog "Move Log Files to Archives" "INFO"

        #$BackFileMaskName = $BackFile -replace "(\.\*)|(\..*$)", ""
        $BackFileMaskName = $BackFile -replace "(\.\*)|[\*\?]", ""
        $BackFileMaskName = Split-path $BackFileMaskName -Leaf
        #$BackFileMaskName
        #$BackFileMask = Split-path $BackFile -Leaf

        if ( $id.Length -gt 0 ) 
        {
            $id = "_$id"
        }

	    $path = $BackFile;
	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"

    
	    #WriteLog "Processing file [$File]" "DUMP"

        if ( Test-Path -Path $path )
        {
            WriteLog "Process file #[$i] [$BackFile]; IsCompress: [$Compress]; to Folder [$BackUpFolder]" "INFO"
            # Архивирование файлов в папке в архив вида [SourceFile Name|Mask]_yyyy-MM-dd_HHmm.7z
            ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

            # выкладываем / заливаем
            if ( $FilesExport )
            {
                export_backup -Source $arcPath -Target $FilesExportPath -Mask $BackFileMaskName -Verbose
            }

            # чистим старье
            #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
            purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Limits $FilesLimits -Verbose
        }
        else 
        {
            WriteLog "file #[$i] [$BackFile] does not exist" "ERR"

        }
    }

    # идем по массиву $FilesFolderName и пакуем папки.

    foreach ($Folder in $FilesFolderName)
    {

        if ( $Folder[0] -ne "" ) { $BackUpFolder = $Folder[0] } else {$BackUpFolder = $FilesBackUpPahth }
        #$BackUpFolder  = $Folder[0]
        $BackFolder    = $Folder[1]
        $id            = $Folder[2]
        $Compress      = $Folder[3]
        #$CompressLevel = $FilesFileName[$i][3]

        $BackFolderName = Split-Path -Path $BackFolder -Leaf
        $BackFolderParent = Split-Path -Path $BackFolder -Parent
        if ( $BackFolderParent -ne "" )
        {
            $BackFolderParentName = split-path -Path $BackFolderParent -Leaf
        }
        else
        {
            # затычка на случай запуска с дефолтными параметрами, а там прописано просто слово, а не полный путь
            $BackFolderParentName = ""
        }
        

        if ( $id.Length -gt 0 ) 
        {
            $id = "_$id"
        }

        #$BackFolderName
        #$BackFolderParentName
        # пакуем
        
   	    # Текущая дата в формате который используется для именования файлов
    	$currDate = Get-Date -Format $FilesDateFormat


	    $path = $BackFolder;

        if ( $BackFolderName -eq "*" )
        {
            if ( -not (Test-Path -Path $BackFolderParent ) ) { 
                continue 
            }
        }
        else
        {
            if ( -not (Test-Path -Path $BackFolderName ) ) { 
                continue 
            }
        }


        if ( $BackFolderName -eq "*" )
        {
            $dirs = Get-ChildItem -Path $BackFolderParent -Directory #-Depth 0
            
            foreach ( $dir in $dirs )
            {
                $BackFileMaskName = $dir.Name
                $path = $dir.FullName
        	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"
                
                $path
                $arcPath
                ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

                # выкладываем / заливаем
                if ( $FilesExport )
                {
                    export_backup -Source $arcPath -Target $FilesExportPath -Mask $BackFileMaskName -Verbose
                }
    
                # чистим старье
                #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
                purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Limits $FilesLimits -Verbose
                
            }

        }
        else
        {
            $BackFileMaskName = $BackFolderName
    	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"
            ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

            # выкладываем / заливаем
            if ( $FilesExport )
            {
                export_backup -Source $arcPath -Target $FilesExportPath -Mask $BackFileMaskName -Verbose
            }

            # чистим старье
            #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
            #purge_oldBackUp -Path "C:\BackUp\FromComputers\st-nas\" -FileMask "" -Limits $FilesLimits -Verbose
            purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Limits $FilesLimits -Verbose

        }

    }

}


# Сбор бекапов с других серверов
if ( $Collect )
{
    WriteLog "Collect BackUp's from Computers to [$Collect_Folder]" "INFO"

    foreach ( $item in $Collect_Data )
    {
        $Share = $item[0]
        $Mask  = $item[1]
        $days  = $item[2]

        #$host
        $Uri = [System.Uri]$Share
        $curr_Host = $Uri.Host

        $Current_Collect_Folder = "$Collect_Folder\$curr_Host"

        if ( Test-Path -Path $Share )
        {
            WriteLog "Process [$Share] with mask [$Mask]; days: [$days]; To $Current_Collect_Folder" "INFO"

            $x = TestFolderPath -Path $Collect_Folder -Create -Verbose
            $x = TestFolderPath -Path $Current_Collect_Folder -Create -Verbose

            $src_mask = "$Share\$Mask*"

            $x = move_files -Path $src_mask -Destination $Current_Collect_Folder -Verbose

            #$x = purge_oldBackUp -Path $Current_Collect_Folder -FileMask $Mask -Daily $Store_Daily -TenDays $Store_10days -Montly $Store_Montly -Quartal $Store_Quartal -Years $Store_Years -Verbose
            $x = purge_oldBackUp -Path $Current_Collect_Folder -FileMask $Mask -Limits $CollectLimits -Verbose
        }
        else
        {
            WriteLog "Source share [$Share] does not exist or not accessible" "ERRr"
        }
    }
}