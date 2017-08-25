
<#
    1. Shturman Servers Simple Diagnostic
	- TODO Проверка живости базы (выборка по нескольким таблицам, проверяем сколько дней/часов назад последний раз писалось в таблицу
	  TODO Выбираем такие таблицы, в которых данные меняются постоянно.)
	- *.Errors files только за последнюю неделю + общее количество.
	  TODO Если нет за последнюю неделю, то красить в желтый общее количество

	- Объем файлов *.queue в кб. 
	- *.Frames Count с разделением по сервисам
	- *.Messages Count
	- FreeSpace (Gb) на нескольких дисках
	- *.Errors files списком

New:

1.0.2
	- *.Errors files только за последнюю неделю + общее количество.
	- [#] Если не подконнектиться к серверу - сообщает об этом, а не кидает ошибку.
1.0.1
    Все
#>


param (
	[string]$FilePath = "D:\Shturman\Bin\Log",
	[array]$FileMask = ("*.Frames","*.Messages"),
	[array]$ServerName = ("Root","SuperRoot","Gate02","Gate03","Anal"),
	[array]$ServerAddress = ("10.200.24.85","10.200.24.83","10.200.24.81","10.200.24.88","10.200.24.92"),
	[array]$ServerPath = ("\\10.200.24.85\D$\Shturman","\\10.200.24.83\D$\Shturman","\\10.200.24.81\D$\Shturman","\\10.200.24.88\D$\Shturman","\\10.200.24.92\D$\Shturman"),
	[array]$ServerMessagesAndFramesPath = (($ServerPath[0]+"\Bin\Log"),($ServerPath[1]+"\Bin\Log"),($ServerPath[2]+"\Bin\Log"),($ServerPath[3]+"\Bin\Log"),($ServerPath[4]+"\Bin\Log")),
	[array]$ServerQueuePath = (($ServerPath[0]+"\Bin"),($ServerPath[1]+"\Bin"),($ServerPath[2]+"\Bin"),($ServerPath[3]+"\Bin"),($ServerPath[4]+"\Bin")),
	[array]$ServerErrorsPath = (($ServerPath[0]+"\Bin\Errors"),($ServerPath[1]+"\Bin\Errors"),($ServerPath[2]+"\Bin\Errors"),($ServerPath[3]+"\Bin\Errors"),($ServerPath[4]+"\Bin\Errors")),

	[array]$ServerDriveSystem = ("C:","C:","C:","C:","C:"),
	[array]$ServerDriveShturman = ("D:","D:","D:","D:","D:"),
	#[array]$ServerDriveAdditional = (":",":",":"),

	[array]$ServiceName = ("BOINormsServer","DataStorageServer","DataProcServer","DiagServer","FOSServer","HubServer","LogServer","MetroLocationsServer","RRsServer","UpdateServer","FresherServer","SolverServer"),

	[int]$FramesMaxCount = 500,
	[int]$MesagesMaxCount = 500,
	[int]$ServerQueueMaxSize = 500,

	[string]$ResultFilePath = "D:\Shturman\Diag",

	[switch]$NoWait = $FALSE,		# не ждать после завершения

#	[switch]$Debug = $FALSE		# в консоль все события лога пишет
	[switch]$Debug = $TRUE		# в консоль все события лога пишет
)



$version = "1.0.1";

<#
for($i=0; $i -lt $ServerErrorsPath.Count; $i++)
{
write-host $ServerErrorsPath[$i]
}
break
#>

# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

clear;
WriteLog "Simplify diagnostic tool for Shturman Servers" "INFO"
WriteLog "Script version: [$version]" "INFO"

# ===============================================
#                   Functions
# ===============================================

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
    }
    #$ResultFileFullPath
    $Text | Out-File $ResultFileFullPath -Encoding "default" -Append

}

# ===============================================
#                   Script
# ===============================================

# Result file

[string]$DateFormat = "yyyy-MM-dd_HH-mm-ss";
$currDateTime = Get-Date -Format $DateFormat
$ResultFileFullPath = $ResultFilePath + "\ServerSimpleDiag_" + $currDateTime + ".txt"

TestFolderPath -Path $ResultFilePath -Create


WriteResult -Text ("Execution time: $currDateTime")

#$ResultFileFullPath
#"ddddd" | Out-File $ResultFileFullPath -Encoding "default" -Append


#WriteResult -Text "DDDDDDD" -Color "Green"

#break

# -----------------------------
#         Queue size 
# -----------------------------

