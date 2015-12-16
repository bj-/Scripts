#
# ��������� ������ ����������� ���������� � ������ *.dproj
# ���� *.dproj � �������� � ������������ ��������� � $Path
# � ������ �� ������ �� ��������� � ����� Param. ���� � ������.

# Help ���������� ������ -Help

#   ���� ������ �� ����������� � �������� ��� ��������� ��������� ������������� ������� - ��������� � PS ������ �������
#   Set-ExecutionPolicy RemoteSigned
#   !!! �� ��� ������


# History:
# [!] - New, [#] - Bugs
# [1.0.3]
#   - Debug Mode ��� ������������ � �������
#   - �������� ��� ����� ������ ����������� � ����
#   - ��������� �������� ������ *.BAK
# [1.0.4]
#   - [!] ��������� -Debug -ClearComment ������ ������. �.�. ���� ������ = True, ���� �� ������ - False
#   - [!] help. ���������� ���������� [-help]
#   - [!] �� ���� �����, ����� $ProgGroupName ������� ��� ����� <VerInfo_*> (MajorVer/MinorVer/Build/Release/Keys)
#   - [#] ���������� ���������� ", " � ����������, ���� ����������� ������ � ��� ����� -ClearComment
#   - [#] �������� ���������� �������������� XML ����� - ����������� ������� 4 ������� �� �������. ������ ����� "/>" ���� �� ��������.
#   - [!] ���� �� ������ �������� $Path - ������������ ������� ������ �������.
#   - [!] ���� �� ������ �� ���� �� ������� ������ - ��������� ���������� ����
# TODO NEXT [1.0.5]
#   - 
#
# TODO
#   TODO [HIGH] ��������� �������� ������ ����/���� ��� ��� ������� �������. ��������������.... �� ���. ����/������ � �������. ����� � �������.
#   TODO [HIGH] ���� ���� ��� ������ ��� � XML, �� � ��������� ������ ������� ��������� ���� ������ - ������� ����. $MajorVersion-$Revision
#   TODO [HIGH] ������ �� CMD  ��� ���� �� ������ ��������� (����������� cmd � �������)
#   TODO [HIGH] �������������� XML ����� �������� �� ����� �����. :) - � ������ <tag/> / <tag prop=""/>, � � PS <tag /> /  / <tag prop="" />
#   TODO - �������� ����������� ���� � ��������� ��� � ��� ������������ ��������� ����� ��������
#   TODO - ��������� � �������� ���� �������� ��������������� ��� �� \ ��� � ��� ����  

param (
	# ���� � ������� � ������� ������ �����. ��� ���������� \. �������� "D:\projects"
	# �� ��������� ������� ������� �������
	[string]$Path = (Split-Path $script:MyInvocation.MyCommand.Path), 

	# ��������������� ������ [Major].[Minor].[Build].[Revision]
	[string]$MajorVersion 	= "00",
	[string]$MinorVersion 	= "00",
	[string]$Build	 	= "00",
	[string]$Revision	= "00",
	[string]$Comment	= "",
	[switch]$ClearComment	= $false,
	[switch]$Debug		= $false,
	[switch]$Help		= $false
)


# Script Version
[string]$scriptver = "1.0.4";

#��������� Condition � PropertyGroup
[string]$ProgGroupName = "'`$(Base)'!=''"; # ����� !������! ������ $ ����������� �������� �������. � ������ ����� ������. ������������� ��� � ps ��������

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
[string]$DateFormat = "yyyy-MM-dd HH-mm-ss";

# �������� � ����������.
[string]$LogFile = ".\ChangeVersion.log";


# ����� �� ������ �� ���� �� ������ ������ - ���������� ����
if ($MajorVersion -eq "00" -and $MinorVersion -eq "00" -and $Build -eq "00" -and $Revision -eq "00")
{$Help = $TRUE}

