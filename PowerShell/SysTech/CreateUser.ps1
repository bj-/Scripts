param (
	[string]$User = "Admin",
	[string]$UserFullName = "Block Administrator",
	[string]$UserDescription = "Block Administrator",
	[string]$Password = "mRaGjr2Ty",
	[string]$Group = "Администраторы",
	[switch]$Debug = $FALSE
);

clear;

# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"

[string]$version = "1.0.1"
<#
by NET (рабаатет)


NET USER username "password" /ADD
NET LOCALGROUP "group" "user" /ADD  #to set group membership. 

NET USER "UserName" # вернет все проперти юзера и членство в группах

#>

WriteLog "AddUser and set shell. Version: [$version]" "INFO"

# проверка наличия административных привилегий. если их нет - отваливаемся
if(isAdmin)
{
	WriteLog "Админские права: есть." "MESS"
};


function addUser2Group([string]$user,[string]$group)
{
    $cname = gc env:computername
    try
    {
        ([adsi]"WinNT://$cname/$group,group").Add("WinNT://$cname/$user,user")
    }
    catch
    {
        WriteLog($_)
        return $false
    }

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

	WriteLog "Creating user [$User]" "DUMP"

	# проверяем существвет ли уже данный пользователь
	if (Check-LocalUserLogin -UserName $UserName -Verbose)
	{
		if ($Verbose = $TRUE)
		{
			WriteLog "User [$User] already exist" "INFO"
		}
		return -1
	}

$aa;
break; 

	if ($UserPassword -eq "")
	{
		$UserPassword = ([char[]](Get-Random -Input $(48..57 + 65..90 + 97..122) -Count 12)) -join ""
		if ($Verbose = $TRUE)
		{
			WriteLog "Password is empty. Generated new password [$UserPassword]" "INFO"
		}
		
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
	# TODO
	

}

# ========================================

#Get-LocalUserAccount -UserName "Admins"

# Create user


if (CreateUser -UserName $User -UserPassword $Password -UserFullName $UserFullName -UserDescription $UserDescription -Verbose)
{
	WriteLog "User $User Created" "MESS"
}
Else
{
	WriteLog "User $User doesn't created" "ERRr"
}

# Create Group
WriteLog "Adding user $User to group $Group" "INFO"
# TODO вставить проверку что включился в группу
addUser2Group $User $Group


# SetShell for users

# PowerShell Set-ItemProperty script to set values in the registry
#function SetRegKey ($RegKey, )


WriteLog "Set Personal Shell (OnBoard.exe) for current user" "INFO"
# TODO вставить проверку что на что подменилось
$RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
#Get-ItemProperty -Path $RegKey -Name Shell
#$RegKey ="HKCU:\Control Panel\Desktop"
Set-ItemProperty -path $RegKey -name Shell -value "Explorer.exe"
#Get-ItemProperty -Path $RegKey -Name Shell

WriteLog "Set Shell (explorer.exe) for PC (all users)" "INFO"
# TODO вставить проверку что на что подменилось
$RegKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
#Get-ItemProperty -Path $RegKey -Name Shell
#$RegKey ="HKCU:\Control Panel\Desktop"
Set-ItemProperty -path $RegKey -name Shell -value "C:\Shturman\BIN\OnBoard.exe"
#Get-ItemProperty -Path $RegKey -Name Shell


break

<#
# CreateLocalGroup.ps1

$cn = [ADSI]"WinNT://edlt"
$group = $cn.Create("Group","mygroup")
$group.setinfo()
$group.description = "Test group"
$group.SetInfo()

#>