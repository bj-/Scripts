
#
# Поиск заданной строки в файлах
# 
#


param (
	[string]$Path = "C:\Shturman\Bin\log\",
	[string]$FileFilter = "*.log",
	[string]$LookFor = "ERR"
	#,
	#[string]$someone = $( Read-Host "Input password, please" )
)

# Script Version
$scriptver = "1.0.0";




$arr = Get-ChildItem -Path $Path -Force -Recurse -Include $FileFilter -Name; # рекурсивно список всех файлов в каталоге и подкаталогах

$Lines = "";

Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	write-host "File: $FullPath "

#		Get-Content -Path $path -Tail 10
	Get-Content -Path $FullPath -Tail 1000 | where {$_ -match $LookFor}; # Выбираем строки датафрейм
#	write-host $s

#	$ss = $ss -replace ".*Name=""", "" # убираем то что до назвния фрема
#	$ss = $ss -replace """ .*", ""     # и то что после



}