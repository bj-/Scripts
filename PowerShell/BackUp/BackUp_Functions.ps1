# ===============================================
#                   Functions
# ===============================================
$ModVer = "1.0.1"
$ModName = "Functions"
WriteLog "Module [$ModName] version: [$ModVer]" "INFO"

function FilePurge ()
{
# Удаление старых лог файлов
	param (
		[int]$PurgeDays = 30,
		[string]$Path = "",
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

	# вычисляем дату до которой надо все похерить.
	$PurgeDate = (Get-Date).AddDays(-$PurgeDays) 

	WriteLog "Purge old log files, older than [$Path] days" "INFO" -Verbose $Verbose

	$arr = Get-ChildItem -Path $Path -Force -Filter "*.7z"

	Foreach ($File in $arr) 
	{

		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # этот вариант красивше, но возвращает дату с точкой на конце
		$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		#$match = [regex]::Match($File,"(\d){2}-(\d){2}-(\d){2}") # тоже что и предыдущий, но более понятно.
#		$match
#		$match.Value


		# если в файле небыло ничего похожего на дату - пропустим этот файл
		if ($match.Value -ne "")
		{

			# добавляем 20 в начало, чтобы год был полностью указан и преобразовываем в дату
			$FileDate =  get-date ("20" + $match.Value)

			# сравниваем даты. если файл старше требуемой даты - убиваем его.
			if ($FileDate -lt $PurgeDate)
			{
				WriteLog "Try to delete file [$File]" "DUMP"

				Remove-Item -Path $File.FullName -Force

				# проверяем исходный файл на наличие, если все еще присутсвует - ругаемся
				if (test-path -Path $File.FullName -ErrorAction SilentlyContinue)
				{

					WriteLog "Old Log file [$File] doesn't removed" "ERRr"
				}
				else
				{
					WriteLog "File [$File] is deleted" "MESS" # а если нормально удалился - пишем что ремувед
				}


				
			}
		}
	}
}


function UploadFiles ()
{
# Заливка лог файлов на сервер
	param (
		[string]$Path = "",
		[string]$File = "",
        #[string]$UploadHost = "",
		[string]$UploadPath = "",
		[array]$UploadCred = ("UserName", "Password"),
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";
    #$UploadPath

    $UploadCred


    [object] $objCred = $null
    [string] $strUser = $UploadCred[0]
    [System.Security.SecureString] $strPass = $NULL 
    #[System.Security.SecureString] $strPass = '' 


    $strPass = ConvertTo-SecureString -String $UploadCred[1] -AsPlainText -Force
    $objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strPass)

    $username = $UploadCred[0]
    $pass = $UploadCred[1]
net use /D $UploadPath
net use $UploadPath /u:$username $pass
    #"net use $UploadPath /u:$username $pass"

    $MaxAttempts = 10

    for($i=0; $i -lt $MaxAttempts; $i++)
    {
        if ( TestFolderPath -Path $UploadPath -Create -ContinueOnError )
        {
        #$Path
        #break
           
            # Переливаем все содержимое фолдера
            if ($Path -ne "")
            {
                if ( TestFolderPath -Path $Path )
                {
                    $Files = $NULL;
                    $Files = Get-ChildItem -Path $Path -Recurse | % { $_.FullName }
                    #$Files
                    #break
                }

                foreach ($OneFile in $Files)
                {
                    if (Test-Path -Path $OneFile) 
                    {
                        WriteLog "try to Upload file [$OneFile] to [$UploadPath]" "DUMP"
                        Move-Item -Path $OneFile -Destination $UploadPath -Force # -Credential (Get-Credential $objCred)
                        #if (
                        WriteLog "Upload file [$OneFile] to [$UploadPath] (done)" "MESS"

                    }
                }
            }

            # Переливаем единичный файл
            if ($File -ne "")
            {
                if (Test-Path -Path $File) 
                {
                    WriteLog "try to Upload file [$OneFile] to [$UploadPath]" "DUMP"
                    Move-Item -Path $File -Destination $UploadPath -Force # -Credential (Get-Credential $objCred)
                    WriteLog "Upload file [$File] to [$UploadPath] (done)" "MESS"
                }
            }
        }
    }

# отконнекчиваемся
net use /D $UploadPath

    #$UploadPatch = "\\172.16.30.19\Share\"
    #Test-Path -Path $UploadPatch 
<#
"gogogogogogo"

#UploadFiles -Path "D:\BackUP\2Tape" -File "D:\BackUP\x\DelphiChromiumEmbedded.Local.dump" -UploadPatch ("\\172.16.30.139\Share\"+(get-date -Format "yyyy-MM-HH")) -UploadCred ("Upload","Chi79Mai") -Verbose

break;


	WriteLog "Upload Files to Server" "INFO";

	[string]$LogFilePathServer = "\\SHTURMAN-ROOT\Logs\test";
	[string]$BlockName = "aaa11";
#	[string]$ShareMarker = "$LogFilePathServer"; # проверяя наличие этого файла - проверяем доступность пути в шаре
	[string]$LogFilePathServerBlock = "$LogFilePathServer\$BlockName";

	# - создание и проверка существования фолдера для архивов
# "test-path -Patch $LogFilePathServer -ErrorAction SilentlyContinue"

	if (test-path -Path $LogFilePathServer -ErrorAction SilentlyContinue)
	{
		WriteLog "Log Store share [$LogFilePathServer] is exist" "DUMP"

		if (test-path -Path $LogFilePathServerBlock -ErrorAction SilentlyContinue)
		{
			WriteLog "Block's folder in log store share [$LogFilePathServerBlock] is exist" "DUMP"
			
		}
		Else
		{
			$res = New-Item -Path $LogFilePathServer -Name $BlockName -ItemType "directory"
			WriteLog "Create Folder: $res" "DUMP"

			if (test-path -Path $LogFilePathServerBlock -ErrorAction SilentlyContinue)
			{
				WriteLog "Block's folder in log store share [$LogFilePathServerBlock] created" "MESS"
			}
			Else
			{
				WriteLog "Create Folder [$BlockName] in [$LogFilePathServer] failed" "ERRr"
			}
		}	


"asasf"
break;
		


		# PowerShell's New-Item creates a folder
		if (-not (test-path $LogFilePathOld))
		{
			WriteLog "Path for Arcived Files [$LogFilePathOld] doesn't exist" "ERRr"
			break;
		}
		else
		{
			WriteLog "Created folder [$LogFilePathOld]" "MESS"
		}
	}
	else
	{
		WriteLog "Path for Arcived Files [$LogFilePathServer] doen't exist" "ERRr"
		break;
	}


	$arr = Get-ChildItem -Path $LogFilePathOld -Force -Filter "*.7z"


	Foreach ($File in $arr) 
	{
#		Copy-Item -Destination C:\Temp
		Copy-Item -Path $File.FullName -Destination \\SHTURMAN-ROOT\Logs\test
#		$File
	}
# Copy-Item -Destination C:\Temp
# Remove-Item C:\Scripts\*
#>
}

function ArchiveFiles ()
{
    # Архивирование файлов
	param (
		[string]$Path = "",
		[string]$arcPath = "",
		[switch]$FastArchive = $FALSE,		# Сжатие по дефолту (для архиватора) если флаг ни один флаг не взведен - пакуем по максимому, но долго-долго.
		[switch]$StoreArchive = $FALSE,		# Упаковка без сжатия (как правило с целью нарезки архива)
		[switch]$DelSource = $FALSE,		    # Удаление исходного файла
		   [int]$Size = 0,		                # нарезка на куски = в Мб,  0 - одним куском. 
		[switch]$Verbose = $FALSE		    # в консоль все события лога пишет
	)

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	WriteLog "$FuncName Archive file [$Path] to [$arcPath] DelSrc: [$DelSource] StoreArc [$StoreArchive] FastArch [$FastArchive] PartSize [$Size]" "DUMP"


    # на сколько сильно паковать. если флаг не взведен - пакуем по максимому, но долго-долго.
	if ($FastArchive -eq $TRUE)
	{
        $ArcivationDensity = ""
    } 
    elseif ($StoreArchive -eq $TRUE )
    {
	    $ArcivationDensity = "-mx=0"
    }
    else
    {
	    $ArcivationDensity = "-mx=9"
	}
    
    # Удаление исходного файла
	if ($DelSource -eq $TRUE)
	{
        $DelSourceFile = "-sdel"
    } 
    else 
    {
	    $DelSourceFile = ""
    }

    if ( $Size -gt 0 )
    {
        #-v{Size}[b|k|m|g] : Create volumes
        $SizeVolume = "-v"+$Size+"m";

    }
    else
    {
        $SizeVolume = "";
    }


 

 	#WriteLog "$FuncName Exec[D:\Prog\7-zip\7za.exe $SizeVolume $ArcivationDensity a $arcPath $DelSourceFile $Path]" "DUMP"

    

    # Проверяем возможные пути расположения архиватора
    if (test-path -Path "D:\Prog\7-zip\7za.exe" -ErrorAction SilentlyContinue)
    {
     	WriteLog "$FuncName Exec [D:\Prog\7-zip\7za.exe $ArcivationDensity $SizeVolume a $arcPath $DelSourceFile $Path]" "DUMP"
		$res = D:\Prog\7-zip\7za.exe $ArcivationDensity $SizeVolume a $arcPath $DelSourceFile $Path
    }
    ElseIf (test-path -Path "C:\Prog\7-Zip\7za.exe" -ErrorAction SilentlyContinue)
    {
        WriteLog "$FuncName Exec [C:\Prog\7-Zip\7za.exe $ArcivationDensity $SizeVolume a ```"$arcPath```" $DelSourceFile $Path]" "DUMP"		
        $res = C:\Prog\7-Zip\7za.exe $ArcivationDensity $SizeVolume a `"$arcPath`" $DelSourceFile $Path
    }
    else 
    {
    	WriteLog "Archiver not found" "ERRr" # не нашли архиватор. делать нефиг, вываливаемся
        break;
	}

    WriteLog "$res" "DUMP"


    # подменяем имя файла архива для проверки его наличия
    if ( $Size -gt 0 )
    {
        # если архивбыл порезанный на части то добавляем .001 к названию
        # TODO каким-то макаром проверять сужествование и остальных частей (ХЗ как вычислить сколько их всего)
        $arcPath = $arcPath+".001"
    }

	if (test-path $arcPath)
    {
        if ($DelSource)
        {
		    # повторная попытка грохнуть файл. если архиватор не смог. бесполезная по сути... т.к. не помогает.
	        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
            #	$File.Delete()
        }
	    # проверяем исходный файл на наличие, если все еще присутсвует - ругаемся
	    if (test-path $Path -ErrorAction SilentlyContinue)
#	    if (test-path "c:\windows" -ErrorAction SilentlyContinue)
	    {
            if ($DelSource)  # Разные сообщения Ворнинг или Мессадж в зависимости от того надо было удалять или нет.
            {
		        WriteLog "File [$Path] added to archive [$arcPath]" "WARN" $Verbose # если исходный остался - пишем что файл _добавлен_
		        WriteLog "Source file [$Path] doesn't removed" "ERRr" $TRUE # И ругаемся чтоне удалось удалить
            }
            else
            {
		        WriteLog "File [$Path] added to archive [$arcPath]" "MESS" $Verbose # если исходный остался - пишем что файл _добавлен_
            }
	    }
	    else
	    {
			WriteLog "File [$Path] moved to archive [$arcPath]" "MESS" $Verbose # а если нормально удалился - пишем что ремувед
	    }
			
	}
    Else
    {
		WriteLog "Arcived File [$arcPath] doesn't exist" "ERRr" $TRUE
    }
}


function purge_oldBackUp ()
{
    # Архивирование файлов
	param (
		[string]$Path = "",
		[string]$FileMask = "",
        [array]$Limits = $NULL,                           #Array()  Daily / TenDays / Montly / Quartal / Years
		[switch]$Verbose = $FALSE		    # в консоль все события лога пишет
	)

	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    $arr = if ( $Limits ) { $Limits } else { $DefaultStoreLimits }
        
    # заменить на это после искоренения
   	[int]$Daily   = $arr[0] 	# days
	[int]$TenDays = $arr[1]		# days
	[int]$Montly  = $arr[2]		# days
    [int]$Quartal = $arr[3]	    # days
    [int]$Years   = $arr[4]


    WriteLog "$FuncName Purge old BackUps [ $Daily / $TenDays / $Montly / $Quartal / $Years ] Daily / TenDays / Montly / Quartal / Years by mask [$FileMask]" "INFO" $Verbose

    #//echo "$Path\$FileMask"
    if ( Test-Path -Path $Path )
    {
        $Files = Get-ChildItem -Path "$Path\$FileMask*"
    }
    else
    {
        $Files = $NULL
        WriteLog "$FuncName Path [$Path] does not exist" "WARN" $Verbose
    }

    ForEach ($file in $Files) 
    {
        $FileName = $file.Name
        $FileFullName = $file.FullName

        $match = [regex]::Match($FileName,"(\d){4}-(\d){2}-(\d){2}") # ищем в формате yyyy-MM-dd.
    	#$match
    	#$match.Value

    		# если в файле небыло ничего похожего на дату - пропустим этот файл
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

                <#
                if ($FileMaxDate -lt $FileDate) 
                { 
                    $FileMaxDate = $FileDate;
                    $LastFile = $File;
                }
                #>

    			# сравниваем даты. Пропускаем и не удаяем файлы младше требуемой даты.
			    if ($FileDate -lt (Get-Date).AddDays(-$Daily))
			    {
                    $delfile = $FALSE

                    #write-host $FileDate + "---" + $Years + "---" + ((Get-Date).AddDays(-$Years)) + ((Get-Date).AddDays(-$Quartal))

                    # Старше $Years - удаляем, но только если не 0 (т.е. анлимитед)
                    if ( ($Years -ne 0) -and ($FileDate -lt (Get-Date).AddDays(-$Years)) )    { $delfile = $TRUE }

                    # Оставаляем годовые - Старше $Quartal, но не 01.01.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Quartal)) -and ( ($FileDate.Day -notin 1) -or ($FileDate.Month -notin 1) ) )    { $delfile = $TRUE }

                    # Оставаляем квартальные - Старше $Montly, но не 01.хх.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Montly)) -and ( ($FileDate.Day -notin 1) -or ($FileDate.Month -notin 1,4,7,10) ) )    { $delfile = $TRUE }

                    # Оставаляем месячные - Старше $TenDays, но не 01.хх.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$TenDays)) -and ( ($FileDate.Day -notin 1) ) )    { $delfile = $TRUE }


                    # Оставаляем 10-тидневки - Старше $Daily, но не 01.хх.хх - удаляем
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Daily)) -and ( ($FileDate.Day -notin 1,10,20) ) )    { $delfile = $TRUE }

                    
                    if ( $delfile )
                    {
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] from [$FileDate]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                    }
                                        


                }
            }

    }
}
#$DefaultStoreLimits = (30, 90, 181, 365, 0)
#purge_oldBackUp -Path "C:\BackUp\FromComputers\st-nas\" -FileMask "" -Limits (10, 60, 180, 365, 0) -Verbose
#break 

