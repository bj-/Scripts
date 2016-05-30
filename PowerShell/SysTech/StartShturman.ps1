<#
#
# Запуск сервисов и штурмана в один клик
#
# поверяет наличие сервиса SQL сервера, 
#
#
# TODO 
#  TODO чистить очереди и логи перед стартом
#
 Ключи
 -ServicesUninstall - Разрегистрация всех сервисов

 -ShturmanInstall


ChangeNotes


#>
param (
	[string]$SQLServiceName = "MSSQL`$SQLEXPRESS",
	[string]$SQLDBName = "ShturmanMOSStep8",
	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
	[string]$SQLUsername = "sa",
	[string]$SQLPassword = "as",
#	[string]$SQLScriptFile = "test.sql",
	[string]$SQLScriptFile = "",
    [string]$SQLDBBackUpPatch = "",
	[string]$AppPath = "D:\Shturman",
	[string]$InstallPath = "C:\ShturmanInstallationPackage\",
	[string]$ParamsPath = "$AppPath\Params.ps1",
	[switch]$ServicesUninstall = $FALSE,
	[switch]$ServicesInstall = $FALSE,
	[switch]$ShturmanInstall = $FALSE,
	[switch]$Fast = $FALSE,		# Сокращает периоды сна между командами до 1 сек.
	[switch]$Debug = $FALSE		# в консоль все события лога пишет
	
)

#$AppPath\PSS\SysTech\CreateUser.ps1

clear;

# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"
<#
# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"
#>

$version = "1.0.5";

#[Console]::OutputEncoding = [System.Text.Encoding]::1251
#$OutputEncoding = [Console]::OutputEncoding
#write-host "ffff" + $OutputEncoding


if ($Fast -eq $TRUE) # Для отладки, чтоб не ждать
{
	[Int]$SleepBeforeSQLService = 1      #Recomended: 600
	[Int]$SleepAfterSQLService = 1      #Recomended: 300
	[Int]$SleepAfterSQLScript = 1      #Recomended: 20-30
	[Int]$SleepBetwenSrvcInstalationAndSrvcConfiguration = 0
	[Int]$SleepBeforeScriptRuning = 1
}
Else
{
	[Int]$SleepBeforeScriptRuning = 10
	[Int]$SleepBeforeSQLService = 10      #Recomended: 600
	[Int]$SleepAfterSQLService = 30      #Recomended: 300
	[Int]$SleepAfterSQLScript = 5      #Recomended: 20-30
	[Int]$SleepBetwenSrvcInstalationAndSrvcConfiguration = 1   # Для шибко тупых компов может потребоваться промежуток
}
#$SQLServiceName = "MSSQL`$SQLEXPRESS"
#$SQLDBName = "Shturman_metro"
#$SQLServerInstance = "localhost\SQLEXPRESS"
#$SQLUsername = "sa"
#$SQLPassword = "as"
#$SQLScriptFile = ".\21_Init.sql"

#$ShturmanEXELocation = "D:\Shturman\Bin\"
#$ShturmanEXELink = "Shturman_conf1.lnk"
#Invoke-Item "cd "+ $ShturmanEXELocation
#Invoke-Item $ShturmanEXELink
#cd "D:\Shturman\Bin\"

WriteLog "Установщик Штурмана / Автозапуск Демонстрашек при запуске компа" "INFO"
WriteLog "Версия: $version" "INFO"



# проверка наличия административных привилегий. если их нет - отваливаемся
if(isAdmin)
{
	WriteLog "Админские права: есть." "MESS"
};

# Список всех существующих в мире сервисов
$ShturmanServicesAll = "ShturmanQuality","ShturmanMainUnit","ShturmanRRs","ShturmanDataSync","ShturmanUpdate","ShturmanAsnp",
	"ShturmanGPS","ShturmanWLan","ShturmanAccelerometer","ShturmanModem","ShturmanFOS","ShturmanBlueGiga",
	"ShturmanMetroLocations","ShturmanDataStorage","ShturmanHub","ShturmanLog","ShturmanBOINorms"

