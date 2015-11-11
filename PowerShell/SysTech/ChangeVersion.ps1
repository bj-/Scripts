#
# ��������� ������ ����������� ���������� � ������ *.dproj
# ���� *.dproj � �������� � ������������ ��������� � $Path
# � ������ �� ������ �� ��������� � ����� Param. ���� � ������.

# ������:
# ���� ������� ����� Param - ������ ����������� � ���
# ���� �� ��������� ������ PS:
# .\ChangeVersion.ps1 
#	����� �� ������������. ��� �������� ������ - ������ ��������� �������� �� param
# 	-Path "[���� �� ������� � ������� ������]"  (��� ����������� �����)
#	-MajorVersion "[Major]" 
#	-MinorVersion "[Minor]" 
#	-Build "[Build]" 
#	-Revision "[Revision]"
#	-Comment "[����������]"
#	-ClearComment 1|0         - 1 ������������ ���������� �����; 0 �������� � ������������� (�� ���������: ��������)
#
# ������:
#   .\ChangeVersion.ps1 -Path "D:\Projects" -MajorVersion "0" -MinorVersion "16" -Build "005" -Revision "00" -Comment "�����-��-�� (������ ����)" -ClearComment
#
#  ������ ���� ��� ������� �������� (�������� ��������) �������� ���:
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\SysTech\ChangeVersion.ps1 -Path 'D:\Projects' -MajorVersion 0 -MinorVersion 16 -Build 005 -Revision 00 -Comment '��� �������'"
# 
#
#   ���� ������ �� ����������� � �������� ��� ��������� ��������� ������������� ������� - ��������� � PS ������ �������
#   Set-ExecutionPolicy RemoteSigned
#

param (
	[string]$Path = ".\SETPATH", # ���� � ������� � ������� ������ �����. ��� ���������� \. �������� "D:\projects"
	# ��������������� ������ [Major].[Minor].[Build].[Revision]
	[string]$MajorVersion 	= "0",
	[string]$MinorVersion 	= "00",
	[string]$Build	 	= "000",
	[string]$Revision	= "00",
	[string]$Comment	= "",
	[bool]$ClearComment	= $false

	#,
	#[string]$someone = $( Read-Host "Input password, please" )
)

# Script Version
[string]$scriptver = "1.0.2";

#��������� Condition � PropertyGroup
[string]$ProgGroupName = "'`$(Base)'!=''"; # ����� !������! ������ $ ����������� �������� �������. � ������ ����� ������. ������������� ��� � ps ��������

# 
# [LOG]
#
# ���������� ��������� (���������� ���������). �������� ���������  INFO|WARN|ERRr|MESS|DUMP
[string]$HostErrorLevel = "INFO|WARN|ERRr|MESS";
[string]$LogErrorLevel = "INFO|WARN|ERRr|MESS|DUMP";

# ������ ���� ������� ��� ����
[string]$DateFormat = "yyyy-MM-dd HH-mm-ss";

# �������� � ����������.
[string]$LogFile = ".\ChVer.log";


# ��������� �������� ������
$MajorVersion 	= $MajorVersion -replace "\D";
$MinorVersion 	= $MinorVersion -replace "\D";
$Build	 	= $Build -replace "\D";
$Revision	= $Revision -replace "\D";
$Comment 	= $Comment -replace ";";

# ===================================================

function WriteLog($message, $messagetype = "INFO")
{
	$currDateTime = Get-Date -Format $DateFormat
	
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
		Write-Host $message -foregroundcolor $color;
	}
	# � ���
	if ($messagetype -match $LogErrorLevel)
	{
		"$currDateTime $messagetype $message" | Out-File $LogFile -Encoding "default" -Append
	}

};

# ������� �� ������ - ��� ������� ����������.
Clear;

# �����������
WriteLog "Version changer [version: $scriptver]" "MESS"
WriteLog "Changing app version in *.dproj files in folder $Path" "MESS"


# Get files in start folder (recursive)
$arr = Get-ChildItem -Path $Path -Force -Recurse -Include *.dproj -Name;

