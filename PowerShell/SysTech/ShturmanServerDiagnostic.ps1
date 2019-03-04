
<#
    1. Shturman Servers Simple Diagnostic
	- TODO Проверка живости базы (выборка по нескольким таблицам, проверяем сколько дней/часов назад последний раз писалось в таблицу
	  TODO Выбираем такие таблицы, в которых данные меняются постоянно.)
	- *.Errors files только за последнюю неделю + общее количество.
	  Если нет за последнюю неделю, то красить в желтый общее количество
    - TODO Объем занятой памяти
    - сколько времени назад записана последняя строчка в лог (минут/часов/дней - 15м / 1ч / 12д)
      Если файла лога за сегодня нет - пишет N/A красного цвета

	- Объем файлов *.queue в кб. 
	- *.Frames Count с разделением по сервисам
	- *.Messages Count
	- FreeSpace (Gb) на нескольких дисках
	- *.Errors files списком

New:

1.0.1
	объем занимаемой памяти процессами теперь 64-х битный (нет ухода в отрицательные значения)
1.0.0
    Все
#>


param (

    [string]$ConfigFile = "ShturmanServerDiagnostic_Params.ps1",

	[array]$FileMask = ("*.Frames","*.Messages"),
	[array]$FileMaskGroupName = ("Frames","Messages"),  # Имя группы параметров для вставки в БД
	[string]$ServerName = "Root", # Название для шапки (в скрипте)
	[string]$ServerAlias = "Root", # Реальный алиас хабсервера из ini файла
	[string]$ServerDriveSystem = "C:",
	[string]$ServerDriveShturman = "D:",
	[string]$ServerLocalPath = "D:\Shturman",
	[string]$ServerLocalQueuePath = "D:\Shturman\Bin",
	[string]$ServerLocalLogPath = "D:\Shturman\Bin\Log",
	[string]$ServerLocalErrorsPath = "D:\Shturman\Bin\Log\Errors",
	[string]$ServerLocalMessagesAndFramesPath = "D:\Shturman\Bin\Log",
	[array]$ServerServicesLogRequired = 
                                        ("BOINorms","Data","Diag","FOS","Hub","Log","Location","RRs","Update"),
#                                        ("BOINorms","Data","FOS","Hub","Log","Location","RRs"),
#                                        ("Hub","Log"),
#                                        ("Https", "Data","Hub","Log","Solver"),
#                                        ("Https", "Data","Hub","Log","Fresher","Solver","DataTransfer"),
	[array]$ServerServicesExeRequired = 
                                        ("BOINormsServer","DataStorageServer","DiagServer","FOSServer","HubServer","LogServer3","MetroLocationsServer","RRsServer","UpdateServer"),
#                                        ("BOINormsServer","DataStorageServer","FOSServer","HubServer","LogServer3","MetroLocationsServer","RRsServer"),
#                                        ("HubServer","LogServer3"),
#                                        ("HttpsServer", "DataStorageServer","HubServer","LogServer","SolverServer"),
#                                        ("HttpsServer", "DataStorageServer","HubServer","LogServer","FresherServer","SolverServer","DataTransferServer")
	[array]$ServiceNameExeExclude = ("HttpsServer"),



	[string]$SQLServerAddress = "localhost",
	[string]$SQLServerDBName = "DBName", # имя БД
#                                "Shturman3"# имя БД
	[string]$SQLServerUserName = "SQLLogin", # пользователь БД
	[string]$SQLServerUserPass = "SQLPassword", # Пароль пользоателя БД

    [bool]$SQL = $FALSE,

    [string]$SQLFolderName = 'ShturmanServerDiagnostic_SQL',

	[array]$SQLQueries = ( # Выполняемые запросы
                            (
                                "Block Conn Time (ago)",
                                "SELECT TOP 1 CONCAT(DateDiff(SECOND,MAX([Connected]),GetDate()), 's') FROM [servers] WHERE [SerialNo] LIKE 'STB%'",  # Запрос
#                                ("Root4","SupRoot","Root3","Anal")  # Сервера
                                ("Root4")  # Сервера
                            ),
                            (
                                "Drivers on trains",
                                "SELECT count(*) FROM SensorsCardio sc, Sensors s, Servers sv, Vehicles ve, MetroTrains mt, users u, persons p where sc.Guid = s.guid and sc.UserGuid = u.Guid and u.PersonsGuid = p.Guid and sc.ServersGuid =sv.Guid and ve.Guid = mt.Guid and mt.IsActive = 1 and sc.IsConnected = 1  and sc.UserGuid = ve.UsersGuid",
#                                ("Root4","SupRoot","Root3","Anal")
                                ("Root4")
                            )
                         ),



	[array]$ServiceNameExe = ("HttpsServer", "BOINormsServer","DataStorageServer","DataProcServer","DiagServer","FOSServer","HubServer","LogServer","LogServer3","MetroLocationsServer","RRsServer","UpdateServer","FresherServer","SolverServer","DataTransferServer", "ShturmanHub"),
    [array]$ServiceNameLog = ("Https", "BOINorms","Data","DataProc","Diag","FOS","Hub","Log","Log","Location","RRs","Update","Fresher","Solver","DataTransfer", "ShturmanHub"), #  имя используемое джля формирование лог файлов
    [array]$ServiceName = ("Https", "BOI","Data","DataProc","Diag","FOS","Hub","Log","Log","Location","RRs","Update","Fresher","Solver","DataTransfer"), #  имя используемое джля формирование лог файлов

#	[switch]$NoWait = $FALSE,		# не ждать после завершения
	[switch]$NoWait = $TRUE,		# не ждать после завершения

	[switch]$Debug = $FALSE		# в консоль все события лога пишет
#	[switch]$Debug = $TRUE		# в консоль все события лога пишет
)

