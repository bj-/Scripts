#
# Поиск уникальных фремов в сценариях Штурмана.
# Выбираем все строки датафрейм, из ни названияе фремов вырезаются, список выдается только уникальных.
#

$Path = "D:\Shturman\Scripts\testScripts\21trains\"

$arr = Get-ChildItem -Path $Path -Force -Recurse -Include *.scenario -Name; # рекурсивно список всех файлов в каталоге и подкаталогах

$Lines = "";

Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	write-host "File: $FullPath "

#		Get-Content -Path $path -Tail 10
	$ss += Get-Content -Path $FullPath | where {$_ -match "DataFrame "}; # Выбираем строки датафрейм

	$ss = $ss -replace ".*Name=""", "" # убираем то что до назвния фрема
	$ss = $ss -replace """ .*", ""     # и то что после



}

$ss = $ss | select -uniq # убираем дубликаты

$ss