# TODO сделать чтоб сам искал все фалы *.Server.exe
$ShturmanExeFiles = "AccelerometerServer.exe","AsnpServer.exe","BlueGigaServer.exe","DataStorageServer.exe","DataSyncServer.exe",
		"FOSServer.exe","GPSServer.exe","HubServer.exe","LogServer.exe","MainUnitServer.exe","MetroLocationsServer.exe",
		"ModemServer.exe","QualityServer.exe","RRsServer.exe","UpdateServer.exe","WLanServer.exe","BOINormsServer.exe"


# Если в каталоге демки присуствует файл Services.ps1 - подсасываем из него персонализинованные параметры необходимых данной демке
if (test-path $ParamsPath)
{
	# инклюдим параметры (список сервисов, инстанс SQL и пр что обычно в блоке params
	WriteLog "Чтение настроек скрипта [$ParamsPath]" "INFO"
	."$ParamsPath"
}
Else
{
	# если персонального списка нет - считаем что нужны все сервисы
	WriteLog "Скрипт запущен с дефолтными настройками (файл настроек [$ParamsPath] не найден)" "INFO"
	$ShturmanServices = $ShturmanServicesAll
	$ShturmanServicesAutomaticDelayStart = ""
}



# $ShturmanExeFiles = "DataStorageServer.exe","HubServer.exe","LogServer.exe","MetroLocationsServer.exe","QualityServer.exe"


#   +===================+
#   |     Functions     |
#   +===================+

function ServiceStop
{
# Стоппинг сервиса
	param (
		[string]$ServiceName = "MSSQL`$SQLEXPRESS",
		[switch]$Verbose = $FALSE		# говорливость в лог
	)
#Check-Service -ServiceName $ServiceName
	# стопим сервис
	if(Check-Service -ServiceName $ServiceName)
	{
		net stop $ServiceName

#Start-Sleep -Seconds 10; 
#Get-Service $ServiceName -ErrorAction SilentlyContinue
#		if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
		if (Check-Service -ServiceName $ServiceName)
		{
			WriteLog "ServiceStop: Service [$ServiceName] can not stop" "ERRr" $Verbose
		}
		Else
		{
			WriteLog "ServiceStop: Service [$ServiceName] is stopped" "INFO" $Verbose
		}
	}
	Else
	{
		WriteLog "ServiceStop: Service [$ServiceName] already stopped" "INFO" $Verbose
	}

}
function ServiceStart
{
# Стоппинг сервиса
	param (
		[string]$ServiceName = "MSSQL`$SQLEXPRESS",
		[switch]$Verbose = $FALSE		# говорливость в лог
	)


	if(Check-Service -ServiceName $ServiceName)
	{
		WriteLog "ServiceStart: Service [$ServiceName] already started" "INFO" $Verbose
	}
	Else
	{
		net start $ServiceName

		if (Check-Service -ServiceName $ServiceName)
		{
			WriteLog "ServiceStart: Service [$ServiceName] is started" "INFO" $Verbose
		}
		Else
		{
			WriteLog "ServiceStart: Service [$ServiceName] can not start" "ERRr" $Verbose
		}
	}
}

