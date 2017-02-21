<#
    1. Log Archiver
       - ������������� ���� *.log ������ �� ����������� �����������
       - � �������� Old
       - �� ���������� 1 ��� � ����� � 03:30 (��������� ������)
       - �������� ������� ������ [$LogFilePurgeDays] ����
       - TODO ������� ����� �� ������
       - TODO ���������� ������������� ����� � ������� ���� � ������ �� ������
       - TODO �������� ��������� ����� ��� ��������������� ������� �������
    2. MS SQL BackUP
       - �� Shturman_Metro ������ ����� (������ � MS SQL)
       - � ����� d:\BackUP
       - TODO ������������� ������
       - �������� ������ ������� �� �������� ([$SQLBackUpDaily] ���� - ����������; [$SQLBackUp10days] ���� - "���������" 1/10/20 ����� ���� ���; [$SQLBackUpMontly] ���� - �������� �� 1 �����;  ������ - �������������� �� 1 �����)
       - TODO ��������� ������ ������� �� ���������� 1 ��� � ����� � 03:00
       - TODO �������������� ������ � �������� �����
       - TODO ��������� �� ������� � ������ �� ����������� ��������.
    3. SVN BackUP
       - TODO ����� ������������ � ���� ���� ���������, ����� ��������
       - TODO � ����� d:\BackUP
       - TODO �������� ������ ������� �� �������� (1 ��� - ����������, 1 ����� - ��������� 1/15/21 ����� ���� ���, ������ - ����������� �� 1 �����)
       - TODO ��������� ������ ������� �� ���������� 1 ��� � ����� � 03:00
       - TODO �������������� ������ � �������� �����
       - TODO ��������� �� ������� � ������ �� ����������� ��������.
    4. Redmine BackUP
       - TODO ����� ����, ��������������, ��������
       - TODO � ����� d:\BackUP
       - TODO �������� ������ ������� �� �������� (1 ��� - ����������, 1 ����� - ��������� 1/15/21 ����� ���� ���, ������ - ����������� �� 1 �����)
       - TODO ��������� ������ ������� �� ���������� 1 ��� � ����� � 03:00
       - TODO �������������� ������ � �������� �����
       - TODO ��������� �� ������� � ������ �� ����������� ��������.


New:

1.0.4
    Common
        ��������� ������������ �� ����� BackUpSettings.ps1, ��� ������� ����� [-UseSettingsFile], ���� ������ ���������� � ����� �������.
        ��������� ������������� ����� PARAM. ��� ��� ����� � ������ ����� ����� ��������� �� ������ ��������� �������
    2. MS SQL BackUP
        �������� ������ ������� �� �������� ([$SQLBackUpDaily] ���� - ����������; [$SQLBackUp10days] ���� - "���������" 1/10/20 ����� ���� ���; [$SQLBackUpMontly] ���� - �������� �� 1 �����;  ������ - �������������� �� 1 �����)
    1. Log Archiver
        ��������� ������������� ����� �� ����� [$Log]

1.0.3
    ���
#>