if ("Queue")
{

    WriteResult -Text "---------------------------        Queue Size        ---------------------------" -Color "Green"

    $TableHeader = "Service_Name" + (' ' * (25-("Service_Name").Length)) + "	" + $ServerName[0] + "	" + $ServerName[1] + "        	" + $ServerName[2] + "      	" + $ServerName[3] + "      	" + $ServerName[4];
    WriteResult -Text $TableHeader -Color "Green"

    [array]$result = "","","","","";

    for($i=0; $i -lt $ServerQueuePath.Count; $i++)
    {

    if (Test-Path -Path $ServerQueuePath[$i])  # Если путь отсутвует пишем N/A в результатах
        {
            $res = Get-ChildItem -Path $ServerQueuePath[$i] -Filter "*.queue" | Measure-Object -Sum Length
            $resX =  $res.Sum / 1000
            $resX = [math]::Round($resX, 0)
        
            # $result[$i] = $res.Sum
    
            #$resX.ToString().Length
            $result[$i] =   $resX.ToString() + (' ' * (10-$resX.ToString().Length))
        
            # Красим в красное если очереди длинные
            if($resX -gt $ServerQueueMaxSize)
            {
                $Color = "red"
            }
        }
        Else
        {
            $result[$i] = "N/A" + (' ' * 7)
        }
    }
    
    $ResultLine = "Queue sizes (kb)" + ' ' * (25-("Queue sizes (kb)").Length) + "	" + $result[0] + "	" + $result[1] + "	" + $result[2] + "	" + $result[3] + "	" + $result[4]
    WriteResult -Text $ResultLine -Color $Color
    $Color = ""
}


# -----------------------------
#    Frames,  Messages count 
# -----------------------------


for($i=0; $i -lt $FileMask.Count; $i++)
{
    WriteResult -Text ("---------------------------     " + $FileMask[$i] + " Count     ---------------------------") -Color "Green"


    $TableHeader = "Service_Name" + (' ' * (25-("Service_Name").Length)) + "	" + $ServerName[0] + "	" + $ServerName[1] + "        	" + $ServerName[2] + "      	" + $ServerName[3] + "      	" + $ServerName[4];
    WriteResult -Text $TableHeader -Color "Green"


    for($sn=0; $sn -lt $ServiceName.Count; $sn++)
    {

        # Сбрасываем результаты проверок, дабы небыло наводок
        [array]$result = "","","","","";

        for($smf=0; $smf -lt $ServerMessagesAndFramesPath.Count; $smf++)
        {
            
            $FileExt = $FileMask[$i] -replace "\*", ""
            $FullFilePath = $ServerMessagesAndFramesPath[$smf] + "\" + $ServiceName[$sn] + $FileExt
            if (Test-Path -Path $FullFilePath)
            {
                $lines = Get-Content -Path $FullFilePath | where {$_ -match ''};

                foreach ($line in $lines)
                {
                    # $line
                    # Вычленяем из строки количество
	                $match = [regex]::Match($line,"Фреймов: ([0-9]*) шт.")
                    $FramesCount = $match.Value -replace "Фреймов: ", ""
                    $FramesCount = $FramesCount -replace " шт.", ""
    
                    if ($FramesCount -ne "")
                    {
                        #$File.BaseName + "	" + $FramesCount
    
                        # Красим строчку в красный цвет при привышении порога одним из серверов
                        if ([convert]::ToInt32($FramesCount, 10) -gt $FramesMaxCount)
                        {
                            $Color = "red"
                        }


                        $result[$smf] =  $FramesCount + (' ' * (10-$FramesCount.Length))

                        #AppendSpaces
                    }


                    $match = [regex]::Match($line,"Сообщений: ([0-9]*) шт.")
                    $MesagesCount = $match.Value -replace "Сообщений: ", ""
                    $MesagesCount = $MesagesCount -replace " шт.", ""

                    if ($MesagesCount -ne "")
                    {
                        # Красим строчку в красный цвет при привышении порога одним из серверов
                        if ([convert]::ToInt32($MesagesCount, 10) -gt $MesagesMaxCount)
                        {
                            $Color = "red"
                        }

                        #$File.BaseName + "	" + $MesagesCount
                        $result[$smf] =   $MesagesCount + (' ' * (10-$MesagesCount.Length))

                    }
                }
            }
            else
            {
                $result[$smf] =  (' ' * 10)
            }

        }

        $ResultLine = $ServiceName[$sn] + ' ' * (25-($ServiceName[$sn]).Length) + "	" + $result[0] + "	" + $result[1] + "	" + $result[2] + "	" + $result[3] + "	" + $result[4]
        WriteResult -Text $ResultLine -Color $Color
        $Color = ""

    }
# $ServerMessagesAndFramesPath

}



# -----------------------------
#         Free Space
# -----------------------------

