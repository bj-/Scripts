#
# Изменялка версии собираемого приложения в файлах *.dproj
# Ищет *.dproj в каталоге и подкаталогах указанных в $Path
# и меняет им версию на указанную в блоке Param. либо в ключах.

# Help вызывается ключем -Help

#   Если скрипт не запускается и ругается что запрещено запускать неподписанные скрипты - выполнить в PS данную команду
#   Set-ExecutionPolicy RemoteSigned
#   !!! из под админа


# History:
# [!] - New, [#] - Bugs
# [1.0.3]
#   - Debug Mode для логгирования в консоли
#   - Проверка что новые данные зааплаились в ноду
#   - отключено создание файлов *.BAK
# [1.0.4]
#   - [!] Аргументы -Debug -ClearComment теперь свитчи. т.е. если указан = True, если не указан - False
#   - [!] help. вызывается аргументом [-help]
#   - [!] Во всех нодах, кроме $ProgGroupName убивает все ключи <VerInfo_*> (MajorVer/MinorVer/Build/Release/Keys)
#   - [#] Исправлено добавление ", " в коментарий, если комментарий пустой и нет ключа -ClearComment
#   - [#] Частично исправлено форматирование XML файла - установлены отступы 4 пробела на уровень. Пробел перед "/>" пока не побежден.
#   - [!] Если не указан параметр $Path - используется текущий фолдер скрипта.
#   - [!] Если не указан ни один из кллючей версии - автоматом показывает хелп
# TODO NEXT [1.0.5]
#   - 
#
# TODO
#   TODO [HIGH] Запретить задавать версию ниже/туже чем при прошлом запуске. контролировать.... хз как. файл/запрос к серверу. лучше к серверу.
#   TODO [HIGH] Если ноды для версий нет в XML, но в командной строке указано прописать туда версию - создать ноду. $MajorVersion-$Revision
#   TODO [HIGH] Запуск из CMD  так чтоб не билась кодировка (попробовать cmd в юникоде)
#   TODO [HIGH] форматирование XML файла доделать до убого делфи. :) - в делфях <tag/> / <tag prop=""/>, а у PS <tag /> /  / <tag prop="" />
#   TODO - зачитать сохраненный файл и проверить что в нем дествительно сохранены новые значения
#   TODO - принимать в качестве пути значения оканчивающмяеся как на \ так и без оной  

param (
	# Путь к фолдеру в котором менять файлы. без оконечного \. например "D:\projects"
	# По умолчанию каталог запуска скрипта
	[string]$Path = (Split-Path $script:MyInvocation.MyCommand.Path), 

	# Устанавливаемая версия [Major].[Minor].[Build].[Revision]
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
[string]$LogFile = ".\ChangeVersion.log";


# еслди не указан ни один из ключей версии - показываем хелп
if ($MajorVersion -eq "00" -and $MinorVersion -eq "00" -and $Build -eq "00" -and $Revision -eq "00")
{$Help = $TRUE}

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
# Примеры:
#   Все файлы *.prodj в каталоге и подкаталогах D:\Projects
#   .\ChangeVersion.ps1 -Path "D:\Projects" -MajorVersion '0' -MinorVersion '16' -Build '005' -Revision '00' -Comment 'Хаааа-ха-ха (адский смех)' -ClearComment
#   Все файлы *.prodj в начиная с текущего каталога (скрипта)
#   .\ChangeVersion.ps1 -MajorVersion '0' -MinorVersion '16' -Build '005' -Revision '00' -Comment 'Хаааа-ха-ха (адский смех)' -ClearComment
#
#  Полный путь для запуска скриптов (шоткатом например) выглядит так:
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe ""C:\SysTech\ChangeVersion.ps1 -Path 'D:\Projects' -MajorVersion 0 -MinorVersion 16 -Build 005 -Revision 00 -Comment 'Все починил' -ClearComment""
# 
#
#   Если скрипт не запускается и ругается что запрещено запускать неподписанные скрипты - выполнить в PS данную команду
#   Set-ExecutionPolicy RemoteSigned
#   !!! из полд админа
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

	if ($ClearComment) {$CommentMode = "Replace"} Else {$CommentMode = "Append"}
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
					if ($Comment -ne "") # добавляем коммент только если он не пустой
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


# т.к. <Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
# т.е. указан нейм-спейс - требуется указать следующие магически строчки.
# как это работает гуглить по "powershell selectNodes csproj" (У шарпа теже проблемы)
[System.Xml.XmlNamespaceManager] $nsmgr = $xml.NameTable
$nsmgr.AddNamespace('a','http://schemas.microsoft.com/developer/msbuild/2003')

#$xml.SelectNodes("PropertyGroup")
$nodes = $xml.Project.PropertyGroup | where {$_.Condition -ne $ProgGroupName}

function RemoveSingleNode ($Condition, $NodeToRemove)
{
	# Удаление одной ноды из XML с неймспейсом. функция только для нод PropertyGroup с Condition
	
	# Собираем XPatch
	$xPath = "//a:PropertyGroup[@Condition = ""$Condition""]/a:$NodeToRemove"

	$rnode = $xml.SelectSingleNode($xPath, $nsmgr)	# выбираем ноду которую надо удалить
	$parentNode = $rnode.ParentNode; 	# На уровень выше т.к. PS умеет удалять только детей.
	$d = $parentNode.RemoveChild($rnode);   # удаляем. "$d =" для того чтоб в консоль не писала содержимое ноды.
}

foreach ($xnode in $nodes)
{
	# Удаление нод VerInfo_* из всех PropertyGroup, кроме той у которой Condition != $ProgGroupName

	if ($xnode.Condition -ne $ProgGroupName)
	{
		# Condition текущей ноды
		$Condition = $xnode.Condition

		# Проверяем на существование дочерней ноды, и если она есть - удаляем
		if ($xnode.VerInfo_MajorVer -ne $NULL)
		{
			# Само удаление ноды (через функцию)
			RemoveSingleNode $Condition "VerInfo_MajorVer"

			# логгируем результат удаления
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

