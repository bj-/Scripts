# ���� �������� ������� BackUp.ps1

<#
	# Log Files
	[switch]$Log = $TRUE				# ����� � ������������ Log ������ ( ��� ����� ������ ��������� �� ������ ������������)
	[string]$DateFormatLog = "yy-MM-dd"
	[string]$LogFilePath = "D:\Shturman\Bin\Log"
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old"
#    [string]$LogFolderForArchives = $env:computername
	[string]$LogFilePurgeDays = "30"    # Days
	[switch]$PurgeLogFiles = $TRUE     # ���������� ������ ������  $LogFilePurgeDays ����
	[switch]$UploadLogFiles = $FALSE    # ������� ��� ������ �� ������.
	[switch]$FastArcive = $FALSE        # ����� ����������� ���������. ��� ����� - ������ �� ���������, ��� � � ��� ������. �� ������� ������ ����� ��������
	[switch]$LogFileAll2Arc = $FALSE    # ���������� ����������� ��� ��� �����. ������� �����������

    # Errors log Archiver 
	[switch]$Errors = $FALSE				# ������������� Errors ������
	[string]$ErrorsPath = "D:\Shturman\Bin\Errors"		# ����� ��� ����� Errors, �������� ��� � ������� $LogFilePathOld\Errors � ������ Errors_yyyy_MM_dd.7z
#>

    # SQL
	[switch]$SQL = $FALSE,				# ����� � ������������ SQL ( ��� ����� ������ ��������� �� ������ SQL* ������������)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS",
#	[string]$SQLDBName = "Shturman_Metro",
#	[string]$SQLUsername = "BackUpOperator",
#	[string]$SQLPassword = "diF80noY",
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro",
	[string]$SQLExportPath = "D:\BackUp\2Tape",
	[switch]$SQLExport = $FALSE # �������� ��������� ���� � ������� ��� �������� (�������� �� �����������)
	[array]$SQLBackUpFileMask = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_*.bak")
	#[string]$SQLDateFormatLog = "yyyy-MM-dd_HHmm"
	[int]$SQLBackUpDaily = "7" # Days
	[int]$SQLBackUp10days = "60" # Days
	[int]$SQLBackUpMontly = "180" # Days

<#
# SVN
	[switch]$SVN = $TRUE				# ����� � ������������ SVN ( ��� ����� ������ ��������� �� ������ SVN* ������������)
	[string]$SVNRepoPath = "D:\Repositories"
	[string]$SVNBackUpPath = "D:\BackUp\SVN"
	[int]$SVNBackUpDaily = "7"          # Days
	[int]$SVNBackUp10days = "30"        # Days
	[int]$SVNBackUpMontly = "90"        # Days

#>
        # Common
        [switch]$HighestPrivelegesIsRequired = $FALSE
