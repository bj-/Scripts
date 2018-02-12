<# 


[TODO]
- Подсчет чексумм и генерирование файла для проверки корректности закачки
  [Имя файла],[MD5 Hash],[Путь назначения]
- путь назначения берется из файла Dest.txt
  Файл в формате [имя файла],[Путь назначения]
- выполнение проверяющего скрипта
- запрос файла с результатами проверки
- заливка недостающих/битых файлов


#>


# Parameters
param(  

    [object] $objCred = $null,
    [string] $UserName = 'root',
    [string] $UserPass = 'olimex', 
    [string] $UpdatesPath = 'D:\GitHubRep\Scripts\PowerShell\SysTech\UpdateUnixPC\Updates', 

#    [array] $Servers = ("a","b","c"),
#    [string] $FileName = "D:\b.b",
#    [string] $PathTarget = "/home/olimex/", 

    #[System.Security.SecureString] $strPass = 'olimex', 

    #$Port = 22,
    #$KeyfilePath = "",
    #$Command = "echo '0:Hello World'",
    [switch] $AutoUpdateFingerprint = $TRUE,
    #[switch] $Debug = $FALSE
    [switch] $Debug = $TRUE
)


$version = "1.0.0";

# файлы котоырй игнорируются апдейтом (служебные)
$UpdateInternalFiles = "config.ps1", "targethost.txt", "vardump.ps1", "LogDONE.log", "LogFAIL.log"


# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

clear;
WriteLog "Upload files and folder to Olimex. Execution remote commands" "INFO"
WriteLog "Script version: [$version]" "INFO"


# Check if our module loaded properly
#if (Get-Module -ListAvailable -Name Posh-SSH) { <# do nothing #> }
#else { 
    # install the module automatically
#    iex (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")
#    if (-ne (Get-Module -ListAvailable -Name Posh-SSH)) { 
#        break; # Stop Script 
#    }
#}


function md5hash($path)
{
    $fullPath = Resolve-Path $path
    $md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $file = [System.IO.File]::Open($fullPath,[System.IO.Filemode]::Open, [System.IO.FileAccess]::Read)
    try {
        $ret = [System.BitConverter]::ToString($md5.ComputeHash($file))
    } finally {
        $file.Dispose()
    }

    $ret = $ret -replace "-", ""
    return $ret.ToLower()
}


