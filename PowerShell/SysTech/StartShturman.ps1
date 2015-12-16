#
#
# ������ �������� � �������� � ���� ����
#
# �������� ������� ������� SQL �������, 
#
#
# TODO 
#  TODO ������� ������� � ���� ����� �������
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
	[string]$SQLScriptFile = "",
	[string]$AppPath = "D:\Shturman\",
	[switch]$ServicesUninstall = $FALSE,
	[switch]$ServicesInstall = $FALSE,
	[switch]$Fast = $FALSE,		# ��������� ������ ��� ����� ��������� �� 1 ���.
	[switch]$Debug = $FALSE		# � ������� ��� ������� ���� �����
	
)

# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"

clear;

#[Console]::OutputEncoding = [System.Text.Encoding]::1251
#$OutputEncoding = [Console]::OutputEncoding
#write-host "ffff" + $OutputEncoding


if ($Fast -eq $TRUE) # ��� �������, ���� �� �����
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
	[Int]$SleepBetwenSrvcInstalationAndSrvcConfiguration = 1   # ��� ����� ����� ������ ����� ������������� ����������
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

# �������� ������� ���������������� ����������. ���� �� ��� - ������������
if(isAdmin)
{
	WriteLog "��������� �����: ����." "MESS"
};

# ������ ���� ������������ � ���� ��������
$ShturmanServicesAll = "ShturmanQuality","ShturmanMainUnit","ShturmanRRs","ShturmanDataSync","ShturmanUpdate","ShturmanAsnp",
	"ShturmanGPS","ShturmanWLan","ShturmanAccelerometer","ShturmanModem","ShturmanFOS","ShturmanBlueGiga",
	"ShturmanMetroLocations","ShturmanDataStorage","ShturmanHub","ShturmanLog"

# ���� � �������� ����� ����������� ���� Services.ps1 - ����������� �� ���� ������������������� ��������� ����������� ������ �����
if (test-path "$AppPath\..\Params.ps1")
{
	# �������� ��������� (������ ��������, ������� SQL � �� ��� ������ � ����� params
	WriteLog "������ �������� ������� $AppPath\Params.ps1" "INFO"
	."$AppPath\Params.ps1"
}
Else
{
	# ���� ������������� ������ ��� - ������� ��� ����� ��� �������
	WriteLog "������ ������� � ���������� �����������" "INFO"
	$ShturmanServices = $ShturmanServicesAll
}


# TODO ������� ���� ��� ����� ��� ���� *.Server.exe
$ShturmanExeFiles = "AccelerometerServer.exe","AsnpServer.exe","BlueGigaServer.exe","DataStorageServer.exe","DataSyncServer.exe",
		"FOSServer.exe","GPSServer.exe","HubServer.exe","LogServer.exe","MainUnitServer.exe","MetroLocationsServer.exe",
		"ModemServer.exe","QualityServer.exe","RRsServer.exe","UpdateServer.exe","WLanServer.exe"

#$ShturmanExeFiles = "DataStorageServer.exe","HubServer.exe","LogServer.exe","MetroLocationsServer.exe","QualityServer.exe"


#   +===================+
#   |     Functions     |
#   +===================+
function ServicesUninstall
{
	# �������� ���� ��������
	WriteLog "Removing Services" "INFO"

	foreach($item in $ShturmanServicesAll)
	{

		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			# ������ ������
			if((Check-Service -ServiceName $item) -eq $FALSE)
			{
				WriteLog "Service [$item] already stopped" "DUMP"
			}
			Else
			{
				net stop $item

				# BUG � ������ ��� �����, � �� ��������.
				if (Get-Service $item -ErrorAction SilentlyContinue)
				{
					WriteLog "Service [$item] is stopped" "INFO"
				}
			}

			# �������
			$UninstallResult = (Get-WmiObject Win32_Service -filter "name='$item'").Delete()
			if ($UninstallResult.ReturnValue -eq 0)
			{

				if (Get-Service $item -ErrorAction SilentlyContinue)
				{
					if((Check-Service -ServiceName $item) -eq $TRUE)
					{
						WriteLog "Service [$item] doesn't removed (Service is RUN). Required rebot for complete operation." "WARN"
					}
					Else
					{
						# �� ���� ��� ���� ������ ���������.
						WriteLog "Service [$item] doesn't removed (Service is STOPED). Uncknown Error." "ERRr"
					}
				}
				else
				{
					WriteLog "Service [$item] succesffully removed" "MESS"
				}
			}
			Else
			{
				if((Check-Service -ServiceName $item) -eq $TRUE)
				{
					WriteLog "Service [$item] can not remove (Service is RUN),  Required rebot for complete operation." "WARN"
				}
				else
				{
# TODO �� ������ ��� ������ ����������. ����� ���� �������� �� ������. ����� ����� ��������.
					WriteLog "Service [$item] can not remove (Service is STOPED). [I don't know what's happens]" "ERRr"
				}
			}
		}
		else
		{
			WriteLog "Service [$item] doesn't exist" "INFO"
		}

	}
}

