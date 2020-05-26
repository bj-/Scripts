# ���� �������� ������� BackUp.ps1

	# +==============+
	# |   Log Files  |
	# +==============+
	[switch] $Log                  = $FALSE 					     # ����� � ������������ Log ������ ( ��� ����� ������ ��������� �� ������ ������������)
	[string] $LogFilePath          = "D:\Shturman\Bin\Log"
	[string] $LogFilePathOld       = "D:\Shturman\Bin\Log\Old"  
	[switch] $PurgeLogFiles        = $TRUE		                     # ���������� ������ ������  $LogFilePurgeDays ����
	# Errors log Archiver 
	[switch] $Errors               = $TRUE						     # ������������� Errors ������
	[string] $ErrorsPath           = "D:\Shturman\Bin\Errors"	  	 # ����� ��� ����� Errors, �������� ��� � ������� $LogFilePathOld\Errors � ������ Errors_yyyy_MM_dd.7z


	# +==============+
	# |    MySQL     |
	# +==============+
	[switch] $MySQL                    = $FALSE					                    # ����� � ������������ MySQL ( ��� ����� ������ ��������� �� ������ MySQL* ������������)
	[string] $MySQLDumperPath          = "C:\Redmine\mysql\bin\mysqldump.exe"		# �� ��� ��������� �����
	[array]  $MySQLCred                = ("login","password")		    # ����� � ������ ��� �������
	[array]  $MySQL_DB                 = ("db_name_1","db_name_2")                        # ������ ��� ��� ������

	# +==============+
	# |     SVN      |
	# +==============+
	[switch] $SVN            = $FALSE				    # ����� � ������������ SVN ( ��� ����� ������ ��������� �� ������ SVN* ������������)
	[string] $SVNRepoPath    = "C:\Repositories"
	[string] $SVNBackUpPath  = "C:\BackUp\SVN"

	# +==============+
	# |    Redmine   |
	# +==============+
	[switch] $Redmine             = $FALSE			                        # ����� � ������������ Redmine ( ��� ����� ������ ��������� �� ������ Redmine* ������������)
	[string] $RedminePath         = "C:\redmine\apps\redmine\htdocs\files"  # ����� ��� ����� ����� ������� ���������� ���������� (������)


	# +=========================+
	# |    Files and folders    |
	# +=========================+
	#[switch]$FilesON = $TRUE,		                                         # ��������� ������ ������/���������
	[switch] $FilesON = $FALSE		                                         # ��������� ������ ������/���������
	[string] $FilesBackUpPahth = "D:\BackUp\Shturman_Metro\Files"           # ����� ���� ����������� ��������� ������
	[array]  $FilesFileName = (
                                  # ��� ������� ����������� � $FilesBackUpPath , ���� ������� ���������� ����������, ID - �� ������ ������� � ����������� ����������, Compress | $FALSE - �������
                                  # --TODO --"Mask Include", "Mask Exclude" - ����� ������
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress"), 
                                ("TargetFolderForBackUpFile", "FilePatch", "ID", "Compress")
                             )		# ��������� �����
	[array]  $FilesFolderName =  (
                                      # ��� ������� ����������� � $FilesBackUpPath , ������� ������� ���������� ����������, Compress | $FALSE - �������, ������� ������ [0-9], ����� ���������� ������, ����� �����������
                                      # "Mask Include", "Mask Exclude" - ����� ������
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude"), 
                                    ("TargetFolderForFolder", "FolderPatch", "ID", "Compress", "Mask Include", "Mask Exclude")
                                )		# ������� �������
	# �������� ������ ������� (��� � �����) ��� ���?
	[string] $FilesExportPath          = "D:\BackUp\2Tape"
	[switch] $FilesExport              = $TRUE			                  # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)



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

	[string]$BackUpPath = "C:\BackUp"          # ������� ��� ������� �� ���������
	[string]$ExportPath = "C:\BackUp\2Tape"    # ������� ��� �������� ������� �� ���������
	[string]$Export = $TRUE                    # ���� �������� �� ��� ������ ����� ������������. ���������� �� ������� ��������
