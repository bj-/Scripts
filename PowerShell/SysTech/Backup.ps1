<#
    1. Log Archiver
       - ������������� ���� *.log ������ �� ����������� �����������
       - � �������� Old
       - �� ���������� 1 ��� � ����� � 03:30 (��������� ������)
       - �������� ������� ������ [$LogFilePurgeDays] ����
       - ������������ Errors �����
       - TODO �������� ������ �� ���� (���� �� ������� ��� �.�. ��� �� ������ �������)
       - TODO ������� ����� �� ������
       - TODO �������� (�������� ��� �����������) � ������� ��� �������� (�� ������ ������/������), �������� ������ �����.
       - TODO ���������� ������������� ����� � ������� ���� � ������ �� ������
       - TODO �������� ��������� ����� ��� ��������������� ������� �������
       - TODO ����������� ������ �� ����� (���� ����� ���������) ����� �������������� "Blue*" "*17-04-03*" � �.�.
    2. MS SQL BackUP
       - �� Shturman_Metro ������ ����� (������ � MS SQL)
       - � ����� d:\BackUP
       - �������� (�������� ��� �����������) � ������ ��� �������� (�� ������ ������/������), �������� ������ �����.
       - TODO ������������� ������
       - ������������� ������ ��� ������� �� ������ � �������� �� ��� ��
       - �������� ������ ������� �� �������� ([$SQLBackUpDaily] ���� - ����������; [$SQLBackUp10days] ���� - "���������" 1/10/20 ����� ���� ���; [$SQLBackUpMontly] ���� - �������� �� 1 �����;  ������ - �������������� �� 1 �����)
       - TODO ��������� ������ ������� �� ���������� 1 ��� � ����� � 03:00
       - TODO �������������� ������ � �������� �����
       - TODO ��������� �� ������� � ������ �� ����������� ��������.
       - TODO ������� ���������� ������ �� ������, ���� �� ���������� �� �����������
    3. SVN BackUP
       - ����� ������������ � ���� ���� ���������, ����� ��������
       - TODO ���������� (������) ����� ��������, ������� ����� � ������� ��������, � �� ������ ������ ������ � �����
       - � ����� d:\BackUP
       - TODO �������� ������ ������� �� �������� (1 ��� - ����������, 1 ����� - ��������� 1/15/21 ����� ���� ���, ������ - ����������� �� 1 �����)
       - TODO �������������� ������ � �������� �����
       - TODO ��������� �� ������� � ������ �� ����������� ��������.
       - TODO ������� �������� ��� ������������� ��������������� �����
       - TODO ������� �������� ��� ����� ��������, � �� ������ �������� ���� *.dump ��� ������
    4. Redmine BackUP
       - TODO ����� ����, ��������������, ��������
       - TODO � ����� d:\BackUP
       - TODO �������� ������ ������� �� �������� (1 ��� - ����������, 1 ����� - ��������� 1/15/21 ����� ���� ���, ������ - ����������� �� 1 �����)
       - TODO ��������� ������ ������� �� ���������� 1 ��� � ����� � 03:00
       - TODO �������������� ������ � �������� �����
       - TODO ��������� �� ������� � ������ �� ����������� ��������.
    5. Files and Folders
       - TODO ����� ���������� ������ (����� �� �������� ������� ���� ������ � ����� ����� ������� ��������)
       - TODO ����� �������� (����� �� �������� ������� ���� ������ � ���� ������� ��������) + ����� �� ������� ����� ����� + ����� ������� ���������� �� ������
       - TODO ������� ������ �� ������


New:
1.0.9
    - ������������� ������ � ��������
        - ��������� ������
        - ������ �� ����� (�� * �� �����)
        - ��������� ��������� (���� ������ ������)
        - ���� ������������ � ��������� ������ (��������� ������� ������ ��� "*" )
        - ������������ ��������� ������ ������� ������ � ��������� ������� (HardLink �� �����������)

1.0.8
    - ������� ArchiveFiles: ������� ��������� �������� �� ����, ������������ �������� �������� ������, 3 ���� ������ - ������, ������� � ������������
    SQL
    - ������������� ������ SQL (� ����������� ����� (�����������))
    - Upload ������ � ����.
1.0.7
    SQL
	- ����������� ���� ��� ������� �� ������� ��������� � ����� $SQLExportPath.
	  ���������� ���������� ������ $SQLExport, �� ��������� ��������.
	  ������� ������� ������� ��������, ���� �� ���������� - ������� �����. ��� ���������� ������ (�� ����� $SQLBackUpFileMask[$i]) �������
1.0.6
    Errors
        - ��� � ������������� Error ������ � ��� �� ������� � ������� ������������ ��� �����
    Error+Log
        - ��������������� �� ������ � ���������� $LogFolderForArchives. �� ��������� ������������ ��� ����������.
1.0.5
    SVN
        - ����� ������������ � ���� ���� ���������, ����� �������� � ������� [$SVNBackUpPath\SVN_yyyy-MM-dd_HHmm]. ������ ����������� � ���� ����.

1.0.4
    Common
        - ��������� ������������ �� ����� BackUpSettings.ps1, ��� ������� ����� [-UseSettingsFile], ���� ������ ���������� � ����� �������.
        - ��������� ������������� ����� PARAM. ��� ��� ����� � ������ ����� ����� ��������� �� ������ ��������� �������
    2. MS SQL BackUP
        - �������� ������ ������� �� �������� ([$SQLBackUpDaily] ���� - ����������; [$SQLBackUp10days] ���� - "���������" 1/10/20 ����� ���� ���; [$SQLBackUpMontly] ���� - �������� �� 1 �����;  ������ - �������������� �� 1 �����)
    1. Log Archiver
        - ��������� ������������� ����� �� ����� [$Log]

1.0.3
    ���
#>