function ServicesUninstall
{

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	# Удаление всех сервисов
	WriteLog "$FuncName Removing Services" "INFO"

	foreach($item in $ShturmanServicesAll)
	{

		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			# стопим сервис
			ServiceStop -ServiceName $item -Verbose
<#			if((Check-Service -ServiceName $item) -eq $FALSE)
			{
				WriteLog "$FuncName Service [$item] already stopped" "DUMP"
			}
			Else
			{
				net stop $item

				# BUG п омоему тут хрень, а не проверка.
				if (Get-Service $item -ErrorAction SilentlyContinue)
				{
					WriteLog "Service [$item] is stopped" "INFO"
				}
			}
#>
			# удаляем
			$UninstallResult = (Get-WmiObject Win32_Service -filter "name='$item'").Delete()
			if ($UninstallResult.ReturnValue -eq 0)
			{

				if (Get-Service $item -ErrorAction SilentlyContinue)
				{
					if((Check-Service -ServiceName $item) -eq $TRUE)
					{
						WriteLog "$FuncName Service [$item] doesn't removed (Service is RUN). Required rebot for complete operation." "WARN"
					}
					Else
					{
						# не факт что сюда зайдет когданить.
						WriteLog "$FuncName Service [$item] doesn't removed (Service is STOPED). Uncknown Error." "ERRr"
					}
				}
				else
				{
					WriteLog "$FuncName Service [$item] succesffully removed" "MESS"
				}
			}
			Else
			{
				if((Check-Service -ServiceName $item) -eq $TRUE)
				{
					WriteLog "$FuncName Service [$item] can not remove (Service is RUN),  Required rebot for complete operation." "WARN"
				}
				else
				{
# TODO хз почему так иногда происходит. может даже процесса не висеть. вроде ребут помогает.
					WriteLog "$FuncName Service [$item] can not remove (Service is STOPED). [I don't know what's happens]" "ERRr"
				}
			}
		}
		else
		{
			WriteLog "$FuncName Service [$item] doesn't exist" "INFO"
		}

	}
}

function ServicesInstall
{
	# Исталятор сервисов. инстоллит все что сможет найти.

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	WriteLog "$FuncName Services Installer" "INFO"

	# По списку экзешников возможных, если экзешник есть - регистрируем его.
	foreach ($item in $ShturmanExeFiles)
	{
		# проверяем вдруг сервис уже зареган.
		$itemServiceName = "Shturman" + ($item -replace "Server.exe", "")
#		$itemServiceName
		if (Get-Service $itemServiceName -ErrorAction SilentlyContinue)
		{
			WriteLog "$FuncName Service [$itemServiceName] aready registered." "WARN"
		}
		Else
		{
			if (test-path "$AppPath\BIN\$item")
			{

				#WriteLog "Registering service [$itemServiceName]." "INFO"

				# регистрируе сервис его же средставами
				start $AppPath\BIN\$item "/install /silent"

				$i = 0; # костыль чтоб дать время сервису прийти в себя после регистрации. т.к. прямо сразу - он еще не существует.
				while ($i -le 5)
				{
					# Проверка что сервис зарегался.
					if (Get-Service $itemServiceName -ErrorAction SilentlyContinue)
					{
						WriteLog "$FuncName Service [$itemServiceName] registered." "MESS"
						break; # выпадеем из цикла, если регистрация успешна
					}
					else
					{

						# в конце пятой попытки еще раз проверяем сервис, и если его таки нет - кидаем ошибку
						if ($i -eq 5 -and (-not (Get-Service $itemServiceName -ErrorAction SilentlyContinue)))
						{
							WriteLog "$FuncName Service [$itemServiceName] can not register" "ERRr"
						}

						# тупо спим 0.1с. обычно этого хватает. но на всякий случай спим 5 попыток
						Start-Sleep -Milliseconds 100; 
						$i++;
					}
				}

			}
			Else
			{
					WriteLog "$FuncName File [$AppPath\BIN\$item] not found." "WARN"
			}
		}
	}

	# особотупые компы могут не успеть зарегать сервис... посему для таких слоупоков зарежка
	Start-Sleep -Second $SleepBetwenSrvcInstalationAndSrvcConfiguration


	# Проставляем мануальный запуск для всех, кроме лога
	WriteLog "$FuncName Set ""Manual"" in Service's StartType" "INFO"

	foreach($item in $ShturmanServicesAll)
	{

		# Обращаемся к сервису
		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			if ($item -ne "ShturmanLog") { # кроме лог сервиса

				# ставим мануальный запуск
				Set-Service $item -StartupType Manual

				# проверяем что манул установлен
				$s = Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='$item'"
				if ($s.StartMode -eq "Manual")
				{
					WriteLog "$FuncName Service [$item] StartupMode: Manual" "MESS"
				}
				Else
				{
					WriteLog "$FuncName Service [$item] can not set StartupMode to Manual" "ERR"
				}
#				WriteLog "Servives Installer" "MESS"
			}
		}
	}
	# Проставляем AutomaticDelay запуск для Сервисов из списка
	WriteLog "$FuncName Set ""AutomaticDelay"" in Service's StartType" "INFO"

	foreach($item in $ShturmanServicesAutomaticDelayStart)
	{
	
		# Обращаемся к сервису
		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			if ($item -ne "ShturmanLog") { # кроме лог сервиса

				# Проставляем AutomaticDelay запуск для Сервиса
				WriteLog "$FuncName Try to set Automatic(Delay) for service [$item]" "DUMP"
				$r = SC.EXE config $item start= delayed-auto 
				WriteLog "$FuncName $r" "DUMP"


#				$s = Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='$item'"
#				WriteLog $s.StartMode "MESS"

				# ставим мануальный запуск
#				Set-Service $item -StartupType Manual

				# проверяем что манул установлен
				$s = Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='$item'"
				if ($s.StartMode -eq "Auto")
				{
					WriteLog "$FuncName Service [$item] StartupMode: Automatic(Delay)" "MESS"
				}
				Else
				{
					WriteLog "$FuncName Service [$item] can not set StartupMode to Automatic(Delay)" "ERR"
				}

#				WriteLog "Servives Installer" "MESS"
			}
		}
	}

}