if ($Help)
{
	Clear;
	Write-Host "
# ChangeVersion.ps1
# ver: $scriptver
#
# Update ������ ����������� ���������� � ������ *.dproj
# ���� *.dproj � �������� � ������������ ��������� � ��������� -Path
# � ������ �� ������ �� ��������� � ����� Param. ���� � ������.
#
# ������:
# ���� ������� ����� Param - ������ ����������� � ���
# ���� �� ��������� ������ PS:
# .\ChangeVersion.ps1 
#	����� �� ������������. ��� �������� ������ - ������ ��������� �������� �� param
# 	[-Path '[���� �� ������� � ������� ������]']  (��� ���������� �����) TODO ������� ����������
#	[-MajorVersion '[Major]'] 
#	[-MinorVersion '[Minor]']
#	[-Build '[Build]'] 
#	[-Revision '[Revision]']
#	[-Comment '[����������]']
#	[-ClearComment]		- ������������ ���������� ����� (�� ���������: ��������)
#	[-Debug]		- � ������� ������ ��� ��������� ��� ����, Default = ���������
#       [-Help]			- ������ ����. ��� ������������� ������� ����� - ������ ����� ������������ � ������ �� �����������.
#
# �������:
#   ��� ����� *.prodj � �������� � ������������ D:\Projects
#   .\ChangeVersion.ps1 -Path "D:\Projects" -MajorVersion '0' -MinorVersion '16' -Build '005' -Revision '00' -Comment '�����-��-�� (������ ����)' -ClearComment
#   ��� ����� *.prodj � ������� � �������� �������� (�������)
#   .\ChangeVersion.ps1 -MajorVersion '0' -MinorVersion '16' -Build '005' -Revision '00' -Comment '�����-��-�� (������ ����)' -ClearComment
#
#  ������ ���� ��� ������� �������� (�������� ��������) �������� ���:
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe ""C:\SysTech\ChangeVersion.ps1 -Path 'D:\Projects' -MajorVersion 0 -MinorVersion 16 -Build 005 -Revision 00 -Comment '��� �������' -ClearComment""
# 
#
#   ���� ������ �� ����������� � �������� ��� ��������� ��������� ������������� ������� - ��������� � PS ������ �������
#   Set-ExecutionPolicy RemoteSigned
#   !!! �� ���� ������
";
	break;
}


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

	if ($ClearComment) {$CommentMode = "Replace"} Else {$CommentMode = "Append"}
	WriteLog "File: \$File New Version: $MajorVersion.$MinorVersion.$Build.$Revision, Comment=[$Comment] (mode: $CommentMode)";

	# Get File content in XML
	$xml = [xml](Get-Content -Path $FileFullPath -Encoding UTF8);

	# searching <PropertyGroup Condition= $ProgGroupName >
	$node = $xml.Project.PropertyGroup | where {$_.Condition -eq $ProgGroupName}
	# Change version in properties
	if ($node.VerInfo_MajorVer -ne $null) # ������ ���� �������� ��� �������������. ������ ���� ������ �� ������� � �������.
	{
		WriteLog ("Old VerInfo_MajorVer: " + $node.VerInfo_MajorVer) "DUMP" # Dumping edited values
		$node.VerInfo_MajorVer = $MajorVersion;
#		$node.VerInfo_MajorVer = "ff";
		WriteLog ("New VerInfo_MajorVer: " + $node.VerInfo_MajorVer) "DUMP" # Dumping edited values
		if ($node.VerInfo_MajorVer -ne $MajorVersion) { WriteLog ("In prop [VerInfo_MajorVer] applied value [" + $node.VerInfo_MajorVer + "] not correspond to required value [$MajorVersion]") "ERRr" }
	}
	if ($node.VerInfo_MinorVer -ne $null)
	{
		WriteLog ("Old VerInfo_MinorVer: " + $node.VerInfo_MinorVer) "DUMP" # Dumping edited values
		$node.VerInfo_MinorVer = $MinorVersion;
#		$node.VerInfo_MinorVer = "ff";
		WriteLog ("New VerInfo_MinorVer: " + $node.VerInfo_MinorVer) "DUMP" # Dumping edited values
		if ($node.VerInfo_MinorVer -ne $MinorVersion) { WriteLog ("In prop [VerInfo_MinorVer] applied value [" + $node.VerInfo_MinorVer + "] not correspond to required value [$MinorVersion]") "ERRr" }
	}
	if ($node.VerInfo_Build -ne $null)
	{
		WriteLog ("Old VerInfo_Build: " + $node.VerInfo_Build) "DUMP" # Dumping edited values
		$node.VerInfo_Build    = $Revision;
#		$node.VerInfo_Build = "ff";
		WriteLog ("New VerInfo_Build: " + $node.VerInfo_Build) "DUMP" # Dumping edited values
		if ($node.VerInfo_Build -ne $Revision) { WriteLog ("In prop [VerInfo_Build] applied value [" + $node.VerInfo_Build + "] not correspond to required value [$Revision]") "ERRr" }
	}
	if ($node.VerInfo_Release -ne $null)
	{
		WriteLog ("Old VerInfo_Release: " + $node.VerInfo_Release) "DUMP" # Dumping edited values
		$node.VerInfo_Release    = $Build;
#		$node.VerInfo_Release = "ff";
		WriteLog ("New VerInfo_Release: " + $node.VerInfo_Release) "DUMP" # Dumping edited values
		if ($node.VerInfo_Release -ne $Build) { WriteLog ("In prop [VerInfo_Release] applied value [" + $node.VerInfo_Release + "] not correspond to required value [$Build]") "ERRr" }
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
					if ($Comment -ne "") # ��������� ������� ������ ���� �� �� ������
					{
						$arr[$i] = $arr[$i] + $Separator + $Comment
					}
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
#		if ($node.VerInfo_Keys -ne $NewLine) { WriteLog ("In prop [VerInfo_Keys] applied value [" + $node.VerInfo_Keys + "] not correspond to required value [$NewLine]") "ERRr" }
	}


# �.�. <Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
# �.�. ������ ����-����� - ��������� ������� ��������� ��������� �������.
# ��� ��� �������� ������� �� "powershell selectNodes csproj" (� ����� ���� ��������)
[System.Xml.XmlNamespaceManager] $nsmgr = $xml.NameTable
$nsmgr.AddNamespace('a','http://schemas.microsoft.com/developer/msbuild/2003')

