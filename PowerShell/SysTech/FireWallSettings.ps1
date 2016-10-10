<#

 Настройка Windows FireWall

 Ключи:
	-SheduledTask $FALSE	- отключает создание шедульной таски которая отключает фаервол
	-Debug			- полное логгирование в консоль (серым цветом обычно невидимые сообщения). в лог пишет всегда

 Функционал большей частью обернут в функции проверящие выполнение каждого дествия.

 В файл лога (создается в каталоге скрипта с именем ИмяФайлаСкрипта.log) также пишутся все включенные правила. Для призрачной возможности отката.
 в формате (на каждое правило):
	-------------------------
	Name: CoreNet-ICMP6-DU-In
	DisplayName: Основы сетей — назначение недостижимо (входящий трафик ICMPv6)
	Description: Сообщение об ошибке "Назначение недостижимо" отправляется любым узлом, который не может переслать проходящий через него пакет по любой причине, кроме перегрузки сети.
	Direction: Inbound
	-------------------------

 При выполнении все должно быть бело-зеленое. если что-то не удалось - вручную проверять все правила. в некоторых случаях скрипт сам остановится, 
 если заметит что не выполнилось что-то жизненно важное (но не все. например не созданные правила не вызывают остановку скрипта)

 При обнаружени косяков - обращатсья на завод изготовитель. 
 
 ==================
 Что делает скрипт: 

 Устанавливает правила
 Вход:
 - RDP с фиксированных IP адресов м диапазонов сетей используемых в компании
	172.16.30.0/24,  Внутренняя сеть штурмана
	109.188.130.109, Внешний IP подразделения Штурман
	192.168.43.0/24, Точка доступа на андроиде
	185.15.189.99,   Московский сервер
	10.110.95.0/24, 10.168.102.0/24,  Сеть метро SPB 4 Line
	80.76.243.254 - Системные технологии (сеть Systech)
 Выход
 - запрещено все что не разрешено
 - правила:
	GRE
	PPTP
	SMB
	Ping
	на порты штурмана 45790-45800
	80, 8080
	443
	DHCP

 Создает шедульную таску (отключается ключем -SheduledTask $FALSE), которая каждый час будет выключать фаервол. на случай если что-то пойдет не так.
 Таску необходимо убить самостоятельно после проверки что на комп можно попасть

#>

param (
#	[string]$AdminLogin = (Read-Host 'For creating sheduled task - required Admin login and password. Type Login'),
#	[string]$AdminLogin = (Write-host Read-Host 'For creating sheduled task required Admin login and password `n Login:'),
#	[string]$AdminPassword = (Read-Host 'Password'),
	[bool]$SheduledTask = $TRUE,		# Создавать таску отключающую фаервол через час после выполнения скрипта (нга случай косяков)
	[bool]$Debug = $FALSE		# в консоль все события лога пишет
)

clear;
$version = "1.0.0";


#Enable All log messages in console
#$Debug = $TRUE;


# START Base Functions

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

#
# логгирование работы
#

#$MyInvocation

$LogFile = $MyInvocation.InvocationName -replace ".ps1", ""
$LogFile = $LogFile + ".log"
#$LogFile
#break

# $HostErrorLevel
# $LogErrorLevel
#break
# 
# [LOG]
#
# Логгирумые сообщения (регулярное выражение). Доступны сообщения  INFO|WARN|ERRr|MESS|DUMP
[string]$FullErrorLevel = "INFO|WARN|ERRr|MESS|DUMP";
[string]$LogErrorLevel = $FullErrorLevel;
if ($Debug)
{
	[string]$HostErrorLevel = $FullErrorLevel;
}
Else
{
	[string]$HostErrorLevel = "INFO|WARN|ERRr|MESS";
}

# Формат даты времени для лога
[string]$LogDateFormat = "yyyy-MM-dd HH:mm:ss";


