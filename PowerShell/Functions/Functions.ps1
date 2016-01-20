#
# Basic functions
# Version 1.0.0
#
#
#
# Разделы и функции.
# [Services]
# Check-Service ($ServiceName)	Запущен ли сервис	return True/False, write status into console

# [Secirity]
# isAdmin	проверка наличия административных привилегий	return True/False, write status into console and stop script when False

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
		break;
		#return $FALSE;
	}
	Else
	{
		return $TRUE;
	}
} 


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
				if ($Verbose) {WriteLog "User [$UserName] found" "INFO" }
				return $TRUE
			}
		}

		if ($Verbose) {WriteLog "User [$UserName] not found" "WARN" }
		return $FALSE
	}
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