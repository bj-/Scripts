if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile;  break }

function BackUp_MySQL()
{
    $ModVer = "1.0.1"
    $ModName = "MySQL"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"
    
    WriteLog "MySQL BackUp: DB list: [$MySQL_DB]" "INFO"

    $CurrentBackUpFolder = get_BackUpPath -Path $MySQLBackUpPath

    #WriteLog ("MySQL_DB.Length1:" + $MySQL_DB.Length) "DUMP"
    
    if ( $MySQL_DB.Length )
    {
        #WriteLog ("MySQL_DB.Length2:" + $MySQL_DB.Length) "DUMP"
        foreach ($db in $MySQL_DB)
        {
            WriteLog ("db:" + $db) "DUMP"
            $BackUpNameMask =  $MySQLBackUpPrefix + $db
            $BackUpName =  $BackUpNameMask + "_$CurrDate" + "_$CurrTime" + ".sql"
            $CurrentBackUpFilePath = "$CurrentBackUpFolder\$BackUpName"
            MySQLBackUp -User $MySQLCred[0] -Password $MySQLCred[1] -DataBase $db -File $CurrentBackUpFilePath -Verbose
            #MySQLBackUp -DataBase $db -File $CurrentBackUpFilePath -Verbose

            $FileCreated = Get-ChildItem -Path $CurrentBackUpFilePath
    
            if ( (Test-Path -Path $CurrentBackUpFilePath) -and ($FileCreated.Length -gt 0) )
            #if ( Test-Path -Path $CurrentBackUpFilePath )
            {
                WriteLog "MySQL: Created BackUp of DB [$db] in to [$CurrentBackUpFilePath]" "MESS"

                $arcPath = "$CurrentBackUpFilePath.7z"
                ArchiveFiles -Path $CurrentBackUpFilePath -arcPath $arcPath -DelSource -Verbose

                if ( $Export -or $MySQLExport )
                {
                    export_backup -Source $arcPath -Target $ExportPath -Mask $BackUpNameMask -Verbose
                }

            }
            else
            {
                WriteLog "MySQL: Can not create BackUp of DB [$db] in to [$CurrentBackUpFilePath]" "ERR"
            }

            #purge_oldBackUp -Path $CurrentBackUpFolder -FileMask $BackUpNameMask -Daily $MySQLBackUpDaily -TenDays $MySQLBackUp10days -Montly $MySQLBackUpMontly -Verbose
            purge_oldBackUp -Path $CurrentBackUpFolder -FileMask $BackUpNameMask -Limits $MySQLLimits -Verbose

        }
    }
}