function WriteLog
{
	param (
		[string]$message = "",
		[string]$messagetype = "INFO",
		[bool]$Verbose = $TRUE		# в консоль все события лога пишет
	)


	$currDateTime = Get-Date -Format $LogDateFormat
	
	switch ($messagetype)
	{
		"INFO"
		{
			[string]$color = "white"
		}
		"WARN"
		{
			[string]$color = "yellow"
		}
		"ERRr"
		{
			[string]$color = "red"
		}
		"MESS"
		{
			[string]$color = "Green"
		}
		"DUMP"
		{
			[string]$color = "Gray"
		}
	}

	# В консоль 
	if ($messagetype -match $HostErrorLevel)
	{
		if ($Verbose -or ($messagetype -eq "ERRr") -or ($messagetype -eq "WARN"))
		{
			Write-Host "[ $messagetype ] $message" -foregroundcolor $color;
		}
	}
	# В лог
	if ($messagetype -match $LogErrorLevel)
	{
		"$currDateTime $messagetype $message" | Out-File $LogFile -Encoding "default" -Append
	}

};

# END Base Functions


# Import-Module
Function InstallModuleIfNotExist()
{
    PARAM (
        [string]$ModuleName = "",
  		[switch]$Verbose = $FALSE		# говорливость в консоль

    )

  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

  	WriteLog "$FuncName PSS Module installer and checker. Check module [$ModuleName]" "DUMP" $Verbose


    if ($ModuleName -eq "") {
    	WriteLog "$FuncName Module not specified. Abort." "ERRr" $Verbose
        #return "InstallModuleIfNotExist: Module not specified. Abort." 
        return $FALSE
    }

  	WriteLog "$FuncName Read installed modules. Look for [$ModuleName]" "DUMP" $Verbose
    $ModList = Get-Module -Name $ModuleName

    if ($ModList.Name -eq $ModuleName)
    {
     	WriteLog "$FuncName Module [$ModuleName] already installed" "INFO" $Verbose
        return $TRUE
    }
    else
    {
     	WriteLog "$FuncName Module [$ModuleName] currently doesn't installed" "DUMP" $Verbose

        # Look for modules in available mods
     	WriteLog "$FuncName Looking for module [$ModuleName] in available mods" "DUMP" $Verbose
        $ModAvailibleList = Get-Module -ListAvailable

        foreach ($AvailableMod in $ModAvailibleList)
        {
            #$AvailableMod.Name
            if ($AvailableMod.Name -eq $ModuleName)
            {
             	WriteLog "$FuncName Found module [$ModuleName] in available mods. Try to Install" "DUMP" $Verbose

                Import-Module $ModuleName -ErrorAction SilentlyContinue
                
             	WriteLog "$FuncName Check installation result [$ModuleName]" "DUMP" $Verbose
                $ModList = Get-Module -Name $ModuleName -ErrorAction SilentlyContinue

                if ($ModList.Name -eq $ModuleName)
                {
            	    WriteLog "$FuncName Module [$ModuleName] installed" "MESS" $Verbose
                    return $TRUE
                }
                else
                {
            	    WriteLog "$FuncName Module [$ModuleName] doesn't installed" "ERRr" $Verbose
                    return $FALSE
                }

            }
        }
    }
}

