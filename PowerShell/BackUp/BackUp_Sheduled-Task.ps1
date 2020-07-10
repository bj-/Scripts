function BackUp_SheduledTask()
{
    $ModVer = "1.0.1"
    $ModName = "SheduledTask"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"

	if(isAdmin)
	{
		WriteLog "Админские права: есть." "MESS"
	};
	#WriteLog "NO FUNCTIONALE (c) Kuba's taxist" "ERRr"
    $Name = "BackUp Logs, Fileas and Folders, SQL DB"
    $Description = "Automatic BackUp and purge old BackUps"

    #WriteLog "Run with params: TaskName: [$Name]; Description: [$Description]; Execute: [$Execute] with Argument: [$Argument]" "INFO"
    WriteLog "Will Create Sheduled task for Script: TaskName: [$Name]" "INFO"

    # Проверяем существует ли уже таска с таким названием
    $ShTask = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

    #$ShTask

    if ( ($ShTask.TaskName -eq $Name) )
    {
        # удаляем существующую таску
        Unregister-ScheduledTask -TaskName $Name -Confirm:$false
      	WriteLog "Delete exist Sheduled task [$Name]" "MESS"

        $ShTask = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

        if ($ShTask.TaskName -eq $Name)
        {
            # Заканчиваем с ошибкой т.к. таска уже существует
      	    WriteLog "Sheduled task [$Name] already exist. And can't be delete" "WARN"
            break;
        }
    }


    # Create sheduled task 
 	$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
                                      -Argument "$ScriptFullPath -UseSettingsFile"
    
    #$RunAt = ParseDate -Date $Date -Time $Time -Verbose # Переводим то что дал пользователь в дату-время. либо берем сегодняшнюю если не сказал ничего
    #$RunAt = Get-Date
    #$RunAt = "10/10/2020"
    #ParseInterval -Interval $Interval

    #$RepetitionInterval = New-TimeSpan -Minutes 55
    #$RepetitionInterval = New-TimeSpan -Days 10
    #$RepetitionInterval = ParseInterval -Interval $Interval -verbose
    #$RepetitionInterval = New-TimeSpan -Days 1
    #$RepetitionInterval =  1

    #$RepetitionInterval

	#$trigger = New-ScheduledTaskTrigger `
	#    -Once `
	#    -At ($RunAt) `
	#    -RepetitionInterval ($RepetitionInterval) `
	#    -RepetitionDuration ([System.TimeSpan]::MaxValue)
    $trigger = New-ScheduledTaskTrigger -At 00:10:00 -Daily
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
}