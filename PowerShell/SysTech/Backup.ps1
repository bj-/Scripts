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
       - TODO Удаление старых бэкапов по принципу (2 нед - ежедневный, 3 месяца - недельный 1/15/21 чтсдла кажд мес, всегда - ежемесячный от 1 числа)
       - TODO обработка старых архивов по расписанию 1 раз в сутки в 03:00
       - TODO Восстановление бэкапа и проверка оного
       - TODO Сообщение об ошибках в случае не прохождения проверки.

#>


param (
	[string]$LogFilePath = "D:\Shturman\Bin\Log",
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old",
	[string]$DateFormatLog = "yy-MM-dd",
	[string]$LogFilePurgeDays = "30", # Days
	[switch]$PurgeLogFiles = $FALSE, # похоронить архивы старше  $LogFilePurgeDays дней
	[switch]$UploadLogFiles = $FALSE, # Заливка лог файлов на сервер.
	[switch]$FastArcive = $FALSE, # более легковесный упаковщик. без флага - пакует по максимому, что в Х раз дольше. но немного меньше места занимает
	[switch]$LogFileAll2Arc = $FALSE, # заставляет упаковывать все лог файлы. включая сегоднящние
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro",

	[string]$BackUpDaily = "14", # Days
	[string]$BackUpWeekly = "13", # Weeks
#	[string]$BackUpMontly = "14", # Days
#	[string]$AppPath = "C:\Shturman\",
	[switch]$CreateSheduledTask = $FALSE		# Создание Шедульной таски для автоматического запуска скрипта
	[switch]$Debug = $FALSE		# в консоль все события лога пишет
)

$version = "1.0.2";

# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"

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

clear;
WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
WriteLog "Script version: [$version]" "INFO"


# TODO Создание Шедульной таски для автоматического запуска скрипта
if ($CreateSheduledTask -eq $TRUE)
{
	WriteLog "NO FUNCTIONALE (c) Kuba's taxist" "ERRr"

}

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

				WriteLog "File [$File] added to archive [$File.zip]" "WARN" # если исходный остался - пишем что файл _добавлен_
				WriteLog "Source file [$path] doesn't removed" "ERRr"
			}
			else
			{
				WriteLog "File [$File] moved to archive [$File.zip]" "MESS" # а если нормально удалился - пишем что ремувед
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