function UloadFile ()
{
    # Закачка файла
    param(  
        [string] $FileSrc = "",
        [string] $PathTarget = "",
        [string] $HostName = "",
        [object] $objCred = $null,
        [switch] $AutoUpdateFingerprint = $FALSE,
        [switch] $Verbose = $FALSE
    )

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";


    $ret = $FALSE # default func result


    # Проверка входящих переменных

    # проверка существования адреса
    if (Test-Connection -ComputerName $HostName -BufferSize 16 -Count 1 -Quiet -ErrorAction SilentlyContinue)
    {
        WriteLog "$FuncName Hostname [$HostName] available." "DUMP"
    }
    else
    {
        WriteLog "$FuncName Hostname [$HostName] does not available. Skipped." "WARN"
        return $FALSE
        break;
    }
    # TODO

    # Проверка наличия исходного файла
    # TODO

    # Путь, куда заливать, существует
    # TODO

    # Удаление существующего Fingerprint
    if ($AutoUpdateFingerprint)
    {
        WriteLog "$FuncName Remove Fingerprint from trusted host list. Host: [$HostName]" "DUMP"
        Remove-SSHTrustedHost $HostName
    }
    
    # заливка
    ##Set-SCPFile -LocalFile "d:\b.b" -RemoteFile "/home/olimex/b.b" -ComputerName $HostName -Credential (Get-Credential $objCred)
    #Set-SCPFile -LocalFile "d:\b.b" -RemotePath "/home/olimex/" -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey $TRUE

    WriteLog ("$FuncName Try to Upload file [$FileSrc] to [$HostName`:$PathTarget]") "DUMP"
    if (Set-SCPFile -LocalFile $FileSrc -RemotePath $PathTarget -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey $TRUE -ErrorAction SilentlyContinue)
    {
        WriteLog ("$FuncName Uploaded file [$FileSrc] to [$HostName`:$PathTarget]") "DUMP"
    }
    else
    {
        # Если не вышо залить через SCP пробуем через SFTP
        WriteLog ("$FuncName Cant not upload file [$FileSrc] to [$HostName`:$PathTarget] by SCP, Trying again by SFTP") "DUMP"

        $SessionSFTP = $NULL;
        $SessionSFTP = New-SFTPSession -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey
        
        # try to create SFTP session
        if ($SessionSFTP.Connected) 
        {
            WriteLog ("$FuncName SFTP: Connected to host [$HostName] by SFTP") "DUMP"

            WriteLog ("$FuncName SFTP: Try to Upload file [$FileSrc] to [$HostName`:$PathTarget]") "DUMP"
            $res = Set-SFTPFile -SessionId $SessionSFTP.SessionId -LocalFile $FileSrc -RemotePath $PathTarget -Overwrite

            # remove SFTP Session
            if (Remove-SFTPSession -SessionId $SessionSFTP.SessionId)
            {
                WriteLog ("$FuncName SFTP: SFTP Session disconnected from host [$HostName]") "DUMP"
            }
            else
            {
                WriteLog ("$FuncName SFTP: SFTP Session can not disconnect from host [$HostName]") "DUMP"
                return $FALSE
                break;
            }

        }
        else
        {
            WriteLog ("$FuncName SFTP: Can not connect to host [$HostName] by SFTP") "DUMP"
            return $FALSE
            break;

        }
    }
    

    # Create SSH Session (for executing SSH command
    #$Session = New-SFTPSession -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey
    $Session = New-SSHSession -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey
    
    #$Session
    #Get-SSHSession

    # Get MD5sum uploaded file
    $fileName = $FileSrc -replace ".*[/\\]", "" # вычленяем имя файла из полного пути.

    #break 
    # Get md5sum uploaded file
    #$UploadedFileHash = Invoke-SSHCommand -Command "md5sum $PathTarget/$fileName" -SessionId $Session.SessionId
    
    WriteLog ("$FuncName Try to get MD5sum of file [$HostName`:$PathTarget/$fileName]") "DUMP"
    $UploadedFileHash = (Invoke-SSHCommand -Command "md5sum $PathTarget/$fileName" -SessionId $Session.SessionId).Output
    #Extract md5sum from respond string
    #"Invoke-SSHCommand -Command md5sum $PathTarget/$fileName -SessionId " + $Session.SessionId

    if ($UploadedFileHash -ne "")
    {
        WriteLog ("$FuncName Got MD5sum [$UploadedFileHash] of file [$HostName`:$PathTarget/$fileName]") "DUMP"
    }
    
    #$UploadedFileHash
    
    $UploadedFileHash = ($UploadedFileHash.Substring(0,$UploadedFileHash.IndexOfAny(" "))).ToLower()

    if ($UploadedFileHash -eq (md5hash $FileSrc))
    {
        WriteLog ("$FuncName Uploaded file [$FileSrc] to [$HostName`:$PathTarget] Succesfull") "INFO" $Verbose
        $ret = $TRUE # func result
    }
    else 
    {
        WriteLog ("$FuncName Failed to upload file [$FileSrc] to [$HostName`:$PathTarget]") "WARN" $Verbose
        $ret = $FALSE # func result
    }
    #break 

    if(Remove-SSHSession -SessionId $Session.SessionId)
    #if($false)
    {
        WriteLog ("$FuncName Disconnected SSH Session ["+($Session.SessionId)+"]") "DUMP"
    }
    else
    {
        WriteLog ("$FuncName Cant Disconnect SSH Session ["+($Session.SessionId)+"]") "DUMP"
    }
    #$res


    # Remove-SFTPSession -SessionId $Session.SessionId

    #if ($res)
    #{
    #    WriteLog ("$FuncName Uploaded file [$FileSrc] to [$HostName`:$PathTarget] on host [$HostName]") "MESS"
    #}

    # провека целостности залитого файла
    # TODO
    
    return $ret;

}

