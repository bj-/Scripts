function BackUp_Logs()
{

    $ModVer = "1.0.1"
    $ModName = "LogFiles"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"

    # проверки на существование путей
    # - фолдера для Лог файлов и фолдера для архивов
    $x = TestFolderPath -Path $LogFilePath #-Verbose
    $x = TestFolderPath -Path $LogFilePathOld -Create #-Verbose


    # Удаление старых заархивированных логов
    if ($PurgeLogFiles -eq $TRUE){ FilePurge -Path $LogFilePathOld -LogFilePurgeDays $LogFilePurgeDays <# -Verbose #>; };


#break;
    	# Текущая дата в формате который используется для именования файлов
    	$currDate = Get-Date -Format $DateFormatLog

    	WriteLog "Move Log Files to Archives" "INFO"

    	# массив всех файлов
    	# TODO: сделать как-то покрасивше. т.е. из набранного массива выпиливать лишнее, а не так как сейчас
    	if ($LogFileAll2Arc -eq $TRUE)
    	{
		    $arr = Get-ChildItem -Path $LogFilePath -Force -Filter "*.log" -Name;
	    }
	    Else
	    {
            $notmatch = $currDate -replace "-", "[\.-]"
            #$notmatch
            #WriteLog "Get-ChildItem -Path $LogFilePath -Force -Filter *.log -Name | where {`$_ -notmatch $currDate.log" "dump"
            WriteLog "Get-ChildItem -Path $LogFilePath -Force -Filter *.log -Name | where {`$_ -notmatch $notmatch.log" "dump"
    		$arr = Get-ChildItem -Path $LogFilePath -Force -Filter "*.log" -Name | where {$_ -notmatch "$notmatch.log" };
            #break
    	}

    #	echo "Service's Error Logs Sensor [version: $scriptver]`r`nMonitoring *.Error files in folder $ErrLogPath"
    
    #	$i = 0;

    	Foreach ($File in $arr) 
    	{
		    $path = $LogFilePath + "\" + $File;
		    $arcPath = "$LogFilePathOld\" + "$LogFolderForArchives\$File.7z"
    
		    WriteLog "Processing file [$File]" "DUMP"

            # Архивирование файлов в папке в архив вида Errors_yyyy-MM-dd_HHmm.7z с удалением файлов
            ArchiveFiles -Path $path -arcPath $arcPath -DelSource -Verbose

    	}
    # Заливка заархивированных логов на сервер
    if ($UploadLogFiles -eq $TRUE)
    {
    #	UploadFiles # -Verbose
    }
}