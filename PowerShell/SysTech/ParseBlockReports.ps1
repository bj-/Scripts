param (
    [string]$SourcePath = "D:\BlockUpload\",
    [string]$FileFilterIncludeTxt = "LogErrorsCount*txt",
    [string]$FileFilterIncludeArc = "LogErrorsCount*gz",
    [string]$FileFilterExclude = (Get-Date -Format "*dd*"),
    #[string]$ArchiverCmdExtract = "D:\prog\7-zip\7za.exe e ",
	[switch]$Debug = $FALSE		# в консоль все события лога пишет
#	[switch]$Debug = $TRUE		# в консоль все события лога пишет
)

$version = "1.0.0";

# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
# Include SubScripts
.$ScriptDir"\..\Functions\Functions.ps1"
.$ScriptDir"\..\Functions\log.ps1"

clear;
WriteLog "Block Statistics Uploader" "INFO"
WriteLog "Script version: [$version]" "INFO"

$version = "1.0.0";


# Extract filea from Archove and remove archives
$Files = Get-ChildItem $SourcePath -Recurse -Filter $FileFilterIncludeArc -Exclude $FileFilterExclude
foreach ($file in $Files)
{
    #D:\prog\7-zip\7za.exe e $file.FullName
    echo $file.FullName
    #$file.DirectoryName

    $fn = $file.FullName;
    $fd = $file.DirectoryName;

    D:\prog\7-zip\7za.exe e $fn -so | D:\prog\7-zip\7za.exe  x -aoa -si -ttar -o"$fd"
    Remove-Item -Path $fn
    <#
        x    = Extract with full paths command
        -so  = write to stdout switch
        -si  = read from stdin switch
        -aoa = Overwrite all existing files without prompt. 
        -o   = output directory
    #>
}


$Files = Get-ChildItem $SourcePath -Recurse -Filter $FileFilterIncludeTxt
foreach ($file in $Files)
{

    $ScriptResult = ""

    #D:\prog\7-zip\7za.exe e $file.FullName
    $FileFullName = $file.FullName
    $Lines = Get-Content -Path $file.FullName

    #WriteLog "Processing file: [$FileFullName]" "INFO"

    $WagonName = $file.DirectoryName -replace (".*\\", "")

    $FileDate = $file.BaseName -replace (".*_", "")
    $FileDate = "20$FileDate"

    #echo $WagonName
    #echo $FileDate 
    #break

    $ScriptResult = "";
    $ScriptResultHEX = "";

    foreach ($line in $Lines)
    {
        #$line = psiconv -f "windows-1251" -t "utf-8" $line
        $line = psiconv -f "utf-8" -t "windows-1251" $line

        #$line

        $match = [regex]::Match($line,"^[ ]*([0-9]*)") # ищем в формате yyyy-MM-dd.
        #$match
        #$match.Value
        #$DriveLetter = $match.Value  # извлеченное имя диска (2 символа)
        $count = $match.Value -replace (" ", "")
        $line = $line -replace ($match.Value, "")


        $match = [regex]::Match($line,"^[ A-Z:]*") # ищем в формате yyyy-MM-dd.
        #$match
        #$match.Value
        #$DriveLetter = $match.Value  # извлеченное имя диска (2 символа)
        $type = $match.Value -replace (" |:", "")
        $line = $line -replace ($match.Value, "")

        $match = [regex]::Match($line,"^[ 0-9]*") # ищем в формате yyyy-MM-dd.
        #$match
        #$match.Value
        #$DriveLetter = $match.Value  # извлеченное имя диска (2 символа)
        $code = $match.Value -replace (" ", "")
        $line = $line -replace ($match.Value, "")


        $match = [regex]::Match($line,"^\[[A-Za-z]*\]") # ищем в формате yyyy-MM-dd.
        #$match
        #$match.Value
        $device = $match.Value -replace ("\[|\]", "")

        $text = $line
        #$text = "ывфаываыв" 
        #$text = psiconv -f "utf-8" -t "windows-1251" "ывфаываыв" 
        #$text = psiconv -f "windows-1251" -t "utf-8" "ывфаываыв" 

        $textHEX = bin2hex -text $text # convert to HEX
        
        $sResult = "$WagonName!;!$FileDate!;!$count!;!$type!;!$code!;!$device!;!$text"
        $sResultHEX = "$WagonName!;!$FileDate!;!$count!;!$type!;!$code!;!$device!;!$textHEX"
        $ScriptResult += $sResult+"`n";
        $ScriptResultHEX += $sResultHEX+"`n";


        if ($Debug)
        {
            echo "`$WagonName = [$WagonName]"
            echo "`$FileDate  = [$FileDate]"
            echo "`$count = [$count]"
            echo "`$type = [$type]"
            echo "`$code = [$code]"
            echo "`$device = [$device]"
            echo "`$text = [$text]"
            #echo $line
        }

        
    }
     
    WriteLog "Processing Wagon: [$WagonName] / Date:  [$FileDate] / File: [$FileFullName]" "MESS"

    #Write-Host "Wagon: [$WagonName] / Date:  [$FileDate] / File: [$FileFullName]" -ForegroundColor Green
    #Write-Host "" -ForegroundColor Green
    #Write-Host "Log: "
    #echo $ScriptResult


    $postQ = "data=$ScriptResultHEX";

    $f = Invoke-WebRequest -Uri http://10.200.24.92/request/addblockslogmessage.php -Method POST -Body $postQ
    
    $fContent = $f.Content
    if ($fContent -ne "" )
    {
        WriteLog "result from php script [$fContent]" "INFO"
    }
    else
    {
        DeleteFile -File $FileFullName
    }

    $ScriptResult = "";
    $ScriptResultHEX = "";


    #break
    #$file.DirectoryName
}