$version = "1.0.1";

# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptFileName = $MyInvocation.MyCommand.Name
$ScriptBaseName = $ScriptFileName -replace ".ps1", ""
#$ScriptName = $MyInvocation.MyCommand.Definition # Full Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

.$ScriptDir\$ConfigFile

#echo $ScriptDir"\..\Functions\Functions.ps1"
#exit 
clear;
WriteLog "Simplify diagnostic tool for Shturman Servers" "INFO"
WriteLog "Script version: [$version]" "INFO"

# ===============================================
#                   Functions
# ===============================================

$ScriptResult = "";

function WriteResult()
{
    param (
    	[string]$Text = "",
    	[string]$Color = ""
    )


    if ($Color -ne "")
    {
        Write-Host $Text -ForegroundColor $Color
    }
    else
    {
        Write-Host $Text
        $ScriptResult += $ScriptResult;

    }
    #$ResultFileFullPath
#    $Text | Out-File $ResultFileFullPath -Encoding "default" -Append

}

function WriteResultLine()
{
    param (
    	[string]$Name = "",
    	[array]$Cols = "",
    	[string]$Color = ""
    )

    $ResultLine = $Name

    WriteResult -Text $ResultLine -Color $Color
}


#    WriteResultLine -Name "Queue sizes (kb)" -Cols ($result[0], $result[1], $result[2], $result[3], $result[4]) -Color $Color


# ===============================================
#                   Script
# ===============================================


# -----------------------------
#         Queue size 
# -----------------------------

WriteLog "Start Processing: [Queue]" "INFO"

if ("Queue")
{

    WriteResult -Text "---------------------------        Queue Size        ---------------------------" -Color "Green"

    if (Test-Path -Path $ServerLocalQueuePath)  # Если путь отсутвует пишем N/A в результатах
    {
            $res = Get-ChildItem -Path $ServerLocalQueuePath -Filter "*.queue" | Measure-Object -Sum Length
            
            $resX =  $res.Sum
            $resX = [math]::Round($resX, 0)
        
            $result =   $resX.ToString()
        
    }
    Else
    {
        $result = "N/A"
    }
    
    $sResult = "$ServerName;Queue;QueueSizes;$result"
    $ScriptResult += $sResult+"`n";
    WriteResultLine -Name $sResult -Cols $result -Color $Color
    $Color = ""
}

WriteLog "Start Processing: [Frames/Messages count]" "INFO"

