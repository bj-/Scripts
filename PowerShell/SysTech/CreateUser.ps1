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

# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir".\..\Functions\log.ps1"


[string]$version = "1.0.3"
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


# ========================================

# Create user
if ((CreateUser -UserName $User -UserPassword $Password -UserFullName $UserFullName -UserDescription $UserDescription -Verbose) -eq $TRUE)
{
	# Add To Group
	addUser2Group -User $User -Group $Group -Verbose
}




#    [string]$DomainName = $env:USERDOMAIN            



#$admin = get-sid "Administrator"
#$admin.SubString(0, $admin.Length - 4)

get-LocalUserSid -UserName Admin -Verbose
get-LocalUserSid -UserName bj -Verbose



write-host (new-object System.Security.Principal.NTAccount "bj").Translate([System.Security.Principal.SecurityIdentifier])


<#            
foreach($User in $UserAccount) {            
 $object = New-Object �TypeName PSObject �Prop (            
                @{'UserName'=$null;            
                'DomainName'=$null;            
                'SIDValue'=$null}            
                )            
            
 $Object.UserName = $User.ToUpper()            
 $Object.DomainName = $DomainName.ToUpper()            
 try {            
     $UserObject = [System.Security.Principal.NTAccount]::new($DomainName,$User)            
     $out = $UserObject.Translate([System.Security.Principal.SecurityIdentifier])            
  $Object.SIDValue = $out.Value            
             
 } catch {            
  $Object.SIDValue = "FAILED"            
 }            
$Object            
}   
}

aaa  -UserAccount bj
break
#>                              




# SetShell for users
WriteLog "Set Personal Shell (OnBoard.exe) for current user" "INFO"
# TODO �������� �������� ��� �� ��� �����������
$RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -path $RegKey -name Shell -value "Explorer.exe"

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