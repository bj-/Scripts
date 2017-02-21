# ���� �������� ������� BackUp.ps1

[bool]$Debug = $TRUE


	# Log Files
	[switch]$Log = $TRUE				# ����� � ������������ Log ������ ( ��� ����� ������ ��������� �� ������ ������������)
	[string]$DateFormatLog = "yy-MM-dd"
	[string]$LogFilePath = "D:\Shturman\Bin\Log"
	[string]$LogFilePathOld = "D:\Shturman\Bin\Log\Old"
	[string]$LogFilePurgeDays = "30"    # Days
	[switch]$PurgeLogFiles = $TRUE     # ���������� ������ ������  $LogFilePurgeDays ����
	[switch]$UploadLogFiles = $FALSE    # ������� ��� ������ �� ������.
	[switch]$FastArcive = $FALSE        # ����� ����������� ���������. ��� ����� - ������ �� ���������, ��� � � ��� ������. �� ������� ������ ����� ��������
	[switch]$LogFileAll2Arc = $FALSE    # ���������� ����������� ��� ��� �����. ������� �����������

# SQL

	[bool]$SQL = $TRUE				# ����� � ������������ SQL ( ��� ����� ������ ��������� �� ������ SQL* ������������)
#	[string]$SQLServerInstance = "localhost\SQLEXPRESS"
#	[string]$SQLDBName = "Shturman_Metro"
#	[string]$SQLUsername = "BackUpOperator"
#	[string]$SQLPassword = "diF80noY"
	[string]$SQLBackUpPath = "D:\BackUp\Shturman_Metro"
	[array]$SQLBackUpFileMask = ("Shturman_Metro_2*.bak","Shturman_Metro_Anal_*.bak")
	[int]$SQLBackUpDaily = "7" # Days
	[int]$SQLBackUp10days = "60" # Days
	[int]$SQLBackUpMontly = "100" # Days