function ServicesInstall
{
	# ��������� ��������. ��������� ��� ��� ������ �����.

	WriteLog "Services Installer" "INFO"

	# �� ������ ���������� ���������, ���� �������� ���� - ������������ ���.
	foreach ($item in $ShturmanExeFiles)
	{
		# ��������� ����� ������ ��� �������.
		$itemServiceName = "Shturman" + ($item -replace "Server.exe", "")
#		$itemServiceName
		if (Get-Service $itemServiceName -ErrorAction SilentlyContinue)
		{
			WriteLog "Service [$itemServiceName] aready registered." "WARN"
		}
		Else
		{
			if (test-path "$AppPath\BIN\$item")
			{

				#WriteLog "Registering service [$itemServiceName]." "INFO"

				# ����������� ������ ��� �� �����������
				start $AppPath\BIN\$item "/install /silent"

				$i = 0; # ������� ���� ���� ����� ������� ������ � ���� ����� �����������. �.�. ����� ����� - �� ��� �� ����������.
				while ($i -le 5)
				{
					# �������� ��� ������ ���������.
					if (Get-Service $itemServiceName -ErrorAction SilentlyContinue)
					{
						WriteLog "Service [$itemServiceName] registered." "MESS"
						break; # �������� �� �����, ���� ����������� �������
					}
					else
					{

						# � ����� ����� ������� ��� ��� ��������� ������, � ���� ��� ���� ��� - ������ ������
						if ($i -eq 5 -and (-not (Get-Service $itemServiceName -ErrorAction SilentlyContinue)))
						{
							WriteLog "Service [$itemServiceName] can not register" "ERRr"
						}

						# ���� ���� 0.1�. ������ ����� �������. �� �� ������ ������ ���� 5 �������
						Start-Sleep -Milliseconds 100; 
						$i++;
					}
				}

			}
			Else
			{
					WriteLog "File [$AppPath\BIN\$item] not found." "WARN"
			}
		}
	}

	# ���������� ����� ����� �� ������ �������� ������... ������ ��� ����� ��������� �������
	Start-Sleep -Second $SleepBetwenSrvcInstalationAndSrvcConfiguration


	# ����������� ���������� ������ ��� ����, ����� ����
	WriteLog "Set ""Manual"" in Service's StartType" "INFO"

	foreach($item in $ShturmanServicesAll)
	{

		# ���������� � �������
		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			if ($item -ne "ShturmanLog") { # ����� ��� �������

				# ������ ���������� ������
				Set-Service $item -StartupType Manual

				# ��������� ��� ����� ����������
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


WriteLog "���� $SleepBeforeSQLService ���, ���� ������� ������ � ���� ����� ��������" "INFO"
Start-Sleep -Seconds $SleepBeforeScriptRuning; 


# ���������� ������������������ SQL �������, ���� ������ � ���������.
# ��������� � ��������� ������ ��� ���������� ���� � ����� �������e ��������� (������� �������� �������)
if ($SQLScriptFile -ne "")
{

	Start-Sleep -Seconds $SleepBeforeSQLService; 

	# ���� ������� MS SQL
	while ((Check-Service -ServiceName $SQLServiceName -verbose) -ne $TRUE)
	{
		Start-Sleep -Seconds 5; 
	}


	WriteLog "���� $SleepAfterSQLService ���, ����� ������� SQL �������. �.�. �� ������ ����� � ���� ����� ���������������" "INFO"
	# ����� ��� ������ ����� ������... �� ������ ������


	Start-Sleep -Seconds $SleepAfterSQLService; 

	WriteLog "���������� ������������������ �������" "INFO"

	# ��������� ����������������� ������
	WriteLog "Invoke-Sqlcmd -InputFile $SQLScriptFile -Database $SQLDBName -ServerInstance $SQLServerInstance -Username $SQLUsername -Password $SQLPassword -Verbose | Format-Table"
	Invoke-Sqlcmd -InputFile $SQLScriptFile -Database $SQLDBName -ServerInstance $SQLServerInstance -Username $SQLUsername -Password $SQLPassword -Verbose | Format-Table

	# ����� �����
	Start-Sleep -Seconds $SleepAfterSQLScript; 
}

WriteLog "������ ��������" "INFO"

# ������ ������� �.�. � ��� ������� ������� � ������� �������� ����������� �������. ��� �� ��������.
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

			# TODO ���������� ������ �� �����������
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
#		WriteLog "succ���" "INFO"
#	}
#	Else
#	{
#		WriteLog "fuck�����" "err"	
#	}
}


#Write-Host 
#Start-Sleep -Seconds 100; 
WriteLog "������ ����������" "MESS"

#cd $AppPath
#Start "$AppPath\Shturman.lnk"
Start "$AppPath\BIN\Shturman.lnk"

WriteLog "Done. Windows will be automaticaly closed after 120s" "INFO"
Start-Sleep -Seconds 120; 

# break

#$ShturmanEXELocation