param (
	# Log Files
	[switch]$Log = $FALSE,					# ����� � ������������ Log ������ ( ��� ����� ������ ��������� �� ������ ������������)
	[string]$DateFormatLog = "yy-MM-dd",
	[string]$LogFilePath = "D:\Shturman\Bin\Log",
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old",
    [string]$LogFolderForArchives = $env:computername,
	[string]$LogFilePurgeDays = "30",		# Days
	[switch]$PurgeLogFiles = $FALSE,		# ���������� ������ ������  $LogFilePurgeDays ����
#	[switch]$UploadLogFiles = $FALSE,		# ������� ��� ������ �� ������.
	[switch]$FastArcive = $FALSE,			# ����� ����������� ���������. ��� ����� - ������ �� ���������, ��� � � ��� ������. �� ������� ������ ����� ��������
	[switch]$LogFileAll2Arc = $FALSE,		# ���������� ����������� ��� ��� �����. ������� �����������

    # Errors log Archiver 
	[switch]$Errors = $FALSE,							# ������������� Errors ������
	[string]$ErrorsPath = "D:\Shturman\Bin\Errors",		# ����� ��� ����� Errors, �������� ��� � ������� $LogFilePathOld\Errors � ������ Errors_yyyy_MM_dd.7z

	# SQL
	[switch]$SQL = $FALSE,					# ����� � ������������ SQL ( ��� ����� ������ ��������� �� ������ SQL* ������������)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro",
	[string]$SQLExportPath = "D:\BackUp\2Tape",
	[switch]$SQLExport = $FALSE,			# �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    [switch]$SQLExportUploadArc = $FALSE,	# ������������� ������ ��� ������� �� ������
    [int]$SQLExportUploadArcPart = 100,		# ������� ������ �� ����� = ������ ����� � ��, 0 = ����� ������
    [switch]$SQLExportUpload = $FALSE,		# ������� ���������� ������ �� ������, (���� �� ���������� �� �����������)
    [string]$SQLExportUploadPath = "\\172.16.30.139\Share\Exp",	# ���� ���� ��������
    [array]$SQLExportUploadCred = ("UserName","password"),		# ����� � ������ ��� �������
	[array]$SQLBackUpFileMask = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),
	#[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm",
	[int]$SQLBackUpDaily = "7",			# Days
	[int]$SQLBackUp10days = "60",		# Days
	[int]$SQLBackUpMontly = "180",		# Days

	# SVN
	[switch]$SVN = $FALSE,				# ����� � ������������ SVN ( ��� ����� ������ ��������� �� ������ SVN* ������������)
	[string]$SVNRepoPath = "D:\Repositories",
	[string]$SVNBackUpPath = "D:\BackUp\SVN",
	[int]$SVNBackUpDaily = "7",			# Days
	[int]$SVNBackUp10days = "30",		# Days
	[int]$SVNBackUpMontly = "90",		# Days

	# Redmine
	[switch]$Redmine = $FALSE,			# ����� � ������������ Redmine ( ��� ����� ������ ��������� �� ������ Redmine* ������������)

	[string]$BackUpDaily = "14",		# Days
	[string]$BackUpWeekly = "13",		# Weeks
#	[string]$BackUpMontly = "14",		# Days
#	[string]$AppPath = "C:\Shturman\",
	[switch]$CreateSheduledTask = $FALSE,		# �������� ��������� ����� ��� ��������������� ������� �������


    # Files and folders
	#[switch]$FilesON = $TRUE,		# ��������� ������ ������/���������
	[switch]$FilesON = $FALSE,		# ��������� ������ ������/���������
    [string]$FilesDateFormat = "yyy-MM-dd_HHmm",
	[string]$FilesBackUpPahth = "D:\BackUp\Shturman_Metro\Files",  # ����� ���� ����������� ��������� ������
	[array]$FilesFileName = (
                                # ��� ������� ����������� � $FilesBackUpPath , ���� ������� ���������� ����������, ID - �� ������ ������� � ����������� ����������, Compress | $FALSE - �������
                                  # --TODO --"Mask Include", "Mask Exclude" - ����� ������
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress"), 
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress")
                             ),		# ��������� �����
	[array]$FilesFolderName =  (
                                    # ��� ������� ����������� � $FilesBackUpPath , ������� ������� ���������� ����������, Compress | $FALSE - �������, ������� ������ [0-9], ����� ���������� ������, ����� �����������
                                      # "Mask Include", "Mask Exclude" - ����� ������
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude"), 
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude")
                                ),		# ������� �������
	# �������� ������ ������� (��� � �����) ��� ���?
	[int]$FilesBackUpDaily = "7",			# Days
	[int]$FilesBackUp10days = "60",			# Days
	[int]$FilesBackUpMontly = "180",		# Days
	[string]$FilesExportPath = "D:\BackUp\2Tape",
    [switch]$FilesExport = $FALSE,			# �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    [int]$FilesExportUploadArcPart = 100,		# ������� ������ �� ����� = ������ ����� � ��, 0 = ����� ������
    [switch]$FilesExportUpload = $FALSE,		# ������� ���������� ������ �� ������, (���� �� ���������� �� �����������)
    [string]$FilesExportUploadPath = "\\172.16.30.139\Share\Exp",	# ���� ���� ��������
    [array]$FilesExportUploadCred = ("UserName","password"),		# ����� � ������ ��� �������
	#[array]$FilesBackUpFileMask = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),


        # Common
	[switch]$UseSettingsFile = $FALSE,			# �������������� ���� �������� BackUpSettings.ps1 (��������� � ������� �������). ��������� ���������� ������� ����� PARAM.
	[switch]$HighestPrivelegesIsRequired = $FALSE,   #��������� ���� �� ��������� �����. ���� ���� ���������� ������ � �������


	[string]$UploadCahnnelType = "VPN",			# VPN | FTP | NO .... - ����� ��� �������� ������ �� ������� ������
	[string]$VPNName = "ST",					# 
#	[string]$VPNUserName = "username",			# 
#	[string]$VPNPassword= "password",			# 

	[switch]$Debug = $FALSE		# � ������� ��� ������� ���� �����
#	[switch]$Debug = $TRUE		# � ������� ��� ������� ���� �����
)

$version = "1.0.9";



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

#WriteLog "Debug Mode: [$Debug]" "MESS"
if ( $Debug )
{
    WriteLog "Debug Mode: [$Debug]" "MESS"
}


# �������� ������� ���������������� ����������. ���� �� ��� - ������������
if ( $HighestPrivelegesIsRequired )
{
	if(isAdmin)
	{
		WriteLog "��������� �����: ����." "MESS"
	};
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
		[string]$Path = "",
		[string]$File = "",
        #[string]$UploadHost = "",
		[string]$UploadPath = "",
		[array]$UploadCred = ("UserName", "Password"),
		[switch]$Verbose = $FALSE		# � ������� ��� ������� ���� �����
	)

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";
    #$UploadPath

    $UploadCred


    [object] $objCred = $null
    [string] $strUser = $UploadCred[0]
    [System.Security.SecureString] $strPass = $NULL 
    #[System.Security.SecureString] $strPass = '' 


    $strPass = ConvertTo-SecureString -String $UploadCred[1] -AsPlainText -Force
    $objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strPass)

    $username = $UploadCred[0]
    $pass = $UploadCred[1]