#$xml.SelectNodes("PropertyGroup")
$nodes = $xml.Project.PropertyGroup | where {$_.Condition -ne $ProgGroupName}

function RemoveSingleNode ($Condition, $NodeToRemove)
{
	# �������� ����� ���� �� XML � �����������. ������� ������ ��� ��� PropertyGroup � Condition
	
	# �������� XPatch
	$xPath = "//a:PropertyGroup[@Condition = ""$Condition""]/a:$NodeToRemove"

	$rnode = $xml.SelectSingleNode($xPath, $nsmgr)	# �������� ���� ������� ���� �������
	$parentNode = $rnode.ParentNode; 	# �� ������� ���� �.�. PS ����� ������� ������ �����.
	$d = $parentNode.RemoveChild($rnode);   # �������. "$d =" ��� ���� ���� � ������� �� ������ ���������� ����.
}

foreach ($xnode in $nodes)
{
	# �������� ��� VerInfo_* �� ���� PropertyGroup, ����� ��� � ������� Condition != $ProgGroupName

	if ($xnode.Condition -ne $ProgGroupName)
	{
		# Condition ������� ����
		$Condition = $xnode.Condition

		# ��������� �� ������������� �������� ����, � ���� ��� ���� - �������
		if ($xnode.VerInfo_MajorVer -ne $NULL)
		{
			# ���� �������� ���� (����� �������)
			RemoveSingleNode $Condition "VerInfo_MajorVer"

			# ��������� ��������� ��������
			if ($xnode.VerInfo_MajorVer -eq $NULL) 
			{
				WriteLog ("Exist key VerInfo_MajorVer in PropertyGroup[@Condition=" + $Condition + "] removed succesfully ") "DUMP" # Dumping edited values
			}
			Else
			{
				WriteLog ("Exist key VerInfo_MajorVer in PropertyGroup[@Condition=" + $Condition + "] didn't removed") "ERRr" # Dumping edited values
			}
		}
		If ($xnode.VerInfo_MinorVer -ne $NULL)
		{
			RemoveSingleNode $Condition "VerInfo_MinorVer"
			if ($xnode.VerInfo_MajorVer -eq $NULL) 
			{
				WriteLog ("Exist key VerInfo_MinorVer in PropertyGroup[@Condition=" + $Condition + "] removed succesfully ") "DUMP" # Dumping edited values
			}
			Else
			{
				WriteLog ("Exist key VerInfo_MinorVer in PropertyGroup[@Condition=" + $Condition + "] didn't removed") "ERRr" # Dumping edited values
			}
		}
		If ($xnode.VerInfo_Build -ne $NULL)
		{
			RemoveSingleNode $Condition "VerInfo_Build"
			if ($xnode.VerInfo_MajorVer -eq $NULL) 
			{
				WriteLog ("Exist key VerInfo_Build    in PropertyGroup[@Condition=" + $Condition + "] removed succesfully ") "DUMP" # Dumping edited values
			}
			Else
			{
				WriteLog ("Exist key VerInfo_Build in PropertyGroup[@Condition=" + $Condition + "] didn't removed") "ERRr" # Dumping edited values
			}
		}
		If ($xnode.VerInfo_Release -ne $NULL)
		{
			RemoveSingleNode $Condition "VerInfo_Release"
			if ($xnode.VerInfo_MajorVer -eq $NULL) 
			{
				WriteLog ("Exist key VerInfo_Release  in PropertyGroup[@Condition=" + $Condition + "] removed succesfully ") "DUMP" # Dumping edited values
			}
			Else
			{
				WriteLog ("Exist key VerInfo_Release in PropertyGroup[@Condition=" + $Condition + "] didn't removed") "ERRr" # Dumping edited values
			}
		}
		If ($xnode.VerInfo_Keys -ne $NULL)
		{
			RemoveSingleNode $Condition "VerInfo_Keys"
			if ($xnode.VerInfo_MajorVer -eq $NULL) 
			{
				WriteLog ("Exist key VerInfo_Keys     in PropertyGroup[@Condition=" + $Condition + "] removed succesfully ") "DUMP" # Dumping edited values
			}
			Else
			{
				WriteLog ("Exist key VerInfo_Keys in PropertyGroup[@Condition=" + $Condition + "] didn't removed") "ERRr" # Dumping edited values
			}
		}
	}
}


	# backup original file
#	Copy-Item -Path $FileFullPath -Destination "$FileFullPath.BAK"


	# Save XML File
	$enc = New-Object System.Text.UTF8Encoding( $true ) # True - Save with BOM, False - Save with out BOM
	$wrt = New-Object System.XML.XMLTextWriter( "$FileFullPath", $enc )
	$wrt.Formatting = 'Indented'
	$wrt.Indentation = 4
	$xml.Save( $wrt )
	$wrt.Close()

	
}

WriteLog "END. May be it was successfull..." "MESS"

