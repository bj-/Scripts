<# 
���������� IntallationPackage
  - ������� SFX ����� � ������ ShturmanBlock_InstallationPackage.exe
     ��������� ������
     - \Shturman - c:\shturman
     - \DB - ���� � ���� ������� �� ����������
     - \Prog - c:\Prog
     - Install.ps1 - ������ ���������
  - ����� ����������� �� ������ ��������� ������� �� � ������ �������.

���������:
  - !!! ��� �������� ��������� �� ����� ��� ������ Block !!!
  - �������������� �������� ����� �� ���� � ��������� ���.
  ����� �������������:
  - ����� ��������������� � ������� ����� TODO � "c:\temp\ShturmanInstall"
  - TODO: ����� ���������� ����������� ������ ��������������� ��������
    �������� ������ ������, ���� ������� �������:
  - ������ ������� �������� � ������ ��
  - ������ "shturman.ini" � "shturman.ini.bak" � �������� "c:\shturman\bin"
  - ��������� �� ��������� �� Shturman_Metro, ��� �� �������, ����������� � ������.
  - ������� ��� � �������� "c:\shturman"
  - TODO: ������� ��� � �������� "c:\Log"
    ��������� �����:
  - ������� �� - ������������ �� ������ TODO sql ��������
  - TODO: ������� �������� "c:\Log\old" � c:\Shturman
  - �������� ������� � "c:\shturman"
  - ������������ ������� � ��������� � ������ ����� (��������� / ���������-����� / manual )
  - TODO: �������� �� "shturman.ini.bak" ��������� ��� ������ � ����� ����� �� ���� ��� ������
  - TODO: ��������� ����� � �������� ��������� � ������������� �� � INI.
  - TODO: ���������� �� ��� ������� ����� � ��� ���� �����. �������� �� ��������������

  ���������� ���������
  - TODO: ������� "shturman.ini.bak", Installation Script � ���� ������� "c:\temp\ShturmanInstall" (��� ��������� ������)
#>

param (
	[string]$PackageVersion = (Read-Host 'Package version required in format "0.00.0": '), # ���������� ����� ������ ���������
    [string]$TargetDir = "InstallationPackage",
    [string]$PackagePrefix = "ProductName",
    [string]$ShturmanBlockVersionsFolder = "",
	[switch]$Debug = $FALSE		# � ������� ��� ������� ���� �����
)

$version = "1.0.1";


# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"


# ===============================================
#                   Functions
# ===============================================



clear;
WriteLog "Prepare Installation Package Script" "INFO"
WriteLog "Script version: [$version]" "INFO"


if (test-path -Path "$ShturmanBlockVersionsFolder\CurrentVersion\Prog\7-zip\7za.exe" -ErrorAction SilentlyContinue)
{
}
else
{
	WriteLog "Archiver not found [$ShturmanBlockVersionsFolder\CurrentVersion\Prog\7-zip\7za.exe]" "ERRr"
	break;
}


$TargetDir = $ShturmanBlockVersionsFolder + $TargetDir;
;
$TargetDirFull = "$TargetDir\$PackageVersion";
$TargetFile =  $TargetDirFull + "\" + $PackagePrefix + "_u" + $PackageVersion + ".exe"



WriteLog "Testing directory for new Package [$TargetDirFull]" "Dump"
if (test-path -Path $TargetDirFull -ErrorAction SilentlyContinue)
{
	WriteLog "Package already exist [$PackageVersion]. Please Try Again." "ERRr"
	break;
}


$res = New-Item -Path $TargetDir -Name $PackageVersion -ItemType "directory"
WriteLog "Create Folder: $res" "DUMP"
if (test-path -Path $TargetDirFull -ErrorAction SilentlyContinue)
{
	WriteLog "Block's folder in log store share [$TargetDirFull] created" "MESS"
}
Else
{
	WriteLog "Create Folder [$PackageVersion] in [$TargetDir] failed" "ERRr"
	break;
}


#break

# ������� ���� ����������
WriteLog "Run Archiving [.$ShturmanBlockVersionsFolder\CurrentVersion\Prog\7-zip\7za.exe -mx=9 -v7m -sfx a $TargetFile $ShturmanBlockVersionsFolder\CurrentVersion\ -x!CreateInstallPackage*]" "DUMP"
# .\..\Prog\7-zip\7za.exe -mx=9 -v7m -sfx a $TargetFile .\ -x!CreateInstallPackage*

#cd .$ShturmanBlockVersionsFolder\CurrentVersion\
.$ShturmanBlockVersionsFolder\CurrentVersion\Prog\7-zip\7za.exe -mx=9 -v7m -sfx a $TargetFile $ShturmanBlockVersionsFolder\CurrentVersion\ -x!CreateInstallPackage*
#.$ShturmanBlockVersionsFolder\CurrentVersion\Prog\7-zip\7za.exe -mx=9 -v7m -sfx a $TargetFile .\ -x!CreateInstallPackage*

if (test-path -Path $TargetFile -ErrorAction SilentlyContinue)
{
	WriteLog "Created Package [$TargetFile]" "MESS"
}
Else
{
	WriteLog "Can't create package" "ERRr"
}