net use /D $UploadPath
net use $UploadPath /u:$username $pass
    #"net use $UploadPath /u:$username $pass"

    $MaxAttempts = 10

    for($i=0; $i -lt $MaxAttempts; $i++)
    {
        if ( TestFolderPath -Path $UploadPath -Create -ContinueOnError )
        {
        #$Path
        #break
           
            # ���������� ��� ���������� �������
            if ($Path -ne "")
            {
                if ( TestFolderPath -Path $Path )
                {
                    $Files = $NULL;
                    $Files = Get-ChildItem -Path $Path -Recurse | % { $_.FullName }
                    #$Files
                    #break
                }

                foreach ($OneFile in $Files)
                {
                    if (Test-Path -Path $OneFile) 
                    {
                        WriteLog "try to Upload file [$OneFile] to [$UploadPath]" "DUMP"
                        Move-Item -Path $OneFile -Destination $UploadPath -Force # -Credential (Get-Credential $objCred)
                        #if (
                        WriteLog "Upload file [$OneFile] to [$UploadPath] (done)" "MESS"

                    }
                }
            }

            # ���������� ��������� ����
            if ($File -ne "")
            {
                if (Test-Path -Path $File) 
                {
                    WriteLog "try to Upload file [$OneFile] to [$UploadPath]" "DUMP"
                    Move-Item -Path $File -Destination $UploadPath -Force # -Credential (Get-Credential $objCred)
                    WriteLog "Upload file [$File] to [$UploadPath] (done)" "MESS"
                }
            }
        }
    }

# ����������������
net use /D $UploadPath

    #$UploadPatch = "\\172.16.30.19\Share\"
    #Test-Path -Path $UploadPatch 
<#
"gogogogogogo"

#UploadFiles -Path "D:\BackUP\2Tape" -File "D:\BackUP\x\DelphiChromiumEmbedded.Local.dump" -UploadPatch ("\\172.16.30.139\Share\"+(get-date -Format "yyyy-MM-HH")) -UploadCred ("Upload","Chi79Mai") -Verbose

break;


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
#>
}

function ArchiveFiles ()
{
    # ������������� ������
	param (
		[string]$Path = "",
		[string]$arcPath = "",
		[switch]$FastArchive = $FALSE,		# ������ �� ������� (��� ����������) ���� ���� �� ���� ���� �� ������� - ������ �� ���������, �� �����-�����.
		[switch]$StoreArchive = $FALSE,		# �������� ��� ������ (��� ������� � ����� ������� ������)
		[switch]$DelSource = $FALSE,		    # �������� ��������� �����
		   [int]$Size = 0,		                # ������� �� ����� = � ��,  0 - ����� ������. 
		[switch]$Verbose = $FALSE		    # � ������� ��� ������� ���� �����
	)

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

	WriteLog "$FuncName Archive file [$Path] to [$arcPath] DelSrc: [$DelSource] StoreArc [$StoreArchive] FastArch [$FastArchive] PartSize [$Size]" "DUMP"


    # �� ������� ������ ��������. ���� ���� �� ������� - ������ �� ���������, �� �����-�����.
	if ($FastArchive -eq $TRUE)
	{
        $ArcivationDensity = ""
    } 
    elseif ($StoreArchive -eq $TRUE )
    {
	    $ArcivationDensity = "-mx=0"
    }
    else
    {
	    $ArcivationDensity = "-mx=9"
	}
    
    # �������� ��������� �����
	if ($DelSource -eq $TRUE)
	{
        $DelSourceFile = "-sdel"
    } 
    else 
    {
	    $DelSourceFile = ""
    }

    if ( $Size -gt 0 )
    {
        #-v{Size}[b|k|m|g] : Create volumes
        $SizeVolume = "-v"+$Size+"m";

    }
    else
    {
        $SizeVolume = "";
    }


 

    "D:\Prog\7-zip\7za.exe $SizeVolume $ArcivationDensity a $arcPath $DelSourceFile $Path"

    # ��������� ��������� ���� ������������ ����������
    if (test-path -Path "D:\Prog\7-zip\7za.exe" -ErrorAction SilentlyContinue)
    {
		$res = D:\Prog\7-zip\7za.exe $ArcivationDensity $SizeVolume a $arcPath $DelSourceFile $Path
    }
    ElseIf (test-path -Path "C:\Prog\7-Zip\7za.exe" -ErrorAction SilentlyContinue)
    {
		$res = C:\Prog\7-Zip\7za.exe $ArcivationDensity $SizeVolume a `"$arcPath`" $DelSourceFile $Path
    }
    else 
    {
    	WriteLog "Archiver not found" "ERRr" # �� ����� ���������. ������ �����, ������������
        break;
	}

    WriteLog "$res" "DUMP"


    # ��������� ��� ����� ������ ��� �������� ��� �������
    if ( $Size -gt 0 )
    {
        # ���� �������� ���������� �� ����� �� ��������� .001 � ��������
        # TODO �����-�� ������� ��������� ������������� � ��������� ������ (�� ��� ��������� ������� �� �����)
        $arcPath = $arcPath+".001"
    }

	if (test-path $arcPath)
    {
        if ($DelSource)
        {
		    # ��������� ������� �������� ����. ���� ��������� �� ����. ����������� �� ����... �.�. �� ��������.
	        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
            #	$File.Delete()
        }
	    # ��������� �������� ���� �� �������, ���� ��� ��� ����������� - ��������
	    if (test-path $Path -ErrorAction SilentlyContinue)
#	    if (test-path "c:\windows" -ErrorAction SilentlyContinue)
	    {
            if ($DelSource)  # ������ ��������� ������� ��� ������� � ����������� �� ���� ���� ���� ������� ��� ���.
            {
		        WriteLog "File [$Path] added to archive [$arcPath]" "WARN" $Verbose # ���� �������� ������� - ����� ��� ���� _��������_
		        WriteLog "Source file [$Path] doesn't removed" "ERRr" $TRUE # � �������� ����� ������� �������
            }
            else
            {
		        WriteLog "File [$Path] added to archive [$arcPath]" "MESS" $Verbose # ���� �������� ������� - ����� ��� ���� _��������_
            }
	    }
	    else
	    {
			WriteLog "File [$Path] moved to archive [$arcPath]" "MESS" $Verbose # � ���� ��������� �������� - ����� ��� �������
	    }
			
	}
    Else
    {
		WriteLog "Arcived File [$arcPath] doesn't exist" "ERRr" $TRUE
    }
}

