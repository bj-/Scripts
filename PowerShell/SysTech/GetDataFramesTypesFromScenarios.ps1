#
# ����� ���������� ������ � ��������� ��������.
# �������� ��� ������ ���������, �� �� ��������� ������ ����������, ������ �������� ������ ����������.
#

$Path = "D:\Shturman\Scripts\testScripts\21trains\"

$arr = Get-ChildItem -Path $Path -Force -Recurse -Include *.scenario -Name; # ���������� ������ ���� ������ � �������� � ������������

$Lines = "";

Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	write-host "File: $FullPath "

#		Get-Content -Path $path -Tail 10
	$ss += Get-Content -Path $FullPath | where {$_ -match "DataFrame "}; # �������� ������ ���������

	$ss = $ss -replace ".*Name=""", "" # ������� �� ��� �� ������� �����
	$ss = $ss -replace """ .*", ""     # � �� ��� �����



}

$ss = $ss | select -uniq # ������� ���������

$ss