# � ��� ������:
Foreach ($File in $arr) 
{
	# ������ ������ ���� �� ���������� �����
	$FileFullPath = $Path + "\" + $File;

	WriteLog "File: \$File New Version: $MajorVersion.$MinorVersion.$Build.$Revision";

	# Get File content in XML
	$xml = [xml](Get-Content -Path $FileFullPath -Encoding UTF8);

	# searching <PropertyGroup Condition= $ProgGroupName >
	$node = $xml.Project.PropertyGroup | where {$_.Condition -eq $ProgGroupName}
	# Change version in properties
	if ($node.VerInfo_MajorVer -ne $null) # ������ ���� �������� ��� �������������. ������ ���� ������ �� ������� � �������.
	{
		WriteLog ("Old VerInfo_MajorVer: " + $node.VerInfo_MajorVer) "DUMP" # Dumping edited values
		$node.VerInfo_MajorVer = $MajorVersion;
		WriteLog ("New VerInfo_MajorVer: " + $node.VerInfo_MajorVer) "DUMP" # Dumping edited values
	}
	if ($node.VerInfo_MinorVer -ne $null)
	{
		WriteLog ("Old VerInfo_MinorVer: " + $node.VerInfo_MinorVer) "DUMP" # Dumping edited values
		$node.VerInfo_MinorVer = $MinorVersion;
		WriteLog ("New VerInfo_MinorVer: " + $node.VerInfo_MinorVer) "DUMP" # Dumping edited values
	}
	if ($node.VerInfo_Build -ne $null)
	{
		WriteLog ("Old VerInfo_Build: " + $node.VerInfo_Build) "DUMP" # Dumping edited values
		$node.VerInfo_Build    = $Revision;
		WriteLog ("New VerInfo_Build: " + $node.VerInfo_Build) "DUMP" # Dumping edited values
	}
	if ($node.VerInfo_Release -ne $null)
	{
		WriteLog ("Old VerInfo_Release: " + $node.VerInfo_Release) "DUMP" # Dumping edited values
		$node.VerInfo_Release    = $Build;
		WriteLog ("New VerInfo_Release: " + $node.VerInfo_Release) "DUMP" # Dumping edited values
	}

	if ($node.VerInfo_Keys -ne $null)
	{
		WriteLog ("Old VerInfo_Keys: " + $node.VerInfo_Keys) "DUMP"

		# ��������� ��� ������ ������ � ���� ����� (��, � ���������� ��������� ���� ������ �������)
#		$node.VerInfo_Keys = $node.VerInfo_Keys -replace '(ersion=[0-9]{1,10}\.[0-9]{1,10}\.[0-9]{1,10}\.[0-9]{1,10})', "ersion=$MajorVersion.$MinorVersion.$Build.$Revision"
		$node.VerInfo_Keys = $node.VerInfo_Keys -replace 'ersion=([0-9]*(\.)?){1,4}', "ersion=$MajorVersion.$MinorVersion.$Build.$Revision"
#		$node.VerInfo_Keys = $node.VerInfo_Keys -replace 'ersion=(.*?;)', "ersion=$MajorVersion.$MinorVersion.$Build.$Revision;"

		# � ��������� � ������������ ����������
		$arr = $node.VerInfo_Keys.Split("{;}")
		$i = 0;
		while ($arr.Count -gt $i)
		{
			if ($arr[$i] -match "^Comments=")
			{
				if ($ClearComment -eq $false)
				{
					if ($arr[$i].Length -eq 9)
					{
						$Separator = "";
					}
					Else
					{
						$Separator = ", ";
					}
					$arr[$i] = $arr[$i] + $Separator + $Comment
				}
				Else 
				{
					$arr[$i] = "Comments=$Comment"
				}
			}
#			ElseIf ($arr[$i] -match "^Comments=")
#			{
#			}
			$i++;
		}

		$NewLine = $arr -Join ";"

		$node.VerInfo_Keys = $NewLine;

		

#		write-host $ClearComment
#		if ($ClearComment -eq $false)
#		{
#			$node.VerInfo_Keys = $node.VerInfo_Keys -replace 'Comments=', "Comments=$Comment, "
#		}
#		Else
#		{	
#			$node.VerInfo_Keys = $node.VerInfo_Keys -replace '(Comments=.*?;)|(Comments=.*?;?)', "Comments=$Comment;"
#		}

		WriteLog ("New VerInfo_Keys: " + $node.VerInfo_Keys) "DUMP" # Dumping edited values
	}
#	WriteLog "Changed PropertyGroup Condition=$ProgGroupName Set Version = $MajorVersion.$MinorVersion.$Build.$Revision"
#	WriteLog "File saved"

	# backup original file
	#Copy-Item -Path $FileFullPath -Destination "$FileFullPath.BAK"

	# Save XML File
	# $xml.Save($FileFullPath); Save with out BOM

	$enc = New-Object System.Text.UTF8Encoding( $true ) # True - Save with BOM, False - Save with out BOM
	$wrt = New-Object System.XML.XMLTextWriter( "$FileFullPath", $enc )
	$wrt.Formatting = 'Indented'
	$xml.Save( $wrt )
	$wrt.Close()

#	$xml.Save($FileFullPath);
	
}

WriteLog "END. May be it was successfull..." "MESS"


#    <PropertyGroup Condition="'$(Base)'!=''">
#        <VerInfo_MinorVer>14</VerInfo_MinorVer>
#        <VerInfo_MajorVer>0</VerInfo_MajorVer>
#        <VerInfo_Keys>CompanyName=��� ��� ��������� ����������;FileDescription=������� ������ ���������� ������ ���� &quot;�������&quot;;FileVersion=0.14.0.0;InternalName=HubServerConsole;LegalCopyright=2014 ��� ��� ��������� ����������;LegalTrademarks=;OriginalFilename=HubServerConsole.exe;ProductName=������������������ ������� ������ ��������� &quot;�������&quot;;ProductVersion=0.14.0.0;Comments=</VerInfo_Keys>
