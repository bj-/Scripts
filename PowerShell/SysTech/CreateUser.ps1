<#
  TODO: ��������� ��� ����� ������ ��������
  TODO: �� �������� �� ���� ��� ��� ��������� - ��������� ��� �����������.

#>
param (
	[string]$User = "Admin",
	[string]$UserFullName = "Block Administrator",
	[string]$UserDescription = "Block Administrator",
	[string]$Password = "",
	[string]$Group = "��������������",
	[switch]$Debug = $FALSE
);

clear;

# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"

[string]$version = "1.0.2"
<#
by NET (��������)


NET USER username "password" /ADD
NET LOCALGROUP "group" "user" /ADD  #to set group membership. 

NET USER "UserName" # ������ ��� �������� ����� � �������� � �������

#>

WriteLog "AddUser and set shell. Version: [$version]" "INFO"

# �������� ������� ���������������� ����������. ���� �� ��� - ������������
if(isAdmin)
{
	WriteLog "��������� �����: ����." "MESS"
};


function addUser2Group ()
{
	param (
		[string]$user = "",
		[string]$group = "",
		[switch]$Verbose = $FALSE
		)

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
		WriteLog "User [$User] doesn't created" "ERRr" $Verbose
		return $FALSE
	}
	

}

# ========================================

#Get-LocalUserAccount -UserName "Admins"

# Create user
# write-host  $Password

$uCrRes = CreateUser -UserName $User -UserPassword $Password -UserFullName $UserFullName -UserDescription $UserDescription
if ($uCrRes -eq $TRUE)
{
	WriteLog "User [$User] Created" "MESS"
}
ElseIf ($uCrRes -eq "-1")
{
	WriteLog "User [$User] already exist" "INFO"
}
Else
{
	WriteLog "User [$User] doesn't created" "ERRr"
}

# Add To Group
WriteLog "Adding user [$User] to group [$Group]" "INFO"
# TODO �������� �������� ��� ��������� � ������

addUser2Group -User $User -Group $Group


# SetShell for users

# PowerShell Set-ItemProperty script to set values in the registry
#function SetRegKey ($RegKey, )


WriteLog "Set Personal Shell (OnBoard.exe) for current user" "INFO"
# TODO �������� �������� ��� �� ��� �����������
$RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
#Get-ItemProperty -Path $RegKey -Name Shell
#$RegKey ="HKCU:\Control Panel\Desktop"
Set-ItemProperty -path $RegKey -name Shell -value "Explorer.exe"
#Get-ItemProperty -Path $RegKey -Name Shell

WriteLog "Set Shell (explorer.exe) for PC (all users)" "INFO"
# TODO �������� �������� ��� �� ��� �����������
$RegKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
#Get-ItemProperty -Path $RegKey -Name Shell
#$RegKey ="HKCU:\Control Panel\Desktop"
Set-ItemProperty -path $RegKey -name Shell -value "C:\Shturman\BIN\OnBoard.exe"
#Get-ItemProperty -Path $RegKey -Name Shell


# break

<#
# CreateLocalGroup.ps1

$cn = [ADSI]"WinNT://edlt"
$group = $cn.Create("Group","mygroup")
$group.setinfo()
$group.description = "Test group"
$group.SetInfo()

#>