function export_backup ()
{

    # Архивирование файлов
	param (
		[string]$Source = "",         # каталог - из которого взять
		[string]$Target = "",         # каталог - куда положить
		[string]$Mask = "",           #маска по которой будут удалены предыдущие
		[switch]$Verbose = $FALSE		    # в консоль все события лога пишет
	)

	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    WriteLog "$FuncName Export new Backup [$Source] to [$Target]" "INFO" $Verbose

    # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
	        #WriteLog "Create a latest copy of SQL backup(s) in Export folder [$SQLExportPath]" "DUMP"
    
    # Проверка наличия пути без создания оного.
    #TestFolderPath -Path $Target #-Verbose

    if ( (test-path -Path $Source -ErrorAction SilentlyContinue) -and (TestFolderPath -Path $Target) )
    {

        $file = Split-Path -Path $Source -Leaf  # имя файла

        #delete old by mask
        #echo "Get-ChildItem -Path $Target -filter $Mask*"
        $Files = Get-ChildItem -Path $Target -filter "$Mask*"
        
        foreach ( $File_d in $Files )
        {
            DeleteFile -File $File_d.FullName -Verbose
        }
        #$Files

        #echo "Remove-Item -Path `"$Target\*`" -include `"$Mask*`" -WhatIf"
        #Remove-Item -Path "$Target\*" -filter $Mask* -WhatIf
        #Get-ChildItem -Path $Target -Filter $Mask | Remove-Item -Path $_
        #DeleteFile -File "$Target\$Mask*" -Verbose

        # try to create hardlink
                   # Пробуем создать хардлинк

                    #WriteLog "Try to create New file for export is [$LastFile] will replace old file [$Target\$file]" "DUMP"
                    $command = "cmd /c mklink /H `"$Target\$file`" `"$Source`""
                    #echo $command
                    invoke-expression $command

                    if (-not (Test-Path -Path $Target\$file -ErrorAction SilentlyContinue) )
                    {
                        # Если не удалось создать хардлинк пробуем скопировать
                        WriteLog "Did not create HardLink of file for export [$Target\$file], try to create a copy" "DUMP"
                                
                        # Проверка наличия свободного места на диске под копию файла
                        if ( CheckFreeSpace -Path $Target -Size $Source.Length  ) #-Verbose
                        {
                            # Копирование файла если место есть
                            Copy-Item -Path $Source -Destination $Target
                        }
                    }
                    # Финальная проверка что создалась копия
                    if (Test-Path -Path $Target\$file -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created hardlink or copy of file for export (to Tape) [$Target\$file]" "MESS"
                    }
                    else 
                    {
                        # Если не удалось создать и копии тоже - ругаемся красненьким
                        WriteLog "Did not create file for export [$Target\$file] (HardLink or Copy)" "ERRr"
                    }
        # copy if impossible

        WriteLog "$FuncName Source file [$Source] target folder [$Target] mask [$Mask]" "MESS" $Verbose

    }
    else
    {
        WriteLog "$FuncName Source file [$Source] or target folder [$Target] does not exist" "ERR" $Verbose
    }

     <#   
            # Проверка что есть более свежая версия файла, если нет, то дальнейшая работа не имеет смысла. 

    	    $arr = Get-ChildItem -Path $SQLExportPath -Force -Filter $SQLBackUpFileMask[$i]

            # Берем максимальную дату из имеющихся файлов (попавших под маску), если нет файлов в таргетном каталоге считаем что дата последней выкладки 01-01-1970.
            # Сбрасываем значение даты, заоодно если нет файлов в каталоге для экспорта - считаем что там очень старый файл.
            $FileDate = get-date ("1970/01/01");

       	    Foreach ($File in $arr) 
            {

                WriteLog ("Extract date from file name [" + $File.FullName + "]") "DUMP"             

                #Extract date from file name
                $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ищем в аормате yyyy-MM-dd.
                #$match
                #$match.Value
        
                # если в файле небыло ничего похожего на дату - пропустим этот файл
                if ($match.Value -ne "")
                {
                    $nfDate = get-date ($match.Value)
                    if ($FileDate -lt $nfDate)
                    {
                        $FileDate = $nfDate
                    }
                }
            }

#-------
            if ($FileDate -lt $FileMaxDate)
            {
                WriteLog "New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"

                $SQLBackUpFileMask[$i]
                # Удаляем неактуальную версию
                $File = $SQLExportPath + "\" + $SQLBackUpFileMask[$i]
                DeleteFile -File $File -Verbose

                #Test-Path -Path $SQLExportPath
                if (Test-Path -Path $SQLExportPath)
                {
                    # Пробуем создать хардлинк
                    #New-Item -ItemType HardLink -Name "$SQLExportPath\$LastFile" -Value "$SQLBackUpPath\$LastFile"
                    #$command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"

                    WriteLog "Try to create New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"
                    $command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"
                    invoke-expression $command

                    if (-not (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue) )
                    {
                        # Если не удалось создать хардлинк пробуем скопировать
                        WriteLog "Did not create HardLink of file for export [$SQLExportPath\$LastFile], try to create a copy" "DUMP"
                                
                        # Проверка наличия свободного места на диске под копию файла
                        if ( CheckFreeSpace -Path $SQLExportPath -Size $File.Length  ) #-Verbose
                        {
                            # Копирование файла если место есть
                            Copy-Item -Path $SQLBackUpPath\$LastFile -Destination $SQLExportPath\$LastFile
                        }
                    }
                    # Финальная проверка что создалась копия
                    if (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created copy of file for export (to Tape) [$SQLExportPath\$LastFile]" "MESS"
                    }
                    else 
                    {
                        # Если не удалось создать и копии тоже - ругаемся красненьким
                        WriteLog "Did not create file for export [$SQLExportPath\$LastFile] (HardLink or Copy)" "ERRr"
                    }
                }
                else
                {
                    WriteLog "Export folder does not exist [$SQLExportPath]" "ERRr"
                }
            }
            Else 
            {
                WriteLog "NO New file for export. Last file [$LastFile] is same as old file [$SQLExportPath\$File]" "DUMP"
            }
            <# #>
}


