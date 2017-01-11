<#
# Basic functions
# Version 1.0.0
#
#
#
������� � �������.
[DateTime]
	ParseDate()  Parse date and time.
    	[string]$Date = "",			# Required '25/12/2015' 'dd/mm/YYYY'"
    	[string]$Time = "",			# Required '15:10:13' 'hh:mm:ss'"
    	[switch]$Verbose = $FALSE,		# ������������ � ���
    	[switch]$Debug = $FALSE			# � ������� ��� ������� ���� �����
	return date by Get-Date. Return current date-time if empty


[Services]
	Check-Service()	������� �� ������	return True/False, write status into console
		[string]$ServiceName = "",
		[switch]$verbose
		return $TRUE/$FALSE


[Secirity]
	isAdmin()	�������� ������� ���������������� ����������	return True/False, write status into console and stop script when False
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
	addUser2Group ()			�������� ����� � ������
		[string]$user = "",
		[string]$group = "",
		[switch]$Verbose = $FALSE
		return $TRUE/$FALSE
	CreateUser ()				�������� �����
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

[SQL]
	SQLCreateUser 				Create SQL User if not exist
		[string]$SQLServerInstance = "",	SQL server instance
		[string]$SQLUsername = "",		Used SQL Login an Password
		[string]$SQLPassword = "",
		[string]Role ="", 			If Empy - do not set role. used default
		[string]$NewUser = "",			To create SQL User NAmd Passord
		[string]$NewPassword = "",
		[switch]$Verbose = $FALSE

    SQLQueryExec
		[string]$SQLServerInstance = "",	SQL server instance
		[string]$SQLUsername = "",		Used SQL Login an Password
		[string]$SQLPassword = ""
		[string]$SQLQuery = ""            Query to Execute
		[switch]$Verbose = $FALSE

    SQLDropDatabase 				# Kill connection and drop database if exist
		[string]$SQLServerInstance = ""     SQL server instance
		[string]$SQLUsername = ""           Used SQL Login an Password
		[string]$SQLPassword = ""
		[string]$SQLDBName = ""             DB to Drop
		[switch]$Verbose = $FALSE

    SQLRestoreDB	                # MS SQL Server - Restore DBExecuting some SQL Query
		[string]$SQLServerInstance = "",
		[string]$SQLUsername = "",
		[string]$SQLPassword = "",
		[string]$SQLDBName = "",              # new db name
        [string]$SQLDBBackUpPatch = "",       # Bak file plased there
        [string]$AppPath = "",                # Path to restored mdf and ldf
		[switch]$Verbose = $FALSE

#>

# =============================================================================================

# [DateTime]
# Parse date and time. return date by Get-Date. Return current date-time if empty
function ParseDate()
{
    param (
    	[string]$Date = "",				# Required '25/12/2015' 'dd/mm/YYYY'"
    	[string]$Time = "",				# Required '15:10:13' 'hh:mm:ss'"
    	[switch]$Verbose = $FALSE,		# ������������ � ���
    	[switch]$Debug = $FALSE			# � ������� ��� ������� ���� �����
    )

  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    $pDate = "$Date $Time"

    if (($Date -eq "") -and ($Time -eq ""))
    {
        return Get-Date
    }
    $result = 0
    if (!([DateTime]::TryParse($pDate, [ref]$result)))
    {
        WriteLog "$FuncName Incorrect Date or Time format: [$Date $Time]. Required '25/12/2015 15:10:13' 'dd/mm/YYYY hh:mm:ss'" "ERRr" $Verbose
        #break;
     }

    return $result
}


# [Services]
# ������� �� ������
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
# �������� ������� ���������������� ����������
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
		break; # ���� ��� - ������������.
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

    # TestFolderPath -Path -Create -Verbose

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";


	if ($Path -eq "")
	{
		WriteLog "$FuncName Parameter [Path] in function are missed" "ERRr" $TRUE
		break;
	}
