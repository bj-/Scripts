
param (
	[string]$Path = "c:\Logs\",
	[string]$FileFilter = "Modem*.log",
	[string]$LookFor = 'Запуск',
	[switch]$CountOnly = $FALSE
	#,
	#[string]$someone = $( Read-Host "Input password, please" )
)


# Script Version
$scriptver = "1.0.1";

clear;


$Files = Get-ChildItem -Path $Path -Force -Recurse -Include $FileFilter -Name; # рекурсивно список всех файлов в каталоге и подкаталогах

Foreach ($File in $Files) 
{
	$FullPath = $Path + $File;

	write-host "File: $FullPath " -ForegroundColor Cyan

    $lines = Get-Content -Path $FullPath | where {$_ -match $LookFor};
    #write-host $lines.Count
    $HitsCount = $HitsCount1 + $lines.Count

    

    if ($CountOnly -eq $FALSE)
    {
	    Get-Content -Path $FullPath | where {$_ -match $LookFor}; # Выбираем строки датафрейм
    }

    Write-host "Total: $HitsCount" -ForegroundColor Green

}
