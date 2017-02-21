<#
    1. Log Archiver
       - архивирование всех *.log файлов за исключением сегодняшних
       - в подпапку Old
       - по расписанию 1 раз в сутки в 03:30 (Шедульной таской)
       - удаление архивов старше [$LogFilePurgeDays] дней
       - TODO заливка логов на сервер
       - TODO выборочное архивирование логов и заливка оных с блоков на сервак
       - TODO Создание Шедульной таски для автоматического запуска скрипта
    2. MS SQL BackUP
       - бд Shturman_Metro полный бекап (Джобой в MS SQL)
       - в папку d:\BackUP
       - TODO Архивирование бэкапа
       - Удаление старых бэкапов по принципу ([$SQLBackUpDaily] дней - ежедневный; [$SQLBackUp10days] дней - "недельный" 1/10/20 числа кажд мес; [$SQLBackUpMontly] дней - месячный от 1 числа;  всегда - ежеквартальный от 1 числа)
       - TODO обработка старых архивов по расписанию 1 раз в сутки в 03:00
       - TODO Восстановление бэкапа и проверка оного
       - TODO Сообщение об ошибках в случае не прохождения проверки.
    3. SVN BackUP
       - TODO Поиск репозиториев и дамп всех найденных, бэкап настроек
       - TODO в папку d:\BackUP
       - TODO Удаление старых бэкапов по принципу (1 нед - ежедневный, 1 месяц - недельный 1/15/21 числа кажд мес, всегда - ежемесячный от 1 числа)
       - TODO обработка старых архивов по расписанию 1 раз в сутки в 03:00
       - TODO Восстановление бэкапа и проверка оного
       - TODO Сообщение об ошибках в случае не прохождения проверки.
    4. Redmine BackUP
       - TODO Бэкап базы, файлохранилища, настроек
       - TODO в папку d:\BackUP
       - TODO Удаление старых бэкапов по принципу (1 нед - ежедневный, 1 месяц - недельный 1/15/21 числа кажд мес, всегда - ежемесячный от 1 числа)
       - TODO обработка старых архивов по расписанию 1 раз в сутки в 03:00
       - TODO Восстановление бэкапа и проверка оного
       - TODO Сообщение об ошибках в случае не прохождения проверки.


New:

1.0.4
    Common
        Настройки подцепляются из файла BackUpSettings.ps1, при наличии ключа [-UseSettingsFile], Файл должен находиться в папке скрипта.
        Настройки соответствует блоку PARAM. Все что будет в данной файле имеет приоритет на любыми входящими ключами
    2. MS SQL BackUP
        Удаление старых бэкапов по принципу ([$SQLBackUpDaily] дней - ежедневный; [$SQLBackUp10days] дней - "недельный" 1/10/20 числа кажд мес; [$SQLBackUpMontly] дней - месячный от 1 числа;  всегда - ежеквартальный от 1 числа)
    1. Log Archiver
        Включение архивирования логов по флагу [$Log]

1.0.3
    Все
#>