# New-NetFirewallRule
function CreateFireWallRule()
{

    PARAM (
        [string]$RuleName = "",
        [string]$RuleDisplayName = $RuleName,
        [string]$RuleDescription = "",
        [string]$RuleDirection = "",
        [string]$RuleProfile = "",
        [string]$RuleProtocol = "",
        [string]$RuleLocalPort = "",
        [string]$RuleRemotePort = "",
        #[string]$RuleRemoteAddress = "", # ругается. надо как-то по другмоу передавать эту переменную
   		[switch]$Verbose = $FALSE		# говорливость в консоль
    )

  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

  	WriteLog "$FuncName Create Firewall rule function. Request for create [$RuleName] [$RuleDisplayName]" "DUMP" $Verbose



    if ($RuleName -eq "") 
    {
      	WriteLog "$FuncName [$RuleName] parameterr is empty. Abort." "ERRr" $Verbose
        break;
    }

    # Check Rule exist and create it if not
    $Rule = Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue
    
    if ($Rule.Name -ne $RuleName)
    {

      	WriteLog "$FuncName Try to create Rule [RuleName]" "DUMP" $Verbose

        $CreatedRule = New-NetFirewallRule -Name $RuleName -DisplayName $RuleDisplayName -Description $RuleDescription `
                                            -Direction $RuleDirection -Profile $RuleProfile -Protocol $RuleProtocol

        # Check created rule and add parameters
        $Rule = Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue
        if ($Rule.Name -eq $RuleName)
        {
          	WriteLog "$FuncName Rule [$RuleName] Created, Adding parameters if exist." "DUMP" $Verbose

            # additional settings if it exist in incoming params
            if ($RuleLocalPort -ne "") 
            {
                Set-NetFirewallRule -Name $RuleName -LocalPort $RuleLocalPort ; 
              	WriteLog "$FuncName Write parameter LocalPort = [$RuleLocalPort]" "DUMP" $Verbose
            }

            if ($RuleRemotePort -ne "") 
            {
             #"Set-NetFirewallRule -Name $RuleName -RemotePort `"$RuleRemotePort`" ;"
                Set-NetFirewallRule -Name $RuleName -RemotePort $RuleRemotePort ;
              	WriteLog "$FuncName Write parameter RemotePort = [$RuleRemotePort]" "DUMP" $Verbose
            }
            <#
            if ($RuleRemoteAddress -ne "")
            {
            "Set-NetFirewallRule -Name $RuleName -RemoteAddress $RuleRemoteAddress"
                Invoke-Command -ScriptBlock (Set-NetFirewallRule -Name $RuleName -RemoteAddress $RuleRemoteAddress ) ;
              	WriteLog "$FuncName Write parameter RemoteAddress = [$RuleRemoteAddress]" "DUMP" $Verbose
            }
            #>

          	WriteLog "$FuncName Rule [$RuleName] Created" "MESS" $Verbose

        }
        else
        {
          	WriteLog "$FuncName [$RuleDirection] Rule [$RuleName] doesn't created" "ERRr" $Verbose
        }
    }
    Else
    {
      	WriteLog "$FuncName Rule [$RuleName] already exist" "INFO" $Verbose
    }

}

# Disable all FireWall rules exept created "Shturman.RDP"
Function DisableFireWallRules()
{
    PARAM (
        [string]$ExceptRuleName = "",
        [string]$RuleDirection = "",
        [string]$RuleEnabled = "",
   		[switch]$Verbose = $FALSE		# говорливость в консоль
    )

  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

  	WriteLog "$FuncName Disable FireWall rules except [$RuleName]" "DUMP" $Verbose



  	WriteLog "$FuncName Get all rules" "DUMP" $Verbose
    $FWRules = Get-NetFirewallRule

    foreach ($DRule in $FWRules)
    {
        # if specified direction
        if (($DRule.Direction -eq $RuleDirection) -or ($RuleDirection -eq ""))
        {
            # if specified Enable
            if (($DRule.Enabled -eq $RuleEnabled) -or ($RuleEnabled -eq ""))
            {
            
                if (($DRule.Name -ne $ExceptRuleName) -or ($ExceptRuleName -eq ""))
                {
                    Disable-NetFirewallRule -Name $DRule.Name
                    #$DRule.Name
                    #$DRule.DisplayName
                    #$DRule.Description

                    $CheckRule = Get-NetFirewallRule -Name $DRule.Name

                    if ($CheckRule.Enabled -ne "True")
                    {
                        $LogMess = "DISABLED [" + $CheckRule.Direction + "] Rule [" + $CheckRule.Name + "] [" + $CheckRule.DisplayName + "]";
                        WriteLog $LogMess "MESS" $Verbose
                    }
                    else
                    {
                        $LogMess = "[" + $CheckRule.Direction + "] Rule [" + $CheckRule.Name + "] [" + $CheckRule.DisplayName + "] can't disable";
                        WriteLog $LogMess "ERRr" $Verbose
                    }
                }
            }
        }
    }
}

