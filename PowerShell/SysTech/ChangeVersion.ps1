#
# Изменялка версии собираемого приложения в файлах *.dproj
# Ищет *.dproj в каталоге и подкаталогах указанных в $Path
# и меняет им версию на указанную в блоке Param. либо в ключах.

# Запуск:
# либо правкой блока Param - версии прописываем в нем
# либо из командной строки PS:
# .\ChangeVersion.ps1 
#	Ключи не обязательные. при отсутвии любого - возмет дефолтное значение из param
# 	[-Path "[Путь до фолдера в котором менять]"]  (без оконечного слеша) TODO сделать толерастом
#	[-MajorVersion "[Major]"] 
#	[-MinorVersion "[Minor]"]
#	[-Build "[Build]"] 
#	[-Revision "[Revision]"]
#	[-Comment "[Коментарий]"]
#	[-ClearComment]		- перезаписать коментарий новым (по умолчанию: добавить)
#	[-Debug]		- в консоль сыпать все сообщения для лога, Default = отключено
#
# Пример:
#   .\ChangeVersion.ps1 -Path "D:\Projects" -MajorVersion "0" -MinorVersion "16" -Build "005" -Revision "00" -Comment "Хаааа-ха-ха (адский смех)" -ClearComment
#
#  Полный путь для запуска скриптов (шоткатом например) выглядит так:
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\SysTech\ChangeVersion.ps1 -Path 'D:\Projects' -MajorVersion 0 -MinorVersion 16 -Build 005 -Revision 00 -Comment 'Все починил'" -ClearComment
# 
#
#   Если скрипт не запускается и ругается что запрещено запускать неподписанные скрипты - выполнить в PS данную команду
#   Set-ExecutionPolicy RemoteSigned
#

# History:
# [1.0.3]
#   - Debug Mode для логгирования в консоли
#   - Проверка что новые данные зааплаились в ноду
#   - отключено создание файлов *.BAK
# [1.0.4]
#   - Аргументы -Debug -ClearComment теперь свитчи. т.е. если указан = True, если не указан - False
#   - help. вызывается аргументом [-help]
#
# TODO
#   TODO [HIGH] Во всех нодах, кроме $ProgGroupName убивать все ключи по маске <VerInfo_*>
#   TODO [HIGH] Если ноды для версий нет в XML, но в командной строке указано прописать туда версию - создать ноду. $MajorVersion-$Revision
#   TODO [HIGH] Default $Path - текущий фолдер скрипта. возможно отдельным свитчем. чтоб случайно в C: не запустили
#   TODO [HIGH] Запуск из CMD  так чтоб не билась кодировка (попробовать cmd в юникоде)
#   TODO [HIGH] форматирование XML файла сделать также убого как в делфи. :) дабы при коммите нормально реплейсились только измененные строки.
#   TODO - зачитать сохраненный файл и проверить что в нем дествительно сохранены новые значения
#   TODO - принимать в качестве пути значения оканчивающмяеся как на \ так и без оной  
#   TODO - автоматом показывать хелп, (если нет корректных аргументов на входе.)

param (
	[string]$Path = ".\DEFAULTPATH", # Путь к фолдеру в котором менять файлы. без оконечного \. например "D:\projects"
	# Устанавливаемая версия [Major].[Minor].[Build].[Revision]
	[string]$MajorVersion 	= "0",
	[string]$MinorVersion 	= "00",
	[string]$Build	 	= "000",
	[string]$Revision	= "00",
	[string]$Comment	= "",
	[switch]$ClearComment	= $false,
	[switch]$Debug		= $false,
	[switch]$Help		= $false
)

# Script Version
[string]$scriptver = "1.0.4";

#требуемый Condition в PropertyGroup
[string]$ProgGroupName = "'`$(Base)'!=''"; # перед !первым! знаком $ обязательна обратная кавычка. и только перед первым. экранирование так в ps работает

# 
# [LOG]
#
# Логгирумые сообщения (регулярное выражение). Доступны сообщения  INFO|WARN|ERRr|MESS|DUMP
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

# Формат даты времени для лога
[string]$DateFormat = "yyyy-MM-dd HH-mm-ss";

# Значения и переменные.
[string]$LogFile = ".\ChVer.log";

if ($Help)
{
	Clear;
	Write-Host "
# ChangeVersion.ps1
# ver: $scriptver
#
# Update версии собираемого приложения в файлах *.dproj
# Ищет *.dproj в каталоге и подкаталогах указанных в аргументе -Path
# и меняет им версию на указанную в блоке Param. либо в ключах.
#
# Запуск:
# либо правкой блока Param - версии прописываем в нем
# либо из командной строки PS:
# .\ChangeVersion.ps1 
#	Ключи не обязательные. при отсутвии любого - возмет дефолтное значение из param
# 	[-Path '[Путь до фолдера в котором менять]']  (без оконечного слеша) TODO сделать толерастом
#	[-MajorVersion '[Major]'] 
#	[-MinorVersion '[Minor]']
#	[-Build '[Build]'] 
#	[-Revision '[Revision]']
#	[-Comment '[Коментарий]']
#	[-ClearComment]		- перезаписать коментарий новым (по умолчанию: добавить)
#	[-Debug]		- в консоль сыпать все сообщения для лога, Default = отключено
#       [-Help]			- Данный Хелп. при использовании данного ключа - другие ключи игнорируются и скрипт не выполняется.
#
# Пример:
#   .\ChangeVersion.ps1 -Path "D:\Projects" -MajorVersion '0' -MinorVersion '16' -Build '005' -Revision '00' -Comment 'Хаааа-ха-ха (адский смех)' -ClearComment
#
#  Полный путь для запуска скриптов (шоткатом например) выглядит так:
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe ""C:\SysTech\ChangeVersion.ps1 -Path 'D:\Projects' -MajorVersion 0 -MinorVersion 16 -Build 005 -Revision 00 -Comment 'Все починил' -ClearComment""
# 
#
#   Если скрипт не запускается и ругается что запрещено запускать неподписанные скрипты - выполнить в PS данную команду
#   Set-ExecutionPolicy RemoteSigned
";
	break;
}