# ========================================================================================================================

if ($ServicesUninstall)
{
	ServicesUninstall;
	break;	
}


if ($ServicesInstall) 
{
	ServicesInstall;
	break;	
}

if ($ShturmanInstall)
{
	# Сносим сервисы
	ServicesUninstall;

    WriteLog "Убиваем OnBoard.exe" "MESS"
    taskkill.exe /f /im OnBoard.exe

# $InstallPath


	# бэкап ini
	# TODO  Проверка что путь куда копировать существует.
	$sh_ini_Path = "$AppPath\Bin\Shturman.ini"
	if (test-path $sh_ini_Path )
	{
		Copy-Item -Path $sh_ini_Path -Destination $InstallPath\Shturman_old.ini
#		Copy-Item -Path $sh_ini_Path -Destination $AppPath\Bin\Shturman_old.ini
		# TODO Проверка что скопировалось
	}

    # СНОС
	# сносим базу
    WriteLog "Remove old Database [$SQLDBName]" "MESS"
    SQLDropDatabase -SQLServerInstance "$SQLServerInstance" -SQLUsername "$SQLUsername" -SQLPassword "$SQLPassword" -SQLDBName $SQLDBName  # -Verbose

	# Сносим штурмана
	# TODO Сносить таки без Shturman.ini. сейчас с ним сносит
	Remove-Item -Path $AppPath -Recurse -exclude *Shturman.ini -ErrorAction SilentlyContinue
	WriteLog "exec: Remove-Item -Path $AppPath -Recurse -Exclude Shturman*.ini -ErrorAction SilentlyContinue" "DUMP"
#	WriteLog "$dump" "DUMP"


	# Проверка все ли файлы удалились. справишаем юзера продолжать ли если удалилось не все.
	[bool]$CantRemoveFiles = $FALSE; 

	if (test-path $sh_ini_Path )
	{
    	$arr = Get-ChildItem -Path $AppPath -Force -Recurse -exclude Shturman*.ini -Name; # рекурсивно список всех файлов в каталоге и подкаталогах
    	Foreach ($File in $arr) 
    	{
		    WriteLog "File [$File] didn't remove" "ERRr"
		    $CantRemoveFiles = $TRUE;
	    }
	    if ($CantRemoveFiles)
	    {
    		WriteLog "Ask User: Some files didn't remove. Continue? [Y/N]" "DUMP"
    
		    $a = Read-Host -Prompt "Some files didn't remove. Continue? [Y/N]";
		    WriteLog "Answer is: [$a]" "DUMP"
    
		    if ( $a -ne "Y") 
		    { 
    			WriteLog "All answers except [y/Y] -> Exit" "DUMP"
			    WriteLog "Script Aborted by User" "MESS"
			    break; 
		    };
	    };
    };



<#  решено по другому
	# TODO ---- 
	# Restart SQL сервера. дабы прибить все коннекции к базе (так проще)
	# стопим сервис
# TODO Раскоментить обе строки
#	ServiceStop -ServiceName $SQLServiceName -Verbose
#	ServiceStart -ServiceName $SQLServiceName -Verbose
#>


	# Разворачиваем базу
	WriteLog "Создание пользователя SQL сервера l:[ShturmanBlock], p:[P@ssw0rd] и установки роли [sysadmin]" "MESS"
    SQLCreateUser -SQLServerInstance "$SQLServerInstance" -SQLUsername "$SQLUsername" -SQLPassword "$SQLPassword" -NewUser "ShturmanBlock" -NewPassword "P@ssw0rd" -Role "sysadmin" #-Verbose


    WriteLog "Restore Database [$SQLDBName] from BackUp [$SQLDBBackUpPatch]" "MESS"
    SQLRestoreDB -SQLServerInstance "$SQLServerInstance" -SQLUsername "$SQLUsername" -SQLPassword "$SQLPassword" -SQLDBName $SQLDBName -SQLDBBackUpPatch $SQLDBBackUpPatch -AppPath $AppPath # -Verbose

	# Разворачиваем штурмана
	# TODO 

	WriteLog "Copy ShturmanFiles to [$AppPath]" "DUMP"
	Copy-Item -Path $InstallPath\Shturman\* -Destination $AppPath -Recurse -Force
	WriteLog "Copying ShturmanFiles to [$AppPath] finished" "DUMP"
	# TODO: Check copied files
	#WriteLog "Check copied files [$InstallPath] - [$AppPath]" "DUMP"
	#$arrSrc = Get-ChildItem -Path "$InstallPath\Shturman\" -Force -Recurse; # рекурсивно список всех файлов в каталоге и подкаталогах
	#$arrTarget = Get-ChildItem -Path "$AppPath" -Force -Recurse; # рекурсивно список всех файлов в каталоге и подкаталогах
	#write-host
#Foreach ($File in $arr) 
#{
	

	# Регистрируем сервисы
	ServicesInstall;

	

	# создание Юзера Admin
    if ((CreateUser -UserName $User -UserPassword $Password -UserFullName $UserFullName -UserDescription $UserDescription -Verbose) -eq $TRUE)
    {
        $res = addUser2Group -User $User -Group $Group # -Verbose
    	if ($res)
        {
            WriteLog "User [$User] added to group [$Group]" "MESS"
        }
    }    

	# Установка Шеллов для юзеров
	# TODO 

    # Set Shell for All Users and System
    WriteLog "Set Shell (Explorer.exe) for Local Machine" "MESS"
    # TODO вставить проверку что на что подменилось
    $RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty -path $RegKey -name Shell -value "Explorer.exe"


    # Set personal Shell for user Block
    WriteLog "Set Shell (OnBoard.exe) for user [Block]" "INFO"
    # TODO вставить проверку что на что подменилось
    
    # Get User SID
    [string]$UserSID = get-LocalUserSid -UserName "Block" #-Verbose
    WriteLog "User [Block] SID is [$UserSID]" "INFO"

    # create a new PSDrive to the HKEY_USERS hive.  Just because only HKLM: and HKCU: exist by default
    $res = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
#    WriteLog "create a new PSDrive to the HKEY_USERS hive result: [$res]" "INFO"

    
    $RegKey = "HKU:\$UserSID\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
    if (Test-Path -Path $RegKey)
    {
    #    write-host($regkey)
        Set-ItemProperty -path $RegKey -name "Shell" -value "C:\Shturman\BIN\OnBoard.exe"
        # WriteLog "Set Shell (OnBoard.exe) result: [$res]" "INFO"
        
    }
    else
    {
        #WriteLog "User [Block] newer logon. Creating registry key [$RegKey] " "ERRr"
        #New-Item -Path $RegKey -ItemType Key                 # не создает так
            #if (Test-Path -Path $RegKey)
            #{
            #Set-ItemProperty -path $RegKey -name "Shell" -value "C:\Shturman\BIN\OnBoard.exe"  
            #}
            #else
            #{
                WriteLog "Can not set Shell for User [Block] because his newer logon on this Computer and Script can not create regestry key" "ERRr"
            #}
    }



	# Редактирование ini
	# TODO 

	# Сносим инсталятор если все ок
	# TODO 

	# ребут
	# TODO 


	break;
}

