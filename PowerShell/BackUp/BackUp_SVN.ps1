if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile;  break }

function BackUp_SVN(){

    # SVN
    $ModVer = "1.0.1"
    $ModName = "SVN"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"
    
    WriteLog "SVN BackUp: Repositories: [$SVNRepoPath]" "INFO"

    #BackUp SVN Repository
    $CurrDate = Get-Date -Format "yyyy-MM-dd"
    $CurrTime = Get-Date -Format "HHmm"
    $BackUpFolderName = "SVN_$CurrDate" + "_$CurrTime"
    $SVNBackUpPathCurrent = "$SVNBackUpPath\$BackUpFolderName"

    #TestFolderPath -Path $SVNBackUpPathCurrent  -Create #-Verbose
    TestFolderPath -Path "$SVNBackUpPathCurrent\Conf"  -Create #-Verbose


    # Purge old BackUp

   <#	
   $arr = Get-ChildItem -Path $SVNBackUpPath -Force -Directory

    #$arr

   	Foreach ($File in $arr) 
   	{
        #$File
        #$File.Name;

        #Extract date from file name
 		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # этот вариант красивше, но возвращает дату с точкой на конце
	    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
	    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ищем в аормате yyyy-MM-dd.
   		#$match
   		#$match.Value

   		# если в файле/каталоге небыло ничего похожего на дату - пропустим этот файл
	    if ($match.Value -ne "")
	    {
        }

   			$FileDate =  get-date ($match.Value)
            #$match.Value

  			# сравниваем даты. Пропускаем и не удаяем файлы младше требуемой даты.
		    if ($FileDate -lt (Get-Date).AddDays(-$SVNBackUpDaily))
		    {

                #$FileDate
                #$FileDate.Day -notin 1, 10, 20
                #$File.Name

                # если файл не от 1/10/20 числа месяца и находится в диапазоне дат от $SQLBackUp10days до $SQLBackUpDaily  - удаляем
                #($FileDate -gt (Get-Date).AddDays(-$SVNBackUp10days))
                #($FileDate.Day -notin 1, 10, 20)
                if (($FileDate -gt (Get-Date).AddDays(-$SVNBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                {
                    $File.Name;
                    #$File.FullName;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # если файл не от первого числа месяца и находится в диапазоне дат от $SQLBackUpMontly до $SQLBackUp10days - удаляем
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SVNBackUpMontly))) -and ($FileDate.Day -notin 1) )
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # если файл старше даты $SQLBackUpMontly и не от 1-го числа квартала - удаляем
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }


            }



    }
    #>

    #break;
    
    # Copy SVN Config Files
	WriteLog "Try to copy SVN configuration files" "DUMP"
    Copy-Item -Path "$SVNRepoPath\*.conf" -Destination "$SVNBackUpPathCurrent\Conf"
    Copy-Item -Path "$SVNRepoPath\*.pid" -Destination "$SVNBackUpPathCurrent\Conf"
    Copy-Item -Path "$SVNRepoPath\htpasswd" -Destination "$SVNBackUpPathCurrent\Conf"
   	WriteLog "SVN Configuration copied to [$SVNBackUpPathCurrent\Conf]" "MESS"
    
    # TODO сделать проверку что оно скопировалось


    # Получаем список репозиториев (один фолдер - один репозиторий)
    $arr = Get-ChildItem -Path $SVNRepoPath -Force -Directory -Name;
    
  	Foreach ($File in $arr) 
   	{
    	WriteLog "Try to create dump of repository [$SVNRepoPath\$File] to [$SVNBackUpPathCurrent\$File.dump]" "DUMP"

        # дампим репы средствами 

        $command = "cmd /c svnadmin dump $SVNRepoPath\$File > $SVNBackUpPathCurrent\$File.dump"
        WriteLog "exec [$command]" "DUMP"
        invoke-expression $command
        
        #svnadmin dump $SVNRepoPath\$File > $SVNBackUpPathCurrent\$File.dump

        # проверка бессмысленная т.к. файл оно создает в любом случае
        # TODO сделать осмысленую проверку
        if (Test-Path -Path "$SVNBackUpPathCurrent\$File.dump")
        {
        	WriteLog "Dump of repository [$SVNRepoPath\$File] Created" "MESS"
        }
        else
        {
        	WriteLog "Dump of repository [$SVNRepoPath\$File] is not Created" "ERRr"
        }
    }

    $arcPath = "$SVNBackUpPath\$BackUpFolderName.7z"

    ArchiveFiles -Path $SVNBackUpPathCurrent -arcPath $arcPath -Size 0 -StoreArchive -DelSource -Verbose

    # Export last BackUp
    if ( $SVNExport )
    {
        export_backup -Source $arcPath -Target $ExportPath -Mask "SVN_" -Verbose
    }

    # чистим старье
    #purge_oldBackUp -Path $SVNBackUpPath -FileMask "SVN_" -Daily $SVNBackUpDaily -TenDays $SVNBackUp10days -Montly $SVNBackUpMontly -Verbose 
    purge_oldBackUp -Path $SVNBackUpPath -FileMask "SVN_" -Limits $SVNLimits -Verbose

}