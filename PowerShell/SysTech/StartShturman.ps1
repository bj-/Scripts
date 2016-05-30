<#
#
# ������ �������� � �������� � ���� ����
#
# �������� ������� ������� SQL �������, 
#
#
# TODO 
#  TODO ������� ������� � ���� ����� �������
#
 �����
 -ServicesUninstall - �������������� ���� ��������

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
	[switch]$Fast = $FALSE,		# ��������� ������� ��� ����� ��������� �� 1 ���.
	[switch]$Debug = $FALSE		# � ������� ��� ������� ���� �����
	
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

WriteLog "���������� �������� / ���������� ������������ ��� ������� �����" "INFO"
WriteLog "������: $version" "INFO"



# �������� ������� ���������������� ����������. ���� �� ��� - ������������
if(isAdmin)
{
	WriteLog "��������� �����: ����." "MESS"
};

# ������ ���� ������������ � ���� ��������
$ShturmanServicesAll = "ShturmanQuality","ShturmanMainUnit","ShturmanRRs","ShturmanDataSync","ShturmanUpdate","ShturmanAsnp",
	"ShturmanGPS","ShturmanWLan","ShturmanAccelerometer","ShturmanModem","ShturmanFOS","ShturmanBlueGiga",
	"ShturmanMetroLocations","ShturmanDataStorage","ShturmanHub","ShturmanLog","ShturmanBOINorms"

# TODO ������� ���� ��� ����� ��� ���� *.Server.exe
$ShturmanExeFiles = "AccelerometerServer.exe","AsnpServer.exe","BlueGigaServer.exe","DataStorageServer.exe","DataSyncServer.exe",
		"FOSServer.exe","GPSServer.exe","HubServer.exe","LogServer.exe","MainUnitServer.exe","MetroLocationsServer.exe",
		"ModemServer.exe","QualityServer.exe","RRsServer.exe","UpdateServer.exe","WLanServer.exe","BOINormsServer.exe"


# ���� � �������� ����� ����������� ���� Services.ps1 - ����������� �� ���� ������������������� ��������� ����������� ������ �����
if (test-path $ParamsPath)
{
	# �������� ��������� (������ ��������, ������� SQL � �� ��� ������ � ����� params
	WriteLog "������ �������� ������� [$ParamsPath]" "INFO"
	."$ParamsPath"
}
Else
{
	# ���� ������������� ������ ��� - ������� ��� ����� ��� �������
	WriteLog "������ ������� � ���������� ����������� (���� �������� [$ParamsPath] �� ������)" "INFO"
	$ShturmanServices = $ShturmanServicesAll
	$ShturmanServicesAutomaticDelayStart = ""
}



# $ShturmanExeFiles = "DataStorageServer.exe","HubServer.exe","LogServer.exe","MetroLocationsServer.exe","QualityServer.exe"


#   +===================+
#   |     Functions     |
#   +===================+

