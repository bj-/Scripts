<#
 Проверка уровней мощности установленных в метках станций

#>

# [SENSORLBLDATA: BlockSerialNo=STB10305;SensorSerialNo=STL009-04-08-2;Version=4;TxPwr=9;Battery=99;Line=4;Station=8;Way=

param (
	[string]$Path = "D:\Shturman\BIN\Log\",
	[string]$FilePrefix = "Root",
	[int]$MaxRowsAnalyze = 1000000,  # 1kk Lines = 3 minutes, 50kk = 1h
	[switch]$Debug = $TRUE
)

# Script Version
$scriptver = "1.0.0";

clear;

$StartDateTime = Get-Date

Write-host "Check Power in labels on metro stations" 
Write-host "Working wery slow. Because Log file is very big. Please wait, smoking, drinking and sleeping." 
Write-host "Analyzing last [$MaxRowsAnalyze] rows in log file"   -foregroundcolor green
Write-host "Run at: " ( Get-Date -Format "dd.MM.yyyy hh:mm:ss")  -foregroundcolor darkgray
# Write-host "От Дыбенко 1-й путь, от Спасской 2-й путь"
<#

Write-host "На метках должна быть мощность:"
Write-host "Метка			Pwr	Станция"
Write-host "STL001-04-01-1	1	Дыбенко в сторону ветки"
Write-host "STL009-04-08-2	1	Спасская в сторону ветки"
Write-host "STL017-04-09-1	3	ПТО"
Write-host "Все остальные	5	все остальные"
#>

[array]$OriginalLabels = "STL001-04-01-1	1                   	улица Дыбенко в сторону Проспект Большевиков", 
                         "STL002-04-02-1	5                   	Проспект Большевиков в сторону Ладожская", 
                         "STL003-04-03-1	5                   	Ладожская в сторону Новочеркасская", 
                         "STL004-04-04-1	5                   	Новочеркасская в сторону пл.Александра Невского - 2", 
                         "STL005-04-05-1	5                   	пл.Александра Невского - 2 в сторону Лиговский проспект", 
                         "STL006-04-06-1	5                   	Лиговский проспект в сторону Достоевская", 
                         "STL007-04-07-1	5                   	Достоевская в сторону Спасская", 
                         "STL008-04-08-1	5                   	Спасская в сторону Оборот", 
                         "STL009-04-08-2	1                   	Спасская в сторону Достоевская", 
                         "STL010-04-07-2	5                   	Достоевская в сторону Лиговский проспект", 
                         "STL011-04-06-2	5                   	Лиговский проспект в сторону пл.Александра Невского - 2", 
                         "STL012-04-05-2	5                   	пл.Александра Невского - 2 в сторону Новочеркасская", 
                         "STL013-04-04-2	5                   	Новочеркасская в сторону Ладожская", 
                         "STL014-04-03-2	5                   	Ладожская в сторону Проспект Большевиков", 
                         "STL015-04-02-2	5                   	Проспект Большевиков в сторону улица Дыбенко", 
                         "STL016-04-01-2	5                   	улица Дыбенко в сторону Оборот", 
                         "STL017-04-09-1	3                   	ПТО А.Невского"



$CurrDate = Get-Date -Format "yy-MM-dd"

$FullPath = "$Path$FilePrefix-$CurrDate.log"

Write-host "Searching in file [$FullPath]" -foregroundcolor gray


$lines = Get-Content -Tail $MaxRowsAnalyze -Path $FullPath | where {$_ -match 'SensorSerialNo=STL(.*)TxPwr=9'};
#$lines = Get-Content -TotalCount $MaxRowsAnalyze -Path $FullPath | where {$_ -match 'SensorSerialNo=STL(.*)TxPwr=9'};


[System.Collections.ArrayList]$Labels = "SensorSerialNo	Pwr	Station", "======================================"

foreach ($line in $lines)
{
    #write-host $line
    #$l = $line -match 'SensorSerialNo=([STL][0-9]-)*;'
    #write-host $l

    # Вычленяем из строки номер метки
	$match = [regex]::Match($line,"STL(.*?);")
    $SensorSerialNo = $match.Value -replace ";", ""
    
    # и ее мощность
   	$match2 = [regex]::Match($line,"TxPwr=([0-9]){1,1}")
    $Power = $match2.Value -replace "TxPwr=", ""

    #write-host "$SensorSerialNo	$Power"
    
    # если такую метку с такой мощностью еще не встречали - в массив ее добавляем
    if (-not ($Labels -contains "$SensorSerialNo"))
    {
        $x = $Labels.Add("$SensorSerialNo")
        
        #Write-host "$SensorSerialNo	$Power"
    }
}

# Показываем то что получилось
if ($labels.Count -eq 2)
{
	Write-host "Меток со слетевшей мощностью не найдено" -foregroundcolor green

}
else
{
	Write-host "Метки со слетевшей мощностью (=9)`n`n" `
	            "Метка      	Установить мощноcть 	Cтанция"
	foreach ($label in $labels)
	{
	#$label
	    foreach ($OriginalLabel in $OriginalLabels)
	    {
	        #($OriginalLabel -match $label)
	        if ($OriginalLabel -match $label)
	        {
	            $OriginalLabel
	        }
	    }
	}
}
                                               



$EndDateTime = Get-Date
$TimeSpent = $EndDateTime - $StartDateTime
Write-host "`n`nEnd at: " ( Get-Date -Format "dd.MM.yyyy hh:mm:ss") -foregroundcolor darkgray
Write-host "Spent: " $TimeSpent.Days "days" $TimeSpent.Hours "h" $TimeSpent.Minutes "m" $TimeSpent.Seconds "s"   -foregroundcolor darkgray
