﻿if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile -Debug;  break }

function BackUp_Purger()
{
	<#
	 1.0.2
		 -  Skip empty arrays
	#>

    $ModVer = "1.0.2"
    $ModName = "Purger"
    WriteLog "Module [$ModName] version: [$ModVer]" "INFO"


    foreach ( $item in $PurgeList )
    {
        # "Path" - "Путь к месту хранения", "Mask" - маски файлов, ("Limits") - правила удаления (10, 60, 180, 365, 0) - d / 10d / m / q / y
        #("Path", "Mask", ("Limits"))
        #("c:\BackUp", "SomeFile_", ($NULL))
        #("c:\BackUp", "SomeFile_", (10, 60, 180, 365, 0))
    
        $Path = $item[0]
        $Mask = $item[1]
        $cLimits = if ( $item[2] ) { $item[2] } else { $DefaultStoreLimits }


        #Purge if backup created
        if ( $Path -ne "" )
        {
            WriteLog "Purger procesing in [$Path] by mask [$Mask]; limits [$cLimits]" "INFO"
            purge_oldBackUp -Path $Path -FileMask $Mask -Limits $cLimits -Verbose
        }
        else
        {
            WriteLog "Purger procesing nothing, becouse empty Path [$Path]; mask [$Mask]; limits [$cLimits]" "DUMP"
        }
    }
}