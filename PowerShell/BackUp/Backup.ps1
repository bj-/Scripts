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
        - ���� �������� ��
        - ������������� ������� �����
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
    C. TODO: ���������� � ����������� ������
        - TODO: �� ������ GET/POST
        - TODO: ��������� ������
        - TODO: ��������� ����� (�������� � �� ���� ��� ����������� �����
        - TODO: ��������� ������



New:
1.1.2
    - ����������
1.1.1
    - ���������� �������� �� ������ ������
    - ��� ������ �������� � ��������� ������� �� ������� ����� �������� � functions.ps1
    - [Fix] Errors - ��� ������������� ������ ������������ ������� ��������� �����.
    - ��������� �������� �������
1.0.12
    - �������
        - Files: ����� ���� ��� �������� (������ �������� ��������� ���� ��� �������������)
        - Files: ���������� ��������� ����� �� ������� ����� ���� ��������
        - Log: ��� �������� ��� ������ ��������� �� ���������. ���������� ������ 20.10.31 � 20-10-31
        - Files: ������� � ������� ID (������� �� ����� �����, ��� ����� ID, ��� ��������� � ������� ������� ������ ���� ����� ���������
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
    [array]  $MySQLLimits              = $NULL,                                     # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
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
	[string] $FilesBackUpPath = "D:\BackUp\Files",           # ����� ���� ����������� ��������� ������
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
	[string] $FilesExportPath          = $NULL,
    [switch] $FilesExport              = $FALSE,			                  # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
    [int]    $FilesExportUploadArcPart = 100,		                          # ������� ������ �� ����� = ������ ����� � ��, 0 = ����� ������
    [switch] $FilesExportUpload        = $FALSE,		                      # ������� ���������� ������ �� ������, (���� �� ���������� �� �����������)
    [string] $FilesExportUploadPath    = "\\172.16.30.139\Share\Exp",	      # ���� ���� ��������
    [array]  $FilesExportUploadCred    = ("UserName","password"),		      # ����� � ������ ��� �������
	#[array] $FilesBackUpFileMask      = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_2*.bak"),

	# +===================================+
    # |    Purge Old Files/folders        |
	# +===================================+
	#[switch]$Purge = $TRUE,		                                         # ��������� ������ ������/���������
	[switch] $Purge = $FALSE,		                                         # ��������� ������ ������/���������
	[array]  $PurgeList = (
                                  # ��� ������� ����������� � $FilesBackUpPath , ���� ������� ���������� ����������, ID - �� ������ ������� � ����������� ����������, Compress | $FALSE - �������
                                  # "Path" - "���� � ����� ��������", "Mask" - ����� ������, ("Limits") - ������� �������� (10, 60, 180, 365, 0) - d / 10d / m / q / y
                                ("Path", "Mask", ($NULL)),
                                ("Path", "Mask", ($NULL))
                                #("c:\BackUp", "SomeFile_", ($NULL)),
                                #("c:\BackUp", "SomeFile_", (10, 60, 180, 365, 0))
                             ),		# ��������� �����
    

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
    [int]    $Store_Daily    = 14,                    # ���� �������� ���������� ������
    [int]    $Store_10days   = 60,                    # ���� �������� ������ �� 01, 10 � 20 �����
    [int]    $Store_Montly   = 365,                   # ���� �������� ����������� ������ (01.��.��)
    [int]    $Store_Quartal  = 720,                   # ���� �������� �������������� ������ (01.01.�� 01.04.�� 01.07.�� 01.10.��)
    [int]    $Store_Years    = 0,                     # ���� �������� ���������� ������ (01.01.��)

	[switch] $SheduledTaskCreate = $FALSE,		      # �������� ��������� ����� ��� ��������������� ������� �������
	[switch] $UseSettingsFile = $FALSE,			      # �������������� ���� �������� BackUpSettings.ps1 (��������� � ������� �������). ��������� ���������� ������� ����� PARAM.
	[string] $SettingsFile = $NULL,			          # �������������� ��������� ���� �������� (����� BackUpSettings.ps1) ���� ���� ��������� � ������� ������� ���� ������� ������ ����. 
	[switch] $HighestPrivelegesIsRequired = $FALSE,   # ��������� ���� �� ��������� �����. ���� ���� ���������� ������ � �������

    [string] $TempPath = "D:\BackUp",                 # ������� ��� ������� �� ���������

    [string] $BackUpPath = "D:\BackUp",               # ������� ��� ������� �� ���������
    [string] $ExportPath = "D:\BackUp\2Tape",         # ������� ��� �������� ������� �� ���������
    [switch] $Export     = $FALSE,                    # ���� �������� �� ��� ������ ����� ������������. ���������� �� ������� ��������

	[string] $UploadCahnnelType = "VPN",		      # VPN | FTP | NO .... - ����� ��� �������� ������ �� ������� ������
	[string] $VPNName = "ST",					      # 
#	[string] $VPNUserName = "username",			      # 
#	[string] $VPNPassword= "password",			      # 

	[switch] $Debug = $FALSE	    # � ������� ��� ������� ���� �����
#	[switch] $Debug = $TRUE		# � ������� ��� ������� ���� �����
)

$version = "1.1.2";
$InScript = $TRUE

# +==================+
# |       Common     |
# +==================+
[array]$DefaultStoreLimits = ($Store_Daily, $Store_10days, $Store_Montly, $Store_Quartal, $Store_Years)   # ���� ������ �� � �������, ��� �������� ���������
$CurrDate = Get-Date -Format "yyyy-MM-dd"
$CurrTime = Get-Date -Format "HHmm"
$CurrDateTime = Get-Date -Format "yyyy-MM-dd_HHmm"

# // Files //
$FilesBackUpPath = if ( $FilesBackUpPath -ne "" ) { $FilesBackUpPath } else { $BackUpPath }           # ����� ���� ����������� ��������� ������
$FilesLimits     = if ( $FilesLimits.Count )      { $FilesLimits } else { $DefaultStoreLimits }           
$FilesExportPath = if ( $FilesExportPath -ne "" ) { $FilesExportPath } else { $ExportPath }           
$FilesExport     = if ( $FilesExport )            { $FilesExport } else { $Export }           


# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptFullPath = $ScriptDir + "\" + $script:MyInvocation.MyCommand.Name

# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"
.$ScriptDir"\BackUp_Functions.ps1"

#clear;
WriteLog "Archive Log Files, purge old archives and upload archives to Server" "INFO"
WriteLog "Script version: [$version]" "INFO"


if ( $SettingsFile.Length -gt 3 )
{
    [string]$ParamsPath = "$ScriptDir\$SettingsFile";
}
elseif ( $UseSettingsFile )
{
    [string]$ParamsPath = "$ScriptDir\Settings.ps1";;
}
else 
{
    $ParamsPath = $NULL
}

if ( $ParamsPath.Length -ne 0 )
{
    if ( Test-Path -Path $ParamsPath )
    {
	    # �������� ��������� (������ ��������, ������� SQL � �� ��� ������ � ����� params
	    WriteLog "������ �������� ������� [$ParamsPath]" "INFO"
	    ."$ParamsPath"
    }
    else
    {
    	WriteLog "������ ������� � ���������� ����������� (��������� ���� �������� [$ParamsPath] �� ������)" "ERRr"
    }
}
else
{
	WriteLog "������ ������� � ���������� �����������" "INFO"
}

<#
������ �������� ������ ����� ��������
[string]$ParamsPath = "$ScriptDir\Settings.ps1";
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
#>

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



# �������� ��������� ����� ��� ��������������� ������� �������
#$SheduledTaskCreate = $TRUE
if ($SheduledTaskCreate) { .$ScriptDir"\BackUp_Sheduled-Task.ps1";  BackUp_SheduledTask;  }

if ( Test-Path -Path "ScriptDir\BackUp_SQL.ps1" )     { .$ScriptDir"\BackUp_SQL.ps1";     }
if ( Test-Path -Path "ScriptDir\BackUp_Log.ps1" )     { .$ScriptDir"\BackUp_Log.ps1";     }
if ( Test-Path -Path "ScriptDir\BackUp_Errors.ps1" )  { .$ScriptDir"\BackUp_Errors.ps1";  }
if ( Test-Path -Path "ScriptDir\BackUp_MySQL.ps1" )   { .$ScriptDir"\BackUp_MySQL.ps1";   }
if ( Test-Path -Path "ScriptDir\BackUp_Redmine.ps1" ) { .$ScriptDir"\BackUp_Redmine.ps1"; }
if ( Test-Path -Path "ScriptDir\BackUp_SVN.ps1" )     { .$ScriptDir"\BackUp_SVN.ps1";     }
if ( Test-Path -Path "ScriptDir\BackUp_Files.ps1" )   { .$ScriptDir"\BackUp_Files.ps1";   }
if ( Test-Path -Path "ScriptDir\BackUp_Purger.ps1" )  { .$ScriptDir"\BackUp_Purger.ps1";  }
if ( Test-Path -Path "ScriptDir\BackUp_Collect.ps1" ) { .$ScriptDir"\BackUp_Collect.ps1"; }

#"[$Debug]"
#$Debug = $TRUE
#"[$Debug]"
#"fffff3"

# Custom Scenarios (in settings.ps1)
if ( ($SettingsFile.Length -gt 3) -or $UseSettingsFile )
{
    Custom_Scenario
}
else
{
    if ( $SQL     ) { BackUp_MSSQL;            } # MS SQL
    if ( $Log     ) { BackUp_Logs;             } # Log files
    if ( $Errors  ) { BackUp_Errors;           } # Error files (Special for shturman)
    if ( $MySQL   ) { BackUp_MySQL;            } # MySQL
    if ( $Redmine ) { BackUp_Redmine;          } # Redmine
    if ( $SVN     ) { BackUp_SVN;              } # SVN Repositories
    if ( $FilesON ) 
    { 
        BackUp_FilesAndFolders -BackUpPath $FilesBackUpPath -DateFormat $FilesDateFormat -FilesList $FilesFileName -FolderList $FilesFolderName -Limits $FilesLimits -ExportPath $FilesExportPat -Export $FilesExport
    } # ����� � ��������
    if ( $Purge   ) { BackUp_Purger;           } # Purger old backup (bastd on files and folders)
    if ( $Collect ) { BackUp_Collect;          } # ���� ������� � ������ ��������
}

# Custom Scenarios (in settings.ps1)
#if ( ($SettingsFile.Length -gt 3) -or $UseSettingsFile )
#{
    #Scenario_After
#}

$InScript = $FALSE