#
# ������������ ������
#


$LogFile = $MyInvocation.ScriptName -replace ".ps1", ""
$LogFile = $LogFile + ".log"
#$LogFile
# $HostErrorLevel
# $LogErrorLevel
#break
# 
# [LOG]
#
# ���������� ��������� (���������� ���������). �������� ���������  INFO|WARN|ERRr|MESS|DUMP
[string]$FullErrorLevel = "INFO|WARN|ERRr|MESS|DUMP";
[string]$LogErrorLevel = $FullErrorLevel;
if ($Debug)
{
	[string]$HostErrorLevel = $FullErrorLevel;
}
Else
{
	[string]$HostErrorLevel = "INFO|WARN|ERRr|MESS";
}

# ������ ���� ������� ��� ����
[string]$LogDateFormat = "yyyy-MM-dd HH-mm-ss";


function WriteLog
{
	param (
		[string]$message = "",
		[string]$messagetype = "INFO",
		[bool]$Verbose = $TRUE		# � ������� ��� ������� ���� �����
	)

	$currDateTime = Get-Date -Format $LogDateFormat
	
	switch ($messagetype)
	{
		"INFO"
		{
			[string]$color = "White"
		}
		"WARN"
		{
			[string]$color = "Yellow"
		}
		"ERRr"
		{
			[string]$color = "Red"
		}
		"ERR"
		{
			[string]$color = "Red"
		}
		"ERROR"
		{
			[string]$color = "Red"
		}		
        "MESS"
		{
			[string]$color = "Green"
		}
		"DUMP"
		{
			[string]$color = "Gray"
		}
	}

	# � ������� 
	if ($messagetype -match $HostErrorLevel)
	{
		if ($Verbose -or ($messagetype -eq "ERRr") -or ($messagetype -eq "ERR") -or ($messagetype -eq "ERROR") -or ($messagetype -eq "WARN"))
		{
			Write-Host "[ $messagetype ] $message" -foregroundcolor $color;
			#Write-Host "Write-Host [ $messagetype ] $message -foregroundcolor $color";

		}
	}
	# � ���
	if ($messagetype -match $LogErrorLevel)
	{
		"$currDateTime $messagetype $message" | Out-File $LogFile -Encoding "default" -Append
	}

};