# Disable all FireWall rules exept created "Shturman.RDP"
Function EnableFireWallRule()
{
    PARAM (
        [string]$RuleName = "",
        [string]$RuleDisplayName = "",
        [string]$RuleDirection = "",
        [string]$Profile = "",
	[switch]$Verbose = $FALSE		# говорливость в консоль
    )
  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

  	WriteLog "$FuncName Enabling FireWall rule [$RuleName] / [$RuleDisplayName] / [$RuleDirection]" "DUMP" $Verbose



    #$RuleName
    #$RuleDisplayName
    

    if ($RuleName -ne "")
    {
        $FWRules = Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue
      	WriteLog "$FuncName Rule to enable Name: [$RuleName]" "DUMP" $Verbose

    }
    elseif ($RuleDisplayName -ne "")
    {
        $FWRules = Get-NetFirewallRule -DisplayName $RuleDisplayName -ErrorAction SilentlyContinue
      	WriteLog "$FuncName Rule to enable Display-name: [$RuleDisplayName]" "DUMP" $Verbose
    }
    else
    {
      	WriteLog "$FuncName Rule doesn't specified" "WARN" $Verbose
        #write-host "EnableFireWallRule: Rule doesn't specified" -ForegroundColor Red
    }

    if ($FWRules.Count -eq 0)
    {
      	WriteLog "$FuncName Rule [$RuleName] / [$RuleDisplayName] doesn't exist" "ERRr" $Verbose
    }

    foreach ($DRule in $FWRules)
    {
        # if specified direction
      	WriteLog "$FuncName Check Rule direction [$RuleDirection]" "DUMP" $Verbose
        if ($DRule.Direction -eq $RuleDirection)
        {
            if ($DRule.Enabled -eq "True")
            {
                $LogMessage = "$FuncName Rule [" + $DRule.Name + "] / [" + $DRule.DisplayName +"] Direction [" + $DRule.Direction + "] exist and already Enabled"
          	    WriteLog $LogMessage "INFO" $Verbose
            }
            else
            {
                $LogMessage = "$FuncName Rule [" + $DRule.Name + "] / [" + $DRule.DisplayName +"] Direction [" + $DRule.Direction + "] does exist. Try to Enable"
      	        WriteLog $LogMessage "DUMP" $Verbose

    #           Disable-NetFirewallRule -Name $DRule.Name
                Enable-NetFirewallRule -Name $DRule.Name -ErrorAction SilentlyContinue


		# check
                $CheckRule = Get-NetFirewallRule -Name $DRule.Name
                if ($CheckRule.Enabled -eq "True")
                {
                    $LogMessage = "$FuncName ENABLED [" + $CheckRule.Direction + "] Rule [" + $CheckRule.Name + "] / [" + $CheckRule.DisplayName +"]"
                    WriteLog $LogMessage "MESS" $Verbose
                }
                else
                {
                    $LogMessage = "$FuncName Rule is still DISABLED [" + $CheckRule.Name + "] / [" + $CheckRule.DisplayName +"] Direction [" + $CheckRule.Direction + "]"
                    WriteLog $LogMessage "ERRr" $Verbose
                }
		if ($Profile -ne "")
		{
			$LogMess = "$FuncName Set Profile [$Profile] for rule [" + $DRule.Name + "]"
		      	WriteLog $LogMess "DUMP" $Verbose

			Set-NetFirewallRule -Name $DRule.Name -Profile $Profile -ErrorAction SilentlyContinue
			
			#check
			$CheckRule = Get-NetFirewallRule -Name $DRule.Name
			if ($CheckRule.Profile -eq $Profile)
			{
				$LogMess = "$FuncName Set Profile [$Profile] for [" + $CheckRule.Direction + "] rule [" + $CheckRule.Name + "] done"
			      	WriteLog $LogMess "INFO" $Verbose
			}
			else
			{
				$LogMess = "$FuncName Can't Set Profile [$Profile] for rule [" + $CheckRule.Name + "] exist profile ["+ $CheckRule.Profile  +"]"
			      	WriteLog $LogMess "ERRr" $Verbose
			}
		}
            }
        }
    }
}


function DeleteFireWallRule()
{

    PARAM (
        [string]$RuleName = "",
        #[string]$RuleDisplayName = "",
        #[string]$RuleDirection = "",
   		[switch]$Verbose = $FALSE		# говорливость в консоль

    )

    
  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

  	WriteLog "$FuncName Delete Firewall rule function. Request for del [$RuleName] [$RuleDisplayName]" "DUMP" $Verbose

    $Rule = Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue

    if ($Rule.Name -eq $RuleName) 
    {
        WriteLog "$FuncName Rule [$RuleName] is exist. Try to Remove" "DUMP" $Verbose

        Remove-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue

        $Rule = Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue

        if ($Rule.Name -ne $RuleName) 
        {
            WriteLog "$FuncName Rule [$RuleName] deleted" "MESS" $Verbose
        }
        else
        {
            WriteLog "$FuncName Rule [$RuleName] can't delete" "ERRr" $Verbose
        }
    
    }
    else
    {
      	WriteLog "$FuncName Rule [$RuleName] doesn't exist" "INFO" $Verbose
    }

    
}



