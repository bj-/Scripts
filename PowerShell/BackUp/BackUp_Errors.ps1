function BackUp_Errors()
{
    $ModVer = "1.0.1"
    $ModName = "Errors-Files"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"

    # Errors log Archiver 
    # $ErrorsPath = "D:\Shturman\Bin\Errors",		# Папка где лежат Errors, запакует все в каталог $LogFilePathOld\Errors с именем Errors_yyyy-MM-dd_HHmm.7z

    # проверка существования файлов Error по исходному пути, если их там нет то и делать нечего
    if (Test-Path -Path "$ErrorsPath\*.Error")
    {
        # проверка/создание папки куда складывать архив ошибок
        TestFolderPath -Path "$LogFilePathOld\Errors" -Create #-Verbose

        # move ВСЕХ файлов из каталога Еррор, а не только еррор файлов. на всякий случай
      	WriteLog "Try to move ALL files from [$ErrorsPath] to [$LogFilePathOld\Errors]" "DUMP"
        Move-Item -Path "$ErrorsPath\*" -Destination "$LogFilePathOld\Errors" -Force

        # Проверка что смувилось все
        if (-not (Test-Path -Path "$ErrorsPath\*"))
#        if (-not (Test-Path -Path "$ErrorsPath\ddd"))
        {
           	WriteLog "All Error's files moved from [$LogFilePathOld\Errors]" "DUMP"
        }
        else
        {
           	WriteLog "NOT All Error's files moved to [$LogFilePathOld\Errors]" "WARN"
        }
        
        # Проверка что в новом месте что-то появилось и архивирование
        if (Test-Path -Path "$LogFilePathOld\Errors\*.Error")
        {
           	WriteLog "Error's Files does moved succesfully to [$LogFilePathOld\Errors]" "MESS" $FALSE

            # Архивирование файлов в папке в архив вида Errors_yyyy-MM-dd_HHmm.7z с удалением файлов
            $PathToArchive = "$LogFilePathOld\Errors\*.Error"
            $CurrDate = Get-Date -Format "yyyy-MM-dd"
            $ArchivePatch =   "$LogFilePathOld\" + "$LogFolderForArchives\Errors\Errors_$CurrDate.7z"
            ArchiveFiles -Path $PathToArchive -arcPath $ArchivePatch -Verbose -DelSource
        }
        else
        {
           	WriteLog "Error's Files does not exit in [$LogFilePathOld\Errors]" "ERRr"
        }

        
        WriteLog "Remove folder [$LogFilePathOld\Errors]" "DUMP"
        Remove-Item "$LogFilePathOld\Errors"

        
    }
    else
    {
       	WriteLog "No Error's files found in [$ErrorsPath]" "INFO"
    }
}