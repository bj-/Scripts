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
       - �������� ������ ������� �� �������� (1 ��� - ����������, 1 ����� - ��������� 1/15/21 ����� ���� ���, ������ - ����������� �� 1 �����)
       - �������� ������ � ��������� � ���� ����� (��� ������)
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
    6. MySQL BackUp
        -
    7. Collector
        - ���� ������� � ������������ �����������
        - ������������� � ��������� ������� � ���������� = ��������� | IP address 
    �. �������� ��������� �����
        - �������� ��������� ����� (������������� ��� ���������� ���������). ��������, ����� ������� - ��� �������.
    B. General ���������
        - SettingsFile - ������� ���������� ���� �������� (������������� ���� �� "c:\�������_�������\")
        - TODO: ���� ������
        - TODO: �������� (������� / 10-�� ������ / �������� / ����������� / ����������� / �������
        - TODO: ������� ��� ����������������� �����



New:
1.0.11
    - ��������� SVN
        - ���� ���� ��������� ������������
        - ���������������� ������
        - ������������ ������ � ��������� � ���� �����
    - ��������� MySQL
    - ��������� Redmine
    - ������� � ������ ������
    - ����������� purge_backUp �������
    - ����������� ������� ��������� ���� �������� SettingsFile
1.0.10
    - �������� ��������� �����
        - ��������, ����� ������� - ��� �������. ���� ���� - ���������� �� ��������� ����� ���.
          �������� ��������� ����� -������������� ��� ���������� ���������
1.0.9
    - ������������� ������ � ��������
        - ��������� ������
        - ������ �� ����� (�� * �� �����)
        - ��������� ��������� (���� ������ ������)
        - ���� ������������ � ��������� ������ (��������� ������� ������ ��� "*" )
        - ������������ ��������� ������ ������� ������ � ��������� ������� (HardLink �� �����������)
        - Archive prefix (can add)
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
	# +==============+
    # |   Log Files  |
	# +==============+  
	[switch] $Log                  = $FALSE,					     # ����� � ������������ Log ������ ( ��� ����� ������ ��������� �� ������ ������������)
	[string] $DateFormatLog        = "yy-MM-dd",
	[string] $LogFilePath          = "D:\Shturman\Bin\Log",
	[string] $LogFilePathOld       = "D:\Shturman\Bin\Log\Old",
    [string] $LogFolderForArchives = $env:computername,
	[string] $LogFilePurgeDays     = "30",		                     # Days
	[switch] $PurgeLogFiles        = $FALSE,		                 # ���������� ������ ������  $LogFilePurgeDays ����
#	[switch] $UploadLogFiles       = $FALSE,		                 # ������� ��� ������ �� ������.
	[switch] $FastArcive           = $FALSE,		                 # ����� ����������� ���������. ��� ����� - ������ �� ���������, ��� � � ��� ������. �� ������� ������ ����� ��������
	[switch] $LogFileAll2Arc       = $FALSE,		                 # ���������� ����������� ��� ��� �����. ������� ����������� 

    # Errors log Archiver 
	[switch] $Errors               = $FALSE,						 # ������������� Errors ������
	[string] $ErrorsPath           = "D:\Shturman\Bin\Errors",	  	 # ����� ��� ����� Errors, �������� ��� � ������� $LogFilePathOld\Errors � ������ Errors_yyyy_MM_dd.7z

	# +==============+
	# |     SQL      |
	# +==============+
	[switch] $SQL                    = $FALSE,					    # ����� � ������������ SQL ( ��� ����� ������ ��������� �� ������ SQL* ������������)
#	[string] $SQLServerInstance      = "localhost\SQLEXPRESS",
#	[string] $SQLDBName              = "Shturman_Metro",
#	[string] $SQLUsername            = "BackUpOperator",
#	[string] $SQLPassword            = "diF80noY",
	[string] $SQLBackUpPath          = "D:\BackUp\Shturman_Metro",
	[string] $SQLExportPath          = "D:\BackUp\2Tape",
	[switch] $SQLExport              = $FALSE,			            # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    [switch] $SQLExportUploadArc     = $FALSE,	                    # ������������� ������ ��� ������� �� ������
    [int]    $SQLExportUploadArcPart = 100,		                    # ������� ������ �� ����� = ������ ����� � ��, 0 = ����� ������
    [switch] $SQLExportUpload        = $FALSE,		                # ������� ���������� ������ �� ������, (���� �� ���������� �� �����������)
    [string] $SQLExportUploadPath    = "\\172.16.30.139\Share\Exp",	# ���� ���� ��������
    [array]  $SQLExportUploadCred    = ("UserName","password"),		# ����� � ������ ��� �������
	[array]  $SQLBackUpFileMask      = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),
    #[array] $SQLLimits              = (10, 60, 180, 365, 0),   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $SQLLimits              = $NULL,                  # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	#[string]$SQLDateFormatLog       = "yyyy-MM-dd_HHmm",

	# +==============+
	# |    MySQL     |
	# +==============+
	[switch] $MySQL                    = $FALSE,					                # ����� � ������������ MySQL ( ��� ����� ������ ��������� �� ������ MySQL* ������������)
    [string] $MySQLDumperPath          = "C:\Redmine\mysql\bin\mysqldump.exe",		# �� ��� ��������� �����
    [array]  $MySQLCred                = ("UserName","password"),		            # ����� � ������ ��� �������
	[array]  $MySQL_DB                 = ("db_name_1","db_name_2"),                 # ������ ��� ��� ������
	#[string]$SQLDateFormatLog         = "yyyy-MM-dd_HHmm",
	[string] $MySQLBackUpPath          = "\MySQL",
    [string] $MySQLBackUpPrefix        = "MySQL_",	                                # ������� �������� ������������ �����
    #[array]  $MySQLLimits              = (10, 60, 180, 365, 0),                    # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array] $MySQLLimits              = $NULL,                                      # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	[switch] $MySQLExport              = $FALSE,			                        # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    [int]    $MySQLExportUploadArcPart = 0,		                                    # ������� ������ �� ����� = ������ ����� � ��, 0 = ����� ������

	# +==============+
	# |     SVN      |
	# +==============+
	[switch] $SVN            = $FALSE,				    # ����� � ������������ SVN ( ��� ����� ������ ��������� �� ������ SVN* ������������)
	[string] $SVNRepoPath    = "D:\Repositories",
	[string] $SVNBackUpPath  = "D:\BackUp\SVN",
    #[array] $SVNLimits      = (10, 60, 180, 365, 0),   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $SVNLimits      = $NULL,                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [switch] $SVNExport      = $FALSE,                  # ����������� ��������� ����� � ������� ��� �������� �� ������ ������ 

	# +==============+
	# |    Redmine   |
	# +==============+
	#[switch]$Redmine             = $TRUE			                         # ����� � ������������ Redmine ( ��� ����� ������ ��������� �� ������ Redmine* ������������)
	[switch] $Redmine             = $FALSE,			                         # ����� � ������������ Redmine ( ��� ����� ������ ��������� �� ������ Redmine* ������������)
    [string] $RedmineBackUpPrefix = "Redmine",
    [string] $RedmineBackUpPath   =  "\Redmine",                             # ����� ���� ���������� ������
    #[array] $RedmineLimits       = (10, 60, 180, 365, 0),                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $RedmineLimits       = $NULL,                                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	[string] $RedmineDB           = "bitnami_redmine",			             # ����� � ������������ Redmine ( ��� ����� ������ ��������� �� ������ Redmine* ������������)
    [switch] $RedmineExport       = $FALSE,                                  # ������������ ��������� ����� � ����������� ��� � ������� ��� �������� �� ������ ������ 
	[string] $RedminePath         = "C:\redmine\apps\redmine\htdocs\files",  # ����� ��� ����� ����� ������� ���������� ���������� (������)


	# +=========================+
    # |    Files and folders    |
	# +=========================+
	#[switch]$FilesON = $TRUE,		                                         # ��������� ������ ������/���������
	[switch] $FilesON = $FALSE,		                                         # ��������� ������ ������/���������
    [string] $FilesDateFormat = "yyy-MM-dd_HHmm",
	[string] $FilesBackUpPahth = "D:\BackUp\Shturman_Metro\Files",           # ����� ���� ����������� ��������� ������
	[array]  $FilesFileName = (
                                  # ��� ������� ����������� � $FilesBackUpPath , ���� ������� ���������� ����������, ID - �� ������ ������� � ����������� ����������, Compress | $FALSE - �������
                                  # --TODO --"Mask Include", "Mask Exclude" - ����� ������
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress"), 
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress")
                             ),		# ��������� �����
	[array]  $FilesFolderName =  (
                                      # ��� ������� ����������� � $FilesBackUpPath , ������� ������� ���������� ����������, Compress | $FALSE - �������, ������� ������ [0-9], ����� ���������� ������, ����� �����������
                                      # "Mask Include", "Mask Exclude" - ����� ������
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude"), 
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude")
                                ),		# ������� �������
	# �������� ������ ������� (��� � �����) ��� ���?
    #[array] $FilesLimits              = (10, 60, 180, 365, 0),               # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $FilesLimits              = $NULL,                               # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	[string] $FilesExportPath          = "D:\BackUp\2Tape",
    [switch] $FilesExport              = $FALSE,			                  # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    [int]    $FilesExportUploadArcPart = 100,		                          # ������� ������ �� ����� = ������ ����� � ��, 0 = ����� ������
    [switch] $FilesExportUpload        = $FALSE,		                      # ������� ���������� ������ �� ������, (���� �� ���������� �� �����������)
    [string] $FilesExportUploadPath    = "\\172.16.30.139\Share\Exp",	      # ���� ���� ��������
    [array]  $FilesExportUploadCred    = ("UserName","password"),		      # ����� � ������ ��� �������
	#[array] $FilesBackUpFileMask      = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),

	# +==========================================+
	# |     Collect BackUp's from Computers      |
	# +==========================================+
	[switch] $Collect = $FALSE,				           # ���� ������� � �������� ������ � ������������� �� � ����
	[array]  $Collect_Data = (
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", (14,60,365,720,0) ),
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", $NULL )
                            ),
	[string] $Collect_Folder = "D:\BackUp\FromComputers",
    #[array] $CollectLimits = (10, 60, 180, 365, 0),   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    [array]  $CollectLimits = $NULL,                   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]


	# +==============+
    # |    Common    |
	# +==============+
    # �������� �� ��������� ��� �������� �������
    [int]$Store_Daily    = 14,                       # ���� �������� ���������� ������
    [int]$Store_10days   = 60,                       # ���� �������� ������ �� 01, 10 � 20 �����
    [int]$Store_Montly   = 365,                      # ���� �������� ����������� ������ (01.��.��)
    [int]$Store_Quartal  = 720,                      # ���� �������� �������������� ������ (01.01.�� 01.04.�� 01.07.�� 01.10.��)
    [int]$Store_Years    = 0,                        # ���� �������� ���������� ������ (01.01.��)

	[switch]$SheduledTaskCreate = $FALSE,		     # �������� ��������� ����� ��� ��������������� ������� �������
	[switch]$UseSettingsFile = $FALSE,			     # �������������� ���� �������� BackUpSettings.ps1 (��������� � ������� �������). ��������� ���������� ������� ����� PARAM.
	[string]$SettingsFile = $NULL,			         # �������������� ��������� ���� �������� (����� BackUpSettings.ps1) ���� ���� ��������� � ������� ������� ���� ������� ������ ����. 
	[switch]$HighestPrivelegesIsRequired = $FALSE,   # ��������� ���� �� ��������� �����. ���� ���� ���������� ������ � �������

    [string]$BackUpPath = "D:\BackUp",               # ������� ��� ������� �� ���������
    [string]$ExportPath = "D:\BackUp\2Tape",         # ������� ��� �������� ������� �� ���������
    [string]$Export = $FALSE,                        # ���� �������� �� ��� ������ ����� ������������. ���������� �� ������� ��������

	[string]$UploadCahnnelType = "VPN",		     	 # VPN | FTP | NO .... - ����� ��� �������� ������ �� ������� ������
	[string]$VPNName = "ST",					     # 
#	[string]$VPNUserName = "username",			     # 
#	[string]$VPNPassword= "password",			     # 

	[switch]$Debug = $FALSE	    # � ������� ��� ������� ���� �����
#	[switch]$Debug = $TRUE		# � ������� ��� ������� ���� �����
)