# Backup Enabled FireWall rules list to log file
Function BackUpFireWallRulesList()
{
    PARAM (
        [string]$Direction = "All",
   		[switch]$Verbose = $FALSE		# говорливость в консоль
    )
  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

  	WriteLog "$FuncName Backup Enabled FireWall rules list to log file. Direction [$Direction]" "INFO" $Verbose


    $FWRules = Get-NetFirewallRule

    $RuleList = "";

    foreach ($DRule in $FWRules)
    {
        #$DRule.Name
        # if specified direction
        if (($DRule.Direction -eq $Direction) -or ($Direction -eq "All"))
        {
            # if specified Enable
            if ($DRule.Enabled -eq "True")
            {
            
                $RuleList = $RuleList + "Name: " + $DRule.Name + "`n"
                $RuleList = $RuleList + "DisplayName: " + $DRule.DisplayName + "`n"
                $RuleList = $RuleList + "Description: " + $DRule.Description + "`n"
                $RuleList = $RuleList + "Direction: " + $DRule.Direction + "`n"
            }
        }
    }

    $LogMess = "$FuncName Exist Enabled Rules: `n" + $RuleList
  	WriteLog $LogMess "DUMP" $Verbose
  	WriteLog "$FuncName Exist Enabled rules are exported in log file" "MESS" $Verbose

                
}

function  FirewallSetDefaultOutboundAction()
{
    PARAM (
        [string]$Name = "",
   		[string]$DefaultOutboundAction = "",
   		[switch]$Verbose = $FALSE		# говорливость в консоль
    )
  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

  	WriteLog "$FuncName Set DefaultOutboundAction [$Name] for firewall profile [$DefaultOutboundAction]" "DUMP" $Verbose

    if (($Name -ne "") -and ($DefaultOutboundAction -ne ""))
    {
        $FirewallProfile = Get-NetFirewallProfile -Name $Name -ErrorAction SilentlyContinue
        
        if ($FirewallProfile.Name -ne $Name)
        {
          	WriteLog "$FuncName Set FirewallProfile [$Name] doesn't exist" "ERRr" $Verbose
        }
        elseif($FirewallProfile.DefaultOutboundAction -eq $DefaultOutboundAction)
        {
          	WriteLog "$FuncName FirewallProfile [$Name] already has DefaultOutboundAction [$DefaultOutboundAction]" "INFO" $Verbose
        }
        else
        {
          	WriteLog "$FuncName FirewallProfile [$Name] exist. tru to set DefaultOutboundAction [$DefaultOutboundAction]" "DUMP" $Verbose
            Set-NetFirewallProfile -Name $Name -DefaultOutboundAction $DefaultOutboundAction

            $FirewallProfile = Get-NetFirewallProfile -Name $Name -ErrorAction SilentlyContinue
            if ($FirewallProfile.DefaultOutboundAction -eq $DefaultOutboundAction)
            {
              	WriteLog "$FuncName FirewallProfile [$Name]. Set DefaultOutboundAction [$DefaultOutboundAction] DONE" "MESS" $Verbose
            }
            else
            {
              	WriteLog "$FuncName Can't set  DefaultOutboundAction [$DefaultOutboundAction] in FirewallProfile [$Name]" "ERRr" $Verbose
            }
        }
    }
    else
    {
      	WriteLog "$FuncName DefaultOutboundAction [$Name] and/or profile [$DefaultOutboundAction] are't specified" "ERRr" $Verbose
    }
    

}
#Get-NetFirewallRule -DisplayName "Основы сетей - DNS (UDP - исходящий трафик)"


#=================================================

WriteLog "Установка правил Windows Firewall" "INFO"
WriteLog "Версия: $version" "INFO"

# проверка наличия административных привилегий. если их нет - отваливаемся
if(isAdmin)
{
	WriteLog "Админские права: есть." "MESS"
};


if ((InstallModuleIfNotExist -ModuleName "NetSecurity" -Verbose $TRUE) -ne $TRUE)
{
	WriteLog "Module doen't exist. Can't continue. Exit" "ERRr"
    break;
}



#Create Sheduled task for disable Windows Firewall (task will run every 1 hour)

