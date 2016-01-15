<#
    1. Log Archiver
       - ������������� ���� *.log ������ �� ����������� �����������
       - � �������� Old
       - �� ���������� 1 ��� � ����� � 03:30 (��������� ������)
       - �������� ������� ������ [$LogFilePurgeDays] ����
       - TODO ������� ����� �� ������
       - TODO ���������� ������������� ����� � ������� ���� � ������ �� ������
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
	[string]$LogFilePurgeDays = "30", # Days
	[switch]$PurgeLogFiles = $FALSE, # ���������� ������ ������  $LogFilePurgeDays ����
	[switch]$UploadLogFiles = $FALSE, # ������� ��� ������ �� ������.
	[switch]$FastArcive = $FALSE, # ����� ����������� ���������. ��� ����� - ������ �� ���������, ��� � � ��� ������. �� ������� ������ ����� ��������
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

$version = "1.0.1";

# Include SubScripts
.".\..\functions\functions.ps1"
.".\..\functions\log.ps1"

# ===============================================
#                   Functions
# ===============================================

function LogFilePurge ()
{
# �������� ������ ��� ������
	param (
		[int]$LogFilePurgeDays = 30,
		[switch]$Verbose = $FALSE		# � ������� ��� ������� ���� �����
	)

	# ��������� ���� �� ������� ���� ��� ��������.
	$PurgeDate = (Get-Date).AddDays(-$LogFilePurgeDays) 

	WriteLog "Purge old log files, older than [$LogFilePurgeDays] days" "INFO"

	$arr = Get-ChildItem -Path $LogFilePathOld -Force -Filter "*.zip"


	Foreach ($File in $arr) 
	{

		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # ���� ������� ��������, �� ���������� ���� � ������ �� �����
		$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		#$match = [regex]::Match($File,"(\d){2}-(\d){2}-(\d){2}") # ���� ��� � ����������, �� ����� �������.
#		$match
#		$match.Value


		# ���� � ����� ������ ������ �������� �� ���� - ��������� ���� ����
		if ($match.Value -ne "")
		{

			# ��������� 20 � ������, ����� ��� ��� ��������� ������ � ��������������� � ����
			$FileDate =  get-date ("20" + $match.Value)

			# ���������� ����. ���� ���� ������ ��������� ���� - ������� ���.
			if ($FileDate -lt $PurgeDate)
			{
				WriteLog "Try to delete file [$File]" "DUMP"

				Remove-Item -Path $File.FullName -Force

				# ��������� �������� ���� �� �������, ���� ��� ��� ����������� - ��������
				if (test-path -Path $File.FullName -ErrorAction SilentlyContinue)
				{

					WriteLog "Old Log file [$File] doesn't removed" "ERRr"
				}
				else
				{
					WriteLog "File [$File] is deleted" "MESS" # � ���� ��������� �������� - ����� ��� �������
				}


				
			}
		}
	}
}


function UploadFiles ()
{
# ������� ��� ������ �� ������
	param (
		[string]$LogFilePurgeDays = 30,
		[switch]$Verbose = $FALSE		# � ������� ��� ������� ���� �����
	)

	WriteLog "Upload Files to Server" "INFO";

	[string]$LogFilePathServer = "\\SHTURMAN-ROOT\Logs\test";
	[string]$BlockName = "aaa11";
#	[string]$ShareMarker = "$LogFilePathServer"; # �������� ������� ����� ����� - ��������� ����������� ���� � ����
	[string]$LogFilePathServerBlock = "$LogFilePathServer\$BlockName";

	# - �������� � �������� ������������� ������� ��� �������
# "test-path -Patch $LogFilePathServer -ErrorAction SilentlyContinue"

	if (test-path -Path $LogFilePathServer -ErrorAction SilentlyContinue)
	{
		WriteLog "Log Store share [$LogFilePathServer] is exist" "DUMP"

		if (test-path -Path $LogFilePathServerBlock -ErrorAction SilentlyContinue)
		{
			WriteLog "Block's folder in log store share [$LogFilePathServerBlock] is exist" "DUMP"
			
		}
		Else
		{
			$res = New-Item -Path $LogFilePathServer -Name $BlockName -ItemType "directory"
			WriteLog "Create Folder: $res" "DUMP"

			if (test-path -Path $LogFilePathServerBlock -ErrorAction SilentlyContinue)
			{
				WriteLog "Block's folder in log store share [$LogFilePathServerBlock] created" "MESS"
			}
			Else
			{
				WriteLog "Create Folder [$BlockName] in [$LogFilePathServer] failed" "ERRr"
			}
		}	


"asasf"
break;
		


		# PowerShell's New-Item creates a folder
		if (-not (test-path $LogFilePathOld))
		{
			WriteLog "Path for Arcived Files [$LogFilePathOld] doesn't exist" "ERRr"
			break;
		}
		else
		{
			WriteLog "Created folder [$LogFilePathOld]" "MESS"
		}
	}
	else
	{
		WriteLog "Path for Arcived Files [$LogFilePathServer] doen't exist" "ERRr"
		break;
	}


	$arr = Get-ChildItem -Path $LogFilePathOld -Force -Filter "*.7z"


	Foreach ($File in $arr) 
	{
#		Copy-Item -Destination C:\Temp
		Copy-Item -Path $File.FullName -Destination \\SHTURMAN-ROOT\Logs\test
#		$File
	}
# Copy-Item -Destination C:\Temp
# Remove-Item C:\Scripts\*

}