function ServiceStop
{
# �������� �������
	param (
		[string]$ServiceName = "MSSQL`$SQLEXPRESS",
		[switch]$Verbose = $FALSE		# ������������ � ���
	)
#Check-Service -ServiceName $ServiceName
	# ������ ������
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
# �������� �������
	param (
		[string]$ServiceName = "MSSQL`$SQLEXPRESS",
		[switch]$Verbose = $FALSE		# ������������ � ���
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

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	# �������� ���� ��������
	WriteLog "$FuncName Removing Services" "INFO"

	foreach($item in $ShturmanServicesAll)
	{

		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			# ������ ������
			ServiceStop -ServiceName $item -Verbose
<#			if((Check-Service -ServiceName $item) -eq $FALSE)
			{
				WriteLog "$FuncName Service [$item] already stopped" "DUMP"
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
#>
			# �������
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
						# �� ���� ��� ���� ������ ���������.
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
# TODO �� ������ ��� ������ ����������. ����� ���� �������� �� ������. ����� ����� ��������.
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
	# ��������� ��������. ��������� ��� ��� ������ �����.

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	WriteLog "$FuncName Services Installer" "INFO"

	# �� ������ ���������� ���������, ���� �������� ���� - ������������ ���.
	foreach ($item in $ShturmanExeFiles)
	{
		# ��������� ����� ������ ��� �������.
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

				# ����������� ������ ��� �� �����������
				start $AppPath\BIN\$item "/install /silent"

				$i = 0; # ������� ���� ���� ����� ������� ������ � ���� ����� �����������. �.�. ����� ����� - �� ��� �� ����������.
				while ($i -le 5)
				{
					# �������� ��� ������ ���������.
					if (Get-Service $itemServiceName -ErrorAction SilentlyContinue)
					{
						WriteLog "$FuncName Service [$itemServiceName] registered." "MESS"
						break; # �������� �� �����, ���� ����������� �������
					}
					else
					{

						# � ����� ����� ������� ��� ��� ��������� ������, � ���� ��� ���� ��� - ������ ������
						if ($i -eq 5 -and (-not (Get-Service $itemServiceName -ErrorAction SilentlyContinue)))
						{
							WriteLog "$FuncName Service [$itemServiceName] can not register" "ERRr"
						}

						# ���� ���� 0.1�. ������ ����� �������. �� �� ������ ������ ���� 5 �������
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

	# ���������� ����� ����� �� ������ �������� ������... ������ ��� ����� ��������� �������
	Start-Sleep -Second $SleepBetwenSrvcInstalationAndSrvcConfiguration


	# ����������� ���������� ������ ��� ����, ����� ����
	WriteLog "$FuncName Set ""Manual"" in Service's StartType" "INFO"

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
	# ����������� AutomaticDelay ������ ��� �������� �� ������
	WriteLog "$FuncName Set ""AutomaticDelay"" in Service's StartType" "INFO"

	foreach($item in $ShturmanServicesAutomaticDelayStart)
	{
	
		# ���������� � �������
		if (Get-Service $item -ErrorAction SilentlyContinue)
		{
			if ($item -ne "ShturmanLog") { # ����� ��� �������

				# ����������� AutomaticDelay ������ ��� �������
				WriteLog "$FuncName Try to set Automatic(Delay) for service [$item]" "DUMP"
				$r = SC.EXE config $item start= delayed-auto 
				WriteLog "$FuncName $r" "DUMP"


#				$s = Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name='$item'"
#				WriteLog $s.StartMode "MESS"

				# ������ ���������� ������
#				Set-Service $item -StartupType Manual

				# ��������� ��� ����� ����������
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
	# ������ �������
	ServicesUninstall;

    WriteLog "������� OnBoard.exe" "MESS"
    taskkill.exe /f /im OnBoard.exe

# $InstallPath


	# ����� ini
	# TODO  �������� ��� ���� ���� ���������� ����������.
	$sh_ini_Path = "$AppPath\Bin\Shturman.ini"
	if (test-path $sh_ini_Path )
	{
		Copy-Item -Path $sh_ini_Path -Destination $InstallPath\Shturman_old.ini
#		Copy-Item -Path $sh_ini_Path -Destination $AppPath\Bin\Shturman_old.ini
		# TODO �������� ��� �������������
	}

    # ����
	# ������ ����
    WriteLog "Remove old Database [$SQLDBName]" "MESS"
    SQLDropDatabase -SQLServerInstance "$SQLServerInstance" -SQLUsername "$SQLUsername" -SQLPassword "$SQLPassword" -SQLDBName $SQLDBName  # -Verbose

	# ������ ��������
	# TODO ������� ���� ��� Shturman.ini. ������ � ��� ������
	Remove-Item -Path $AppPath -Recurse -exclude *Shturman.ini -ErrorAction SilentlyContinue
	WriteLog "exec: Remove-Item -Path $AppPath -Recurse -Exclude Shturman*.ini -ErrorAction SilentlyContinue" "DUMP"
#	WriteLog "$dump" "DUMP"


	# �������� ��� �� ����� ���������. ���������� ����� ���������� �� ���� ��������� �� ���.
	[bool]$CantRemoveFiles = $FALSE; 

	if (test-path $sh_ini_Path )
	{
    	$arr = Get-ChildItem -Path $AppPath -Force -Recurse -exclude Shturman*.ini -Name; # ���������� ������ ���� ������ � �������� � ������������
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



<#  ������ �� �������
	# TODO ---- 
	# Restart SQL �������. ���� ������� ��� ��������� � ���� (��� �����)
	# ������ ������
# TODO ������������ ��� ������
#	ServiceStop -ServiceName $SQLServiceName -Verbose
#	ServiceStart -ServiceName $SQLServiceName -Verbose
#>


	# ������������� ����
	WriteLog "�������� ������������ SQL ������� l:[ShturmanBlock], p:[P@ssw0rd] � ��������� ���� [sysadmin]" "MESS"
    SQLCreateUser -SQLServerInstance "$SQLServerInstance" -SQLUsername "$SQLUsername" -SQLPassword "$SQLPassword" -NewUser "ShturmanBlock" -NewPassword "P@ssw0rd" -Role "sysadmin" #-Verbose


    WriteLog "Restore Database [$SQLDBName] from BackUp [$SQLDBBackUpPatch]" "MESS"
    SQLRestoreDB -SQLServerInstance "$SQLServerInstance" -SQLUsername "$SQLUsername" -SQLPassword "$SQLPassword" -SQLDBName $SQLDBName -SQLDBBackUpPatch $SQLDBBackUpPatch -AppPath $AppPath # -Verbose

	# ������������� ��������
	# TODO 

	WriteLog "Copy ShturmanFiles to [$AppPath]" "DUMP"
	Copy-Item -Path $InstallPath\Shturman\* -Destination $AppPath -Recurse -Force
	WriteLog "Copying ShturmanFiles to [$AppPath] finished" "DUMP"
	# TODO: Check copied files
	#WriteLog "Check copied files [$InstallPath] - [$AppPath]" "DUMP"
	#$arrSrc = Get-ChildItem -Path "$InstallPath\Shturman\" -Force -Recurse; # ���������� ������ ���� ������ � �������� � ������������
	#$arrTarget = Get-ChildItem -Path "$AppPath" -Force -Recurse; # ���������� ������ ���� ������ � �������� � ������������
	#write-host
#Foreach ($File in $arr) 
#{
	

	# ������������ �������
	ServicesInstall;

	

	# �������� ����� Admin
    if ((CreateUser -UserName $User -UserPassword $Password -UserFullName $UserFullName -UserDescription $UserDescription -Verbose) -eq $TRUE)
    {
        $res = addUser2Group -User $User -Group $Group # -Verbose
    	if ($res)
        {
            WriteLog "User [$User] added to group [$Group]" "MESS"
        }
    }    

	# ��������� ������ ��� ������
	# TODO 

    # Set Shell for All Users and System
    WriteLog "Set Shell (Explorer.exe) for Local Machine" "MESS"
    # TODO �������� �������� ��� �� ��� �����������
    $RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty -path $RegKey -name Shell -value "Explorer.exe"


    # Set personal Shell for user Block
    WriteLog "Set Shell (OnBoard.exe) for user [Block]" "INFO"
    # TODO �������� �������� ��� �� ��� �����������
    
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
        #New-Item -Path $RegKey -ItemType Key                 # �� ������� ���
            #if (Test-Path -Path $RegKey)
            #{
            #Set-ItemProperty -path $RegKey -name "Shell" -value "C:\Shturman\BIN\OnBoard.exe"  
            #}
            #else
            #{
                WriteLog "Can not set Shell for User [Block] because his newer logon on this Computer and Script can not create regestry key" "ERRr"
            #}
    }



	# �������������� ini
	# TODO 

	# ������ ���������� ���� ��� ��
	# TODO 

	# �����
	# TODO 


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
#	WriteLog "Invoke-Sqlcmd -InputFile $SQLScriptFile -Database $SQLDBName -ServerInstance $SQLServerInstance -Username $SQLUsername -Password $SQLPassword -Verbose | Format-Table"
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

WriteLog "Done. This window will be automaticaly closed after 120s" "INFO"
Start-Sleep -Seconds 120; 

# break

#$ShturmanEXELocation