if ("FreeSpace")
{
    WriteResult -Text "----------------------------       FreeSpace (Gb)       ----------------------------" -Color "Green"

    $TableHeader = "Drive_Name" + (' ' * (30-("Drive_Name").Length)) + "	" + $ServerName[0] + "	" + $ServerName[1] + "        	" + $ServerName[2] + "      	" + $ServerName[3] + "  	" + $ServerName[4];
    WriteResult -Text $TableHeader -Color "Green"


    # reset result variable
    [array]$res1 = "","","","",""
    [array]$res2 = "","","","",""

    $Color1 = ""
    $Color2 = ""

    for($i=0; $i -lt $ServerAddress.Count; $i++)
    {



        #Clear-Variable $disk
        #Clear-Variable $res

        #write-host ("Get-WmiObject Win32_LogicalDisk -ComputerName " + $ServerAddress[$i] + " -Filter ""DriveType=3""")

        if ( $disk = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerAddress[$i] -Filter "DriveType=3" -erroraction SilentlyContinue )
        {

            #"GOOD"
            $disk = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerAddress[$i] -Filter "DriveType=3"

            $res = $disk[0].FreeSpace / 1000000000
            $res = [math]::Round($res, 0)

            $res1[$i] =   $res.ToString() + (' ' * (10-$res.ToString().Length))
            #$res1[$i] = $res

            if ($res -lt 10)
            {
                $Color1 = "red"
            }
         
            $res = $disk[1].FreeSpace / 1000000000
            $res = [math]::Round($res, 0)

            $res2[$i] =   $res.ToString() + (' ' * (10-$res.ToString().Length))
            #$res2[$i] = $res

            if ($res -lt 170)
            {
                $Color2 = "red"
            }


        }
        else
        {
            # Бывает если 
            #    if the Windows Management Instrumentation (WMI-In) inbound firewall rule is not enabled 
            #    DCOM is enabled in the Registry or service not stopped or crashed

            WriteResult -Text ("Server [" + $ServerAddress[$i] + "] is unavailable") -Color "yellow"

            $res1[$i] = "N/A" + (' ' * (10-"N/A".Length))
            $res2[$i] = "N/A" + (' ' * (10-"N/A".Length))
            $Color1 = "red"
            $Color2 = "red"
        }



    }

    #$ResultLine = "FreeSpace on SysDrive (Gb)" + ' ' * (25-("FreeSpace SysDrive (Gb)").Length) + "	" + $res1[0] + "	" + $res1[1] + "	" + $res1[2]
    #$ResultLine
#     $res1[0]
     #$res2[0]
    
    $ResultLine = "FreeSpace on SysDrive (Gb)" + ' ' * (30-("FreeSpace on SysDrive (Gb)").Length) + "	" + $res1[0] + "	" + $res1[1] + "	" + $res1[2] + "	" + $res1[3] + "	" + $res1[4]
    WriteResult -Text $ResultLine -Color $Color1

    $ResultLine = "FreeSpace on ShturmanDrv (Gb)" + ' ' * (30-("FreeSpace on ShturmanDrv (Gb)").Length) + "	" + $res2[0] + "	" + $res2[1] + "	" + $res2[2] + "	" + $res2[3] + "	" + $res2[4]
    WriteResult -Text $ResultLine -Color $Color2
    

}

# -----------------------------
#         Errors count 
# -----------------------------

if ("Errors")
{
    WriteResult -Text "----------------------       *.Errors files  (last 7 days)     ---------------------" -Color "Green"

    for($i=0; $i -lt $ServerName.Count; $i++)
    {

        $text =  "Server: " + $ServerName[$i]
        WriteResult -Text $text -Color "Green"

        if (Test-Path -Path $ServerErrorsPath[$i])
        {

            #$Files = (Get-ChildItem -Path $ServerErrorsPath[$i] -Filter "*.error" -Name | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  })
            $Files = Get-ChildItem -Path $ServerErrorsPath[$i] -Filter "*.error"
            #$Files = (Get-ChildItem -Path $ServerErrorsPath[$i] -Filter "*.error" | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  })

            #"Get-ChildItem -Path $ServerErrorsPath[$i] -Filter ""*.error"" -Name | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  }"
            #Get-ChildItem -Path $ServerErrorsPath[$i] -Filter "*.error" -Name | Where-Object { $_.CreationTime -ge (Get-Date).AddDays(-7)  }
    
        
            #$errorFilesFound = $FALSE
        
            foreach ($file in $Files)
            {
                if ( $file.CreationTime -ge (Get-Date).AddDays(-7) )
                {
                    $text =  $file.Name
                    WriteResult -Text $text -Color "red"
                }
            }

            if ($Files.Count -eq 0)
            {
                $text =  "No errors file found"
                WriteResult -Text $text -Color ""
            }
            else
            {
                WriteResult -Text ("Total *.error files: [" + $Files.Count + "]") -Color "Yellow"
            }
        }
        Else
        {
            $text =  "No errors Folder found"
            WriteResult -Text $text -Color ""

        }
        
    }
}


<#

	[array]$ServerAddress = ("10.200.24.85","10.200.24.83","10.200.24.81"),

	[array]$ServerDriveSystem = ("C:","C:","C:"),
	[array]$ServerDriveShturman = ("D:","D:","D:"),


$disk = Get-WmiObject Win32_LogicalDisk -ComputerName 10.200.24.85
#>
# -----------------------------
#         Backup Exist
# -----------------------------

Copy-Item -LiteralPath $ResultFileFullPath -Destination "$ResultFilePath\LastDiag.txt"
#$currDateTime 
#$ResultFileFullPath = $ResultFilePath + "\ServerSimpleDiag_" + $currDateTime + ".txt"


if (-not $NoWait)
{
    [int]$SecondsToWait = 600

    WriteLog "Done. This Window will be automaticaly closed after $SecondsToWait seconds" "INFO"


    Start-Sleep -Seconds $SecondsToWait; 
}

