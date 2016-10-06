clear;

Function Get-LocalUserLogins ()
{
	$adsi = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"
	$list = $adsi.psbase.children | where {$_.psbase.schemaClassName -match "user"} | select @{n="Name";e={$_.name}}

	return $list;
}


Function Remove-LocalUserAccount 
{
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName=$env:computername,
        [parameter(Mandatory=$true)]
        [string[]]$UserName
    )

    foreach ($comp in $ComputerName)
    {

        [ADSI]$server="WinNT://$comp"

        foreach ($User in $UserName)
        {
            $server.delete("user",$user)
        }
    }
}


# Reg delete "HKLM\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg" /f
# Добавление скрытых аккаунтов в реестр
# reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\Userlist" /v "UserName" /t REG_DWORD /d 0


#break;

# маппинг веток ресстра на диски
if ((Test-Path -Path "HKLM:") -eq $FALSE)
{
    $resHKLM = New-PSDrive -PSProvider Registry -Name HKLM -Root HKEY_LOCAL_MACHINE
    Write-Host "Map Regitry tree to disk [HKLM]"

}
if ((Test-Path -Path "HKU:") -eq $FALSE)
{
    $resHKU = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    Write-Host "Map Regitry tree to disk [HKU]"
}


# 1. удаление скрытыж аккаунтов из реестран
$RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts";
if (Test-Path -Path $RegKey)
{
    #Remove-ItemProperty 
    Remove-Item -Path $RegKey -Recurse
    #Reg delete $RegKey /f
    if ((Test-Path -Path $RegKey) -eq $FALSE)
    {
        Write-Host "Removed [$RegKey]" -ForegroundColor Green
    }
    else
    {
        Write-Host "Dint't remove [$RegKey]" -ForegroundColor Red
    }
}


# Удаляем юзеров кроме "Администратор", "Гость", "Admin", "Block"

$UserList= Get-LocalUserLogins

[string]$userD = "";

Foreach ($userD in $UserList)
{
    
    #$r = $user.t
    $userD = $userD -replace "@{Name=";
    $userD = $userD -replace "}";
    $userD = $userD.Trim()
#    $userD -notin "Администратор", "Гость", "Admin", "Block"
    if ($userD -notin "Администратор", "Гость", "Admin", "Block", "bj", "bj-adm")
    #if ($user -notin ("Администратор|Гость|Admin|Block")
    {
        Remove-LocalUserAccount -UserName $userD
        Write-Host "Remove User Account [$userD]"
    }
# if 
}


# change Password for local user

Foreach ($userD in $UserList)
{
    
    #$r = $user.t
    $userD = $userD -replace "@{Name=";
    $userD = $userD -replace "}";
    $userD = $userD.Trim()
#    $userD -notin "Администратор", "Гость", "Admin", "Block"
    if ($userD -in "Admin", "Block")
    {

    	$UserP = [ADSI]"WinNT://$Env:COMPUTERNAME/$userD,user"
        $UserP.psbase.invoke("SetPassword","DrV34mnt")
        $UserP.psbase.CommitChanges()

<#        $admin=[adsi]("WinNT://" + $ComputerName + "/administrator, user")
        $admin.psbase.invoke("SetPassword", $Password)
        $admin.psbase.CommitChanges()
#>
        Write-Host "Change Password for user [$userD]"
    }
# if 
}



write-host "Read HKLM Run" -ForegroundColor Magenta
$key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
if (Test-Path -Path $key)
{
    (Get-ItemProperty -Path $key)
    #(Get-ItemProperty -Path $key).ProgramFilesDir
}
Else
{
    write-host "Path doen't exist";
}

write-host "Read HKU Run" -ForegroundColor Magenta
$key = 'HKU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
if (Test-Path -Path $key)
{
    (Get-ItemProperty -Path $key)
    #(Get-ItemProperty -Path $key).ProgramFilesDir
}
Else
{
    write-host "Path doen't exist";
}


break 

break 


<#

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Classic Start Menu"="\"C:\\Program Files\\Classic Shell\\ClassicStartMenu.exe\" -autorun"

    $RegKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty -path $RegKey -name Shell -value "Explorer.exe"


    $res = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
#    WriteLog "create a new PSDrive to the HKEY_USERS hive result: [$res]" "INFO"

    
    $RegKey = "HKU:\$UserSID\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
    if (Test-Path -Path $RegKey)
    {
    #    write-host($regkey)
        Set-ItemProperty -path $RegKey -name "Shell" -value "C:\Shturman\BIN\OnBoard.exe"
#>