$TakName = "DisableFirewall"

$ShTask = Get-ScheduledTask -TaskName $TakName -ErrorAction SilentlyContinue

if ($ShTask.TaskName -eq $TakName)
{
    Unregister-ScheduledTask -TaskName $TakName -Confirm:$false
  	WriteLog "Delete exist Sheduled task [$TakName]" "MESS"

}

# Create sheduled task for disable firewall
if ($SheduledTask -eq $TRUE)
{ 
	$action = New-ScheduledTaskAction -Execute '%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe' `
	            -Argument '-NoProfile -command "& {Set-NetFirewallProfile -Enabled False;}"'
	$trigger = New-ScheduledTaskTrigger `
	    -Once `
	    -At (Get-Date) `
	    -RepetitionInterval (New-TimeSpan -Minutes 60) `
	    -RepetitionDuration ([System.TimeSpan]::MaxValue)
	$option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
	# $option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$STSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
	#Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TakName -Description "Disable windows firewall" -User $AdminLogin -Password $AdminPassword -RunLevel Highest #-Principal $principal
	Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TakName -Description "Disable windows firewall" -Principal $principal -Settings $STSettings #-ScheduledJobOption $option1


	#-User "$env:USERDOMAIN\$env:USERNAME" `
	#                       -Password 'P@ssw0rd' `

	# Enable-ScheduledTask 
	# Disable-ScheduledTask 
}



#EnableFireWallRule -RuleName "RRAS-GRE-Out" -RuleDirection "Outbound"


#disable FireWall
WriteLog "Try to disable FireWall" "DUMP"
Set-NetFirewallProfile -Enabled False

$FireWallProfile = Get-NetFirewallProfile
if ($FireWallProfile.Enabled -eq "False") 
{
    WriteLog "FireWall Disabled" "MESS"
}
else 
{
    WriteLog "ATTENTION FireWall ENABLED. Recomended to stop script (Ctrl-C)" "WARN"
    WriteLog "Or waiting 120 sec and continue" "INFO"
    Start-Sleep -Seconds 120; 
}



# Backup Enabled FireWall rules list to log file
BackUpFireWallRulesList -Direction "All" -Verbose $TRUE


#Delete Old Rule
DeleteFireWallRule -RuleName "Shturman.RDP-In" -Verbose $TRUE

CreateFireWallRule -RuleName "Shturman.RDP-In" -RuleDisplayName "Shturman.RDP" -RuleDescription "RDP Access from Shturman Department" `
                    -RuleDirection "Inbound" -RuleProfile "Any" -RuleProtocol "TCP" -RuleLocalPort "3389" -RuleRemotePort "" -Verbose $TRUE
WriteLog "Try to set [RemoteAddress 172.16.30.0/24, 109.188.130.109, 192.168.43.0/24, 185.15.189.99, 10.110.95.0/24, 10.168.102.0/24] for rule [Shturman.RDP-In]" "DUMP"
$result = Set-NetFirewallRule -Name "Shturman.RDP-In" -RemoteAddress 172.16.30.0/24, 109.188.130.109, 192.168.43.0/24, 185.15.189.99, 10.110.95.0/24, 10.168.102.0/24, 80.76.243.254


# Disable all FireWall rules exept created "Shturman.RDP"
DisableFireWallRules -ExceptRuleName "Shturman.RDP-In" -RuleDirection "Inbound" -RuleEnabled "True" -Verbose $TRUE
DisableFireWallRules -ExceptRuleName "Shturman.PORTS-Out" -RuleDirection "Outbound" -RuleEnabled "True" -Verbose $TRUE


#Delete Old Rule
DeleteFireWallRule -RuleName "Shturman.PORTS-Out" -Verbose $TRUE
DeleteFireWallRule -RuleName "HTTP.80.8080-Out" -Verbose $TRUE
DeleteFireWallRule -RuleName "HTTPS.SSL-Out" -Verbose $TRUE
#Remove-NetFirewallRule -Name "Shturman.PORTS" -ErrorAction SilentlyContinue
#Remove-NetFirewallRule -Name "HTTP.80.8080" -ErrorAction SilentlyContinue

# Shturman outgoing Rule (Ports 45780-45800
CreateFireWallRule -RuleName "Shturman.PORTS-Out" -RuleDisplayName "Shturman PORTS (45780-45800)" -RuleDescription "Shturman outgoing ports" `
                    -RuleDirection "Outbound" -RuleProfile "Any" -RuleProtocol "TCP" -RuleLocalPort "" -RuleRemotePort "45780-45800" -Verbose $TRUE