<#
	# �������� �� ������������� �����
	# - ������� ��� ��� ������
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

	# - ��������� ������ �������
	if (-not (test-path $Path))
	{
#break	
		if ($Create)
		{
			WriteLog "$FuncName Creating folder [$Path]" "DUMP" $Verbose

			# PowerShell's New-Item creates a folder
			$result = New-Item -Path $Path -ItemType "directory"

			WriteLog "$FuncName Creating folder result: $result" "DUMP" $Verbose
			
			if (-not (test-path $Path))
			{
				WriteLog "$FuncName Can not create folder [$Path]" "ERRr" $TRUE
				break;
			}
			else
			{
				WriteLog "$FuncName Created folder [$Path]" "MESS" $TRUE
			}
		}
		Else
		{
		WriteLog "$FuncName Folder [$Path] doesn't exist" "ERRr" $TRUE
		}
	}
	else
	{
		WriteLog "$FuncName Folder [$Path] is exist" "INFO" $Verbose
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
		WriteLog $_ "WARN" $TRUE
		return $false
	}
# TODO: �������� ��������� �� ���� � ������

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

	# ��������� ���������� �� ��� ������ ������������
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
	$LocalAdmin.SetInfo() # ��� ������ ��������. ������� ������.
	$LocalAdmin.Description  = $UserDescription
	$LocalAdmin.SetInfo()
	$LocalAdmin.FullName = $UserFullName
	$LocalAdmin.SetInfo()
	$LocalAdmin.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD
	$LocalAdmin.SetInfo()

	# ��������� ��� ������������ ��������
	if (Check-LocalUserLogin -UserName $UserName)
	{
		WriteLog "User [$User] Created" "MESS" $Verbose
		return $TRUE
	}
	Else
	{
		WriteLog "User [$User] doesn't created" "ERRr" $TRUE
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

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	# �������� ��� ���� ����������
	if (Check-LocalUserLogin $Username $Verbose)
	{
		$ID = new-object System.Security.Principal.NTAccount($Username)
		$sid = $ID.Translate( [System.Security.Principal.SecurityIdentifier] ).toString()
		# TODO ������������
	}
	else
	{
		# TODO ������������ ������

	}
	
	# TODO: �������� ��� ��� �������

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

<# ==============================================

[SQL]

 ============================================== #>

function SQLCreateUser 				# Create SQL User if not exist
{
	param (
		[string]$SQLServerInstance = "",
		[string]$SQLUsername = "",
		[string]$SQLPassword = "",
		[string]$NewUser = "",
		[string]$NewPassword = "",
		[string]$Role ="",
		[switch]$Verbose = $FALSE
	)

#  SQLCreateUser -SQLServerInstance "localhost" -SQLUsername "sa" -SQLPassword "as" -NewUser "ShturmanBlock" -NewPassword "passForUser"

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

# Make Query
	$SQLQuery = 	"
			USE [master];
			GO
			IF NOT EXISTS(SELECT name FROM [master].[sys].[syslogins] WHERE NAME = '$NewUser')
			BEGIN 
				CREATE LOGIN [$NewUser] WITH PASSWORD=N'$NewPassword', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

				IF NOT EXISTS(SELECT name FROM [master].[sys].[syslogins] WHERE NAME = '$NewUser')
				BEGIN 
					Print('Did not create user [$NewUser]')
				END
				ELSE
					Print('User [$NewUser] Created')
			END
			ELSE
				Print('User [$NewUser] already Exist')"
   
	WriteLog "$FuncName Create SQLUser:[$NewUser]" "INFO" $Verbose

	SQLQueryExec -SQLServerInstance $SQLServerInstance -SQLUsername $SQLUsername -SQLPassword $SQLPassword -SQLQuery $SQLQuery

	IF ($Role -ne "")   # ����������� ���� ��� ���������� �����
	{
		WriteLog "$FuncName Set Role [$Role] for SQL User [$NewUser]" "INFO" $Verbose

		$SQLQuery = 	"
				USE [master];
				GO
				ALTER SERVER ROLE [$Role] ADD MEMBER [$NewUser]";
		SQLQueryExec -SQLServerInstance $SQLServerInstance -SQLUsername $SQLUsername -SQLPassword $SQLPassword -SQLQuery $SQLQuery
	}

}



function SQLDropDatabase 				# Kill connection and drop database if exist
{
	param (
		[string]$SQLServerInstance = "",
		[string]$SQLUsername = "",
		[string]$SQLPassword = "",
		[string]$SQLDBName = "",
		[switch]$Verbose = $FALSE
	)

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    # Make Query
	$SQLQuery = 	"
					DECLARE @dbname sysname
					SET @dbname = '$SQLDBName'


					IF EXISTS(SELECT name FROM sys.databases WHERE name = '$SQLDBName')
					BEGIN
						DECLARE @spid int
						SELECT @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname)
						WHILE @spid IS NOT NULL
						BEGIN
	    					Print('Kill Connections to database [$SQLDBName]')
	    					EXECUTE ('KILL ' + @spid)
	    					SELECT @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname) AND spid > @spid
						END

    					Print('Drop Database [$SQLDBName]')
    					DROP DATABASE [$SQLDBName]

						IF EXISTS(SELECT name FROM sys.databases WHERE name = '$SQLDBName')
						BEGIN
	    					Print('Did not drop database [$SQLDBName]')
							DROP DATABASE [$SQLDBName]
						END
						ELSE
	    					Print('Database [$SQLDBName] dropped')
					END
					ELSE
	    				Print('Database [$SQLDBName] does not exists')

		            "


	WriteLog "$FuncName Drop Database: [$SQLDBName]" "MESS" $Verbose

	SQLQueryExec -SQLServerInstance $SQLServerInstance -SQLUsername $SQLUsername -SQLPassword $SQLPassword -SQLQuery $SQLQuery #-Verbose $Verbose


}