# -----------------------------
#    Frames,  Messages count 
# -----------------------------
for($i=0; $i -lt $FileMask.Count; $i++)
{
    WriteResult -Text ("---------------------------     " + $FileMask[$i] + " Count     ---------------------------") -Color "Green"

    for($sn=0; $sn -lt $ServiceNameExe.Count; $sn++)
    {
        
        if ($ServiceNameExe[$sn] -notin $ServiceNameExeExclude )
        {
            # Сбрасываем результаты проверок, дабы небыло наводок
            $result = "";
    
            $FileExt = $FileMask[$i] -replace "\*", ""
            $FullFilePath = "$ServerLocalMessagesAndFramesPath\"+$ServiceNameExe[$sn]+"$FileExt"
            
            #Get-Content -Path $FullFilePath

            if (Test-Path -Path $FullFilePath)
            {
                $lines = Get-Content -Path $FullFilePath | where {$_ -match ''};
    
                foreach ($line in $lines)
                {
                    $lineUTF = psiconv -f "utf-8" -t "windows-1251" -string $line
                    # Вычленяем из строки количество
                    $matchWin1251 = [regex]::Match($line,"Фреймов: ([0-9]*) шт.")
                    #$matchWin1251
                    $matchUTF = [regex]::Match($lineUTF,"Фреймов: ([0-9]*) шт.")
                    #$matchUTF
                    if ( $matchWin1251.Value -ne "" )
                    {
                        $match = $matchWin1251.Value
                    }
                    else
                    {
                        $match = $matchUTF.Value
                    }

                    $FramesCount = $match -replace "Фреймов: ", ""
                    $FramesCount = $FramesCount -replace " шт.", ""
                    #$FramesCount
                    if ($FramesCount -ne "")
                    {
                        $result = $FramesCount

                    }


                    # Вычленяем из строки количество
                    $matchWin1251 = [regex]::Match($line,"Сообщений: ([0-9]*) шт.")
                    #$matchWin1251
                    $matchUTF = [regex]::Match($lineUTF,"Сообщений: ([0-9]*) шт.")
                    #$matchUTF
                    if ( $matchWin1251.Value -ne "" )
                    {
                        $match = $matchWin1251.Value
                    }
                    else
                    {
                        $match = $matchUTF.Value
                    }


                    #$match = [regex]::Match($line,"Сообщений: ([0-9]*) шт.")
                    #$MesagesCount = $match.Value -replace "Сообщений: ", ""
                    $MesagesCount = $match -replace "Сообщений: ", ""
                    $MesagesCount = $MesagesCount -replace " шт.", ""
    
                    if ($MesagesCount -ne "")
                    {
                        $result = $MesagesCount
    
                    }

                    $match = ""
                }
            }
            else
            {
                $result = "--"
            }


            if ( ($result -eq "--") -and ($ServerServicesExeRequired -contains $ServiceNameExe[$sn] ) )
            {
                $result = "N/A"
            }
            if ($result -ne "--")
            {
                $sResult = "$ServerName;"+$FileMaskGroupName[$i]+";"+$ServiceNameExe[$sn]+";$result"
                    $ScriptResult += $sResult+"`n";
                WriteResultLine -Name $sResult -Cols $result -Color $Color
            }
            $Color = ""
        }
        else
        {
        #    echo "Skip HTTPS"
        }
    }
}

#break;

# -----------------------------
#         Last Log Activity
# -----------------------------
WriteLog "Start Processing: [LastLogActivity]" "INFO"