$version = "1.0.11";

# +==================+
# |       Common     |
# +==================+
[array]$DefaultStoreLimits = ($Store_Daily, $Store_10days, $Store_Montly, $Store_Quartal, $Store_Years)   # ���� ������ �� � �������, ��� �������� ���������
$CurrDate = Get-Date -Format "yyyy-MM-dd"
$CurrTime = Get-Date -Format "HHmm"



# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptFullPath = $ScriptDir + "\" + $script:MyInvocation.MyCommand.Name

#Split-Path $script:MyInvocation.MyCommand.Path
#$script:MyInvocation.MyCommand.Source

#$ScriptDir
#$ScriptFullPath
#break

# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

clear;
WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
WriteLog "Script version: [$version]" "INFO"



[string]$ParamsPath = "$ScriptDir\BackUpSettings.ps1";
[string]$ParamsPathCustom = "$ScriptDir\$SettingsFile";

# ���� � �������� ������� ����������� ���� BackUpSettings.ps1 - ����������� �� ���� ������������������� ���������
if ((test-path $ParamsPath) -and ($UseSettingsFile))
{
	# �������� ��������� (������ ��������, ������� SQL � �� ��� ������ � ����� params
	WriteLog "������ �������� ������� [$ParamsPath]" "INFO"
	."$ParamsPath"
}
ElseIf ( ($SettingsFile.Length -gt 3) -and (test-path -Path $ParamsPathCustom) )
{
	WriteLog "������ �������� ������� [$ParamsPathCustom]" "INFO"
    ."$ParamsPathCustom"
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


 

 	WriteLog "$FuncName Exec[D:\Prog\7-zip\7za.exe $SizeVolume $ArcivationDensity a $arcPath $DelSourceFile $Path]" "DUMP"

    

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


function purge_oldBackUp ()
{
    # ������������� ������
	param (
		[string]$Path = "",
		[string]$FileMask = "",
        [array]$Limits = $NULL,                           #Array()  Daily / TenDays / Montly / Quartal / Years
        #[array]$DefaultLimits = (30, 90, 181, 365, 720),    # Daily / TenDays / Montly / Quartal / Years
		#[int]$Daily   = $NULL,		# days
		#[int]$TenDays = $NULL,		# days
		#[int]$Montly  = $NULL,		# days
        #[int]$Quartal = $NULL,	    # days
        #[int]$Years   = $NULL,		# days
		[switch]$Verbose = $FALSE		    # � ������� ��� ������� ���� �����
	)


	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    if ( $Limits )
    {
        $arr = $Limits
    }
    else
    {
        $arr = $DefaultStoreLimits
    }
        
    # �������� �� ��� ����� �����������
   	[int]$Daily   = $arr[0] 	# days
	[int]$TenDays = $arr[1]		# days
	[int]$Montly  = $arr[2]		# days
    [int]$Quartal = $arr[3]	    # days
    [int]$Years   = $arr[4]


    WriteLog "$FuncName Purge old BackUps [ $Daily / $TenDays / $Montly / $Quartal / $Years ] Daily / TenDays / Montly / Quartal / Years by mask [$FileMask]" "INFO" $Verbose

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
                    $delfile = $FALSE

                    #write-host $FileDate + "---" + $Years + "---" + ((Get-Date).AddDays(-$Years)) + ((Get-Date).AddDays(-$Quartal))

                    # ������ $Years - �������, �� ������ ���� �� 0 (�.�. ���������)
                    if ( ($Years -ne 0) -and ($FileDate -lt (Get-Date).AddDays(-$Years)) )    { $delfile = $TRUE }

                    # ���������� ������� - ������ $Quartal, �� �� 01.01.�� - �������
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Quartal)) -and ( ($FileDate.Day -notin 1) -or ($FileDate.Month -notin 1) ) )    { $delfile = $TRUE }

                    # ���������� ����������� - ������ $Montly, �� �� 01.��.�� - �������
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Montly)) -and ( ($FileDate.Day -notin 1) -or ($FileDate.Month -notin 1,4,7,10) ) )    { $delfile = $TRUE }

                    # ���������� �������� - ������ $TenDays, �� �� 01.��.�� - �������
                    if ( ($FileDate -lt (Get-Date).AddDays(-$TenDays)) -and ( ($FileDate.Day -notin 1) ) )    { $delfile = $TRUE }


                    # ���������� 10-�������� - ������ $Daily, �� �� 01.��.�� - �������
                    if ( ($FileDate -lt (Get-Date).AddDays(-$Daily)) -and ( ($FileDate.Day -notin 1,10,20) ) )    { $delfile = $TRUE }

                    
                    if ( $delfile )
                    {
                        WriteLog "$FuncName Delete old BackUp: [$FileFullName] from [$FileDate]" "DUMP"
                        DeleteFile -File $FileFullName -Verbose
                    }
                                        
                    <#
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


   	[int]$Daily   = $arr[0] 	# days
	[int]$TenDays = $arr[1]		# days
	[int]$Montly  = $arr[2]		# days
    [int]$Quartal = $arr[3]	    # days
    [int]$Years   = $arr[4]
    #>

                }
            }

    }
}
#$DefaultStoreLimits = (30, 90, 181, 365, 0)
#purge_oldBackUp -Path "C:\BackUp\FromComputers\st-nas\" -FileMask "" -Limits (10, 60, 180, 365, 0) -Verbose
#break 

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
                    #echo $command
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