<#
function  SQLBackup ($SQLDBName, $SQLUsername, $SQLPassword, $SQLBackUpPath)
{
}
#>

clear;
	WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
	WriteLog "Script version: [$version]" "INFO"

	# �������� �� ������������� �����
	# - ������� ��� ��� ������
	if (-not (test-path $LogFilePath))
	{
		WriteLog "Log File path [$LogFilePath] doesn't exist" "ERRr"
		break;
	}
	else
	{
		WriteLog "Log File path [$LogFilePath] exist" "INFO"
	}
	# - ������� ��� �������
	if (-not (test-path $LogFilePathOld))
	{
	
		# PowerShell's New-Item creates a folder
		New-Item -Path $LogFilePath -Name "Old" -ItemType "directory"
		if (-not (test-path $LogFilePathOld))
		{
			WriteLog "Path for Arcived Files [$LogFilePathOld] doesn't exist" "ERRr"
			break;
		}
		else
		{
			WriteLog "Created folder [$LogFilePathOld]" "MESS"
		}
	}
	else
	{
		WriteLog "Path for Arcived Files [$LogFilePathOld] exist" "INFO"
	}



# �������� ������ ���������������� �����
if ($PurgeLogFiles -eq $TRUE)
{
	LogFilePurge -LogFilePurgeDays $LogFilePurgeDays # -Verbose
}


#break;
	# ������� ���� � ������� ������� ������������ ��� ���������� ������
	$currDate = Get-Date -Format $DateFormatLog

	WriteLog "Move Log Files to Archives" "INFO"

	# ������ ���� ������
	$arr = Get-ChildItem -Path $LogFilePath -Force -Filter "*.log" -Name | where {$_ -notmatch "$currDate.log" };

	# �� ������� ������ ��������. ���� ���� ������� - ������ �� ���������, �� �����-�����.
	if ($FastArcive -eq $TRUE)
	{
		$ArcivationDensity = ""
	}
	else
	{
		$ArcivationDensity = "-mx=9"
	}
#	echo "Service's Error Logs Sensor [version: $scriptver]`r`nMonitoring *.Error files in folder $ErrLogPath"

#	$i = 0;

	Foreach ($File in $arr) 
	{
		$path = $LogFilePath + "\" + $File;
		$arcPath = "$LogFilePathOld\$File.7z"

		WriteLog "Processing file [$File]" "DUMP"

		# ��������� ��������� ���� ������������ ����������
		if (test-path -Path "D:\Prog\7-zip\7za.exe" -ErrorAction SilentlyContinue)
		{
# "d:\prog\7-zip\7za.exe -m9 a $arcPath -sdel $path"
			$res = D:\Prog\7-zip\7za.exe $ArcivationDensity a $arcPath -sdel $path
		}
		ElseIf (test-path -Path "C:\Prog\7-Zip\7za.exe" -ErrorAction SilentlyContinue)
		{
			$res = C:\Prog\7-Zip\7za.exe $ArcivationDensity a $arcPath -sdel $path
		}
		else 
		{
			WriteLog "Archiver not found" "ERRr" # �� ����� ���������. ������ �����, ������������
			break;
		}


		WriteLog "$res" "DUMP"

		if (test-path $arcPath)
		{
			# ��������� ������� �������� ����. ���� ��������� �� ����. ����������� �� ����... �.�. �� ��������.
			Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
#			$File.Delete()

			# ��������� �������� ���� �� �������, ���� ��� ��� ����������� - ��������
			if (test-path $path -ErrorAction SilentlyContinue)
			{

				WriteLog "File [$File] added to archive [$File.zip]" "WARN" # ���� �������� ������� - ����� ��� ���� _��������_
				WriteLog "Source file [$path] doesn't removed" "ERRr"
			}
			else
			{
				WriteLog "File [$File] moved to archive [$File.zip]" "MESS" # � ���� ��������� �������� - ����� ��� �������
			}
			
		}
		Else
		{
			WriteLog "Arcived File [$arcPath] doesn't exist" "ERRr"
		}

#$File
#		WriteLog $path "INFO"
	}
# ������� ���������������� ����� �� ������
if ($UploadLogFiles -eq $TRUE)
{
	UploadFiles # -Verbose
}