# Валидация входящих данных
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

	# В консоль 
	if ($messagetype -match $HostErrorLevel)
	{
		Write-Host $message -foregroundcolor $color;
	}
	# В лог
	if ($messagetype -match $LogErrorLevel)
	{
		"$currDateTime $messagetype $message" | Out-File $LogFile -Encoding "default" -Append
	}

};

# чистота на экране - как завещал мойдодырок.
Clear;

# приветствие
WriteLog "Version changer [version: $scriptver]" "MESS"
WriteLog "Changing app version in *.dproj files in folder $Path" "MESS"


# Get files in start folder (recursive)
$arr = Get-ChildItem -Path $Path -Force -Recurse -Include *.dproj -Name;

# и для кадого:
Foreach ($File in $arr) 
{
	# строим полный путь до следующего файла
	$FileFullPath = $Path + "\" + $File;

	if ($ClearComment) {$CommentMode = "New"} Else {$CommentMode = "Append"}
	WriteLog "File: \$File New Version: $MajorVersion.$MinorVersion.$Build.$Revision, Comment=[$Comment] (mode: $CommentMode)";

	# Get File content in XML
	$xml = [xml](Get-Content -Path $FileFullPath -Encoding UTF8);

	# searching <PropertyGroup Condition= $ProgGroupName >
	$node = $xml.Project.PropertyGroup | where {$_.Condition -eq $ProgGroupName}
	# Change version in properties
	if ($node.VerInfo_MajorVer -ne $null) # каждую ноду проверяе мна существование. просто чтоб скрипт не ругался в консоли.
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

		# регулярка для замены версии в инфо файла (да, я регулярные выражения знаю весьма хреново)
#		$node.VerInfo_Keys = $node.VerInfo_Keys -replace '(ersion=[0-9]{1,10}\.[0-9]{1,10}\.[0-9]{1,10}\.[0-9]{1,10})', "ersion=$MajorVersion.$MinorVersion.$Build.$Revision"
		$node.VerInfo_Keys = $node.VerInfo_Keys -replace 'ersion=([0-9]*(\.)?){1,4}', "ersion=$MajorVersion.$MinorVersion.$Build.$Revision"
#		$node.VerInfo_Keys = $node.VerInfo_Keys -replace 'ersion=(.*?;)', "ersion=$MajorVersion.$MinorVersion.$Build.$Revision;"

		# и разбираем и обрабатываем коментарий
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
#		if ($node.VerInfo_Keys -ne $NewLine) { WriteLog ("In prop [VerInfo_Keys] applied value [" + $node.VerInfo_Keys + "] not correspond to required value [$NewLine]") "ERRr" }
	}
#	WriteLog "Changed PropertyGroup Condition=$ProgGroupName Set Version = $MajorVersion.$MinorVersion.$Build.$Revision"
#	WriteLog "File saved"

	# remove usless nodes .VerInfo_*

$xxx = $xml.Project.PropertyGroup.SelectNodes("")

$xxx
#$RemoveAttribute = $xml.Project.PropertyGroup.VerInfo_Keys
#$xml.Project.PropertyGroup($RemoveAttribute)

	

	$nodes = $xml.Project.PropertyGroup # | where {$_.Condition -eq $ProgGroupName}
#$nodes
	foreach ($xnode in $nodes)
	{
		if ($xnode.Condition -ne $ProgGroupName)
		{
			if ($xnode.VerInfo_Keys -ne $null) {
			write-host "aaaaaaaaaaaaaa" -foregroundcolor yellow
$xnode.


#$node.SelectNodes($node.VerInfo_Keys) | % { $_.ParentNode.RemoveChild($_) }
#$rnode = $node
#$node.RemoveChild($node.VerInfo_Keys)
#$node.RemoveFromTree($node.VerInfo_Keys)

#$rnode = $node.SelectSingleNode("VerInfo_Keys")
#$node = $xml.SelectSingleNode("//VerInfo_Keys[.='$node.VerInfo_Keys']")
#[Void]
#$aaa = $xnode.SelectSingleNode("VerInfo_Keys")
#$aaa
#$nodes.RemoveChild($xnode.SelectSingleNode("VerInfo_Keys"))
#$xnode.SelectNodes("//VerInfo_Keys").item(0).removechild()

#$rnode
#[Void]$node.RemoveChild($rnode)

#				$node.VerInfo_Keys.RemoveAll();
#				$node.RemoveFromTree();
				
#				$node.RemoveChild(); 
			write-host "aaaaaaaaaaaaaa" -foregroundcolor yellow
			};
	                #$xnode
		}
	}
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
#        <VerInfo_Keys>CompanyName=ЗАО НПП Системные Технологии;FileDescription=Консоль службы диспетчера данных АСПМ &quot;Штурман&quot;;FileVersion=0.14.0.0;InternalName=HubServerConsole;LegalCopyright=2014 ЗАО НПП Системные Технологии;LegalTrademarks=;OriginalFilename=HubServerConsole.exe;ProductName=Автоматизированная Система Помощи Машинисту &quot;Штурман&quot;;ProductVersion=0.14.0.0;Comments=</VerInfo_Keys>
