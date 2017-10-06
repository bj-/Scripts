# Calculate Total execution time for scenarios in folder

$ScenariosPach = "C:\ShturmanDemo\Shturman_MGT_FATP\Scripts\TestScripts\FATP"


# Script

clear;

Write-Host "Calculate Total execution time for scenarios" -ForegroundColor "green"
Write-Host "Scenarios path is [$ScenariosPach]"

$Files = Get-ChildItem -Path $ScenariosPach -Filter "*.scenario"
#$Files = Get-ChildItem -Path C:\ShturmanDemo\Shturman_MGT_FATP\Scripts\TestScripts\FATP -Filter "8709.scenario"


foreach ($file in $Files)
{
    #$file.FullName
    $Lines = Get-Content -Path $file.FullName | where {$_ -match "Timeout"};

    #$i=0;

    $TotalTime = 0;

    foreach ($line in $Lines)
    {
        #$line
	    $match = [regex]::Match($line,'Timeout="(\d*)"')
        #$match = [regex]::Match($File,"(\d){2}-(\d){2}-(\d){2}") # тоже что и предыдущий, но более понятно.
        #$match
        #$match.Value

        $val = $match.Value -replace 'Timeout="', ''
        $val = $val -replace '"', ''

        #$val
        $TotalTime += $val

        #$i++
        #if ($i -gt 10) {break;}
     
        #break
        #$line
    }
    #Extract tile from millisecond
    $ts = [timespan]::frommilliseconds($TotalTime)
    #$ts
    $res = "$($ts.Days)d $($ts.hours):$($ts.minutes):$($ts.seconds),$($ts.milliseconds)"
    #$res

    # подравниваем итоговую табличку
    $ResFilename = ("Scenario [" + $file.Name +"]")
    if ($ResFilename.Length -gt 30)
    {
        $AddSpaces = 1
    }
    Else 
    {
        $AddSpaces = (30-$ResFilename.Length)
    }
    $ResFilename = $ResFilename + ' ' * $AddSpaces


    write-host ("$ResFilename is [$res]")

    #("{0:HH\:mm\:ss\,fff}" -f $ts)

    
    
}