function add_Subfolder_to_Path ()
{
    # Add subfolder to path and create if not exist
    param (
		[string]$Path = "",             # Исходный фолдер
		[string]$SubFolderName = "",		    # Сабфолдер.
		[switch]$Create = $FALSE,		# Создать если такого нет.
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

	# имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    $x = TestFolderPath -Path $Path

    if ( ($Path.Length -gt 3) -and ($SubFolderName.Length -gt 0) )
    {
        if ( $SubFolderName.Substring(0,1) -eq "\" ) 
        {
            $SubFolderName = $SubFolderName.Substring(1)
        }
        
        $CombinedPath = "$Path\$SubFolderName"
        
        if ( $Create )
        {
            $x = TestFolderPath -Path $CombinedPath -Create
        }
        else
        {
            $x = TestFolderPath -Path $CombinedPath
        }

        #$CombinedPath
        
        return $CombinedPath
    }
    else
    {
        WriteLog "$FuncName Path or SubfolderName is shortly [$Path] / [$SubFolderName]" "INFO" $Verbose

    }

    return $FALSE
    

}

#add_Subfolder_to_Path -Path "C:\BackUp" -SubFolderName "ffff5"
#break


function get_CombinedPath ()
{
    # из двух путей выбирает актуальный либо склеивает в один
    # - если не указана локальная - используется дефолтная
    # - если локальная относительная "\addPath" (обязательно с ведущим бэк-слешем - добавит ее к дефолтной
    # - если указана локальная и начинается не со слеша - она считается правильной и берется
	param (
		[string]$Default = "",
		[string]$Local = "",
		[switch]$Create = $FALSE,		# Создать если такого нет.
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

    if ( ($Local.Length -gt 1) -and ( $Local.Substring(0,1) -eq "\") )
    {
        $CombinedPath = add_Subfolder_to_Path -Path $Default -SubFolderName $Local -Create -Verbose
        #$CombinedPath = $BackUpPath + $Path
    }
    elseif ( ($Local.Length -gt 0) -and ( $Local.Substring(0,1) -ne "\") )
    {
        $CombinedPath = $Local
    }
    else
    {
        $CombinedPath = $Default
    }

    if ( $Create )
    {
        $x = TestFolderPath -Path $CombinedPath -Create
    }

    return $CombinedPath
}

function get_BackUpPath ()
{
    # из глобальной и локальной BackUpPath - выбирает актуальную либо склеивает в одну
    # - если не указана локальная - используется глобальная
    # - если локальная относительная "\addPath" (обязательно с ведущим бэк-слешем - добавит ее к глобальной
    # - если указана локальная и начинается не со слеша - она считается правильной и берется
	param (
		[string]$Path = "",
		[switch]$Create = $FALSE,		# Создать если такого нет.
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

    $CombinedPath = get_CombinedPath -Default $BackUpPath -Local $Path -Create
    <#
    if ( ($Path.Length -gt 1) -and ( $Path.Substring(0,1) -eq "\") )
    {
        $CombinedPath = add_Subfolder_to_Path -Path $BackUpPath -SubFolderName $Path -Create -Verbose
        #$CombinedPath = $BackUpPath + $Path
    }
    elseif ( ($MySQLBackUpPath.Length -gt 0) -and ( $Path.Substring(0,1) -ne "\") )
    {
        $CombinedPath = $Path
    }
    else
    {
        $CombinedPath = $BackUpPath
    }

    if ( $Create )
    {
        $x = TestFolderPath -Path $CombinedPath -Create
    }
    #>

    return $CombinedPath
}

function get_ExportPath ()
{
    # из глобальной и локальной ExportPath - выбирает актуальную либо склеивает в одну
    # - если не указана локальная - используется глобальная
    # - если локальная относительная "\addPath" (обязательно с ведущим бэк-слешем - добавит ее к глобальной
    # - если указана локальная и начинается не со слеша - она считается правильной и берется
	param (
		[string]$Path = "",
		[switch]$Create = $FALSE,		# Создать если такого нет.
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)

    $CombinedPath = get_CombinedPath -Default $ExportPath -Local $Path -Create

    return $CombinedPath
}


function MySQLBackUp ()
{
	param (
		[string]$User = "",
		[string]$Password = "",
		[string]$DataBase = "",
		[string]$File = "",
		[switch]$Verbose = $FALSE		# в консоль все события лога пишет
	)
	
    # имя функции
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";
    
    WriteLog "$FuncName Create MySQL dump from [$DataBase] to [$File]" "INFO" $Verbose

    TestFolderPath -Path (Split-Path -Path $File -Parent) -Create

    # Создать такой логин пач можно командой:
    # mysql_config_editor set --login-path="backup-lp" --host="localhost" --user="backup" --password

    $command = "cmd /c $MySQLDumperPath -u $User -p$Password $DataBase > $File"
    #$command = "cmd /c $MySQLDumperPath --login-path=backuplp $DataBase > $File"
    
    WriteLog "$FuncName Exec: [$command]" "DUMP" $Verbose
    #echo $command
    invoke-expression $command

    $FileCreated = Get-ChildItem -Path $File
    
    #$FileCreated.Length

    if ( (Test-Path -Path $File) -and ($FileCreated.Length -gt 0) )
    {
        WriteLog "$FuncName Succesfully created Back Up of DB [$DataBase] in to [$File]" "MESS" $Verbose
    }
    else
    {
        WriteLog "$FuncName Failed dump DB [$DataBase] in to [$File]" "ERRr" $Verbose
    }

}



function  SQLBackup ()
{
}