<#
 Авто Конфигурирование компьютера 

	Disable-AutoRun
	- отключение авторана для всего на свете
	- TODO gpedit.msc > CompConf > Adm templates > Windows components > Autorun policy > дизейбл всего и вся
	- TODO Control Panel > Autorun > все "не делать инчего" и галку сверху убрать

#>



function Disable-AutoRun
{
        # хз что делает
	$path ='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer'
	Set-ItemProperty $path -Name NoDriveTypeAutorun -Type DWord -Value 0xFF

	# тоже Хз помогает ли
	$item = Get-Item "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\AutoRun.inf" -ErrorAction SilentlyContinue
	if (-not $item) {
		$item = New-Item "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\AutoRun.inf"
	}
	Set-ItemProperty $item.PSPath "(default)" "@SYS:DoesNotExist"
	# TODO в лог писать об успехе
	Write-Host "Disable-AutoRun закончено"
}

function Enable-AutoRun
{
    Remove-Item "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\AutoRun.inf" -Force
}


Disable-AutoRun