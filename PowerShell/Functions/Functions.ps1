<#
# Basic functions
# Version 1.0.0
#
#
#
Разделы и функции.
[Services]
	Check-Service()	Запущен ли сервис	return True/False, write status into console
		[string]$ServiceName = "",
		[switch]$verbose
		return $TRUE/$FALSE


[Secirity]
	isAdmin()	проверка наличия административных привилегий	return True/False, write status into console and stop script when False
		return $TRUE/$FALSE

[FilesAndFolders]
	TestFolderPath 
		[string]$Path = "",
		[switch]$Create = $FALSE,
		[switch]$Verbose = $FALSE


[UsersAndGroups]
	Get-LocalUserLogins
		return LOGINS_ARRAY;
	Check-LocalUserLogin
		[string]$UserName = "",
		[switch]$Verbose = $FALSE
		return $TRUE/$FALSE
	addUser2Group ()			Добавить юзера в группу
		[string]$user = "",
		[string]$group = "",
		[switch]$Verbose = $FALSE
		return $TRUE/$FALSE
	CreateUser ()				Создание Юзера
		[string]$UserName = "",
		[string]$UserPassword = "",
		[string]$UserFullName = "",
		[string]$UserDescription = "",
		[switch]$Verbose = $FALSE
		return $TRUE/$FALSE/-1
	get-LocalUserSid			Get Local User SID by Username
		[string]$Username = "",
		[switch]$Verbose = $FALSE
		return USER_SID

#>

# =============================================================================================
# [Services]
# Запущен ли сервис
function Check-Service ()
{
	param (
		[string]$ServiceName = "",
		[switch]$verbose
	)
		
	$x = Get-Service -Name $ServiceName
	if ($x.Status -eq "Running")
	{
		If ($verbose) {	WriteLog "Service [$ServiceName] is started" "MESS"; };
		return $TRUE
	}
	Else 
	{
		If ($verbose) {	WriteLog "Service [$ServiceName] is NOT started" "WARN"; };
#		Write-Host "[$ServiceName] service is NOT started" "WARN"
		return $FALSE
	}
}

# [Secirity]
# проверка наличия административных привилегий
function isAdmin
{  
	$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()  
	$principal = new-object System.Security.Principal.WindowsPrincipal($identity)  
	$admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator  
#	$principal.IsInRole($admin)
	If ($principal.IsInRole($admin) -eq $FALSE) 
	{
		Write-Host "Required Administrative previlegies. Please Run script under administrator." -foregroundcolor "red"; 
		Start-Sleep -Seconds 2; 
		break; # если нет - отваливаемся.
		#return $FALSE;
	}
	Else
	{
		return $TRUE;
	}
} 

# [FilesAndFolders]
Function TestFolderPath 
{
	param (
		[string]$Path = "",
		[switch]$Create = $FALSE,
		[switch]$Verbose = $FALSE
		)

	if ($Path -eq "")
	{
		WriteLog "Parameter [Path] in function [TestFolderPath] are missed" "ERRr"
		break;
	}
<#
	# проверки на существование путей
	# - фолдера для Лог файлов
	if (-not (test-path $LogFilePath))
	{
		WriteLog "Log File path [$LogFilePath] doesn't exist" "ERRr"
		break;
	}
	else
	{
		WriteLog "Log File path [$LogFilePath] exist" "INFO"
	}
#>
	# - Проверяем наличе фолдера
	if (-not (test-path $Path))
	{
#break	
		if ($Create)
		{
			WriteLog "Creating folder [$Path]" "DUMP"

			# PowerShell's New-Item creates a folder
			$result = New-Item -Path $Path -ItemType "directory"

			WriteLog "Creating folder result: $result" "DUMP"
			
			if (-not (test-path $Path))
			{
				WriteLog "Can not create folder [$Path]" "ERRr"
				break;
			}
			else
			{
				WriteLog "Created folder [$Path]" "MESS" -Verbose $Verbose
			}
		}
		Else
		{
		WriteLog "Folder [$Path] doesn't exist" "ERRr"
		}
	}
	else
	{
		WriteLog "Folder [$Path] is exist" "INFO" -Verbose $Verbose
	}

}

<# ==============================================

[UsersAndGroups]

 ============================================== #>

Function Get-LocalUserLogins ()
{
	$adsi = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"
	$list = $adsi.psbase.children | where {$_.psbase.schemaClassName -match "user"} | select @{n="Name";e={$_.name}}

	return $list;
}