function ExtractFolderNameFromPath ()
{
    # добыча пути фолдера из полного пути файла
    param(  
        [string] $Path = "",
        [switch] $ReplaceBackSlash = $FALSE,
        [switch] $AddStarterSlash = $FALSE,
        [switch] $AddFinalSlash = $FALSE,
        [switch] $Verbose = $FALSE
    )

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    #WriteLog "$FuncName Source val [$Path]" "DUMP"

    $ret = $NULL # default func result

    $ret = $Path -replace "/", "\\" # Если вдруг слеши не уставные

    #WriteLog "$FuncName Replaced [/] to [\] in [$ret]" "DUMP"

    #WriteLog ("$FuncName LastIndexOfAny [\] is ["+($ret.LastIndexOfAny("\"))+"] in [$ret]") "DUMP"

    $ret = $ret.Substring(0, $ret.LastIndexOfAny("\"))

    #WriteLog ("$FuncName Substring at last [\]. Result [$ret]") "DUMP"
    
    #$ret.LastIndexOfAny("\\")

    if ($ReplaceBackSlash) # Замена бексолеша на обычный (для юнихов)
    {
        $ret = $ret -replace "\\", "/"
        #WriteLog "$FuncName Replaced [\] to [/] in [$ret]" "DUMP"
    }

    if ($AddStarterSlash) # добавляем слеш рута для юниха
    {
        #WriteLog "$FuncName Added starter [/] in [$ret]" "DUMP"
        $ret = "/"+$ret
    }
    if ($AddFinalSlash) # добавляем слеш рута для юниха
    {
        #WriteLog "$FuncName Added starter [/] in [$ret]" "DUMP"
        $ret += "/"
    }

    
    
    WriteLog "$FuncName Extraced folder.fullpath [$ret] from file.fullpath [$Path]" "DUMP"

    return $ret;

}


function ExtractFileNameFromPath ()
{
    # добыча пути фолдера из полного пути файла
    param(  
        [string] $Path = "",
        [switch] $Verbose = $FALSE
    )

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    #WriteLog "$FuncName Source val [$Path]" "DUMP"

    $ret = $NULL # default func result

    $ret = $Path -replace "/", "\\" # Если вдруг слеши не уставные

    #WriteLog "$FuncName Replaced [/] to [\] in [$ret]" "DUMP"

    #WriteLog ("$FuncName LastIndexOfAny [\] is ["+($ret.LastIndexOfAny("\"))+"] in [$ret]") "DUMP"

    $ret = $ret.Substring($ret.LastIndexOfAny("\")+1)

    #WriteLog ("$FuncName Substring after last [\]. Result [$ret]") "DUMP"

    WriteLog "$FuncName Extraced filename [$ret] from file.fullpath [$Path]" "DUMP"

    return $ret;

}

function DumpVariable ()
{
    # Dump Variable to string and write into file
    param(  
        [string] $VarName ="",
        [object] $Data,
        [string] $Type = "",
        [string] $InToFile = "",
        #[switch] $InToFile,
        [switch] $Append,
        [switch] $Verbose = $FALSE
    )

  	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    #WriteLog "$FuncName Source val [$Path]" "DUMP"


    $ret = ""

    if (($VarName -eq "") -or ($Type -eq ""))
    {
        WriteLog "$FuncName `$VarName [$VarName] or `$Type [$Type] are not specified" "ERRr"

        return $ret
        break;
    }

    if (($Type.ToUpper() -eq "[ARRAY]") -or ($Type.ToLower() -eq "[system.collections.arraylist]"))
    {

        $out = "$Type `$$VarName = (`n"""+($Data -join """, `n""")+"""`n); `n"
        #$out

        # write to file
        if ($InToFile -ne "")
        {
            # Add to file, or create new
            if ($Append)
            {
                $out | Out-File $InToFile -Encoding "default" -Append
            }
            else
            {
                $out | Out-File $InToFile -Encoding "default"
            }
            WriteLog "$FuncName Write dumped variable [$VarName] to file [$InToFile]" "DUMP"

        }

#                    $out | Out-File "$UpdatesPath\$Update\vardump.ps1" -Encoding "default" -Append

        #$VarName
        $ret = $out
    }

    if ($Type.ToUpper() -eq "[STRING]")
    {
        $out = "$Type `$$VarName = ""$Data""; `n"
#        $out

        # write to file
        if ($InToFile -ne "")
        {
            # Add to file, or create new
            if ($Append)
            {
                $out | Out-File $InToFile -Encoding "default" -Append
            }
            else
            {
                $out | Out-File $InToFile -Encoding "default"
            }
            WriteLog "$FuncName Write dumped variable [$VarName] to file [$InToFile]" "DUMP"
        }
        #$VarName
        $ret = $out
    }
    
    return $ret

}
#[array] $ttt = ("aaa", "bbb", "ccc", "ddd")
#DumpVariable -VarName "googleSux" -Data $ttt -Type "[System.Collections.ArrayList]" -InToFile "d:\f.f"
#DumpVariable -VarName "GoogleRuled" -Data "g""gg" -Type "[String]" -InToFile "d:\f.f" -Append


WriteLog "Create ObjCred for access to target host" "DUMP"
# Создаем объект с "правами" доступа
$strPass = ConvertTo-SecureString -String $UserPass -AsPlainText -Force
$objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($UserName, $strPass)

#$HostName = "172.16.30.142"

#$UpdatesPath = "c:\sdfsdfsdf\"

UloadFile -FileSrc "d:\b.b" -PathTarget "/home/olimex/" -HostName 172.16.30.142 -objCred $objCred -AutoUpdateFingerprint -Verbose

break


#Строим список апдейтов
if ((TestFolderPath -Path $UpdatesPath) -ne $TRUE)
{
    WriteLog "[`$UpdatesPath] not specified" "ERRr"
    break;
}

#$UpdatesPath = "$UpdatesPath\x"

WriteLog "Get updates list in [$UpdatesPath]" "DUMP"
$Updates = Get-ChildItem -Path $UpdatesPath -Name -Directory -Filter "201*"

if ($Updates.Count -eq 0)
{
    WriteLog "[`$UpdatesPath] does not containt any updates (Folder is empty)" "ERRr"
    break;
}

# Обрабатываем апдейты
foreach ($Update in $Updates)
{
    #"$UpdatesPath\$Update"
    # Смотрим Актуален ли еще апдейт или уже разлит полностью
    #Test-Path -Path "$UpdatesPath\$Update\passed."
    $toProcessUpdate = $FALSE

    # Читаем конфиг и дампы разливки
    if (Test-Path -Path "$UpdatesPath\$Update\config.ps1")
    {
        $UpdatePassed = $NULL # т.к. этой переменной может и не быть в конфиге.

        .$UpdatesPath"\$Update\config.ps1"
        if ($UpdatePassed -ne $Update.Substring(0,10))
        {
        
            # читаем список хостов, конвертим его в переменные или читаем с дампа
            if (Test-Path -Path "$UpdatesPath\$Update\vardump.ps1")
            {
            }
            else 
            {
                # если дампа еще нет - читаем список хостов исходный
                $Lines = Get-Content -Path "$UpdatesPath\$Update\targethost.txt"

                $ArrayList = $NULL
                [System.Collections.ArrayList] $ArrayList = "EMPTYRECORD", "EMPTYRECORD"
                #$ArrayList.GetType()

                foreach ($line in $Lines)
                {
                    if ($line.Length) # стркоа не пустая
                    {
                        if ($line.Substring(0,1) -ne "#") # строка не начинается с символа коментария
                        {
                            #$line
                            WriteLog "Add Host address [$line] to Array [`$ArrayList]" "DUMP"
                            $IndexOfAddedItem = $ArrayList.Add($line)
                            
                        }
                    }
                }
                # Первыйц дамп адресов хостов сконверченные в переменные
                WriteLog "Remove usless items [FIRST and SECOND] from Array [`$ArrayList]" "DUMP"
                #$ArrayList.Remove("FIRST")
                #$ArrayList.Remove("SECOND")
                
                #$ArrayList -join ", `n"
                if ($ArrayList.Count -gt 2)
                {
                    # Dump $TargetHostList and $TargetHostPassed into file
                    $x = DumpVariable -VarName "TargetHostList" -Data $ArrayList -Type "[System.Collections.ArrayList]" -InToFile "$UpdatesPath\$Update\vardump.ps1"
                    $x = DumpVariable -VarName "TargetHostPassed" -Data ("EMPTYRECORD", "EMPTYRECORD") -Type "[System.Collections.ArrayList]" -InToFile "$UpdatesPath\$Update\vardump.ps1" -Append
                    #DumpVariable -VarName "googleSux" -Data $ttt -Type "[System.Collections.ArrayList]" -InToFile "d:\f.f"
                    WriteLog "Write new Config (variable dump) file [$UpdatesPath\$Update\vardump.ps1]" "DUMP"



                    #$out = "[System.Collections.ArrayList] `$TargetHostList = (`n"""+($ArrayList -join """, `n""")+"""); `n [System.Collections.ArrayList] `$TargetHostPassed = (""EMPTYRECORD"", ""EMPTYRECORD"");"

                    #$out | Out-File "$UpdatesPath\$Update\vardump.ps1" -Encoding "default" -Append
                    #WriteLog "Write new config file [$UpdatesPath\$Update\vardump.ps1]" "DUMP"
                }
                else
                {
                    WriteLog "Target host list is empty. Update Skipped [$Update]" "WARN"
                }
                #$out

            }

            if (Test-Path -Path "$UpdatesPath\$Update\vardump.ps1")
            {
                $TargetHostList = $NULL
                $TargetHostPassed = $NULL

                WriteLog "Read config file [$UpdatesPath\$Update\vardump.ps1]" "DUMP"
                ."$UpdatesPath\$Update\vardump.ps1"

                # Ситавм флаг что можно работать с этим апдейтом
                $toProcessUpdate = $TRUE

            }
            else
            {
                WriteLog "Config File in Update [$Update] does not exist" "WARN"
            }

        }
    }
    else 
    {
        WriteLog "Update [$Update] does not containt [config.ps1] file. Update Skipped" "WARN"
    }
    
    if ($toProcessUpdate)
    {
        # Конфиг корректный и есть что разливать - начинаем разливку
        WriteLog "Processing Update [$Update]" "INFO"

        #$TargetHostPassed
        #$TargetHostList

        $UpdateDirList = $NULL
        $UpdateFileList = $NULL

        $UpdateDirList = Get-ChildItem -Path $UpdatesPath\$Update\ -Name -Recurse -Directory
        $UpdateFileList = Get-ChildItem -Path $UpdatesPath\$Update\ -Name -Recurse -File -Exclude ($UpdateInternalFiles)


        foreach ($HostName in $TargetHostList)
        {
            
            if (($HostName.Length -gt 0) -and ($HostName -ne "EMPTYRECORD")) # отсекаем пустые строки)
            {

                $DoesNotUpdated = $FALSE # Default state

                #$ExecuteSSHCommandBeforeInstall
                #$ExecuteSSHScriptBeforeInstall


                # Upload files
                foreach ($FileName in $UpdateFileList)
                {

                    $ExtractedPath = ExtractFolderNameFromPath -Path $FileName -ReplaceBackSlash -AddStarterSlash -AddFinalSlash
                    $ExtractedFileName = ExtractFileNameFromPath -Path $FileName

                    #$ExtractedPath
                    #$ExtractedFileName

                    #"$UpdatesPath\$Update\$FileName"

                    if ($DoesNotUpdated -ne $TRUE) # нечего заливать, если уже апдейт запорот.
                    {
                        $res = UloadFile -FileSrc "$UpdatesPath\$Update\$FileName" -PathTarget $ExtractedPath -HostName $HostName -objCred $objCred -AutoUpdateFingerprint -Verbose
                    }

                    
                    if ($res)
                    {
                        WriteLog "Function [UploadFile] returned TRUE State. File succesfull uploaded" "DUMP"
                    }
                    else
                    {
                        WriteLog "Function [UploadFile] return FALSE State. Upload fail" "DUMP"
                        #WriteLog "Can not upload to [$HostName] file [$FileName] in [$PathTarget]" "WARN"
                        $DoesNotUpdated = $TRUE
                    }
                    <#
                    if ($res)
                    {
                        # Write Log File
                        $date = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
                        "FAIL; $date; $HostName; $FileName; $PathTarget" | Out-File "$UpdatesPath\$Update\LogFAIL.log" -Encoding "default" -Append
                    
                        WriteLog "Updated [$HostName] placed [$FileName] in [$PathTarget]" "INFO"
                    }
                    else 
                    {
                        # Write Log File
                        $date = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
                        "DONE; $date; $HostName; $FileName; $PathTarget" | Out-File "$UpdatesPath\$Update\LogDONE.log" -Encoding "default" -Append
                    
                        WriteLog "Some problem on update [$HostName] file [$FileName] in [$PathTarget]" "ERRr"
                    }
                    #>
                }



            
                #$ExecuteSSHCommandAfterInstall
                #$ExecuteSSHScriptAfterInstall =


                # Update Result
                # write result into Update Log (Passed and Error are different log files)
                if ($DoesNotUpdated)
                {
                    # Write Log File
                    $date = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
                    "FAIL; $date; $HostName; $Update" | Out-File "$UpdatesPath\$Update\LogFAIL.log" -Encoding "default" -Append
                    
                    WriteLog "Did not update [$HostName] Update Name: [$Update]" "WARN"
                }
                else 
                {
                    # Write Log File
                    $date = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
                    "DONE; $date; $HostName; $Update" | Out-File "$UpdatesPath\$Update\LogDONE.log" -Encoding "default" -Append

                    # move host to succes list
                    $TargetHostList.Remove($HostName)
                    $TargetHostPassed.Add($HostName)
                    
                    WriteLog "Updated [$HostName] Update Name: [$Update]" "MESS"
                    #WriteLog "Some problem on update [$HostName] file [$FileName] in [$PathTarget]" "ERRr"
                }


            }

        }
        # Dump $TargetHostList and $TargetHostPassed into file
        $x = DumpVariable -VarName "TargetHostList" -Data $TargetHostList -Type "[System.Collections.ArrayList]" -InToFile "$UpdatesPath\$Update\vardump.ps1"
        $x = DumpVariable -VarName "TargetHostPassed" -Data $TargetHostPassed -Type "[System.Collections.ArrayList]" -InToFile "$UpdatesPath\$Update\vardump.ps1" -Append
        #DumpVariable -VarName "googleSux" -Data $ttt -Type "[System.Collections.ArrayList]" -InToFile "d:\f.f"
        WriteLog "Write new Config (variable dump) file [$UpdatesPath\$Update\vardump.ps1]" "DUMP"
    }


}

#$HostList = Get-Content -Path


#echo $Lines | %{echo $_;}

break

$res = UloadFile -FileSrc $FileName -PathTarget $PathTarget -HostName $HostName -objCred $objCred -AutoUpdateFingerprint -Verbose

if ($res)
{
    $date = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
    "$date; $HostName; $FileName; $PathTarget"
}

# Скачивание файла

# Get-SCPFile -LocalFile "d:\test.sh" -RemoteFile "/home/olimex/test.sh" -ComputerName $HostName -Credential (Get-Credential $objCred)
#Get-SCPFile -LocalFile "d:\test.sh" -RemoteFile "/home/olimex/test.sh" -ComputerName $HostName -Credential (Get-Credential $objCred)



#------------------
<#
$Session = New-SFTPSession -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey

Get-SFTPFile -SessionId $Session.SessionId -RemoteFile /home/olimex/test.sh -LocalPath "d:\" -Overwrite

Remove-SFTPSession -SessionId $Session.SessionId
#>

#Set-SCPFile -
 