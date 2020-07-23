if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile -Debug;  break }
# ���� �������� ������� BackUp.ps1

	# +==============+
	# |   Log Files  |
	# +==============+
	[switch] $Log                  = $TRUE 					     # ����� � ������������ Log ������ ( ��� ����� ������ ��������� �� ������ ������������)
	[string] $LogFilePath          = "D:\Shturman4\Bin\Log"
	[string] $LogFilePathOld       = "D:\Shturman4\Bin\Log\Old"  
	[switch] $PurgeLogFiles        = $TRUE		                     # ���������� ������ ������  $LogFilePurgeDays ����
	# Errors log Archiver 
	[switch] $Errors               = $TRUE						     # ������������� Errors ������
	[string] $ErrorsPath           = "D:\Shturman4\Bin\Errors"	  	 # ����� ��� ����� Errors, �������� ��� � ������� $LogFilePathOld\Errors � ������ Errors_yyyy_MM_dd.7z

	# +==============+
	# |     SQL      |
	# +==============+
	[switch] $SQL                    = $TRUE					    # ����� � ������������ SQL ( ��� ����� ������ ��������� �� ������ SQL* ������������)
	[string] $SQLBackUpPath          = "D:\BackUp\MSSQL"
	[string] $SQLExportPath          = "D:\BackUp\2Tape"
	[array]  $SQLBackUpFileMask      = ("Shturman3_Anal_2*.bak")
	[array]  $SQLLimits              = (3, 30, 180, 365, 0)   # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
	#[array]  $SQLLimits              = $NULL                  # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]


	# +=========================+
	# |    Files and folders    |
	# +=========================+
	#[switch]$FilesON = $TRUE,		                                         # ��������� ������ ������/���������
	[switch] $FilesON = $TRUE		                                         # ��������� ������ ������/���������
	[string] $FilesBackUpPath = "D:\BackUp\Files"           # ����� ���� ����������� ��������� ������
	[array]  $FilesFileName = (
                                  # ��� ������� ����������� � $FilesBackUpPath , ���� ������� ���������� ����������, ID - �� ������ ������� � ����������� ����������, Compress | $FALSE - �������
                                  # --TODO --"Mask Include", "Mask Exclude" - ����� ������
                                ("", "D:\Shturman4\BIN\Shturman.ini", "Anal", "Compress"),
                                ("", "", "", "")
                             )		# ��������� �����
	[array]  $FilesFolderName =  (
                                      # ��� ������� ����������� � $FilesBackUpPath , ������� ������� ���������� ����������, Compress | $FALSE - �������, ������� ������ [0-9], ����� ���������� ������, ����� �����������
                                      # "Mask Include", "Mask Exclude" - ����� ������
                                    #("", "C:\inetpub\wwwroot\dynamic", "",  "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\includes", "",  "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\request", "",   "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\script", "",    "Compress", "", ""), 
                                    #("", "C:\inetpub\wwwroot\templates", "", "Compress", "", ""), 
                                    ("", "D:\BackUp\Temp\Portal_Anal", "", "", "", ""), 
                                    ("", "", "", "", "", "")
#                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude")
                                )		# ������� �������
	# �������� ������ ������� (��� � �����) ��� ���?
	#[string] $FilesExportPath          = "D:\BackUp\2Tape"
	[string] $FilesExportPath          = "D:\BackUp\2Export"
	[switch] $FilesExport              = $TRUE			                  # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)


	# +===================================+
    # |    Purge Old Files/folders        |
	# +===================================+
	[switch]$Purge = $TRUE		                                         # ��������� ������ ������/���������
	#[switch] $Purge = $FALSE,		                                         # ��������� ������ ������/���������
	[array]  $PurgeList = (
                                  # ��� ������� ����������� � $FilesBackUpPath , ���� ������� ���������� ����������, ID - �� ������ ������� � ����������� ����������, Compress | $FALSE - �������
                                  # "Path" - "���� � ����� ��������", "Mask" - ����� ������, ("Limits") - ������� �������� (10, 60, 180, 365, 0) - d / 10d / m / q / y
                                ("D:\BackUp\MSSQL", "Shturman3Diag_", ($NULL)),
                                ("D:\BackUp\MSSQL", "ShturmanDiagnostics", ($NULL)),
                                ("D:\BackUp\MSSQL\sRoot", "Shturman3_sRoot", ($NULL)),
                                ("D:\BackUp\Files", "Portal_Anal", ($NULL)),
                                ("D:\BackUp\Files", "Shturman3.ini", ($NULL))
                        )
	# +==========================================+
	# |     Collect BackUp's from Computers      |
	# +==========================================+
	[switch] $Collect = $FALSE				           # ���� ������� � �������� ������ � ������������� �� � ����
	[array]  $Collect_Data = (
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", (14,60,365,720,0) ),
                                ("\\HostName.domain.local\Share\Path", "BackUp_Mask", $NULL )
                            )
	[string] $Collect_Folder = "D:\BackUp\FromComputers"


	# +==============+
	# |    Common    |
	# +==============+

	[string]$BackUpPath = "D:\BackUp"          # ������� ��� ������� �� ���������
	[string]$ExportPath = "D:\BackUp\2Export"    # ������� ��� �������� ������� �� ���������
	[string]$Export = $TRUE                    # ���� �������� �� ��� ������ ����� ������������. ���������� �� ������� ��������


function Custom_Scenario()
{
	$FuncName = $MyInvocation.MyCommand;
	$FuncName = "$FuncName" + ":";

    WriteLog "Start Custom Scenario [Before Basic] " "INFO"
    #===================================================
    #$currDate
    #Scenario
    $x_folders = (
                    ("", "C:\inetpub\wwwroot\dynamic", "",  "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\includes", "",  "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\request", "",   "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\script", "",    "Compress", "", ""), 
                    ("", "C:\inetpub\wwwroot\templates", "", "Compress", "", "")
                 )
    BackUp_FilesAndFolders -BackUpPath "D:\BackUp\Temp\Portal_Anal" -FolderList $x_folders
    $Mask = "Portal_Anal"
    $path = "D:\BackUp\Temp\Portal_Anal"
    $arcPath = "$FilesBackUpPath\$Mask" + "_" + $CurrDateTime + ".7z"
    ArchiveFiles -Path $path -arcPath $arcPath -StoreArchive -DelSource -Verbose
    export_backup -Source $arcPath -Target $ExportPath -Mask $Mask -Verbose
    #purge_oldBackUp -Path $FilesBackUpPath -FileMask $Mask -Limits $Limits -Verbose

    #break
    #===================================================
    WriteLog "End Custom Scenario [Before Basic] " "INFO"



    #Basic Scenario
    BackUp_MSSQL;             # MS SQL
    BackUp_Logs;              # Log files
    BackUp_Errors;            # Error files (Special for shturman)
    #BackUp_MySQL;             # MySQL
    #BackUp_Redmine;           # Redmine
    #BackUp_SVN;               # SVN Repositories
    # ����� � ��������
    #"fffffffffffffffffffff"
    #BackUp_FilesAndFolders -BackUpPath $FilesBackUpPath -DateFormat $FilesDateFormat -FilesList $FilesFileName -FolderList $FilesFolderName -Limits $FilesLimits -ExportPath $FilesExportPat -Export $FilesExport
    BackUp_Purger;            # Purger old backup (bastd on files and folders)
    #BackUp_Collect;           # ���� ������� � ������ ��������




    WriteLog "Start Custom Scenario [After Basic] " "INFO"
    #===================================================

    #Scenario

    #===================================================
    WriteLog "End Custom Scenario [After Basic] " "INFO"
    
}
