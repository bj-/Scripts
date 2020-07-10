if ( -not $InScript ) { .\Backup.ps1 -UseSettingsFile -Debug;  break }

function BackUp_Collect()
{
    $ModVer = "1.0.1"
    $ModName = "Collect"
    WriteLog "Module [$ModName] version: [$ModVer]" "INFO"
    #===========================================================
    
    WriteLog "Collect BackUp's from Computers to [$Collect_Folder]" "INFO"

    foreach ( $item in $Collect_Data )
    {
        $Share = $item[0]
        $Mask  = $item[1]
        $days  = $item[2]

        #$host
        $Uri = [System.Uri]$Share
        $curr_Host = $Uri.Host

        $Current_Collect_Folder = "$Collect_Folder\$curr_Host"

        if ( Test-Path -Path $Share )
        {
            WriteLog "Process [$Share] with mask [$Mask]; days: [$days]; To $Current_Collect_Folder" "INFO"

            $x = TestFolderPath -Path $Collect_Folder -Create -Verbose
            $x = TestFolderPath -Path $Current_Collect_Folder -Create -Verbose

            $src_mask = "$Share\$Mask*"

            $x = move_files -Path $src_mask -Destination $Current_Collect_Folder -Verbose

            #$x = purge_oldBackUp -Path $Current_Collect_Folder -FileMask $Mask -Daily $Store_Daily -TenDays $Store_10days -Montly $Store_Montly -Quartal $Store_Quartal -Years $Store_Years -Verbose
            $x = purge_oldBackUp -Path $Current_Collect_Folder -FileMask $Mask -Limits $CollectLimits -Verbose
        }
        else
        {
            WriteLog "Source share [$Share] does not exist or not accessible" "ERRr"
        }
    }
}