if ("LastLogActivity")
{
 
    WriteResult -Text ("---------------------------     Last Log Activity (sec ago)      ---------------------------") -Color "Green"

    for($sn=0; $sn -lt $ServiceNameLog.Count; $sn++)
    {

        # Сбрасываем результаты проверок, дабы небыло наводок
        $result = "";

        $FileExt = ".log" # $FileMask[$i] -replace "\*", ""
        #$ServiceNameLog[$sn]
        if ($ServiceNameLog[$sn] -eq "Hub")  # подмена префикса имени файла для хаб сервера
        {
            $ServiceNameLogFile = $ServerAlias
            #$ServerAlias
        }
        else
        {
            $ServiceNameLogFile = $ServiceNameLog[$sn]
        }
        $FullFilePath = "$ServerLocalLogPath\$ServiceNameLogFile-" + (Get-Date -Format "yy-MM-dd") + $FileExt
        $FullFilePathDot = "$ServerLocalLogPath\$ServiceNameLogFile-" + (Get-Date -Format "yy.MM.dd") + $FileExt
        if ( Test-Path -Path $FullFilePath )
        {
            $FullFilePath = $FullFilePath
        }
        else 
        {
            $FullFilePath = $FullFilePathDot
        }
        #$FullFilePath 
        #echo $FullFilePath 
        if (Test-Path -Path $FullFilePath)
        {
            #$FullFilePath
            $lines = Get-Content -Tail 1 -Path $FullFilePath  # добываем последнюю строку из лога

           	#$match2 = [regex]::Match($lines,"\[(([0-9]){2,2}:){2,2}([0-9]){2,2}\.([0-9]){1,4}\]") # и это работает (отдает полностью время 18:01:22.545])
           	$match2 = [regex]::Match($lines,"\[([0-9:\.])*\]") #(отдает полностью время 18:01:22.545])
           	#$match2 = [regex]::Match($lines,"(([0-9]){2,2}:){2,2}([0-9]){2,2}") # тоже работает (отдает только время чч:мм:сс)
           	$match3 = [regex]::Match($match2.Value,"(([0-9]){2,2}:){2,2}([0-9]){2,2}") # отдает только время чч:мм:сс.  В две ступени т.к. я параноик.
            #$LogLastTime = $match3.Value # -replace "\[", "" 
            $LogLastTime = $match3.Value.Split(":")

            #$DateDiff = (Get-Date) - (Get-Date -Hour $LogLastTime[0] -Minute $LogLastTime[1] -Second $LogLastTime[2])
            #$result = (Get-Date) - (Get-Date -Hour $LogLastTime[0] -Minute $LogLastTime[1] -Second $LogLastTime[2])
            #"DUMP: $lines"
            #"DUMP: $match2"
            #"DUMP: $match3"
            $ts = New-TimeSpan -start (Get-Date -Hour $LogLastTime[0] -Minute $LogLastTime[1] -Second $LogLastTime[2])
            $result = $ts.TotalSeconds
        }
        else
        {
            # если нет файла, смотрим есть ли он в списке обязательных для этого сервера
            if ($ServerServicesLogRequired -contains $ServiceNameLog[$sn] )
            {
                $result =  "N/A"
            }
            else
            {
                $result =  "--"
            }
        }

        if ( $result -ne "--" )
        {
            $sResult = "$ServerName;LogActivity"+";"+$ServiceNameExe[$sn]+";$result"
            $ScriptResult += $sResult+"`n";
            WriteResultLine -Name $sResult -Cols $result -Color $Color
        }
    }
}


# Сколько памяти / проца сжирают сервисы
WriteLog "Start Processing: [Memory and CPU utilization]" "INFO"

if ( "Memory and CPU utilization" )
{

    WriteResult -Text ("---------------------------     Memory PM/WS/VM, Handles/Threads count       ---------------------------") -Color "Green"
    WriteResult -Text ("---------- Limits: Memory (P)PM / (W)WS / (V)VM: [ $ServiceMaxMemoryPM / $ServiceMaxMemoryWS / $ServiceMaxMemoryVM ] Mb; (H)Handles/(T)Threads: [ $ServiceMaxHandles / $ServiceMaxThreads ]") -Color "Green"

    for($sn=0; $sn -lt $ServiceNameExe.Count; $sn++)
    {
        # Сбрасываем результаты проверок, дабы небыло наводок
        $result = ""
        $Proc = $NULL

        #$ServiceNameExe[$sn]
            
        if ($ServerServicesExeRequired -ccontains $ServiceNameExe[$sn])
        {
           $Proc = Get-Process -Name $ServiceNameExe[$sn] -ErrorAction SilentlyContinue
           #$Proc
           if ($Proc)
           {
                $Handles = $Proc.Handles
                $Threads = $Proc.Threads.Count
                #$PM = $Proc.PM
                $PM = $Proc.PM.PagedMemorySize64
                #$VM = $Proc.VM
                $VM = $Proc.VirtualMemorySize64
                #$WS = $Proc.WS
                $WS = $Proc.WorkingSet64
                $CPU = $Proc.CPU

                $result = "Handles="+$Handles+":Threads="+$Threads+":PM="+$PM+":VM="+$VM+":WS="+$WS+":CPU="+$CPU
            }
            else
            {
                $result = "N/A"
            }

        }
        else
        {
             $result = "--" 
        }

        if ( $result -ne "--" )
        {
            
            $sResult = "$ServerName;Resource"+";"+$ServiceNameExe[$sn]+";$result"
            $ScriptResult += $sResult+"`n";
            WriteResultLine -Name $sResult -Cols $result -Color $Color
        }
    }    
}

