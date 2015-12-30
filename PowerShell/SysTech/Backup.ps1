<#
    1. Log Archiver
       - ������������� ���� *.log ������ �� ����������� �����������
       - � �������� Old
       - �� ���������� 1 ��� � ����� � 03:30 (��������� ������)
    2. MS SQL BackUP
       - �� Shturman_Metro ������ ����� (������ � MS SQL)
       - � ����� d:\BackUP
       - TODO ������������� ������
       - TODO �������� ������ ������� �� �������� (2 ��� - ����������, 3 ������ - ���������, ������ - �����������)
       - TODO ��������� ������ ������� �� ���������� 1 ��� � ����� � 03:00
#>


param (
	[string]$LogFilePath = "D:\Shturman\Bin\Log",
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old",
	[string]$DateFormatLog = "yy-MM-dd",
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro",

	[string]$BackUpDaily = "14", # Days
	[string]$BackUpWeekly = "13", # Weeks
#	[string]$BackUpMontly = "14", # Days
#	[string]$AppPath = "C:\Shturman\",
	[switch]$Debug = $FALSE		# � ������� ��� ������� ���� �����
)

$version = "1.0.0";

# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"

# ===============================================
#                   Functions
# ===============================================

<#
function  SQLBackup ($SQLDBName, $SQLUsername, $SQLPassword, $SQLBackUpPath)
{
}
#>

clear;
	WriteLog "Script version: [$version]"


	if (-not (test-path $LogFilePath))
	{
		WriteLog "Log File path [$LogFilePath] doesn't exist" "ERRr"
		break;
	}
	if (-not (test-path $LogFilePathOld))
	{
		WriteLog "Path for Arcived Files [$LogFilePath] doesn't exist" "ERRr"
		break;
	}


	# ������� ���� � ������� ������� ����������� ��� ���������� ������
	$currDate = Get-Date -Format $DateFormatLog


	# ������ ���� ������
	$arr = Get-ChildItem -Path $LogFilePath -Force -Include *.log -Name | where {$_ -notmatch "$currDate.log" };

#	echo "Service's Error Logs Sensor [version: $scriptver]`r`nMonitoring *.Error files in folder $ErrLogPath"

	$i = 0;

	Foreach ($File in $arr) 
	{
		$path = $LogFilePath + "\" + $File;
		$arcPath = "$LogFilePathOld\$File.zip"

#		WriteLog "Processing file [$File]" "INFO"

		$res = d:\prog\7-zip\7za.exe a $arcPath -sdel $path

		WriteLog "$res" "DUMP"

		if (test-path $arcPath)
		{
			WriteLog "File [$File] moved to archive [$File.zip]" "MESS"

			if (test-path $path -ErrorAction SilentlyContinue)
			{
				WriteLog "Source file [$path] doesn't removed" "ERRr"
				
			}
			
		}
		Else
		{
			WriteLog "Arcived File [$arcPath] doesn't exist" "ERRr"
		}

#$File
#		WriteLog $path "INFO"
	}
