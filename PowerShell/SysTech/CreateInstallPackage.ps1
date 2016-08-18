<# 
Подготовка IntallationPackage
  - собрать SFX архив с именем ShturmanBlock_InstallationPackage.exe
     Структура архива
     - \Shturman - c:\shturman
     - \DB - база в виде скрипта ее создающего
     - \Prog - c:\Prog
     - Install.ps1 - скрипт установки
  - Архив многотомный на случай удаленной заливки да и просто просили.

Установка:
  - !!! Все действия выполянем на Блоке под юзером Block !!!
  - Самостоятельно копируем архив на блок и запускаем его.
  Далее автоматически:
  - Архив распаковывается в текущую папку TODO в "c:\temp\ShturmanInstall"
  - TODO: после распаковки запускается скрипт устанавливающий штурмана
    Удаление старой версии, если таковая имеется:
  - стопим сервисы Штурмана и сносим их
  - беккап "shturman.ini" в "shturman.ini.bak" в каталоге "c:\shturman\bin"
  - проверяем не занятость бд Shturman_Metro, при ее наличии, освобождаем и дропим.
  - удаляем все в каталоге "c:\shturman"
  - TODO: удаляем все в каталоге "c:\Log"
    Установка новой:
  - создаем бд - разворачивем из бэкапа TODO sql скриптом
  - TODO: Создаем каталоги "c:\Log\old" и c:\Shturman
  - копируем начинку в "c:\shturman"
  - регистрируем сервисы и переводим в нужный режим (автоматик / автоматик-делей / manual )
  - TODO: выдираем из "shturman.ini.bak" настройки ком портов и както кажем их тому кто ставит
  - TODO: запускуем тулзу с детектом компортов и прописыванием их в INI.
  - TODO: сравниваем то что наделал тулза и что было ранее. ругаемся на несоответствия

  Завершение установки
  - TODO: удаляем "shturman.ini.bak", Installation Script и весь каталог "c:\temp\ShturmanInstall" (при отсутсвии ошибок)
#>

param (
	[string]$PackageVersion = (Read-Host 'Package version required in format "0.00.0": '), # спрашиваем какую версию присвоить
    [string]$TargetDir = "InstallationPackage",
    [string]$PackagePrefix = "ProductName",
    [string]$ShturmanBlockVersionsFolder = "",
	[switch]$Debug = $FALSE		# в консоль все события лога пишет
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

# Создаем архв собственно
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

