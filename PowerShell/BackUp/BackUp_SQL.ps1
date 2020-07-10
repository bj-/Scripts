if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile;  break }

function BackUp_MSSQL()
{
    $ModVer = "1.0.1"
    $ModName = "MSSQL"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"

    $SQLBackUpPath = get_BackUpPath -Path $SQLBackUpPath
    $SQLExportPath = get_ExportPath -Path $SQLExportPath


    # $x = TestFolderPath -Path $SQLBackUpPath #-Verbose

    writelog "SQL Settings: SQLBackUpPath: [$SQLBackUpPath], SQLBackUpFileMask: [$SQLBackUpFileMask], SQLDateFormatLog: [$SQLDateFormatLog]" "DUMP"

	WriteLog "Purge old SQL BackUp files, Limits SQL [$SQLLimits]; Default: [$DefaultStoreLimits]" "INFO"


#   [array]$SQLLastBackUpFile = @()


    for($i=0; $i -lt $SQLBackUpFileMask.Count; $i++)
    {
        $Mask = $SQLBackUpFileMask[$i]

    	WriteLog "Process SQL BackUp by Mask: [$Mask]" "INFO"


    	$arr = Get-ChildItem -Path $SQLBackUpPath -Force -Filter $SQLBackUpFileMask[$i]

        $FileMaxDate = ""; # максимальная дата файла
        $LastFile = ""; # файл с максимальной датой
        
        # File Purge
        purge_oldBackUp -Path $SQLBackUpPath -FileMask $Mask -Limits $SQLLimits -Verbose

        <#
    	Foreach ($File in $arr) 
    	{
            #$File.Name;

            #Extract date from file name
    		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # этот вариант красивше, но возвращает дату с точкой на конце
		    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ищем в формате yyyy-MM-dd.
    		#$match
    		#$match.Value

    		# если в файле небыло ничего похожего на дату - пропустим этот файл
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

                if ($FileMaxDate -lt $FileDate) 
                { 
                    $FileMaxDate = $FileDate;
                    $LastFile = $File;
                }

                <#
    			# сравниваем даты. Пропускаем и не удаяем файлы младше требуемой даты.
			    if ($FileDate -lt (Get-Date).AddDays(-$SQLBackUpDaily))
			    {

                    # если файл не от 1/10/20 числа месяца и находится в диапазоне дат от $SQLBackUp10days до $SQLBackUpDaily  - удаляем
                    if (($FileDate -gt (Get-Date).AddDays(-$SQLBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл не от первого числа месяца и находится в диапазоне дат от $SQLBackUpMontly до $SQLBackUp10days - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SQLBackUpMontly))) -and ($FileDate.Day -notin 1) )
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }
                }
                
            }
            
        }
        #>


        # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
	    if ( $SQLExport )
        {
	        #WriteLog "Create a latest copy of SQL backup(s) in Export folder [$SQLExportPath]" "DUMP"
    
            # Проверка наличия пути без создания оного.
            TestFolderPath -Path $SQLExportPath #-Verbose
        
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
        }


        # Архивирование бекапа (как правило с целью нарезки на куски для заливки на сервак)
        if ($SQLExportUploadArc) 
        {
            WriteLog "Try to Arcive Backup file: [$SQLExportPath\$LastFile], ArcLevel: [0], Volume: [$SQLExportUploadArcPart]" "DUMP"

            # Архивирование файлов в папке в архив вида [исходное имя файла].7z
            #$acrPath = "$SQLExportPath\$LastFile"+".7z"
            ArchiveFiles -Path "$SQLExportPath\$LastFile" -arcPath ("$SQLExportPath\$LastFile"+".7z") -DelSource -Size $SQLExportUploadArcPart -StoreArchive -Verbose # -DelSource

            #$SQLExportUploadArcPart
        }

        if ( $SQLExportUpload ) 
        {
            UploadFiles -Path $SQLExportPath -UploadPath $SQLExportUploadPath -UploadCred $SQLExportUploadCred -Verbose
        }

    }
 }