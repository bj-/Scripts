if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile -Debug;  break }

function BackUp_Redmine()
{
    $ModVer = "1.0.1"
    $ModName = "Redmine"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"

    # Куда класть итоговый бекап
    # название файла/каталога бекапа
    # название архива
    # маска для удаления старья

    $Current_BackUpPath = get_BackUpPath -Path $RedmineBackUpPath -Create -Verbose
    #$Current_BackUpPath

    #Create folder
    $Current_BackUpNameMask =  $RedmineBackUpPrefix
    #$Current_BackUpName   = $Current_BackUpNameMask + "_$CurrDate" + "_$CurrTime"
    $Current_BackUpFolder = $Current_BackUpNameMask + "_$CurrDate" + "_$CurrTime"
    #$Current_BackUpFilePath = "$CurrentBackUpFolder\$BackUpName"
    $Current_BackUpFolderPath = add_Subfolder_to_Path -Path $Current_BackUpPath -SubFolderName $Current_BackUpFolder -Create -Verbose 
    #"$CurrentBackUpFolder\$BackUpName"
    $RedmineDB_DumpFileName = "$Current_BackUpFolderPath\RedmineDB" + "_$CurrDate" + "_$CurrTime" + ".sql"


    #Copy Files
    copy_files_and_folders -Path "$RedminePath\*" -Destination $Current_BackUpFolderPath -Recurse -Check -Verbose
    
    #Dump DB
    MySQLBackUp -User $MySQLCred[0] -Password $MySQLCred[1] -DataBase $RedmineDB -File $RedmineDB_DumpFileName -Verbose

    #Archive backup
    $arcPath = "$Current_BackUpPath\$Current_BackUpFolder.7z"
    ArchiveFiles -Path $Current_BackUpFolderPath -arcPath $arcPath -DelSource -Verbose

    #Purge if backup created
    #purge_oldBackUp -Path $Current_BackUpPath -FileMask $Current_BackUpNameMask -Daily $RedmineBackUpDaily -TenDays $RedmineBackUp10days -Montly $RedmineBackUpMontly -Verbose
    purge_oldBackUp -Path $Current_BackUpPath -FileMask $Current_BackUpNameMask -Limits $RedmineLimits -Verbose

    #Export
    export_backup -Source $arcPath -Target $ExportPath -Mask $Current_BackUpNameMask -Verbose
}