param (
	# Log Files
	[switch]$Log = $FALSE,				# Бэкап и обслуживание Log файлов ( бех этого колюча остальные из группы игнорируются)
	[string]$DateFormatLog = "yy-MM-dd",
	[string]$LogFilePath = "D:\Shturman\Bin\Log",
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old",
	[string]$LogFilePurgeDays = "30", # Days
	[switch]$PurgeLogFiles = $FALSE, # похоронить архивы старше  $LogFilePurgeDays дней
	[switch]$UploadLogFiles = $FALSE, # Заливка лог файлов на сервер.
	[switch]$FastArcive = $FALSE, # более легковесный упаковщик. без флага - пакует по максимому, что в Х раз дольше. но немного меньше места занимает
	[switch]$LogFileAll2Arc = $FALSE, # заставляет упаковывать все лог файлы. включая сегоднящние

	# SQL

	[switch]$SQL = $FALSE,				# Бэкап и обслуживание SQL ( без этого колюча остальыне из группы SQL* игнорируются)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro",
	[array]$SQLBackUpFileMask = ("Shturman_Metro_*.bak","Shturman_Metro_Anal_*.bak"),
	[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm",
	[int]$SQLBackUpDaily = "7", # Days
	[int]$SQLBackUp10days = "60", # Days
	[int]$SQLBackUpMontly = "180", # Days

	# SVN
	[switch]$SVN = $FALSE,				# Бэкап и обслуживание SVN ( бех этого колюча остальыне из группы SVN* игнорируются)
	# Redmine
	[switch]$Redmine = $FALSE,			# Бэкап и обслуживание Redmine ( бех этого колюча остальные из группы Redmine* игнорируются)

	[string]$BackUpDaily = "14", # Days
	[string]$BackUpWeekly = "13", # Weeks
#	[string]$BackUpMontly = "14", # Days
#	[string]$AppPath = "C:\Shturman\",
	[switch]$CreateSheduledTask = $FALSE,		# Создание Шедульной таски для автоматического запуска скрипта

	[switch]$UseSettingsFile = $FALSE,		    # использоватать файл настроек BackUpSettings.ps1 (находится в фолдере скрипта). Настройки аналогичны данному блоку PARAM.

	[switch]$Debug = $FALSE		# в консоль все события лога пишет
#	[switch]$Debug = $TRUE		# в консоль все события лога пишет
)

$version = "1.0.4";



# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

clear;
WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
WriteLog "Script version: [$version]" "INFO"


[string]$ParamsPath = "$ScriptDir\BackUpSettings.ps1";

# Если в каталоге скрипта присуствует файл BackUpSettings.ps1 - подсасываем из него персонализинованные параметры
if ((test-path $ParamsPath) -and ($UseSettingsFile))
{
	# инклюдим параметры (список сервисов, инстанс SQL и пр что обычно в блоке params
	WriteLog "Чтение настроек скрипта [$ParamsPath]" "INFO"
	."$ParamsPath"
}
ElseIf (-not $UseSettingsFile)
{
	WriteLog "Скрипт запущен с дефолтными настройками" "INFO"
}
Else
{
	WriteLog "Скрипт запущен с дефолтными настройками (файл настроек [$ParamsPath] не найден)" "INFO"
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
		[string]$LogFilePurgeDays = 30,
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

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

}

<#
function  SQLBackup ($SQLDBName, $SQLUsername, $SQLPassword, $SQLBackUpPath)
{
}
#>

# TODO Создание Шедульной таски для автоматического запуска скрипта
if ($CreateSheduledTask -eq $TRUE)
{
	WriteLog "NO FUNCTIONALE (c) Kuba's taxist" "ERRr"

}

if ($SQL)
{
    TestFolderPath -Path $SQLBackUpPath #-Verbose

    writelog "SQL Settings: SQLBackUpPath: [$SQLBackUpPath], SQLBackUpFileMask: [$SQLBackUpFileMask], SQLBackUpDaily: [$SQLBackUpDaily], SQLBackUp10days: [$SQLBackUp10days], SQLBackUpMontly: [$SQLBackUpMontly], SQLDateFormatLog: [$SQLDateFormatLog]" "DUMP"

	WriteLog "Purge old SQL BackUp files, by settings D:[$SQLBackUpDaily];10d:[$SQLBackUp10days];M:[$SQLBackUpMontly]" "INFO"


;
    for($i=0; $i -lt $SQLBackUpFileMask.Count; $i++)
    {
    	$arr = Get-ChildItem -Path $SQLBackUpPath -Force -Filter $SQLBackUpFileMask[$i]

    	Foreach ($File in $arr) 
    	{
            #$File.Name;

            #Extract date from file name
    		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # этот вариант красивше, но возвращает дату с точкой на конце
		    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # тоже что и предыдущий, но более понятно.
    		#$match
    		#$match.Value

    		# если в файле небыло ничего похожего на дату - пропустим этот файл
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

    			# сравниваем даты. Пропускаем и не удаяем файлы младше требуемой даты.
			    if ($FileDate -lt (Get-Date).AddDays(-$SQLBackUpDaily))
			    {

#$FileDate
#$FileDate.Day -notin 1, 10, 20

                    # если файл не от 1/10/20 числа месяца и находится в диапазоне дат от $SQLBackUp10days до $SQLBackUpDaily  - удаляем
                    if (($FileDate -gt (Get-Date).AddDays(-$SQLBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл не от первого числа месяца и находится в диапазоне дат от $SQLBackUpMontly до $SQLBackUp10days - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SQLBackUpMontly))) -and ($FileDate.Day -notin 1) )
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }


                }
            }



        }
        
        #$SQLBackUpFileMask[$i];
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

	    # на сколько сильно паковать. если флаг взведен - пакуем по максимому, но долго-долго.
	    if ($FastArcive -eq $TRUE)
	    {
    		$ArcivationDensity = ""
    	}
    	else
    	{
		    $ArcivationDensity = "-mx=9"
	    }
    #	echo "Service's Error Logs Sensor [version: $scriptver]`r`nMonitoring *.Error files in folder $ErrLogPath"
    
    #	$i = 0;

    	Foreach ($File in $arr) 
    	{
		    $path = $LogFilePath + "\" + $File;
		    $arcPath = "$LogFilePathOld\$File.7z"
    
		    WriteLog "Processing file [$File]" "DUMP"
    
		    # Проверяем возможные пути расположения архиватора
		    if (test-path -Path "D:\Prog\7-zip\7za.exe" -ErrorAction SilentlyContinue)
		    {
# "d:\prog\7-zip\7za.exe -m9 a $arcPath -sdel $path"
    			$res = D:\Prog\7-zip\7za.exe $ArcivationDensity a $arcPath -sdel $path
		    }
		    ElseIf (test-path -Path "C:\Prog\7-Zip\7za.exe" -ErrorAction SilentlyContinue)
		    {
    			$res = C:\Prog\7-Zip\7za.exe $ArcivationDensity a $arcPath -sdel $path
		    }
		    else 
		    {
    			WriteLog "Archiver not found" "ERRr" # не нашли архиватор. делать нефиг, вываливаемся
			    break;
		    }


		    WriteLog "$res" "DUMP"

    		if (test-path $arcPath)
		    {
    			# повторная попытка грохнуть файл. если архиватор не смог. бесполезная по сути... т.к. не помогает.
			    Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
    #			$File.Delete()
    
			    # проверяем исходный файл на наличие, если все еще присутсвует - ругаемся
			    if (test-path $path -ErrorAction SilentlyContinue)
			    {
    
				    WriteLog "File [$File] added to archive [$File.7z]" "WARN" # если исходный остался - пишем что файл _добавлен_
				    WriteLog "Source file [$path] doesn't removed" "ERRr"
			    }
			    else
			    {
    				WriteLog "File [$File] moved to archive [$File.7z]" "MESS" # а если нормально удалился - пишем что ремувед
			    }
			
    		}
		    Else
		    {
    			WriteLog "Arcived File [$arcPath] doesn't exist" "ERRr"
		    }
    
    #$File
    #		WriteLog $path "INFO"
    	}
    # Заливка заархивированных логов на сервер
    if ($UploadLogFiles -eq $TRUE)
    {
    	UploadFiles # -Verbose
    }
}
