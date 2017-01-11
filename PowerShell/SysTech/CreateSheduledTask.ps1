<#

 Создание Шедульной таски Windows

 Ключи:
	-Debug			- полное логгирование в консоль (серым цветом обычно невидимые сообщения). в лог пишет всегда


 Пример
 .\CreateSheduledTask.ps1 -Name "Reboot PC" -Description "Automaticaly reboot every 1 day at 4 Am" -Execute "shutdown" -Argument "/r /t 0" -Time "04:00:00" -ReCreateIfExist -Interval "day:1"


 Функционал большей частью обернут в функции проверящие выполнение каждого дествия.

 В файл лога (создается в каталоге скрипта с именем ИмяФайлаСкрипта.log)

 При выполнении все должно быть бело-зеленое. В некоторых случаях скрипт сам остановится  
 если заметит что не выполнилось что-то жизненно важное

 При обнаружени косяков - обращатсья на завод изготовитель. 
 
 ==================
 Что делает скрипт: 

 Создает шедульную таску 

#>

param (
	[string]$Name = "NewSheduldTaskFrom PS script",
	[string]$Description = "NewSheduldTask Description",
	[string]$Execute = "notepad.exe",						# Команда
	[string]$Argument = "C:\Windows\WindowsUpdate.log",		# аргументы команды
	[string]$Date = "",			# с какой даты запускать
	[string]$Time = "",			# в какое время
	[string]$Interval = "",		# интервал повторения 'Day:10' или 'Min:15'. нельзя использовать больше 31 дней. минут же может быть много. само конвернет в часы и минуты
#	[string]$AdminLogin = (Write-host Read-Host 'For creating sheduled task required Admin login and password `n Login:'),
#	[string]$AdminPassword = (Read-Host 'Password'),
	[switch]$Unregister = $FALSE,			# Только удаляет таску
	[switch]$ReCreateIfExist = $FALSE,		# Пересоздавать таску если она есть
	[switch]$NoClearScreen = $FALSE,		# Чистить экран консоли в начале выполнения скрипта (в случае встраивания скрипта - отключить можно)
	[switch]$Debug = $FALSE		# в консоль все события лога пишет
)

if ($NoClearScreen -eq $FALSE) { clear; }  # # Чистить экран консоли в начале выполнения скрипта, если не запрещено ключем
$version = "1.0.0";


#Enable All log messages in console
$Debug = $TRUE;


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


function ParseDate()
{
    param (
    	[string]$Date = "",				# Required '25/12/2015' 'dd/mm/YYYY'"
    	[string]$Time = "",				# Required '15:10:13' 'hh:mm:ss'"
    	[switch]$Verbose = $FALSE,		# Говорливость в лог
    	[switch]$Debug = $FALSE			# в консоль все события лога пишет
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
# END Base Functions




#=================================================


#$Interval = "Day:40"

function ParseInterval()
{
    param (
    	[string]$Interval = "",			# Required 'Day:10' or 'Min:10'
    	[switch]$Verbose = $FALSE,		# Говорливость в лог
    	[switch]$Debug = $FALSE			# в консоль все события лога пишет
    )

  	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";


#$Interval.Substring(0,4)
#$Interval.Substring(4)
    if ($Interval.Substring(0,4).ToLower() -eq "day:")
    {
        
        return New-TimeSpan -Days $Interval.Substring(4)
    }
    elseif  ($Interval.Substring(0,4).ToLower() -eq "min:")
    {
        return New-TimeSpan -Minutes $Interval.Substring(4)
    }
    else
    {
        WriteLog "$FuncName Incorrect Interval format: [$Interval]. Required 'Day:10' or 'min:15'" "ERRr" $Verbose
    }
}


WriteLog "Создание Шедульной таски" "INFO"
WriteLog "Версия: $version" "INFO"

# проверка наличия административных привилегий. если их нет - отваливаемся
if(isAdmin)
{
	WriteLog "Админские права: есть." "MESS"
};



#Create Sheduled task for disable Windows Firewall (task will run every 1 hour)


WriteLog "Run with params: TaskName: [$Name]; Description: [$Description]; Execute: [$Execute] with Argument: [$Argument]" "INFO"




# Проверяем существует ли уже таска с таким названием
$ShTask = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

#$ShTask

if (($ReCreateIfExist -or $Unregister) -and ($ShTask.TaskName -eq $Name)){
    # удаляем существующую таску
    Unregister-ScheduledTask -TaskName $Name -Confirm:$false
  	WriteLog "Delete exist Sheduled task [$Name]" "MESS"
}
elseif ($ShTask.TaskName -eq $Name)
{
    # Заканчиваем с ошибкой т.к. таска уже существует
  	WriteLog "Sheduled task [$Name] already exist." "WARN"
    break;
}



if ($Unregister)
{
    break;
}
else
{
    # Create sheduled task 
	$action = New-ScheduledTaskAction -Execute $Execute `
	            -Argument $Argument

    $RunAt = ParseDate -Date $Date -Time $Time -Verbose # Переводим то что дал пользователь в дату-время. либо берем сегодняшнюю если не сказал ничего
    #ParseInterval -Interval $Interval

    #$RepetitionInterval = New-TimeSpan -Minutes 55
    #$RepetitionInterval = New-TimeSpan -Days 10
    $RepetitionInterval = ParseInterval -Interval $Interval -verbose

    #$RepetitionInterval

	$trigger = New-ScheduledTaskTrigger `
	    -Once `
	    -At ($RunAt) `
	    -RepetitionInterval ($RepetitionInterval) `
	    -RepetitionDuration ([System.TimeSpan]::MaxValue)
	$option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
	# $option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$STSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
	#Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "Disable windows firewall" -User $AdminLogin -Password $AdminPassword -RunLevel Highest #-Principal $principal
	Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $Name -Description $Description -Principal $principal -Settings $STSettings #-ScheduledJobOption $option1


	#-User "$env:USERDOMAIN\$env:USERNAME" `
	#                       -Password 'P@ssw0rd' `

	# Enable-ScheduledTask 
	# Disable-ScheduledTask 
}



#EnableFireWallRule -RuleName "RRAS-GRE-Out" -RuleDirection "Outbound"


#"Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue"
#Get-ScheduledTask -TaskName "$TaskName"

$ShTask = Get-ScheduledTask -TaskName "$Name" -ErrorAction SilentlyContinue
#$ShTask
if ($ShTask.TaskName -eq $Name)
{
  	WriteLog "Sheduled task [$Name] created." "MESS"

}
else
{
	WriteLog "Sheduled task [$Name] isn't created." "ERRr"
}


WriteLog "Job Done." "INFO"