<#
function  SQLBackup ($SQLDBName, $SQLUsername, $SQLPassword, $SQLBackUpPath)
{
}
#>

# TODO �������� ��������� ����� ��� ��������������� ������� �������
if ($CreateSheduledTask)
{
	WriteLog "NO FUNCTIONALE (c) Kuba's taxist" "ERRr"

}


#break

#GetFreeSpace -Path D:\BackUP\2Tape -Verbose
#GetFreeSpace -Path "\\st-nas\BackUp\SVN\SVN_2016-09-05" -Verbose


if ($SQL)
{
    TestFolderPath -Path $SQLBackUpPath #-Verbose

    writelog "SQL Settings: SQLBackUpPath: [$SQLBackUpPath], SQLBackUpFileMask: [$SQLBackUpFileMask], SQLBackUpDaily: [$SQLBackUpDaily], SQLBackUp10days: [$SQLBackUp10days], SQLBackUpMontly: [$SQLBackUpMontly], SQLDateFormatLog: [$SQLDateFormatLog]" "DUMP"

	WriteLog "Purge old SQL BackUp files, by settings D:[$SQLBackUpDaily];10d:[$SQLBackUp10days];M:[$SQLBackUpMontly]" "INFO"


#   [array]$SQLLastBackUpFile = @()


    for($i=0; $i -lt $SQLBackUpFileMask.Count; $i++)
    {
    	$arr = Get-ChildItem -Path $SQLBackUpPath -Force -Filter $SQLBackUpFileMask[$i]

        $FileMaxDate = ""; # ������������ ���� �����
        $LastFile = ""; # ���� � ������������ �����

    	Foreach ($File in $arr) 
    	{
            #$File.Name;

            #Extract date from file name
    		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # ���� ������� ��������, �� ���������� ���� � ������ �� �����
		    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
		    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ���� � ������� yyyy-MM-dd.
    		#$match
    		#$match.Value

    		# ���� � ����� ������ ������ �������� �� ���� - ��������� ���� ����
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

                if ($FileMaxDate -lt $FileDate) 
                { 
                    $FileMaxDate = $FileDate;
                    $LastFile = $File;
                }

    			# ���������� ����. ���������� � �� ������ ����� ������ ��������� ����.
			    if ($FileDate -lt (Get-Date).AddDays(-$SQLBackUpDaily))
			    {

                    # ���� ���� �� �� 1/10/20 ����� ������ � ��������� � ��������� ��� �� $SQLBackUp10days �� $SQLBackUpDaily  - �������
                    if (($FileDate -gt (Get-Date).AddDays(-$SQLBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # ���� ���� �� �� ������� ����� ������ � ��������� � ��������� ��� �� $SQLBackUpMontly �� $SQLBackUp10days - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SQLBackUpMontly))) -and ($FileDate.Day -notin 1) )
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # ���� ���� ������ ���� $SQLBackUpMontly � �� �� 1-�� ����� �������� - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }

                    # ���� ���� ������ ���� $SQLBackUpMontly � �� �� 1-�� ����� �������� - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$SQLBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                    {
                        #$File.Name;
                        DeleteFile -File $File.FullName -Verbose
                        #$FileDate
                    }
                }
            }
        }



        # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
	    if ( $SQLExport )
        {
	        #WriteLog "Create a latest copy of SQL backup(s) in Export folder [$SQLExportPath]" "DUMP"
    
            # �������� ������� ���� ��� �������� �����.
            TestFolderPath -Path $SQLExportPath #-Verbose
        
            # �������� ��� ���� ����� ������ ������ �����, ���� ���, �� ���������� ������ �� ����� ������. 

    	    $arr = Get-ChildItem -Path $SQLExportPath -Force -Filter $SQLBackUpFileMask[$i]

            # ����� ������������ ���� �� ��������� ������ (�������� ��� �����), ���� ��� ������ � ��������� �������� ������� ��� ���� ��������� �������� 01-01-1970.
            # ���������� �������� ����, ������� ���� ��� ������ � �������� ��� �������� - ������� ��� ��� ����� ������ ����.
            $FileDate = get-date ("1970/01/01");

       	    Foreach ($File in $arr) 
            {

                WriteLog ("Extract date from file name [" + $File.FullName + "]") "DUMP"             

                #Extract date from file name
                $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ���� � ������� yyyy-MM-dd.
                #$match
                #$match.Value
        
                # ���� � ����� ������ ������ �������� �� ���� - ��������� ���� ����
                if ($match.Value -ne "")
                {
                    $nfDate = get-date ($match.Value)
                    if ($FileDate -lt $nfDate)
                    {
                        $FileDate = $nfDate
                    }
                }
            }

#-------
            if ($FileDate -lt $FileMaxDate)
            {
                WriteLog "New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"

                $SQLBackUpFileMask[$i]
                # ������� ������������ ������
                $File = $SQLExportPath + "\" + $SQLBackUpFileMask[$i]
                DeleteFile -File $File -Verbose

                #Test-Path -Path $SQLExportPath
                if (Test-Path -Path $SQLExportPath)
                {
                    # ������� ������� ��������
                    #New-Item -ItemType HardLink -Name "$SQLExportPath\$LastFile" -Value "$SQLBackUpPath\$LastFile"
                    #$command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"

                    WriteLog "Try to create New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"
                    $command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"
                    invoke-expression $command

                    if (-not (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue) )
                    {
                        # ���� �� ������� ������� �������� ������� �����������
                        WriteLog "Did not create HardLink of file for export [$SQLExportPath\$LastFile], try to create a copy" "DUMP"
                                
                        # �������� ������� ���������� ����� �� ����� ��� ����� �����
                        if ( CheckFreeSpace -Path $SQLExportPath -Size $File.Length  ) #-Verbose
                        {
                            # ����������� ����� ���� ����� ����
                            Copy-Item -Path $SQLBackUpPath\$LastFile -Destination $SQLExportPath\$LastFile
                        }
                    }
                    # ��������� �������� ��� ��������� �����
                    if (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created copy of file for export (to Tape) [$SQLExportPath\$LastFile]" "MESS"
                    }
                    else 
                    {
                        # ���� �� ������� ������� � ����� ���� - �������� �����������
                        WriteLog "Did not create file for export [$SQLExportPath\$LastFile] (HardLink or Copy)" "ERRr"
                    }
                }
                else
                {
                    WriteLog "Export folder does not exist [$SQLExportPath]" "ERRr"
                }
            }
            Else 
            {
                WriteLog "NO New file for export. Last file [$LastFile] is same as old file [$SQLExportPath\$File]" "DUMP"
            }
        }


        # ������������� ������ (��� ������� � ����� ������� �� ����� ��� ������� �� ������)
        if ($SQLExportUploadArc) 
        {
            WriteLog "Try to Arcive Backup file: [$SQLExportPath\$LastFile], ArcLevel: [0], Volume: [$SQLExportUploadArcPart]" "DUMP"

            # ������������� ������ � ����� � ����� ���� [�������� ��� �����].7z
            #$acrPath = "$SQLExportPath\$LastFile"+".7z"
            ArchiveFiles -Path "$SQLExportPath\$LastFile" -arcPath ("$SQLExportPath\$LastFile"+".7z") -DelSource -Size $SQLExportUploadArcPart -StoreArchive -Verbose # -DelSource

            #$SQLExportUploadArcPart
        }

        if ( $SQLExportUpload ) 
        {
            UploadFiles -Path $SQLExportPath -UploadPath $SQLExportUploadPath -UploadCred $SQLExportUploadCred -Verbose
        }

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

    #	echo "Service's Error Logs Sensor [version: $scriptver]`r`nMonitoring *.Error files in folder $ErrLogPath"
    
    #	$i = 0;

    	Foreach ($File in $arr) 
    	{
		    $path = $LogFilePath + "\" + $File;
		    $arcPath = "$LogFilePathOld\" + "$LogFolderForArchives\$File.7z"
    
		    WriteLog "Processing file [$File]" "DUMP"

            # ������������� ������ � ����� � ����� ���� Errors_yyyy-MM-dd_HHmm.7z � ��������� ������
            ArchiveFiles -Path $path -arcPath $arcPath -DelSource -Verbose

    	}
    # ������� ���������������� ����� �� ������
    if ($UploadLogFiles -eq $TRUE)
    {
    #	UploadFiles # -Verbose
    }
}

if ($Errors)
{
    # Errors log Archiver 
    # $ErrorsPath = "D:\Shturman\Bin\Errors",		# ����� ��� ����� Errors, �������� ��� � ������� $LogFilePathOld\Errors � ������ Errors_yyyy-MM-dd_HHmm.7z

    # �������� ������������� ������ Error �� ��������� ����, ���� �� ��� ��� �� � ������ ������
    if (Test-Path -Path "$ErrorsPath\*.Error")
    {
        # ��������/�������� ����� ���� ���������� ����� ������
        TestFolderPath -Path "$LogFilePathOld\Errors" -Create #-Verbose

        # move ���� ������ �� �������� �����, � �� ������ ����� ������. �� ������ ������
      	WriteLog "Try to move ALL files from [$ErrorsPath] to [$LogFilePathOld\Errors]" "DUMP"
        Move-Item -Path "$ErrorsPath\*" -Destination "$LogFilePathOld\Errors" -Force

        # �������� ��� ��������� ���
        if (-not (Test-Path -Path "$ErrorsPath\*"))
#        if (-not (Test-Path -Path "$ErrorsPath\ddd"))
        {
           	WriteLog "All Error's files moved from [$LogFilePathOld\Errors]" "DUMP"
        }
        else
        {
           	WriteLog "NOT All Error's files moved to [$LogFilePathOld\Errors]" "WARN"
        }
        
        # �������� ��� � ����� ����� ���-�� ��������� � �������������
        if (Test-Path -Path "$LogFilePathOld\Errors\*.Error")
        {
           	WriteLog "Error's Files does moved succesfully to [$LogFilePathOld\Errors]" "MESS" $FALSE

            # ������������� ������ � ����� � ����� ���� Errors_yyyy-MM-dd_HHmm.7z � ��������� ������
            $PathToArchive = "$LogFilePathOld\Errors\*.Error"
            $CurrDate = Get-Date -Format "yyyy-MM-dd"
            $ArchivePatch =   "$LogFilePathOld\" + "$LogFolderForArchives\Errors\Errors_$CurrDate.7z"
            ArchiveFiles -Path $PathToArchive -arcPath $ArchivePatch -Verbose
        }
        else
        {
           	WriteLog "Error's Files does not exit in [$LogFilePathOld\Errors]" "ERRr"
        }

        
        WriteLog "Remove folder [$LogFilePathOld\Errors]" "DUMP"
        Remove-Item "$LogFilePathOld\Errors"

        
    }
    else
    {
       	WriteLog "No Error's files found in [$ErrorsPath]" "INFO"
    }


}



if ($SVN)     #BackUp SVN Repositories
{
    #BackUp SVN Repository
    $CurrDate = Get-Date -Format "yyyy-MM-dd"
    $CurrTime = Get-Date -Format "HHmm"
    $SVNBackUpPathCurrent = "$SVNBackUpPath\SVN_$CurrDate" + "_$CurrTime"

    #TestFolderPath -Path $SVNBackUpPathCurrent  -Create #-Verbose
    TestFolderPath -Path "$SVNBackUpPathCurrent\Conf"  -Create #-Verbose


    # Purge old BackUp
   	$arr = Get-ChildItem -Path $SVNBackUpPath -Force -Directory

   	Foreach ($File in $arr) 
   	{
        #$File
        #$File.Name;

        #Extract date from file name
 		#$match = [regex]::Match($File,"((\d){2}[-\.]?){3}")  # ���� ������� ��������, �� ���������� ���� � ������ �� �����
	    #$match = [regex]::Match($File,"((\d){2}-){2}(\d){2}")
	    $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ���� � ������� yyyy-MM-dd.
   		#$match
   		#$match.Value

   		# ���� � �����/�������� ������ ������ �������� �� ���� - ��������� ���� ����
	    if ($match.Value -ne "")
	    {
        }

   			$FileDate =  get-date ($match.Value)
            #$match.Value

  			# ���������� ����. ���������� � �� ������ ����� ������ ��������� ����.
		    if ($FileDate -lt (Get-Date).AddDays(-$SVNBackUpDaily))
		    {

                #$FileDate
                #$FileDate.Day -notin 1, 10, 20
                #$File.Name

                # ���� ���� �� �� 1/10/20 ����� ������ � ��������� � ��������� ��� �� $SQLBackUp10days �� $SQLBackUpDaily  - �������
                #($FileDate -gt (Get-Date).AddDays(-$SVNBackUp10days))
                #($FileDate.Day -notin 1, 10, 20)
                if (($FileDate -gt (Get-Date).AddDays(-$SVNBackUp10days)) -and ($FileDate.Day -notin 1, 10, 20) )
                {
                    $File.Name;
                    #$File.FullName;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # ���� ���� �� �� ������� ����� ������ � ��������� � ��������� ��� �� $SQLBackUpMontly �� $SQLBackUp10days - �������
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUp10days)) -and (($FileDate -gt (Get-Date).AddDays(-$SVNBackUpMontly))) -and ($FileDate.Day -notin 1) )
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # ���� ���� ������ ���� $SQLBackUpMontly � �� �� 1-�� ����� �������� - �������
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUpMontly)) -and ($FileDate.Day -notin 1) -and ($FileDate.Month -notin 1, 4, 7, 10))
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }

                # ���� ���� ������ ���� $SQLBackUpMontly � �� �� 1-�� ����� �������� - �������
                if (($FileDate -lt (Get-Date).AddDays(-$SVNBackUpMontly)) -and (($FileDate.Month -notin 1, 4, 7, 10) -or ($FileDate.Day -notin 1)))
                {
                    $File.Name;
                    #DeleteFile -File $File.FullName -Verbose
                    #$FileDate
                }


            }



    }

    break;
    
    # Copy SVN Config Files
	WriteLog "Try to copy SVN configuration files" "DUMP"
    Copy-Item -Path "$SVNRepoPath\*.conf" -Destination "$SVNBackUpPathCurrent\Conf"
    Copy-Item -Path "$SVNRepoPath\*.pid" -Destination "$SVNBackUpPathCurrent\Conf"
    Copy-Item -Path "$SVNRepoPath\htpasswd" -Destination "$SVNBackUpPathCurrent\Conf"
   	WriteLog "SVN Configuration copied to [$SVNBackUpPathCurrent\Conf]" "MESS"
    
    # TODO ������� �������� ��� ��� �������������


    # �������� ������ ������������ (���� ������ - ���� �����������)
    $arr = Get-ChildItem -Path $SVNRepoPath -Force -Directory -Name;
    
  	Foreach ($File in $arr) 
   	{
    	WriteLog "Try to create dump of repository [$SVNRepoPath\$File]" "DUMP"

        # ������ ���� ���������� 
        svnadmin dump $SVNRepoPath\$File > $SVNBackUpPathCurrent\$File.dump

        # �������� ������������� �.�. ���� ��� ������� � ����� ������
        # TODO ������� ���������� ��������
        if (Test-Path -Path "$SVNBackUpPathCurrent\$File.dump")
        {
        	WriteLog "Dump of repository [$SVNRepoPath\$File] Created" "MESS"
        }
        else
        {
        	WriteLog "Dump of repository [$SVNRepoPath\$File] is not Created" "ERRr"
        }
    }


}