CreateFireWallRule -RuleName "HTTPS.SSL-Out" -RuleDisplayName "HTTPS SSL (443)" -RuleDescription "SSL ports" `
                    -RuleDirection "Outbound" -RuleProfile "Any" -RuleProtocol "TCP" -RuleLocalPort "" -RuleRemotePort "443" -Verbose $TRUE

CreateFireWallRule -RuleName "HTTP.80.8080-Out" -RuleDisplayName "HTTP (80, 8080)" -RuleDescription "HTTP Ports 80 and 8080" `
                    -RuleDirection "Outbound" -RuleProfile "Any" -RuleProtocol "TCP" -RuleLocalPort "" -RuleRemotePort "" -Verbose $TRUE
WriteLog "Try to set [RemotePort 80, 8080] for rule [HTTP.80.8080-Out]" "DUMP"
Set-NetFirewallRule -Name "HTTP.80.8080-Out" -RemotePort 80, 8080



#Set-NetFirewallSetting -
#Get-NetFirewallProfile
FirewallSetDefaultOutboundAction -Name "Private" -DefaultOutboundAction "Block" -Verbose $TRUE
FirewallSetDefaultOutboundAction -Name "Public" -DefaultOutboundAction "Block" -Verbose $TRUE
FirewallSetDefaultOutboundAction -Name "Domain" -DefaultOutboundAction "Block" -Verbose $TRUE

# Ret rule details
# Get-NetFirewallRule -DisplayName "Общий доступ к файлам и принтерам (SMB - исходящий)"

EnableFireWallRule -RuleName "RRAS-GRE-Out" -RuleDirection "Outbound" -Profile "Any" -Verbose $TRUE
EnableFireWallRule -RuleName "RRAS-PPTP-Out-TCP" -RuleDirection "Outbound" -Profile "Any" -Verbose $TRUE
EnableFireWallRule -RuleName "FPS-ICMP4-ERQ-Out-NoScope" -RuleDirection "Outbound" -Profile "Public" -Verbose $TRUE
EnableFireWallRule -RuleName "FPS-ICMP4-ERQ-Out" -RuleDirection "Outbound" -Profile "Public, Private" -Verbose $TRUE
EnableFireWallRule -RuleName "FPS-SMB-Out-TCP-NoScope" -RuleDirection "Outbound" -Profile "Any" -Verbose $TRUE
EnableFireWallRule -RuleName "FPS-SMB-Out-TCP" -RuleDirection "Outbound" -Profile "Public, Private" -Verbose $TRUE
EnableFireWallRule -RuleName "CoreNet-IPHTTPS-Out" -RuleDirection "Outbound" -Profile "Any" -Verbose $TRUE
EnableFireWallRule -RuleName "CoreNet-DHCP-Out" -RuleDirection "Outbound" -Profile "Any" -Verbose $TRUE
EnableFireWallRule -RuleName "CoreNet-DNS-Out-UDP" -RuleDirection "Outbound" -Profile "Any" -Verbose $TRUE

$ShTask = Get-ScheduledTask -TaskName $TakName -ErrorAction SilentlyContinue
if (($ShTask.TaskName -ne $TakName) -and ($SheduledTask -eq $TRUE))
{
  	WriteLog "Sheduled task [$TakName] for automaticaly disable firewall isn't created. Firewall still DISABLED" "ERRr"

}
else
{
	if ($SheduledTask -eq $FALSE)
	{
	  	WriteLog "Sheduled task [$TakName] for automaticaly disable firewall isn't created. It's Dangerous" "WARN"
	}
    #Enable FireWall
    Set-NetFirewallProfile -Enabled True

    $FireWallProfile = Get-NetFirewallProfile
    if ($FireWallProfile.Enabled -eq "True") 
    {
        WriteLog "FireWall Enabled" "MESS"
    }
    else 
    {
        WriteLog "ATTENTION FireWall DISABLED." "ERRr"
    }
}


WriteLog "Job Done. Hackers crying" "INFO"
