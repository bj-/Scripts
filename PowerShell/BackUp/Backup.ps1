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
        - Дамп указаных БД
        - архивирование каждого дампа
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
    C. TODO: Отчетность о проделанной работе
        - TODO: На портал GET/POST
        - TODO: созданные бекапы
        - TODO: удаленные лишки (помечать в бд если они создавались ранее
        - TODO: собранные бекапы



New:
1.1.2
    - Багфиксинг
1.1.1
    - Функционал резнесен по разным файлам
    - сам скрипт переехал в отдельный каталог на уровень равны каталогу с functions.ps1
    - [Fix] Errors - при архивирование теперь самархиватор удаляет исходныен файлы.
    - Добавлены сценарии бекапов
1.0.12
    - Багфикс
        - Files: выбор пути для экспорта (теперь выбирает дефолтный если нет персонального)
        - Files: корректная обработка когда не указано какой файл паковать
        - Log: лог текущего дня теперь исключает по резулярке. допустимый формат 20.10.31 и 20-10-31
        - Files: экспорт с разными ID (удаляло по маске файла, без учета ID, как слдествие в экспорт попадал только один файлю последний
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
    [array]  $MySQLLimits              = $NULL,                                     # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
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
	[string] $FilesBackUpPath = "D:\BackUp\Files",           # Место куда сладируются сделанные бекапы
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
	[string] $FilesExportPath          = $NULL,
    [switch] $FilesExport              = $FALSE,			                  # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
    [int]    $FilesExportUploadArcPart = 100,		                          # Нарезка архива на части = размер части в МБ, 0 = одним куском
    [switch] $FilesExportUpload        = $FALSE,		                      # Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
    [string] $FilesExportUploadPath    = "\\172.16.30.139\Share\Exp",	      # Путь куда заливать
    [array]  $FilesExportUploadCred    = ("UserName","password"),		      # Логин и пароль для заливки
	#[array] $FilesBackUpFileMask      = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),

	# +===================================+
    # |    Purge Old Files/folders        |
	# +===================================+
	#[switch]$Purge = $TRUE,		                                         # Создавать бекапы файлов/каталогов
	[switch] $Purge = $FALSE,		                                         # Создавать бекапы файлов/каталогов
	[array]  $PurgeList = (
                                  # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, ID - на случай архивов с одинаковыми названиями, Compress | $FALSE - сжммать
                                  # "Path" - "Путь к месту хранения", "Mask" - маски файлов, ("Limits") - правила удаления (10, 60, 180, 365, 0) - d / 10d / m / q / y
                                ("Path", "Mask", ($NULL)),
                                ("Path", "Mask", ($NULL))
                                #("c:\BackUp", "SomeFile_", ($NULL)),
                                #("c:\BackUp", "SomeFile_", (10, 60, 180, 365, 0))
                             ),		# единичные файлы
    

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
    [int]    $Store_Daily    = 14,                    # Дней хранятся ежедневные бэкапы
    [int]    $Store_10days   = 60,                    # Дней хранятся бэкапы от 01, 10 и 20 числа
    [int]    $Store_Montly   = 365,                   # Дней хранятся ежемесячные бэкапы (01.хх.хх)
    [int]    $Store_Quartal  = 720,                   # Дней хранятся ежеквартальные бэкапы (01.01.хх 01.04.хх 01.07.хх 01.10.хх)
    [int]    $Store_Years    = 0,                     # Дней хранятся ежегодовые бэкапы (01.01.хх)

	[switch] $SheduledTaskCreate = $FALSE,		      # Создание Шедульной таски для автоматического запуска скрипта
	[switch] $UseSettingsFile = $FALSE,			      # использоватать файл настроек BackUpSettings.ps1 (находится в фолдере скрипта). Настройки аналогичны данному блоку PARAM.
	[string] $SettingsFile = $NULL,			          # использоватать указанный файл настроек (копия BackUpSettings.ps1) файл либо находится в фолдере скрипта либо указать полный путь. 
	[switch] $HighestPrivelegesIsRequired = $FALSE,   # Проверять есть ли админские права. модт быть необходимо работы с файлами

    [string] $TempPath = "D:\BackUp",                 # каталог для бекапов по умолчанию

    [string] $BackUpPath = "D:\BackUp",               # каталог для бекапов по умолчанию
    [string] $ExportPath = "D:\BackUp\2Tape",         # каталог для экспорта бекапов по умолчанию
    [switch] $Export     = $FALSE,                    # Если включено то все бэкапы будут экспортиться. независимо от местных настроек

	[string] $UploadCahnnelType = "VPN",		      # VPN | FTP | NO .... - Канал для загрузки файлов на внешний сервер
	[string] $VPNName = "ST",					      # 
#	[string] $VPNUserName = "username",			      # 
#	[string] $VPNPassword= "password",			      # 

	[switch] $Debug = $FALSE	    # в консоль все события лога пишет
#	[switch] $Debug = $TRUE		# в консоль все события лога пишет
)

$version = "1.1.2";
$InScript = $TRUE

# +==================+
# |       Common     |
# +==================+
[array]$DefaultStoreLimits = ($Store_Daily, $Store_10days, $Store_Montly, $Store_Quartal, $Store_Years)   # теже лимиты но в массиве, для простоты обработки
$CurrDate = Get-Date -Format "yyyy-MM-dd"
$CurrTime = Get-Date -Format "HHmm"
$CurrDateTime = Get-Date -Format "yyyy-MM-dd_HHmm"

# // Files //
$FilesBackUpPath = if ( $FilesBackUpPath -ne "" ) { $FilesBackUpPath } else { $BackUpPath }           # Место куда сладируются сделанные бекапы
$FilesLimits     = if ( $FilesLimits.Count )      { $FilesLimits } else { $DefaultStoreLimits }           
$FilesExportPath = if ( $FilesExportPath -ne "" ) { $FilesExportPath } else { $ExportPath }           
$FilesExport     = if ( $FilesExport )            { $FilesExport } else { $Export }           


# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptFullPath = $ScriptDir + "\" + $script:MyInvocation.MyCommand.Name

# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"
.$ScriptDir"\BackUp_Functions.ps1"

#clear;
WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
WriteLog "Script version: [$version]" "INFO"


if ( $SettingsFile.Length -gt 3 )
{
    [string]$ParamsPath = "$ScriptDir\$SettingsFile";
}
elseif ( $UseSettingsFile )
{
    [string]$ParamsPath = "$ScriptDir\Settings.ps1";;
}
else 
{
    $ParamsPath = $NULL
}

if ( $ParamsPath.Length -ne 0 )
{
    if ( Test-Path -Path $ParamsPath )
    {
	    # инклюдим параметры (список сервисов, инстанс SQL и пр что обычно в блоке params
	    WriteLog "Чтение настроек скрипта [$ParamsPath]" "INFO"
	    ."$ParamsPath"
    }
    else
    {
    	WriteLog "Скрипт запущен с дефолтными настройками (Указанный файл настроек [$ParamsPath] не найден)" "ERRr"
    }
}
else
{
	WriteLog "Скрипт запущен с дефолтными настройками" "INFO"
}

<#
Старый варианта выбора файла настроек
[string]$ParamsPath = "$ScriptDir\Settings.ps1";
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
#>

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



# Создание Шедульной таски для автоматического запуска скрипта
#$SheduledTaskCreate = $TRUE
if ($SheduledTaskCreate) { .$ScriptDir"\BackUp_Sheduled-Task.ps1";  BackUp_SheduledTask;  }

if ( Test-Path -Path "ScriptDir\BackUp_SQL.ps1" )     { .$ScriptDir"\BackUp_SQL.ps1";     }
if ( Test-Path -Path "ScriptDir\BackUp_Log.ps1" )     { .$ScriptDir"\BackUp_Log.ps1";     }
if ( Test-Path -Path "ScriptDir\BackUp_Errors.ps1" )  { .$ScriptDir"\BackUp_Errors.ps1";  }
if ( Test-Path -Path "ScriptDir\BackUp_MySQL.ps1" )   { .$ScriptDir"\BackUp_MySQL.ps1";   }
if ( Test-Path -Path "ScriptDir\BackUp_Redmine.ps1" ) { .$ScriptDir"\BackUp_Redmine.ps1"; }
if ( Test-Path -Path "ScriptDir\BackUp_SVN.ps1" )     { .$ScriptDir"\BackUp_SVN.ps1";     }
if ( Test-Path -Path "ScriptDir\BackUp_Files.ps1" )   { .$ScriptDir"\BackUp_Files.ps1";   }
if ( Test-Path -Path "ScriptDir\BackUp_Purger.ps1" )  { .$ScriptDir"\BackUp_Purger.ps1";  }
if ( Test-Path -Path "ScriptDir\BackUp_Collect.ps1" ) { .$ScriptDir"\BackUp_Collect.ps1"; }

#"[$Debug]"
#$Debug = $TRUE
#"[$Debug]"
#"fffff3"

# Custom Scenarios (in settings.ps1)
if ( ($SettingsFile.Length -gt 3) -or $UseSettingsFile )
{
    Custom_Scenario
}
else
{
    if ( $SQL     ) { BackUp_MSSQL;            } # MS SQL
    if ( $Log     ) { BackUp_Logs;             } # Log files
    if ( $Errors  ) { BackUp_Errors;           } # Error files (Special for shturman)
    if ( $MySQL   ) { BackUp_MySQL;            } # MySQL
    if ( $Redmine ) { BackUp_Redmine;          } # Redmine
    if ( $SVN     ) { BackUp_SVN;              } # SVN Repositories
    if ( $FilesON ) 
    { 
        BackUp_FilesAndFolders -BackUpPath $FilesBackUpPath -DateFormat $FilesDateFormat -FilesList $FilesFileName -FolderList $FilesFolderName -Limits $FilesLimits -ExportPath $FilesExportPat -Export $FilesExport
    } # Файлы и каталоги
    if ( $Purge   ) { BackUp_Purger;           } # Purger old backup (bastd on files and folders)
    if ( $Collect ) { BackUp_Collect;          } # Сбор бекапов с других серверов
}

# Custom Scenarios (in settings.ps1)
#if ( ($SettingsFile.Length -gt 3) -or $UseSettingsFile )
#{
    #Scenario_After
#}

$InScript = $FALSE