function purge_oldBackUp ()
{
    # ������������� ������
	param (
		[string]$Path = "",
		[string]$FileMask = "",
		[int]$Daily = 30,		# days
		[int]$TenDays = 90,		# days
		[int]$Montly = 0,		# days
		[switch]$Verbose = $FALSE		    # � ������� ��� ������� ���� �����
	)


	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    WriteLog "$FuncName Purge old BackUps [ $Daily / $TenDays / $Montly ] Daily / TenDays / Montly by mask [$FileMask]" "INFO" $Verbose
    
    #//echo "$Path\$FileMask"
    $Files = Get-ChildItem -Path "$Path\$FileMask*"

    ForEach ($file in $Files) 
    {
        $FileName = $file.Name
        $FileFullName = $file.FullName

        $match = [regex]::Match($FileName,"(\d){4}-(\d){2}-(\d){2}") # ���� � ������� yyyy-MM-dd.
    	#$match
    	#$match.Value

    		# ���� � ����� ������ ������ �������� �� ���� - ��������� ���� ����
		    if ($match.Value -ne "")
		    {
       			$FileDate =  get-date ($match.Value)

                <#
                if ($FileMaxDate -lt $FileDate) 
                { 
                    $FileMaxDate = $FileDate;
                    $LastFile = $File;
                }
                #>

    			# ���������� ����. ���������� � �� ������ ����� ������ ��������� ����.
			    if ($FileDate -lt (Get-Date).AddDays(-$Daily))
			    {

                    # ���� ���� �� �� 1/10/20 ����� ������ � ��������� � ��������� ��� �� $SQLBackUpDaily �� $SQLBackUp10days - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$Daily)) -and ($FileDate.Day -notin 1, 10, 20) )
                    {
                        #$File.Name;
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] by [if:1]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                        #$FileDate
                    }

                    # ���� ���� �� �� ������� ����� ������ � ��������� � ��������� ��� �� $SQLBackUp10days �� $SQLBackUpMontly - �������
                    if (($FileDate -lt (Get-Date).AddDays(-$TenDays)) -and ($FileDate.Day -notin 1) )
                    {
                        #$File.Name;
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] by [if:2]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                        #$File.Name;
                        #$FileDate
                    }

                    # ���� ���� ������ ���� $SQLBackUpMontly - �������
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Montly)) -and $Montly -gt 0 )
                    {
                        #$File.Name;
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] by [if:3]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                        #$FileDate
                    }
                }
            }

    }
}