Function Check-LocalUserLogin
{
	param (
		[string]$UserName = "",
		[switch]$Verbose = $FALSE

		)
	if ($UserName -eq "")
	{
		WriteLog "[User] property must be specified (function [Check-LocalUserLogin])" "WARN"
	}
	else
	{
		$list = Get-LocalUserLogins
		foreach ($item in $list)
		{
			if ($item.name -eq $UserName)
			{
				WriteLog "User [$UserName] found" "INFO" $Verbose
				return $TRUE
			}
		}

		WriteLog "User [$UserName] not found" "WARN" $Verbose
		return $FALSE
	}
}


function addUser2Group ()
{
	param (
		[string]$user = "",
		[string]$group = "",
		[switch]$Verbose = $FALSE
		)

	WriteLog "Adding user [$User] to group [$Group]" "INFO" $Verbose

	$cname = gc env:computername
	try
	{
		([adsi]"WinNT://$cname/$group,group").Add("WinNT://$cname/$user,user")
	}
	catch
	{
		WriteLog $_ "WARN" $Verbose
		return $false
	}
# TODO: проверка включился ли юзер в группу

	return $true
}

function CreateUser ()
{

	param (
		[string]$UserName = "",
		[string]$UserPassword = "",
		[string]$UserFullName = "",
		[string]$UserDescription = "",
		[switch]$Verbose = $FALSE
		)

	WriteLog "Creating user [$UserName]" "DUMP"

	# проверяем существвет ли уже данный пользователь
	if (Check-LocalUserLogin -UserName $UserName)
	{
		WriteLog "User [$User] already exist" "INFO" $Verbose
		return -1
	}


	if ($UserPassword -eq "")
	{
		$UserPassword = ([char[]](Get-Random -Input $(48..57 + 65..90 + 97..122) -Count 12)) -join ""
		WriteLog "Password is empty. Generated new password [$UserPassword]" "INFO" $Verbose
		
	}

	# Create new local Admin user for script purposes
	$Computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"

	$LocalAdmin = $Computer.Create("User", $UserName)
	$LocalAdmin.SetPassword($UserPassword)
	$LocalAdmin.SetInfo() # Для каждой проперти. пакетно нельзя.
	$LocalAdmin.Description  = $UserDescription
	$LocalAdmin.SetInfo()
	$LocalAdmin.FullName = $UserFullName
	$LocalAdmin.SetInfo()
	$LocalAdmin.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD
	$LocalAdmin.SetInfo()

	# проверяем что пользователь создался
	if (Check-LocalUserLogin -UserName $UserName)
	{
		WriteLog "User [$User] Created" "MESS" $Verbose
		return $TRUE
	}
	Else
	{
		WriteLog "User [$User] doesn't created" "ERRr" $Verbose
		return $FALSE
	}
	

}


function get-LocalUserSid
{
	# Get Local User SID by Username
	Param (
		[string]$Username = "",
		[switch]$Verbose = $FALSE
	)

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	# проверка что юзер существует
	if (Check-LocalUserLogin $Username $Verbose)
	{
		$ID = new-object System.Security.Principal.NTAccount($Username)
		$sid = $ID.Translate( [System.Security.Principal.SecurityIdentifier] ).toString()
		# TODO Логгирование
	}
	else
	{
		# TODO Логгирование ошибки

	}
	
	# TODO: проверка что Сид получен

	WriteLog "$FuncName SID for local user [$Username] is [$sid]" "DUMP" $Verbose
	return $sid

	# Alternative way
#	write-host (new-object System.Security.Principal.NTAccount "Admin").Translate([System.Security.Principal.SecurityIdentifier])

}


<#
Function Get-LocalUserAccount
{
[CmdletBinding()]
param (
	[parameter(ValueFromPipeline=$true,
	ValueFromPipelineByPropertyName=$true)]
	[string[]]$ComputerName=$env:computername,
	[string]$UserName
	)

	foreach ($comp in $ComputerName){

		[ADSI]$server="WinNT://$comp"

		if ($UserName)
		{
			foreach ($User in $UserName)
			{
				$server.children | where {$_.schemaclassname -eq "user" -and $_.name -eq $user}
			}    
		}
		else
		{
			$server.children | where {$_.schemaclassname -eq "user"}
		}
	}
}
#>