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
			[string]$color = "white"
		}
		"WARN"
		{
			[string]$color = "yellow"
		}
		"ERRr"
		{
			[string]$color = "red"
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
		if ($Verbose)
		{
			Write-Host $message -foregroundcolor $color;
		}
	}
	# � ���
	if ($messagetype -match $LogErrorLevel)
	{
		"$currDateTime $messagetype $message" | Out-File $LogFile -Encoding "default" -Append
	}

};
