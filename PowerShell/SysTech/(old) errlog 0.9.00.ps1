Clear;
$LogPath = "D:\Shturman\Bin\Errors\"
$CurDate = Get-Date -format "yy-MM-dd"

$LogFileClnt = $LogPath + "HubClient.exe-" + $CurDate + ".Error"
$LogFileSrv  = $LogPath + "HubServer.exe-" + $CurDate + ".Error"
$LogFileLog  = $LogPath + "LogServer.exe-" + $CurDate + ".Error"

#Get-Content $LogFileClnt;

$a = new-object -comobject wscript.shell

function errFile ($FilePath, $b)
{
	# обработка нажатий кнопок попапа. 
	# стоп скрипта, ничего не далаем, переименовым еггог файл и продолжаем работу
	$currTime = Get-Date -Format " HH-mm-ss"
	$newName = $FilePath + $currTime

	switch ( $b )
	{
		"3"
		{			
			write-host "Script was stopped by user" -ForegroundColor red
			Exit;
		}
		"4"
		{			
			write-host $msg -ForegroundColor yellow
		}
		"5"
		{	
			Rename-Item -Path $FilePath -NewName $newName
			write-host "File $FilePath was renamed `r`n to $newName" -ForegroundColor red
			Start-Sleep -Seconds 3;
		}
		default 
		{ 
			write-host $msg
		}
	}

}

while (1) 
{
#	if ($CurDate != Get-Date -format "yy-MM-dd")
#	{ # проверка текущей даты, если наступил новый день - меняем дату
		# ToDo
#	}

	echo "Service's Error Logs Sensor"
	echo "Monitoring files: `r`n - $LogFileClnt `r`n - $LogFileSrv `r`n - $LogFileLog"

	if (Test-Path $LogFileClnt ) 
	{
		echo "Found file: " + $LogFileClnt;
		Get-Content $LogFileClnt -Tail 40 ;
		$b = $a.popup("Found Errors in " + $LogFileClnt,0,"Found Errors",2)
		errFile $LogFileSrv $b;
	}
		
	if (Test-Path $LogFileSrv ) 
	{
		echo "Found file: " + $LogFileSrv;
		Get-Content $LogFileSrv -Tail 40 ;
		$b = $a.popup("Found Errors in " + $LogFileSrv,9,"Found Errors",2)
		errFile $LogFileSrv $b;
	}

	if (Test-Path $LogFileLog ) 
	{
		echo "Found file: " + $LogFileLog;
		Get-Content $LogFileLog -Tail 40 ;
		$b = $a.popup("Found Errors in " + $LogFileLog,9,"Found Errors",2)
		errFile $LogFileLog $b;
	}

	Start-Sleep -Seconds 3;
	Clear;
}