function export_backup ()
{

    # ������������� ������
	param (
		[string]$Source = "",         # ������� - �� �������� �����
		[string]$Target = "",         # ������� - ���� ��������
		[string]$Mask = "",           #����� �� ������� ����� ������� ����������
		[switch]$Verbose = $FALSE		    # � ������� ��� ������� ���� �����
	)

	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    WriteLog "$FuncName Export new Backup [$Source] to [$Target]" "INFO" $Verbose

    # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
	        #WriteLog "Create a latest copy of SQL backup(s) in Export folder [$SQLExportPath]" "DUMP"
    
    # �������� ������� ���� ��� �������� �����.
    #TestFolderPath -Path $Target #-Verbose

    if ( (test-path -Path $Source -ErrorAction SilentlyContinue) -and (TestFolderPath -Path $Target) )
    {

        $file = Split-Path -Path $Source -Leaf  # ��� �����

        #delete old by mask
        #echo "Get-ChildItem -Path $Target -filter $Mask*"
        $Files = Get-ChildItem -Path $Target -filter "$Mask*"
        
        foreach ( $File_d in $Files )
        {
            DeleteFile -File $File_d.FullName -Verbose
        }
        #$Files

        #echo "Remove-Item -Path `"$Target\*`" -include `"$Mask*`" -WhatIf"
        #Remove-Item -Path "$Target\*" -filter $Mask* -WhatIf
        #Get-ChildItem -Path $Target -Filter $Mask | Remove-Item -Path $_
        #DeleteFile -File "$Target\$Mask*" -Verbose

        # try to create hardlink
                   # ������� ������� ��������

                    #WriteLog "Try to create New file for export is [$LastFile] will replace old file [$Target\$file]" "DUMP"
                    $command = "cmd /c mklink /H `"$Target\$file`" `"$Source`""
                    echo $command
                    invoke-expression $command

                    if (-not (Test-Path -Path $Target\$file -ErrorAction SilentlyContinue) )
                    {
                        # ���� �� ������� ������� �������� ������� �����������
                        WriteLog "Did not create HardLink of file for export [$Target\$file], try to create a copy" "DUMP"
                                
                        # �������� ������� ���������� ����� �� ����� ��� ����� �����
                        if ( CheckFreeSpace -Path $Target -Size $Source.Length  ) #-Verbose
                        {
                            # ����������� ����� ���� ����� ����
                            Copy-Item -Path $Source -Destination $Target
                        }
                    }
                    # ��������� �������� ��� ��������� �����
                    if (Test-Path -Path $Target\$file -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created hardlink or copy of file for export (to Tape) [$Target\$file]" "MESS"
                    }
                    else 
                    {
                        # ���� �� ������� ������� � ����� ���� - �������� �����������
                        WriteLog "Did not create file for export [$Target\$file] (HardLink or Copy)" "ERRr"
                    }
        # copy if impossible

        WriteLog "$FuncName Soource file [$Source] target folder [$Target] mask [$Mask]" "MESS" $Verbose

    }
    else
    {
        WriteLog "$FuncName Source file [$Source] or target folder [$Target] does not exist" "ERR" $Verbose
    }

     <#   
            # �������� ��� ���� ����� ������ ������ �����, ���� ���, �� ���������� ������ �� ����� ������. 

    	    $arr = Get-ChildItem -Path $SQLExportPath -Force -Filter $SQLBackUpFileMask[$i]

            # ����� ������������ ���� �� ��������� ������ (�������� ��� �����), ���� ��� ������ � ��������� �������� ������� ��� ���� ��������� �������� 01-01-1970.
            # ���������� �������� ����, ������� ���� ��� ������ � �������� ��� �������� - ������� ��� ��� ����� ������ ����.
            $FileDate = get-date ("1970/01/01");

       	    Foreach ($File in $arr) 
            {

                WriteLog ("Extract date from file name [" + $File.FullName + "]") "DUMP"             

                #Extract date from file name
                $match = [regex]::Match($File,"(\d){4}-(\d){2}-(\d){2}") # ���� � ������� yyyy-MM-dd.
                #$match
                #$match.Value
        
                # ���� � ����� ������ ������ �������� �� ���� - ��������� ���� ����
                if ($match.Value -ne "")
                {
                    $nfDate = get-date ($match.Value)
                    if ($FileDate -lt $nfDate)
                    {
                        $FileDate = $nfDate
                    }
                }
            }

#-------
            if ($FileDate -lt $FileMaxDate)
            {
                WriteLog "New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"

                $SQLBackUpFileMask[$i]
                # ������� ������������ ������
                $File = $SQLExportPath + "\" + $SQLBackUpFileMask[$i]
                DeleteFile -File $File -Verbose

                #Test-Path -Path $SQLExportPath
                if (Test-Path -Path $SQLExportPath)
                {
                    # ������� ������� ��������
                    #New-Item -ItemType HardLink -Name "$SQLExportPath\$LastFile" -Value "$SQLBackUpPath\$LastFile"
                    #$command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"

                    WriteLog "Try to create New file for export is [$LastFile] will replace old file [$SQLExportPath\$File]" "DUMP"
                    $command = "cmd /c mklink /h $SQLExportPath\$LastFile $SQLBackUpPath\$LastFile"
                    invoke-expression $command

                    if (-not (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue) )
                    {
                        # ���� �� ������� ������� �������� ������� �����������
                        WriteLog "Did not create HardLink of file for export [$SQLExportPath\$LastFile], try to create a copy" "DUMP"
                                
                        # �������� ������� ���������� ����� �� ����� ��� ����� �����
                        if ( CheckFreeSpace -Path $SQLExportPath -Size $File.Length  ) #-Verbose
                        {
                            # ����������� ����� ���� ����� ����
                            Copy-Item -Path $SQLBackUpPath\$LastFile -Destination $SQLExportPath\$LastFile
                        }
                    }
                    # ��������� �������� ��� ��������� �����
                    if (Test-Path -Path $SQLExportPath\$LastFile -ErrorAction SilentlyContinue )
                    {
                        WriteLog "Created copy of file for export (to Tape) [$SQLExportPath\$LastFile]" "MESS"
                    }
                    else 
                    {
                        # ���� �� ������� ������� � ����� ���� - �������� �����������
                        WriteLog "Did not create file for export [$SQLExportPath\$LastFile] (HardLink or Copy)" "ERRr"
                    }
                }
                else
                {
                    WriteLog "Export folder does not exist [$SQLExportPath]" "ERRr"
                }
            }
            Else 
            {
                WriteLog "NO New file for export. Last file [$LastFile] is same as old file [$SQLExportPath\$File]" "DUMP"
            }
            <# #>
}