#break

# -----------------------------
#         SQL Queries 
# -----------------------------

if ($SQL)
{
    WriteLog "Start Processing: [SQL]" "INFO"

    WriteResult -Text ("---------------------------     SQL Queries Diag       ---------------------------") -Color "Green"
    #WriteResult -Text "---------------------------------" -Color "Green"

    WriteResultLine -Name "Query" -Cols $ServerName -Color "Green"

    #$SQLQueries

    for($sn=0; $sn -lt $SQLQueries.Count; $sn++)
    {
        $Name = $SQLQueries[$sn][0]
        $File = $SQLQueries[$sn][2]
        $FileFullPath = "$ScriptDir\$SQLFolderName\$File"
        $Query = $SQLQueries[$sn][1]

        #WriteLog "`$Name [$Name]" "INFO"
        #WriteLog "`$Query [$Query]" "INFO"
        #WriteLog "`$File [$File]" "INFO"

        # Сбрасываем результаты проверок, дабы небыло наводок
        $result = "";

            $r = "";
            if ( ($File -ne "") -and ($Query -eq "") ) 
            {
                #echo "111111111111"
                if ( Test-Path -Path $FileFullPath )
                {
                    WriteLog "SQL: Process file [$FileFullPath]" "DUMP"

                    $r = Invoke-Sqlcmd -HostName $SQLServerAddress -Username $SQLServerUserName -Password $SQLServerUserPass -Database $SQLServerDBName `
                                        -InputFile "$FileFullPath" #-As DataSet
                    #Write-host "Invoke-Sqlcmd -HostName $SQLServerAddress -Username $SQLServerUserName -Password $SQLServerUserPass `
                    #            -Database $SQLServerDBName -InputFile `"$FileFullPath`""

                }
                else
                {
                    WriteLog "SQL File [$FileFullPath] does not exist" "ERRr"
                }
            }
            else
            {
                $r = Invoke-Sqlcmd -HostName $SQLServerAddress -Username $SQLServerUserName -Password $SQLServerUserPass -Database $SQLServerDBName `
                                    -Query "$Query" # -As DataSet
            }
#            $r
            #$r.Tables[0].Rows # | %{echo "par:$($_['Parameter']);Val:" }
            if ( $r.Length -eq 0 )
            {
                WriteLog "SQL query return error on zero rows. QueryName: [$Name] ; File: [$FileFullPath]" "ERRr"
            }
            foreach ( $d in $r )
            {
                #$r
                $Parameter = $d["Parameter"]
                #$d["Parameter"] + $d["Value"]
                $Value = $d["Value"]
                
                if ( ($Parameter.Length -gt 0) -and ($Value.Length -gt 0) )
                {
                    $sResult = "$ServerName;SQL;$Parameter;$Value"
                    #$sResult
                    $ScriptResult += $sResult+"`n";
                    WriteResultLine -Name $sResult -Cols $result -Color $Color
                }
                else
                {
                    WriteLog "SQL query return error on zero rows. QueryName: [$Name] ; File: [$FileFullPath]" "ERRr"
                }
            }
            
        
#        $sResult = "$ServerName;SQL;"+$SQLQueries[$sn][0]+";$result"
#        $ScriptResult += $sResult+"`n";
#        WriteResultLine -Name $sResult -Cols $result -Color $Color
        #WriteResultLine -Name $SQLQueries[$sn][0] -Cols $result -Color $Color

        
        $Color = ""

    }    
}

#break