WriteLog "Ждем $SleepBeforeSQLService сек, пока система придет в себя после загрузки" "INFO"
Start-Sleep -Seconds $SleepBeforeScriptRuning; 


# Выполнение инициализационного SQL скрипта, если указан в пропертях.
# необходим в некоторых демках для приведения базы в некое исходноe состояние (заливка фейковой истории)
if ($SQLScriptFile -ne "")
{

	Start-Sleep -Seconds $SleepBeforeSQLService; 

	# Ждем запуска MS SQL
	while ((Check-Service -ServiceName $SQLServiceName -verbose) -ne $TRUE)
	{
		Start-Sleep -Seconds 5; 
	}


	WriteLog "Ждем $SleepAfterSQLService сек, после запуска SQL Сервера. т.к. не всегда сразу к нему можно приконнектиться" "INFO"
	# тупим еще минуту после старта... на всякий случай


	Start-Sleep -Seconds $SleepAfterSQLService; 

	WriteLog "Выполнение инициализационного скрипта" "INFO"

	# Выполняем инициализационный скрипт
#	WriteLog "Invoke-Sqlcmd -InputFile $SQLScriptFile -Database $SQLDBName -ServerInstance $SQLServerInstance -Username $SQLUsername -Password $SQLPassword -Verbose | Format-Table"
	Invoke-Sqlcmd -InputFile $SQLScriptFile -Database $SQLDBName -ServerInstance $SQLServerInstance -Username $SQLUsername -Password $SQLPassword -Verbose | Format-Table

	# опять тупим
	Start-Sleep -Seconds $SleepAfterSQLScript; 
}

