<#
 ���� ���������������� ���������� 

	Disable-AutoRun
	- ���������� �������� ��� ����� �� �����
	- TODO gpedit.msc > CompConf > Adm templates > Windows components > Autorun policy > ������� ����� � ���
	- TODO Control Panel > Autorun > ��� "�� ������ ������" � ����� ������ ������

#>



function Disable-AutoRun
{
        # �� ��� ������
	$path ='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer'
	Set-ItemProperty $path -Name NoDriveTypeAutorun -Type DWord -Value 0xFF

	# ���� �� �������� ��
	$item = Get-Item "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\AutoRun.inf" -ErrorAction SilentlyContinue
	if (-not $item) {
		$item = New-Item "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\AutoRun.inf"
	}
	Set-ItemProperty $item.PSPath "(default)" "@SYS:DoesNotExist"
	# TODO � ��� ������ �� ������
	Write-Host "Disable-AutoRun ���������"
}

function Enable-AutoRun
{
    Remove-Item "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\AutoRun.inf" -Force
}


Disable-AutoRun