function add_Subfolder_to_Path ()
{
    # Add subfolder to path and create if not exist
    param (
		[string]$Path = "",             # �������� ������
		[string]$SubFolderName = "",		    # ���������.
		[switch]$Create = $FALSE,		# ������� ���� ������ ���.
		[switch]$Verbose = $FALSE		# � ������� ��� ������� ���� �����
	)

	# ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    $x = TestFolderPath -Path $Path

    if ( ($Path.Length -gt 3) -and ($SubFolderName.Length -gt 0) )
    {
        if ( $SubFolderName.Substring(0,1) -eq "\" ) 
        {
            $SubFolderName = $SubFolderName.Substring(1)
        }
        
        $CombinedPath = "$Path\$SubFolderName"
        
        if ( $Create )
        {
            $x = TestFolderPath -Path $CombinedPath -Create
        }
        else
        {
            $x = TestFolderPath -Path $CombinedPath
        }

        #$CombinedPath
        
        return $CombinedPath
    }
    else
    {
        WriteLog "$FuncName Path or SubfolderName is shortly [$Path] / [$SubFolderName]" "INFO" $Verbose

    }

    return $FALSE
    

}

#add_Subfolder_to_Path -Path "C:\BackUp" -SubFolderName "ffff5"
#break


function get_BackUpPath ()
{
    # �� ���������� � ��������� BackUpPath - �������� ���������� ���� ��������� � ����
    # - ���� �� ������� ��������� - ������������ ����������
    # - ���� ��������� ������������� "\addPath" (����������� � ������� ���-������ - ������� �� � ����������
    # - ���� ������� ��������� � ���������� �� �� ����� - ��� ��������� ���������� � �������
	param (
		[string]$Path = "",
		[switch]$Create = $FALSE,		# ������� ���� ������ ���.
		[switch]$Verbose = $FALSE		# � ������� ��� ������� ���� �����
	)

    if ( ($Path.Length -gt 1) -and ( $Path.Substring(0,1) -eq "\") )
    {
        $CombinedPath = add_Subfolder_to_Path -Path $BackUpPath -SubFolderName $Path -Create -Verbose
        #$CombinedPath = $BackUpPath + $Path
    }
    elseif ( ($MySQLBackUpPath.Length -gt 0) -and ( $Path.Substring(0,1) -ne "\") )
    {
        $CombinedPath = $Path
    }
    else
    {
        $CombinedPath = $BackUpPath
    }

    if ( $Create )
    {
        $x = TestFolderPath -Path $CombinedPath -Create
    }

    return $CombinedPath

}


function MySQLBackUp ()
{
	param (
		[string]$User = "",
		[string]$Password = "",
		[string]$DataBase = "",
		[string]$File = "",
		[switch]$Verbose = $FALSE		# � ������� ��� ������� ���� �����
	)
	
    # ��� �������
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";
    
    WriteLog "$FuncName Create MySQL dump from [$DataBase] to [$File]" "INFO" $Verbose

    TestFolderPath -Path (Split-Path -Path $File -Parent) -Create

    # ������� ����� ����� ��� ����� ��������:
    # mysql_config_editor set --login-path="backup-lp" --host="localhost" --user="backup" --password

    $command = "cmd /c $MySQLDumperPath -u $User -p$Password $DataBase > $File"
    #$command = "cmd /c $MySQLDumperPath --login-path=backuplp $DataBase > $File"
    
    WriteLog "$FuncName Exec: [$command]" "DUMP" $Verbose
    #echo $command
    invoke-expression $command

    $FileCreated = Get-ChildItem -Path $File
    
    #$FileCreated.Length

    if ( (Test-Path -Path $File) -and ($FileCreated.Length -gt 0) )
    {
        WriteLog "$FuncName Succesfully created Back Up of DB [$DataBase] in to [$File]" "MESS" $Verbose
    }
    else
    {
        WriteLog "$FuncName Failed dump DB [$DataBase] in to [$File]" "ERRr" $Verbose
    }

}



function  SQLBackup ()
{
}


# �������� ��������� ����� ��� ��������������� ������� �������
#$SheduledTaskCreate = $TRUE
if ($SheduledTaskCreate)
{

	if(isAdmin)
	{
		WriteLog "��������� �����: ����." "MESS"
	};
	#WriteLog "NO FUNCTIONALE (c) Kuba's taxist" "ERRr"
    $Name = "BackUp Logs, Fileas and Folders, SQL DB"
    $Description = "Automatic BackUp and purge old BackUps"

    #WriteLog "Run with params: TaskName: [$Name]; Description: [$Description]; Execute: [$Execute] with Argument: [$Argument]" "INFO"
    WriteLog "Will Create Sheduled task for Script: TaskName: [$Name]" "INFO"

    # ��������� ���������� �� ��� ����� � ����� ���������
    $ShTask = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

    #$ShTask

    if ( ($ShTask.TaskName -eq $Name) )
    {
        # ������� ������������ �����
        Unregister-ScheduledTask -TaskName $Name -Confirm:$false
      	WriteLog "Delete exist Sheduled task [$Name]" "MESS"

        $ShTask = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

        if ($ShTask.TaskName -eq $Name)
        {
            # ����������� � ������� �.�. ����� ��� ����������
      	    WriteLog "Sheduled task [$Name] already exist. And can't be delete" "WARN"
            break;
        }
    }


    # Create sheduled task 
 	$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
                                      -Argument "$ScriptFullPath -UseSettingsFile"
    
    #$RunAt = ParseDate -Date $Date -Time $Time -Verbose # ��������� �� ��� ��� ������������ � ����-�����. ���� ����� ����������� ���� �� ������ ������
    #$RunAt = Get-Date
    #$RunAt = "10/10/2020"
    #ParseInterval -Interval $Interval

    #$RepetitionInterval = New-TimeSpan -Minutes 55
    #$RepetitionInterval = New-TimeSpan -Days 10
    #$RepetitionInterval = ParseInterval -Interval $Interval -verbose
    #$RepetitionInterval = New-TimeSpan -Days 1
    #$RepetitionInterval =  1

    #$RepetitionInterval

	#$trigger = New-ScheduledTaskTrigger `
	#    -Once `
	#    -At ($RunAt) `
	#    -RepetitionInterval ($RepetitionInterval) `
	#    -RepetitionDuration ([System.TimeSpan]::MaxValue)
    $trigger = New-ScheduledTaskTrigger -At 00:10:00 -Daily
	$option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
	# $option1 = New-ScheduledJobOption -StartIfOnBattery -ContinueIfGoingOnBattery
	$STSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
	#Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "Disable windows firewall" -User $AdminLogin -Password $AdminPassword -RunLevel Highest #-Principal $principal
	Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $Name -Description $Description -Principal $principal -Settings $STSettings #-ScheduledJobOption $option1


	#-User "$env:USERDOMAIN\$env:USERNAME" `
	#                       -Password 'P@ssw0rd' `

	# Enable-ScheduledTask 
	# Disable-ScheduledTask 
    #EnableFireWallRule -RuleName "RRAS-GRE-Out" -RuleDirection "Outbound"


    #"Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue"
    #Get-ScheduledTask -TaskName "$TaskName"

    $ShTask = Get-ScheduledTask -TaskName "$Name" -ErrorAction SilentlyContinue
    #$ShTask
    if ($ShTask.TaskName -eq $Name)
    {
      	WriteLog "Sheduled task [$Name] created." "MESS"
    
    }
    else
    {
    	WriteLog "Sheduled task [$Name] isn't created." "ERRr"
    }
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

<#
	# +==============+
	# |    MySQL     |
	# +==============+
	[switch]  $MySQL = $TRUE					# ����� � ������������ MySQL ( ��� ����� ������ ��������� �� ������ MySQL* ������������)
    [array]   $MySQLCred = ("backup","E5-Pk+Tz-rz=aT!Ze@Tw")		# ����� � ������ ��� �������
	[array]   $MySQL_DB = ("bitnami_redmine","r2d2","shturman") # ������ ��� ��� ������
	#[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm",
	[int]     $MySQLBackUpDaily = "7"			# Days
	[int]     $MySQLBackUp10days = "60"		# Days
	[int]     $MySQLBackUpMontly = "180"		# Days
	[switch]  $MySQLExport = $FALSE			# �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    $MySQLBackUpPath = "\MySQL"
    $Export = $TRUE

    [string]$BackUpPath = "C:\BackUp"          # ������� ��� ������� �� ���������
    [string]$ExportPath = "C:\BackUp\2Tape"    # ������� ��� �������� ������� �� ���������

    #E5PkTzrzaTZeTw
    #>

if ( $MySQL )
{
    WriteLog "MySQL BackUp: DB list: [$MySQL_DB]" "INFO"

    $CurrentBackUpFolder = get_BackUpPath -Path $MySQLBackUpPath

    #WriteLog ("MySQL_DB.Length1:" + $MySQL_DB.Length) "DUMP"
    
    if ( $MySQL_DB.Length )
    {
        #WriteLog ("MySQL_DB.Length2:" + $MySQL_DB.Length) "DUMP"
        foreach ($db in $MySQL_DB)
        {
            WriteLog ("db:" + $db) "DUMP"
            $BackUpNameMask =  $MySQLBackUpPrefix + $db
            $BackUpName =  $BackUpNameMask + "_$CurrDate" + "_$CurrTime" + ".sql"
            $CurrentBackUpFilePath = "$CurrentBackUpFolder\$BackUpName"
            MySQLBackUp -User $MySQLCred[0] -Password $MySQLCred[1] -DataBase $db -File $CurrentBackUpFilePath -Verbose
            #MySQLBackUp -DataBase $db -File $CurrentBackUpFilePath -Verbose

            $FileCreated = Get-ChildItem -Path $CurrentBackUpFilePath
    
            if ( (Test-Path -Path $CurrentBackUpFilePath) -and ($FileCreated.Length -gt 0) )
            #if ( Test-Path -Path $CurrentBackUpFilePath )
            {
                WriteLog "MySQL: Created BackUp of DB [$db] in to [$CurrentBackUpFilePath]" "MESS"

                $arcPath = "$CurrentBackUpFilePath.7z"
                ArchiveFiles -Path $CurrentBackUpFilePath -arcPath $arcPath -DelSource -Verbose

                if ( $Export -or $MySQLExport )
                {
                    export_backup -Source $arcPath -Target $ExportPath -Mask $BackUpNameMask -Verbose
                }

            }
            else
            {
                WriteLog "MySQL: Can not create BackUp of DB [$db] in to [$CurrentBackUpFilePath]" "ERR"
            }

            #purge_oldBackUp -Path $CurrentBackUpFolder -FileMask $BackUpNameMask -Daily $MySQLBackUpDaily -TenDays $MySQLBackUp10days -Montly $MySQLBackUpMontly -Verbose
            purge_oldBackUp -Path $CurrentBackUpFolder -FileMask $BackUpNameMask -Limits $MySQLLimits -Verbose

        }
    }

}


if ( $Redmine )
{
    WriteLog "Redmine BackUp" "INFO"

    # ���� ������ �������� �����
    # �������� �����/�������� ������
    # �������� ������
    # ����� ��� �������� ������

    $Current_BackUpPath = get_BackUpPath -Path $RedmineBackUpPath -Create -Verbose
    #$Current_BackUpPath

    #Create folder
    $Current_BackUpNameMask =  $RedmineBackUpPrefix
    #$Current_BackUpName   = $Current_BackUpNameMask + "_$CurrDate" + "_$CurrTime"
    $Current_BackUpFolder = $Current_BackUpNameMask + "_$CurrDate" + "_$CurrTime"
    #$Current_BackUpFilePath = "$CurrentBackUpFolder\$BackUpName"
    $Current_BackUpFolderPath = add_Subfolder_to_Path -Path $Current_BackUpPath -SubFolderName $Current_BackUpFolder -Create -Verbose 
    #"$CurrentBackUpFolder\$BackUpName"
    $RedmineDB_DumpFileName = "$Current_BackUpFolderPath\RedmineDB" + "_$CurrDate" + "_$CurrTime" + ".sql"


    #Copy Files
    copy_files_and_folders -Path "$RedminePath\*" -Destination $Current_BackUpFolderPath -Recurse -Check -Verbose
    
    #Dump DB
    MySQLBackUp -User $MySQLCred[0] -Password $MySQLCred[1] -DataBase $RedmineDB -File $RedmineDB_DumpFileName -Verbose

    #Archive backup
    $arcPath = "$Current_BackUpPath\$Current_BackUpFolder.7z"
    ArchiveFiles -Path $Current_BackUpFolderPath -arcPath $arcPath -DelSource -Verbose

    #Purge if backup created
    #purge_oldBackUp -Path $Current_BackUpPath -FileMask $Current_BackUpNameMask -Daily $RedmineBackUpDaily -TenDays $RedmineBackUp10days -Montly $RedmineBackUpMontly -Verbose
    purge_oldBackUp -Path $Current_BackUpPath -FileMask $Current_BackUpNameMask -Limits $RedmineLimits -Verbose

    #Export
    export_backup -Source $arcPath -Target $ExportPath -Mask $Current_BackUpNameMask -Verbose

}

if ($SVN)     #BackUp SVN Repositories
{
    # SVN
    WriteLog "SVN BackUp: Repositories: [$SVNRepoPath]" "INFO"

    #BackUp SVN Repository
    $CurrDate = Get-Date -Format "yyyy-MM-dd"
    $CurrTime = Get-Date -Format "HHmm"
    $BackUpFolderName = "SVN_$CurrDate" + "_$CurrTime"
    $SVNBackUpPathCurrent = "$SVNBackUpPath\$BackUpFolderName"

    #TestFolderPath -Path $SVNBackUpPathCurrent  -Create #-Verbose
    TestFolderPath -Path "$SVNBackUpPathCurrent\Conf"  -Create #-Verbose


    # Purge old BackUp

   <#	
   $arr = Get-ChildItem -Path $SVNBackUpPath -Force -Directory

    #$arr

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
    #>

    #break;
    
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
    	WriteLog "Try to create dump of repository [$SVNRepoPath\$File] to [$SVNBackUpPathCurrent\$File.dump]" "DUMP"

        # ������ ���� ���������� 

        $command = "cmd /c svnadmin dump $SVNRepoPath\$File > $SVNBackUpPathCurrent\$File.dump"
        WriteLog "exec [$command]" "DUMP"
        invoke-expression $command
        
        #svnadmin dump $SVNRepoPath\$File > $SVNBackUpPathCurrent\$File.dump

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

    $arcPath = "$SVNBackUpPath\$BackUpFolderName.7z"

    ArchiveFiles -Path $SVNBackUpPathCurrent -arcPath $arcPath -Size 0 -StoreArchive -DelSource -Verbose

    # Export last BackUp
    if ( $SVNExport )
    {
        export_backup -Source $arcPath -Target $ExportPath -Mask "SVN_" -Verbose
    }

    # ������ ������
    #purge_oldBackUp -Path $SVNBackUpPath -FileMask "SVN_" -Daily $SVNBackUpDaily -TenDays $SVNBackUp10days -Montly $SVNBackUpMontly -Verbose 
    purge_oldBackUp -Path $SVNBackUpPath -FileMask "SVN_" -Limits $SVNLimits -Verbose



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
            #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
            purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Limits $FilesLimits -Verbose
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
                #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
                purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Limits $FilesLimits -Verbose
                
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
            #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
            #purge_oldBackUp -Path "C:\BackUp\FromComputers\st-nas\" -FileMask "" -Limits $FilesLimits -Verbose
            purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Limits $FilesLimits -Verbose

        }

    }

}


# ���� ������� � ������ ��������
if ( $Collect )
{
    WriteLog "Collect BackUp's from Computers to [$Collect_Folder]" "INFO"

    foreach ( $item in $Collect_Data )
    {
        $Share = $item[0]
        $Mask  = $item[1]
        $days  = $item[2]

        #$host
        $Uri = [System.Uri]$Share
        $curr_Host = $Uri.Host

        $Current_Collect_Folder = "$Collect_Folder\$curr_Host"

        if ( Test-Path -Path $Share )
        {
            WriteLog "Process [$Share] with mask [$Mask]; days: [$days]; To $Current_Collect_Folder" "INFO"

            $x = TestFolderPath -Path $Collect_Folder -Create -Verbose
            $x = TestFolderPath -Path $Current_Collect_Folder -Create -Verbose

            $src_mask = "$Share\$Mask*"

            $x = move_files -Path $src_mask -Destination $Current_Collect_Folder -Verbose

            #$x = purge_oldBackUp -Path $Current_Collect_Folder -FileMask $Mask -Daily $Store_Daily -TenDays $Store_10days -Montly $Store_Montly -Quartal $Store_Quartal -Years $Store_Years -Verbose
            $x = purge_oldBackUp -Path $Current_Collect_Folder -FileMask $Mask -Limits $CollectLimits -Verbose
        }
        else
        {
            WriteLog "Source share [$Share] does not exist or not accessible" "ERRr"
        }
    }
}