WriteLog "Запуск сервисов" "INFO"

# реверс массива т.к. в нем сервису указаны в порядке обратном правильному запуску. так уж повелось.
[array]::Reverse($ShturmanServices)

foreach($item in $ShturmanServices)
{
	if (Get-Service $item -ErrorAction SilentlyContinue)
	{
		if (Check-Service -ServiceName $item)
		{
			WriteLog "Service [$item] already started" "MESS"
		}
		Else 
		{
			WriteLog "Starting Service: [$item]" "MESS"

			# TODO Переписать Запуск по человечески
			net start $item

			if((Check-Service -ServiceName $item) -eq $FALSE)
			{
				WriteLog "Service: [$item] could not start" "ERRr"
			}
		}
	}
	Else
	{
		WriteLog "Service: [$item] is not available. Skipped." "INFO"
	}
	#Start-Service "ShturmanLog"

#	if (Start-Service $item)
#	{
#		WriteLog "succсов" "INFO"
#	}
#	Else
#	{
#		WriteLog "fuckвисов" "err"	
#	}
}


#Write-Host 
#Start-Sleep -Seconds 100; 
WriteLog "Запуск приложения" "MESS"

#cd $AppPath
#Start "$AppPath\Shturman.lnk"
Start "$AppPath\BIN\Shturman.lnk"

WriteLog "Done. This window will be automaticaly closed after 120s" "INFO"
Start-Sleep -Seconds 120; 

# break

#$ShturmanEXELocation