function SQLRestoreDB
{
	# MS SQL Server - Restore DBExecuting some SQL Query
	param (
		[string]$SQLServerInstance = "",
		[string]$SQLUsername = "",
		[string]$SQLPassword = "",
		[string]$SQLDBName = "",
        [string]$SQLDBBackUpPatch = "",
        [string]$AppPath = "",
		[switch]$Verbose = $FALSE
	)

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    # ���� � ������ ���� ���������� ����
    $SQLDBNameFileMDF = "$AppPath\SQL\$SQLDBName"+".mdf"
    $SQLDBNameFileLDF = "$AppPath\SQL\$SQLDBName"+"_log.ldf"

    # Make Query
	$SQLQuery = 	"
					USE [master]
                    RESTORE DATABASE [Shturman_Metro] FROM  DISK = N'$SQLDBBackUpPatch' WITH  FILE = 1,  
	                    MOVE N'Shturman_Metro' TO N'$SQLDBNameFileMDF',  
	                    MOVE N'Shturman_Metro_log' TO N'$SQLDBNameFileLDF',  
	                    NOUNLOAD,  
	                    STATS = 5
                    GO
                    "

    [bool]$CantRestore = $FALSE;
	# - ��������� ������ � �������� ������ (������� ������ � ��������� ��������� ������)
    TestFolderPath -Path "$AppPath\SQL\" -Create # -Verbose ���� ���� ������������� ��

	if (-not (test-path "$SQLDBBackUpPatch"))  # ����� ����������
	{
		WriteLog "$FuncName Bakup File [$SQLDBBackUpPatch] does not exist" "ERRr" $TRUE
        $CantRestore = $TRUE;
	}
	if ((test-path "$SQLDBNameFileMDF")) # ����� ���� � ���� - �� ����������. �.�. �� ���������� ����������� �� � ���� �����
	{
		WriteLog "$FuncName File [$SQLDBNameFileMDF] for db [$SQLDBName] already exist Can not restore DB." "ERRr" $TRUE
        $CantRestore = $TRUE;
	}
	if ((test-path "$SQLDBNameFileLDF"))
	{
		WriteLog "$FuncName File [$SQLDBNameFileLDF] for db [$SQLDBName] already exist. Can not restore DB." "ERRr" $TRUE
        $CantRestore = $TRUE;
	}
    If ($CantRestore) # ���� ���� ���� ������ - ���������� �� ����������
    {
        break;
    }


# write-host $SQLQuery

	WriteLog "$FuncName Restore DB: [$SQLDBName] from [$SQLDBBackUpPatch] " "MESS" $Verbose

	SQLQueryExec -SQLServerInstance $SQLServerInstance -SQLUsername $SQLUsername -SQLPassword $SQLPassword -SQLQuery $SQLQuery #-Verbose $Verbose

}


function SQLQueryExec
{
	# MS SQL Server - Executing some SQL Query
	param (
		[string]$SQLServerInstance = "",
		[string]$SQLUsername = "",
		[string]$SQLPassword = "",
		[string]$SQLQuery = "",
		[switch]$Verbose = $FALSE
	)

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	WriteLog "$FuncName Used SQL Server:[$SQLServerInstance] l:[$SQLUsername]" "DUMP" $Verbose

	WriteLog "$FuncName Execute Query: `n $SQLQuery" "DUMP" $Verbose
	sqlcmd -S $SQLServerInstance -U $SQLUsername -P $SQLPassword -Q $SQLQuery

	

}
#>