#
# Show Log. Show log ShturmanHub Service
#
#  Version 1.0.1
#
param (
	[string]$FilePath = "Z:\" 
#	[string]$FilePrefix = "STB010-"
	#,
	#[string]$someone = $( Read-Host "Input password, please" )

)

Clear;
# Settings
#$FilePath = "Z:\";
$FilePrefix = "ROOT-";
$DateFormat = "yy-MM-dd";
$MaxRow = 55;
$RowsInTail = 90;
$ExcludeFromLog = "ALIVE|Получен пакет|Передан пакет|Скорость приема данных";

$WelcomeStr = "File: "

#Colorer
$Red = "ERR:"
$Yellow = "WRN:"
$Green = "HELLO|WELCOME|CLOSE|Запрос подключения|Запрос авторизации"
$DarkBlue = "ALIVE|скорость приема"


while (1) 
{
	Clear;
	$CurDate = Get-Date -format $DateFormat;
	$LogFile = $FilePath + $FilePrefix + $CurDate +".log";
	
	write-host "$WelcomeStr $LogFile";
#	$Lines = Get-Content (Get-Content -Path $LogFile -tail 5000 | where  {$_ -notmatch "ALIVE|Получен пакет|Передан пакет|Скорость приема данных"}) -Tail 50
#	$Lines = Get-Content -Path $LogFile -tail 50
#	$Lines = 

	if (test-path -path $LogFile)
	{
		$LinesRAW = Get-Content -Path $LogFile -Tail $RowsInTail | where  { $_ -notmatch $ExcludeFromLog }

		#$arr = Get-Content D:\Shturman\Bin\Log\STB010-15-10-27.log -Tail 500 | where  {$_ -notmatch "ALIVE|Получен пакет|Передан пакет|Скорость приема данных"}

		$Linescnt = $LinesRAW.Count;


		if ($Linescnt -gt 0) # Если полученный массив длиннее экрана - опредляем с какой строчки надо его зачитывать
		{
			if ( $MaxRow -gt $Linescnt ) { $iStartRow = 0; }
			else { $iStartRow = $Linescnt-$MaxRow; }
		}
		else
		{
			$iStartRow = 0;
		}


		$Lines = @();
		while ($iStartRow -lt $Linescnt)
		{
			$Lines += $LinesRAW[$iStartRow];
		#	write-host $LinesRAW[$iStartRow];
			$iStartRow++;
		#	echo $i;
		}
	
		foreach ($line in $Lines)
		{	
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
		}
	}
	Else
	{
	write-host "File отсутвует." -foregroundcolor "yellow"
	}

	Start-Sleep -Seconds 1; 
}