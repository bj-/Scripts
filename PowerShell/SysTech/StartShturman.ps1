#
#
# Запуск сервисов и штурмана в один клик
#
# поверяет наличие сервиса SQL сервера, 
#
#
# TODO 
#  TODO чистить очереди перед стартом
#
#
#
#
param (
	[string]$SQLServiceName = "MSSQL`$SQLEXPRESS",
	[string]$SQLDBName = "ShturmanMOSStep8",
	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
	[string]$SQLUsername = "sa",
	[string]$SQLPassword = "as",
#	[string]$SQLScriptFile = "test.sql",
	[string]$SQLScriptFile = "D:\ShturmanMOSStep8_u16\InitMOSDemo.sql",
	[string]$AppPath = "D:\Shturman\BIN\",
	[switch]$ServicesUninstall = $FALSE,
	[switch]$ServicesInstall = $FALSE,
	[switch]$Fast = $FALSE		# Сокращает пероды сна между командами до 1 сек.
)

# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"

clear;

#[Console]::OutputEncoding = [System.Text.Encoding]::1251
#$OutputEncoding = [Console]::OutputEncoding
#write-host "ffff" + $OutputEncoding


if ($Fast -eq $TRUE) # Для отладки, чтоб не ждать
{
	[Int]$SleepBeforeSQLService = 1      #Recomended: 600
	[Int]$SleepAfterSQLService = 1      #Recomended: 300
	[Int]$SleepAfterSQLScript = 1      #Recomended: 20-30
}
Else
{
	[Int]$SleepBeforeSQLService = 10      #Recomended: 600
	[Int]$SleepAfterSQLService = 30      #Recomended: 300
	[Int]$SleepAfterSQLScript = 5      #Recomended: 20-30
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

# проверка наличия административных привилегий. если их нет - отваливаемся
if(isAdmin)
{
	WriteLog "Админские права: есть." "MESS"
};

# Дествия с сервисами. регистрация / разрегистрация
$ShturmanServices = "ShturmanQuality","ShturmanRRs","ShturmanDataSync","ShturmanUpdate","ShturmanAsnp","ShturmanGPS",
	"ShturmanWLan","ShturmanAccelerometer","ShturmanModem","ShturmanFOS","ShturmanBlueGiga","ShturmanMetroLocations",
	"ShturmanDataStorage","ShturmanHub","ShturmanLog"

#$ShturmanServices = "ShturmanQuality","ShturmanMetroLocations","ShturmanDataStorage","ShturmanHub","ShturmanLog"


# TODO сделать чтоб сам искал все фалы *.Server.exe
$ShturmanExeFiles = "AccelerometerServer.exe","AsnpServer.exe","BlueGigaServer.exe","DataStorageServer.exe","DataSyncServer.exe",
		"FOSServer.exe","GPSServer.exe","HubServer.exe","LogServer.exe","MainUnitServer.exe","MetroLocationsServer.exe",
		"ModemServer.exe","QualityServer.exe","RRsServer.exe","UpdateServer.exe","WLanServer.exe"

#$ShturmanExeFiles = "DataStorageServer.exe","HubServer.exe","LogServer.exe","MetroLocationsServer.exe","QualityServer.exe"


# Удаление всех сервисов
if ($ServicesUninstall)
{
	foreach($item in $ShturmanServices)
	{

		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			$UninstallResult = (Get-WmiObject Win32_Service -filter "name='$item'").Delete()
			if ($UninstallResult.ReturnValue -eq 0)
			{
				WriteLog "Service [$item] succesffully removed" "MESS"
			}
			Else
			{
				WriteLog "Service [$item] can not remove" "ERR"
			}
		}
		else
		{
			WriteLog "Service [$item] doesn't exist" "INFO"
		}

#		if ((Check-Service -ServiceName $item -verbose) -ne $TRUE)
#		{
#			$UninstallResult = (Get-WmiObject Win32_Service -filter "name='$item'").Delete()
#		}
	}

	break;	
}

if ($ServicesInstall) 
{

	WriteLog "Services Installer" "MESS"
	# TODO Переписать по нормлальному

WriteLog "cd $AppPath"
#cd $AppPath

#	foreach($item in $ShturmanExeFiles)
#	{

#invoke-Item (".\$item /install")

#		$AppPath
#	}

cd $AppPath
.\AccelerometerServer.exe /install
.\AsnpServer.exe /install
.\BlueGigaServer.exe /install
.\DataStorageServer.exe /install
.\DataSyncServer.exe /install
.\FOSServer.exe /install
.\GPSServer.exe /install
.\HubServer.exe /install
.\LogServer.exe /install
.\MainUnitServer.exe /install
.\MetroLocationsServer.exe /install
.\ModemServer.exe /install
.\QualityServer.exe /install
.\RRsServer.exe /install
.\UpdateServer.exe /install
.\WLanServer.exe /install


	Start-Sleep -Second 15

	# Проставляем мануальный запуск для всех
	foreach($item in $ShturmanServices)
	{

		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			if ($item -ne "ShturmanLog") {

				Set-Service $item -StartupType Manual

				$s = Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='$item'"
				if ($s.StartMode -eq "Manual")
				{
					WriteLog "Service [$item] StartupMode: Manual" "MESS"
				}
				Else
				{
					WriteLog "Service [$item] can not set StartupMode to Manual" "ERR"
				}
#				WriteLog "Servives Installer" "MESS"
			}
		}
	}
#	Get-Service -Name SharedAccess, cx2Svc -EA 0 | 
#	foreach($item in $ShturmanExeFiles)
#	{
#		$s = "$AppPath$item /install"
#		Invoke-Item $s
#		"$AppPath$item /install"
#	}
	break;	
}


WriteLog "Ждем $SleepBeforeSQLService сек, пока система придет в себя после загрузки" "INFO"
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
WriteLog "Invoke-Sqlcmd -InputFile $SQLScriptFile -Database $SQLDBName -ServerInstance $SQLServerInstance -Username $SQLUsername -Password $SQLPassword -Verbose | Format-Table"
Invoke-Sqlcmd -InputFile $SQLScriptFile -Database $SQLDBName -ServerInstance $SQLServerInstance -Username $SQLUsername -Password $SQLPassword -Verbose | Format-Table

# опять тупим
Start-Sleep -Seconds $SleepAfterSQLScript; 


WriteLog "Запуск сервисов" "INFO"
#net start ShturmanLog
#net start ShturmanHub
#net start ShturmanDataStorage
#net start ShturmanMetroLocations
#net start ShturmanQuality



#$ShturmanServicesReverse = [array]::Reverse($ShturmanServices)
#$ShturmanServicesReverse
#$ShturmanServices
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

cd $AppPath
.\Shturman.lnk

break

#$ShturmanEXELocation