if ($FilesON)
{


	WriteLog "BackUp Files and folders" "INFO"


    WriteLog "`$FilesBackUpPath           [$FilesBackUpPath]" "DUMP"          # ����� ���� ����������� ��������� ������
    WriteLog "`$FilesDateFormat           [$FilesDateFormat]" "DUMP"          # ������ ���� ������
    WriteLog "`$FilesFileName             [$FilesFileName]" "DUMP"            # ��� ������� ����������� � $FilesBackUpPath , ���� ������� ���������� ����������, Compress | $FALSE - �������, ������� ������ [0-9]
    WriteLog "`$FilesFolderName           [$FilesFolderName]" "DUMP"          # ��� ������� ����������� � $FilesBackUpPath , ������� ������� ���������� ����������, Compress | $FALSE - �������, ������� ������ [0-9], ����� ���������� ������, ����� �����������
    WriteLog "`$FilesBackUpDaily          [$FilesBackUpDaily]" "DUMP"	      # Days
    WriteLog "`$FilesBackUp10days         [$FilesBackUp10days]" "DUMP"        # Days
    WriteLog "`$FilesBackUpMontly         [$FilesBackUpMontly]" "DUMP"        # Days
    WriteLog "`$FilesExportPath           [$FilesExportPath]" "DUMP"
    WriteLog "`$FilesExport               [$FilesExport]" "DUMP"              # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    WriteLog "`$FilesExportUploadArcPart  [$FilesExportUploadArcPart]" "DUMP" # ������� ������ �� ����� = ������ ����� � ��, 0 = ����� ������
    WriteLog "`$FilesExportUpload         [$FilesExportUpload]" "DUMP"        # ������� ���������� ������ �� ������, (���� �� ���������� �� �����������)
    WriteLog "`$FilesExportUploadPath     [$FilesExportUploadPath]" "DUMP"    # ���� ���� ��������
    WriteLog "`$FilesExportUploadCred     [$FilesExportUploadCred]" "DUMP"    # ����� � ������ ��� �������
    WriteLog "`$FilesBackUpFileMask       [$FilesBackUpFileMask]" "DUMP"


    # ���� �� ������� $FilesFileName � ������ �������������� �����
    for($i=0; $i -lt $FilesFileName.Count; $i++)
    {
        #echo $FilesFileName[$i] 

        if ( $FilesFileName[$i][0] -ne "" ) { $BackUpFolder = $FilesFileName[$i][0] } else {$BackUpFolder = $FilesBackUpPahth }
        #$BackUpFolder  = $FilesFileName[$i][0]
        $BackFile      = $FilesFileName[$i][1]
        $id            = $FilesFileName[$i][2]
        $Compress      = $FilesFileName[$i][3]
        #$CompressLevel = $FilesFileName[$i][3]
    
        WriteLog "`$i                         [$i]" "DUMP"            # ���������� ����� �������� �������
        WriteLog "`$BackUpFolder              [$BackUpFolder]" "DUMP"            # ��� ������� ����������� � $FilesBackUpPath 
        WriteLog "`$BackFile                  [$BackFile]" "DUMP"            #  ���� ������� ���������� ����������
        #WriteLog "`$CompressLevel             [$CompressLevel]" "DUMP"            #  ������� ������ [0-9]
        
        # ������

   	    # ������� ���� � ������� ������� ������������ ��� ���������� ������
    	$currDate = Get-Date -Format $FilesDateFormat
        
    	#WriteLog "Move Log Files to Archives" "INFO"

        #$BackFileMaskName = $BackFile -replace "(\.\*)|(\..*$)", ""
        $BackFileMaskName = $BackFile -replace "(\.\*)|[\*\?]", ""
        $BackFileMaskName = Split-path $BackFileMaskName -Leaf
        #$BackFileMaskName
        #$BackFileMask = Split-path $BackFile -Leaf

        if ( $id.Length -gt 0 ) 
        {
            $id = "_$id"
        }

	    $path = $BackFile;
	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"

    
	    #WriteLog "Processing file [$File]" "DUMP"

        if ( Test-Path -Path $path )
        {
            WriteLog "Process file #[$i] [$BackFile]; IsCompress: [$Compress]; to Folder [$BackUpFolder]" "INFO"
            # ������������� ������ � ����� � ����� ���� [SourceFile Name|Mask]_yyyy-MM-dd_HHmm.7z
            ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

            # ����������� / ��������
            if ( $FilesExport )
            {
                export_backup -Source $arcPath -Target $FilesExportPath -Mask $BackFileMaskName -Verbose
            }

            # ������ ������
            purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
        }
        else 
        {
            WriteLog "file #[$i] [$BackFile] does not exist" "ERR"

        }
    }

    # ���� �� ������� $FilesFolderName � ������ �����.

    foreach ($Folder in $FilesFolderName)
    {

        if ( $Folder[0] -ne "" ) { $BackUpFolder = $Folder[0] } else {$BackUpFolder = $FilesBackUpPahth }
        #$BackUpFolder  = $Folder[0]
        $BackFolder    = $Folder[1]
        $id            = $Folder[2]
        $Compress      = $Folder[3]
        #$CompressLevel = $FilesFileName[$i][3]

        $BackFolderName = Split-Path -Path $BackFolder -Leaf
        $BackFolderParent = Split-Path -Path $BackFolder -Parent
        if ( $BackFolderParent -ne "" )
        {
            $BackFolderParentName = split-path -Path $BackFolderParent -Leaf
        }
        else
        {
            # ������� �� ������ ������� � ���������� �����������, � ��� ��������� ������ �����, � �� ������ ����
            $BackFolderParentName = ""
        }
        

        if ( $id.Length -gt 0 ) 
        {
            $id = "_$id"
        }

        #$BackFolderName
        #$BackFolderParentName
        # ������
        
   	    # ������� ���� � ������� ������� ������������ ��� ���������� ������
    	$currDate = Get-Date -Format $FilesDateFormat


	    $path = $BackFolder;

        if ( $BackFolderName -eq "*" )
        {
            if ( -not (Test-Path -Path $BackFolderParent ) ) { 
                continue 
            }
        }
        else
        {
            if ( -not (Test-Path -Path $BackFolderName ) ) { 
                continue 
            }
        }


        if ( $BackFolderName -eq "*" )
        {
            $dirs = Get-ChildItem -Path $BackFolderParent -Directory #-Depth 0
            
            foreach ( $dir in $dirs )
            {
                $BackFileMaskName = $dir.Name
                $path = $dir.FullName
        	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"
                
                $path
                $arcPath
                ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

            # ����������� / ��������
            if ( $FilesExport )
            {
                export_backup -Source $arcPath -Target $FilesExportPath -Mask $BackFileMaskName -Verbose
            }
    
            # ������ ������
            purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
                
            }

        }
        else
        {
            $BackFileMaskName = $BackFolderName
    	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"
            ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

            # ����������� / ��������
            if ( $FilesExport )
            {
                export_backup -Source $arcPath -Target $FilesExportPath -Mask $BackFileMaskName -Verbose
            }

            # ������ ������
            purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 

        }

    }

}