param (
	# Log Files
	[switch]$Log = $FALSE,				# ����� � ������������ Log ������ ( ��� ����� ������ ��������� �� ������ ������������)
	[string]$DateFormatLog = "yy-MM-dd",
	[string]$LogFilePath = "D:\Shturman\Bin\Log",
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old",
	[string]$LogFilePurgeDays = "30", # Days
	[switch]$PurgeLogFiles = $FALSE, # ���������� ������ ������  $LogFilePurgeDays ����
	[switch]$UploadLogFiles = $FALSE, # ������� ��� ������ �� ������.
	[switch]$FastArcive = $FALSE, # ����� ����������� ���������. ��� ����� - ������ �� ���������, ��� � � ��� ������. �� ������� ������ ����� ��������
	[switch]$LogFileAll2Arc = $FALSE, # ���������� ����������� ��� ��� �����. ������� �����������

	# SQL

	[switch]$SQL = $FALSE,				# ����� � ������������ SQL ( ��� ����� ������ ��������� �� ������ SQL* ������������)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro",
	[array]$SQLBackUpFileMask = ("Shturman_Metro_*.bak","Shturman_Metro_Anal_*.bak"),
	[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm",
	[int]$SQLBackUpDaily = "7", # Days
	[int]$SQLBackUp10days = "60", # Days
	[int]$SQLBackUpMontly = "180", # Days

	# SVN
	[switch]$SVN = $FALSE,				# ����� � ������������ SVN ( ��� ����� ������ ��������� �� ������ SVN* ������������)
	# Redmine
	[switch]$Redmine = $FALSE,			# ����� � ������������ Redmine ( ��� ����� ������ ��������� �� ������ Redmine* ������������)

	[string]$BackUpDaily = "14", # Days
	[string]$BackUpWeekly = "13", # Weeks
#	[string]$BackUpMontly = "14", # Days
#	[string]$AppPath = "C:\Shturman\",
	[switch]$CreateSheduledTask = $FALSE,		# �������� ��������� ����� ��� ��������������� ������� �������

	[switch]$UseSettingsFile = $FALSE,		    # �������������� ���� �������� BackUpSettings.ps1 (��������� � ������� �������). ��������� ���������� ������� ����� PARAM.

	[switch]$Debug = $FALSE		# � ������� ��� ������� ���� �����
#	[switch]$Debug = $TRUE		# � ������� ��� ������� ���� �����
)

$version = "1.0.4";



# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

clear;
WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
WriteLog "Script version: [$version]" "INFO"


[string]$ParamsPath = "$ScriptDir\BackUpSettings.ps1";

# ���� � �������� ������� ����������� ���� BackUpSettings.ps1 - ����������� �� ���� ������������������� ���������
if ((test-path $ParamsPath) -and ($UseSettingsFile))
{
	# �������� ��������� (������ ��������, ������� SQL � �� ��� ������ � ����� params
	WriteLog "������ �������� ������� [$ParamsPath]" "INFO"
	."$ParamsPath"
}
ElseIf (-not $UseSettingsFile)
{
	WriteLog "������ ������� � ���������� �����������" "INFO"
}
Else
{
	WriteLog "������ ������� � ���������� ����������� (���� �������� [$ParamsPath] �� ������)" "INFO"
}


# ===============================================
#                   Functions
# ===============================================

function FilePurge ()
{
# �������� ������ ��� ������
	param (
		[int]$PurgeDays = 30,
		[string]$Path = "",
		[switch]$Verbose = $FALSE		# � ������� ��� ������� ���� �����
	)

	# ��������� ���� �� ������� ���� ��� ��������.
	$PurgeDate = (Get-Date).AddDays(-$PurgeDays) 

	WriteLog "Purge old log files, older than [$Path] days" "INFO" -Verbose $Verbose

	$arr = Get-ChildItem -Path $Path -Force -Filter "*.7z"

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

# TODO �������� ��������� ����� ��� ��������������� ������� �������
if ($CreateSheduledTask -eq $TRUE)
{
	WriteLog "NO FUNCTIONALE (c) Kuba's taxist" "ERRr"

}

if ($SQL)
{
    TestFolderPath -Path $SQLBackUpPath #-Verbose

    writelog "SQL Settings: SQLBackUpPath: [$SQLBackUpPath], SQLBackUpFileMask: [$SQLBackUpFileMask], SQLBackUpDaily: [$SQLBackUpDaily], SQLBackUp10days: [$SQLBackUp10days], SQLBackUpMontly: [$SQLBackUpMontly], SQLDateFormatLog: [$SQLDateFormatLog]" "DUMP"

	WriteLog "Purge old SQL BackUp files, by settings D:[$SQLBackUpDaily];10d:[$SQLBackUp10days];M:[$SQLBackUpMontly]" "INFO"


;
    for($i=0; $i -lt $SQLBackUpFileMask.Count; $i++)
    {
    	$arr = Get-ChildItem -Path $SQLBackUpPath -Force -Filter $SQLBackUpFileMask[$i]

    	Foreach ($File in $arr) 
    	{
            #$File.Name;

            #Extract date from file name
    		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # ���� ������� ��������, �� ���������� ���� � ������ �� �����
		    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ���� ��� � ����������, �� ����� �������.
    		#$match
    		#$match.Value

    		# ���� � ����� ������ ������ �������� �� ���� - ��������� ���� ����
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

    			# ���������� ����. ���������� � �� ������ ����� ������ ��������� ����.
			    if ($FileDate -lt (Get-Date).AddDays(-$SQLBackUpDaily))
			    {

#$FileDate
#$FileDate.Day -notin 1, 10, 20

                    # ���� ���� �� �� 1/10/20 ����� ������ � ��������� � ��������� ��� �� $SQLBackUp10days �� $SQLBackUpDaily  - �������
                    if (($FileDate -gt (Get-Date).AddDays(-$SQLBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # ���� ���� �� �� ������� ����� ������ � ��������� � ��������� ��� �� $SQLBackUpMontly �� $SQLBackUp10days - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SQLBackUpMontly))) -and ($FileDate.Day -notin 1) )
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # ���� ���� ������ ���� $SQLBackUpMontly � �� �� 1-�� ����� �������� - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # ���� ���� ������ ���� $SQLBackUpMontly � �� �� 1-�� ����� �������� - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                    {
                        $File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }


                }
            }



        }
        
        #$SQLBackUpFileMask[$i];
    }

}

if ($Log)
{
    # �������� �� ������������� �����
    # - ������� ��� ��� ������ � ������� ��� �������
    TestFolderPath -Path $LogFilePath #-Verbose
    TestFolderPath -Path $LogFilePathOld -Create #-Verbose


    # �������� ������ ���������������� �����
    if ($PurgeLogFiles -eq $TRUE){ FilePurge -Path $LogFilePathOld -LogFilePurgeDays $LogFilePurgeDays <# -Verbose #>; };


#break;
    	# ������� ���� � ������� ������� ������������ ��� ���������� ������
    	$currDate = Get-Date -Format $DateFormatLog

    	WriteLog "Move Log Files to Archives" "INFO"

    	# ������ ���� ������
    	# TODO: ������� ���-�� ����������. �.�. �� ���������� ������� ���������� ������, � �� ��� ��� ������
    	if ($LogFileAll2Arc -eq $TRUE)
    	{
		    $arr = Get-ChildItem -Path $LogFilePath -Force -Filter "*.log" -Name;
	    }
	    Else
	    {
    		$arr = Get-ChildItem -Path $LogFilePath -Force -Filter "*.log" -Name | where {$_ -notmatch "$currDate.log" };
    	}

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
    
				    WriteLog "File [$File] added to archive [$File.7z]" "WARN" # ���� �������� ������� - ����� ��� ���� _��������_
				    WriteLog "Source file [$path] doesn't removed" "ERRr"
			    }
			    else
			    {
    				WriteLog "File [$File] moved to archive [$File.7z]" "MESS" # � ���� ��������� �������� - ����� ��� �������
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
}
