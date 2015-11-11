#
# Show Log. Show log ShturmanHub Service
#
#  Version 1.0.04
#

# Settings
param (
	# дефолтный путь
	[string]$FilePath = "Z:\",
	[string]$FilePrefix = "ROOT-",
	[string]$DateFormat = "yy-MM-dd",
	[int]$RowsInTail = 100, # сколько строк с конца читать мз файла

	[string]$WelcomeStr = "File: "

	#[string]$someone = $( Read-Host "Input password, please" )

)

Clear;
#$FilePath = "Z:\";
#$MaxRow = 55;

$ExcludeFromLog = "ALIVE|Получен пакет|Передан пакет|Скорость приема данных";
#$ExcludeFromLog = "";


#Colorer (регулярки поддерживаются)
$Red = "ERR:"
$Yellow = "WRN:"
$Green = "HELLO|WELCOME|CLOSE|Запрос подключения|Запрос авторизации"
$DarkBlue = "ALIVE|скорость приема"

Clear;
write-host "$WelcomeStr $LogFile";

#$LastLine = "";
#$FirstRun = 1;
while (1) 
{
	$CurDate = Get-Date -format $DateFormat;
	$LogFile = $FilePath + $FilePrefix + $CurDate +".log";

	if (test-path -path $LogFile)
	{
		# читаем хвост файла где $RowsInTail = кол-во читаемых строк с конца
		$Lines = Get-Content -Path $LogFile -Tail $RowsInTail | where  { $_ -notmatch $ExcludeFromLog }

#		$NewLineIndex = 0;
#		if ($FirstRun -eq 1) 
#		{
#			$FirstRun = 0;
#			$NewLineIndex = 0;
#		}

		# если файл уже читали, то последняя строка записана в переменную $LastLine, ее и ищем в полученном массиве строк из файла
		# если не читали - показываем все что прочитали из файла
		if ($LastLine)
		{

			#Log Errors
#			$currTime = Get-Date -Format " HH-mm-ss"
#			"----- $CurDate - $currTime ------" | Out-File showlog.log -Encoding "default" -Append
#			$LastLine | Out-File .\showlog.log -Encoding "default" -Append
#			$Lines.Count | Out-File .\showlog.log -Encoding "default" -Append
			"---------------------------------" | Out-File showlog.log -Encoding "default" -Append

			# индекс строки в массиве в которой обнаружили совпадение, чтоб продолжить вывод после этой строки, а старые заигнорить
			$aa = [array]::indexof($Lines,$LastLine)
			if ($aa -gt -1)
			{
				$i = ($aa+1); # +1 дабы не дупилась последняя строка при перезачитывании файла
			}
			Else 
			{
				$i = 0;
				write-host "...`n`rSome Lines were missed`n`r..." -foregroundcolor "gray";
			}
		}
		else
		{
			$i = 0;
		}

		# показываем новый строки. + раскраска строк. по каким признакам раскрашивать - в шапке
		while ($Lines.Count -gt $i)
		{
			$line = $Lines[$i];
			if ($line  -match $Yellow)
			{
	                	write-host $line -foregroundcolor "yellow" 
			}
			elseif ($line  -match $Red)
			{
	                	write-host $line -foregroundcolor "red" 
			}
			elseif ($line  -match $Green)
			{
	                	write-host $line -foregroundcolor "green" 
			}
			elseif ($line  -match $DarkBlue)
			{
	                	write-host $line -foregroundcolor "darkblue" 
			}
			else 
			{
	                	write-host $line
			}
			
			# последнюю прочитанню строку запоминаем
			# ToDo надо бы делать это один раз, за цикл, а не на каждой строке.
			$LastLine = $Lines[$i];
			
			$i++;
		}			
	}
	else
	{
		# если файл отсутвует - ругаемся
		write-host "File отсутвует." -foregroundcolor "yellow"
	}

	# сон между циклами зачитывания файла. пусть диск отдохнет
	Start-Sleep -Seconds 1; 
}