# -----------------------------
#         Free Space
# -----------------------------
WriteLog "Start Processing: [FreeSpace]" "INFO"

if ("FreeSpace")
{
    WriteResult -Text "----------------------------       FreeSpace (Gb)       ----------------------------" -Color "Green"

    # reset result variable
    $res1 = ""
    $res2 = ""

    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
    #$disk

    for($i=0; $i -lt $disk.Count; $i++)
    {
        if ( ($disk[$i].DeviceID) -eq $ServerDriveSystem )
        {
            $res1 = "FreeSpace="+($disk[$i].FreeSpace)+":Size="+($disk[$i].Size)+":VolumeName="+($disk[$i].VolumeName)

        }
        if ( ($disk[$i].DeviceID) -eq $ServerDriveShturman )
        {
            $res2 = "FreeSpace="+($disk[$i].FreeSpace)+":Size="+($disk[$i].Size)+":VolumeName="+($disk[$i].VolumeName)
        }
    }

    $sResult = "$ServerName;HDD;System;$res1"
    $ScriptResult += $sResult+"`n";
    WriteResultLine -Name $sResult -Cols $result -Color $Color
    $sResult = "$ServerName;HDD;Shturman;$res2"
    $ScriptResult += $sResult+"`n";
    WriteResultLine -Name $sResult -Cols $result -Color $Color
}

#echo "[$ScriptResult]"


# -----------------------------
#         Errors count 
# -----------------------------
WriteLog "Start Processing: [Errors]" "INFO"

if ("Errors")
{
    WriteResult -Text "----------------------       *.Errors files  (last 7 days)     ---------------------" -Color "Green"

    $ErrorsList = "";
    $ErrorsCnt = 0;
 #   $text =  "Server: " + $ServerName
    #WriteResult -Text $text -Color "Green"

    #$ServerErrorsPath[$i]
    #Test-Path -Path $ServerErrorsPath[$i]
    #echo "Test-Path -Path $ServerLocalErrorsPath"
    if (Test-Path -Path $ServerLocalErrorsPath)
    {
        #$Files = (Get-ChildItem -Path $ServerErrorsPath[$i] -Filter "*.error" -Name | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  })
        $Files = Get-ChildItem -Path $ServerLocalErrorsPath -Filter "*.error"
        #$Files = (Get-ChildItem -Path $ServerErrorsPath[$i] -Filter "*.error" | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  })

        #"Get-ChildItem -Path $ServerErrorsPath[$i] -Filter ""*.error"" -Name | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  }"
        #Get-ChildItem -Path $ServerErrorsPath[$i] -Filter "*.error" -Name | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  }
    
        
        #$errorFilesFound = $FALSE
        
        foreach ($file in $Files)
        {
            if ( $file.CreationTime -ge (Get-Date).AddDays(-7) )
            {
                if ( $ErrorsList -eq "" )
                {
                    $ErrorsList = $file.Name
                }
                else
                {
                    $ErrorsList += ":"+$file.Name
                }
#                WriteResult -Text $text -Color "red"
            }
        }

        $ErrorsCnt = $Files.Count
    }
    Else
    {
        $text =  "No errors Folder found"
        WriteResult -Text $text -Color ""
    }


    $sResult = "$ServerName;Errors;Cnt;$ErrorsCnt"
    $ScriptResult += $sResult+"`n";
    WriteResultLine -Name $sResult -Cols $result -Color $Color
    $sResult = "$ServerName;Errors;Files;$ErrorsList"
    $ScriptResult += $sResult+"`n";
    WriteResultLine -Name $sResult -Cols $result -Color $Color
        
    
}

#$ServerName

WriteLog "Start Uploading to server" "INFO"

#$x = "@{username='me';moredata='qwerty'}";
$postQ = "data=$ScriptResult";

$f = Invoke-WebRequest -Uri http://10.200.24.92/request/serverstatereport.php -Method POST -Body $postQ

echo $f.Content;


if (-not $NoWait)
{
    [int]$SecondsToWait = 600

    WriteLog "Done. This Window will be automaticaly closed after $SecondsToWait seconds" "INFO"


    Start-Sleep -Seconds $SecondsToWait; 
}

