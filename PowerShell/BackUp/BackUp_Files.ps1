if ( -not $InScript ) { $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path; .$ScriptDir"\Backup.ps1" -Debug;  break }
WriteLog "Imported Module [BackUp_Files.ps1]" "INFO"


function local:BackUp_FilesAndFolders ()
{

	param (
	    [string] $BackUpPath          = $NULL,           # Место куда сладируются сделанные бекапы
        [string] $DateFormat          = $NULL,
	    [array]  $FilesList           = $NULL,		# единичные файлы
	    [array]  $FolderList          = $NULL,		# фолдеры целиком

        [array]  $Limits              = $NULL,                               # [(Days, 10day, Mon, Quartal, Year)] example [(10, 60, 180, 365, 0)]
    	[string] $ExportPath          = $NULL,
        [switch] $Export              = $FALSE			                  # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
        #[int]    $FilesExportUploadArcPart = 100,		                          # Нарезка архива на части = размер части в МБ, 0 = одним куском
        #[switch] $FilesExportUpload        = $FALSE,		                      # Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
        #[string] $FilesExportUploadPath    = "\\172.16.30.139\Share\Exp",	      # Путь куда заливать
        #[array]  $FilesExportUploadCred    = ("UserName","password"),		      # Логин и пароль для заливки

	)

    # приведение к старым названиям
    # TODO исправить в скрипте на новые??? и присвоение также изменить на новые. выбор же из дефолтной и указанной придется оставить в любом случае
    <#
    [string] $FilesDateFormat = if ( $DateFormat -ne "" ) { $DateFormat } else { $FilesDateFormat }
    [string] $FilesBackUpPath = if ( $BackUpPath -ne "" ) { $BackUpPath } else { $FilesBackUpPath }
    
    [array]  $FilesFileName   = if ( $FilesList -ne $NULL ) { $FilesList } else { $FilesFileName }
    [array]  $FilesFolderName = if ( $FolderList -ne $NULL ) { $FolderList } else { $FilesFolderName }
    
    [array]  $FilesLimits     = if ( $Limits -ne $NULL )     { $Limits }     else { $FilesLimits }
    [string] $FilesExportPath = if ( $ExportPath -ne "" ) { $ExportPath } else { $FilesExportPath }
    [switch] $FilesExport     = if ( -not $Export )          { $TRUE }       else { $FALSE }
    #>
    if ( $Debug )
    {
        WriteLog  "`$DateFormat:              [$DateFormat]" "DUMP"
        WriteLog  "`$FilesDateFormat:              [$FilesDateFormat]" "DUMP"
        WriteLog  "`$BackUpPath:              [$BackUpPath]" "DUMP"
        WriteLog  "`$FilesList:              [$FilesList]" "DUMP"
        WriteLog  "`$FolderList:              [$FolderList]" "DUMP"
        WriteLog  "`$Limits:              [$Limits]" "DUMP"
        WriteLog  "`$FilesLimits:              [$FilesLimits]" "DUMP"
        WriteLog  "`$ExportPath:              [$ExportPath]" "DUMP"
        WriteLog  "`$FilesExportPath:              [$FilesExportPath]" "DUMP"
        WriteLog  "`----" "DUMP"
    }

    [string] $FilesDateFormat = if ( $DateFormat -ne "" ) { $DateFormat } else { $FilesDateFormat }
    [string] $FilesBackUpPath = $BackUpPath
    
    [array]  $FilesFileName   = $FilesList
    [array]  $FilesFolderName = $FolderList
    $FilesExportPath
    [array]  $FilesLimits     = if ( $Limits.Count -gt 0 ) { $Limits } else { $FilesLimits }
    [string] $FilesExportPath = if ( $ExportPath -ne "" ) { $ExportPath } else { $FilesExportPath  }
    [switch] $FilesExport     = $Export

    #$l_ExportPath
    $ExportPath

    #$FilesExportPath = "ffffffffffff111"
    #$ExportPath = "ffffffffffff111"
    #$Files:FilesExportPath
    #xExit
    "fff"

    $ModVer = "1.0.2"
    $ModName = "Files and folders"
	WriteLog "Module [$ModName] version: [$ModVer]" "INFO"

    #"[$Debug]dfgdfgttt"

    if ( $Debug )
    {
        WriteLog  "`$DateFormat:              [$DateFormat]" "DUMP"
        WriteLog  "`$FilesDateFormat:         [$FilesDateFormat]" "DUMP" $TRUE
        #WriteLog -message ("`$DateFormat:         [$DateFormat]") -messagetype "DUMP" -Verbose $TRUE
        #WriteLog -m   "DUMP" $TRUE
        WriteLog  "`$BackUpPath:              [$BackUpPath]" "DUMP"
        WriteLog  "`$FilesBackUpPath:         [$FilesBackUpPath]" "DUMP" $TRUE
        for ($i=0; $i -lt $FilesFileName.Count; $i++ )
        {
            WriteLog ("`$FilesFileName[$i]:      ["+$FilesFileName[$i]+"]") "DUMP" $TRUE
        }
        for ($i=0; $i -lt $FilesFolderName.Count; $i++ )
        {
            WriteLog ("`$FilesFolderName[$i]:      ["+$FilesFolderName[$i]+"]") "DUMP" $TRUE
        }
        WriteLog  "`$FilesLimits:             [$FilesLimits]" "DUMP" $TRUE
        WriteLog  "`$FilesExportPath:         [$FilesExportPath]" "DUMP" $TRUE
        WriteLog  "`$FilesExport:             [$FilesExport]" "DUMP" $TRUE
    }
    #break


    $FilesExportPath = if ( $FilesExportPath -ne "" ) { $FilesExportPath } else { $ExportPath }

    if ( $Debug )
    {
        WriteLog "`$FilesBackUpPath           [$FilesBackUpPath]" "DUMP"          # Место куда сладируются сделанные бекапы
        WriteLog "`$FilesDateFormat           [$FilesDateFormat]" "DUMP"          # формат даты бекапа
        WriteLog "`$FilesFileName             [$FilesFileName]" "DUMP"            # имя фолдера задаваемого в $FilesBackUpPath , файл который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9]
        WriteLog "`$FilesFolderName           [$FilesFolderName]" "DUMP"          # имя фолдера задаваемого в $FilesBackUpPath , каталог который необходимо забекапить, Compress | $FALSE - сжммать, Уровень сжатия [0-9], Маска включаемых файлов, Маска исключаемых
        #WriteLog "`$FilesBackUpDaily          [$FilesBackUpDaily]" "DUMP"	      # Days
        #WriteLog "`$FilesBackUp10days         [$FilesBackUp10days]" "DUMP"        # Days
        #WriteLog "`$FilesBackUpMontly         [$FilesBackUpMontly]" "DUMP"        # Days
        WriteLog "`$FilesExportPath           [$FilesExportPath]" "DUMP"
        WriteLog "`$FilesExport               [$FilesExport]" "DUMP"              # Выложить последний файл в каталог для экспорта (хардлинк по возможности)
        WriteLog "`$FilesExportUploadArcPart  [$FilesExportUploadArcPart]" "DUMP" # Нарезка архива на части = размер части в МБ, 0 = одним куском
        WriteLog "`$FilesExportUpload         [$FilesExportUpload]" "DUMP"        # Заливка последнего бекапа на сервак, (если он отличается от предыдущего)
        WriteLog "`$FilesExportUploadPath     [$FilesExportUploadPath]" "DUMP"    # Путь куда заливать
        WriteLog "`$FilesExportUploadCred     [$FilesExportUploadCred]" "DUMP"    # Логин и пароль для заливки
        WriteLog "`$FilesBackUpFileMask       [$FilesBackUpFileMask]" "DUMP"
    }

    #$FilesExportPath
     
    # идем по массиву $FilesFileName и пакуем индивидуальное файло
    #for($i=0; $i -lt $FilesFileName.Count; $i++)
    foreach ( $FileItem in $FilesFileName )
    {

        if ( $FileItem[1].Length -eq 0 ) { continue; }
        
        #echo $FilesFileName[$i] 
        #echo $FileItem

        $BackUpFolder = get_BackUpPath -Path $FilesBackUpPath -Create
        $BackUpFolder = get_CombinedPath -Default $BackUpFolder -Local $FileItem[0]

        #$BackUpFolder = if ( $FileItem[0] -ne "" ) { $FileItem[0] } else { $FilesBackUpPath }
        $BackFile      = $FileItem[1]
        $id            = $FileItem[2]
        $Compress      = $FileItem[3]

        WriteLog "Process File [$BackFile] id [$id] [$Compress] to [$BackUpFolder]" "INFO"
        
        if ( $BackFile -eq "" ) 
        {
            continue   # skip item if 
        }
        # пакуем

   	    # Текущая дата в формате который используется для именования файлов
    	$currDate = Get-Date -Format $FilesDateFormat
        
    	#WriteLog "Move Log Files to Archives" "INFO"

        #$BackFileMaskName = $BackFile -replace "(\.\*)|(\..*$)", ""
        $BackFileMaskName = $BackFile -replace "(\.\*)|[\*\?]", ""
        $BackFileMaskName = Split-path $BackFileMaskName -Leaf
        #$BackFileMaskName
        #$BackFileMask = Split-path $BackFile -Leaf

        if ( $id.Length -gt 0 ) 
        {
            $id = "_$id"
        }

	    $path = $BackFile;
	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"

	    $Mask = $BackFileMaskName + $id 
    
	    #WriteLog "Processing file [$File]" "DUMP"

        if ( Test-Path -Path $path )
        {
            #WriteLog "Process file #[$i] [$BackFile]; IsCompress: [$Compress]; to Folder [$BackUpFolder]" "INFO"
            # Архивирование файлов в папке в архив вида [SourceFile Name|Mask]_yyyy-MM-dd_HHmm.7z
            ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

            # выкладываем / заливаем
            if ( $FilesExport -or $Export )
            {
                export_backup -Source $arcPath -Target $FilesExportPath -Mask $Mask -Verbose
            }

            # чистим старье
            #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
            purge_oldBackUp -Path $BackUpFolder -FileMask $Mask -Limits $FilesLimits -Verbose
        }
        else 
        {
            WriteLog "file #[$i] [$BackFile] does not exist" "ERRr"

        }
    }

    # идем по массиву $FilesFolderName и пакуем папки.
    
    foreach ($Folder in $FilesFolderName)
    {

        #if ( $Folder[0] -ne "" ) { $BackUpFolder = $Folder[0] } else {$BackUpFolder = $FilesBackUpPahth }
        # Вычисление каталога для складирования бекапов
        # если [$Folder[0]] не пуст - это каталог куда класть (прямой или относительный путь)
        #                            Если относительный то базовый путь берется из [$FilesBackUpPath] если он не пустой 
        #$FilesBackUpPath

        #$BackUpFolder  = $Folder[0]
        $BackUpFolder = get_BackUpPath -Path $FilesBackUpPath -Create
        $BackUpFolder = get_CombinedPath -Default $BackUpFolder -Local $Folder[0]
        $BackFolder    = $Folder[1]
        $id            = $Folder[2]
        $Compress      = $Folder[3]
        #$CompressLevel = $FilesFileName[$i][3]

        #"yyyy"
        if ( $BackFolder -eq "" )
        {
            WriteLog "Cannot process Folder [$BackFolder]: does not specified; id [$id] [$Compress] to [$BackUpFolder]" "WARN"
            continue # go to Next item
        }

        WriteLog "Process Folder [$BackFolder] id [$id] [$Compress] to [$BackUpFolder]" "INFO"



        $BackFolderName = Split-Path -Path $BackFolder -Leaf
        $BackFolderParent = Split-Path -Path $BackFolder -Parent
        if ( $BackFolderParent -ne "" )
        {
            $BackFolderParentName = split-path -Path $BackFolderParent -Leaf
        }
        else
        {
            # затычка на случай запуска с дефолтными параметрами, а там прописано просто слово, а не полный путь
            $BackFolderParentName = ""
        }
        

        if ( $id.Length -gt 0 ) 
        {
            $id = "_$id"
        }

        #$BackFolderName
        #$BackFolderParentName
        # пакуем
        
   	    # Текущая дата в формате который используется для именования файлов
    	$currDate = Get-Date -Format $FilesDateFormat
        #$currDate


	    $path = $BackFolder;

        if ( $BackFolderName -eq "*" )
        {
            if ( -not (Test-Path -Path $BackFolderParent ) ) { 
                WriteLog "Path `$BackFolderParent [$BackFolderParent] does not exist" "WARN"
                continue 
            }
        }
        else
        {
            #if ( -not (Test-Path -Path $BackFolderName ) ) { 
            #    WriteLog "Path `$BackFolderName [$BackFolderName] does not exist" "WARN"
            #    continue 
            #}
        }

        #"gggg"
        if ( $BackFolderName -eq "*" )
        {
            #if 

            $dirs = Get-ChildItem -Path $BackFolderParent -Directory #-Depth 0
                        

            foreach ( $dir in $dirs )
            {
                $BackFileMaskName = $dir.Name
		        $Mask = $BackFileMaskName + $id
                $path = $dir.FullName
        	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"
                
                $path
                $arcPath
                ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

                # выкладываем / заливаем
                if ( $FilesExport -or $Export )
                {
                    export_backup -Source $arcPath -Target $FilesExportPath -Mask $Mask -Verbose
                }
    
                # чистим старье
                #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
                purge_oldBackUp -Path $BackUpFolder -FileMask $Mask -Limits $FilesLimits -Verbose
                
            }

        }
        else
        {
            $BackFileMaskName = $BackFolderName
	        $Mask = $BackFileMaskName + $id
    	    $arcPath = "$BackUpFolder\$BackFileMaskName" + $id + "_" + $currDate + ".7z"
    #"fff"
            ArchiveFiles -Path $path -arcPath $arcPath -Size $Size -Verbose

            # выкладываем / заливаем
            if ( $FilesExport -or $Export )
            {
                export_backup -Source $arcPath -Target $FilesExportPath -Mask $Mask -Verbose
            }

            # чистим старье
            #purge_oldBackUp -Path $BackUpFolder -FileMask $BackFileMaskName -Daily $FilesBackUpDaily -TenDays $FilesBackUp10days -Montly $FilesBackUpMontly -Verbose 
            #purge_oldBackUp -Path "C:\BackUp\FromComputers\st-nas\" -FileMask "" -Limits $FilesLimits -Verbose
            #"purge_oldBackUp -Path $BackUpFolder -FileMask $Mask -Limits $FilesLimits -Verbose"
            purge_oldBackUp -Path $BackUpFolder -FileMask $Mask -Limits $FilesLimits -Verbose

        }

    }
}