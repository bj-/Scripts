<#

  REQUIRED to change properties

The script works with any SQL Server edition & version starting from 2005: SQL Server 2005, SQL Server 2008 and SQL Server 2008 R2. 
Pay close attention, though, if you’re using Sql Server 2012 or Sql Server 2014 you’ll have to make some small modifications to that code.
For Sql Server 2012 you need to replace two lines of code. In details, replace line 5 with the following line:
	$regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\110\Tools\Setup"
 
And also replace line 16 with the following line (thanks to gprkns for pointing it out):
	$binArray = ($data.uValue)[0..16]
 
You can also take a look of the complete script code for Sql Server 2012 at the following link.
For Sql Server 2014, Microsoft moved the   DigitalProductID  node to the actual instance name in the registry, 
so you will need to replace line 5 with something similar to the following (depending on your installation):
	$regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.[YOUR SQL INSTANCE NAME]\Setup"

#>


function GetSqlServerProductKey {
    ## function to retrieve the license key of a SQL 2008 Server.
    param ($targets = ".")
    $hklm = 2147483650
    # $regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\100\Tools\Setup"  # SQL Server 2005-2008
    #$regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\110\Tools\Setup" # SQL Server 2012
    $regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.[YOUR SQL INSTANCE NAME]\Setup" # For Instane of SQL Server
    $regValue1 = "DigitalProductId"
    $regValue2 = "PatchLevel"
    $regValue3 = "Edition"
    Foreach ($target in $targets) {
        $productKey = $null
        $win32os = $null
        $wmi = [WMIClass]"\\$target\root\default:stdRegProv"
        $data = $wmi.GetBinaryValue($hklm,$regPath,$regValue1)
        [string]$SQLver = $wmi.GetstringValue($hklm,$regPath,$regValue2).svalue
        [string]$SQLedition = $wmi.GetstringValue($hklm,$regPath,$regValue3).svalue
        #$binArray = ($data.uValue)[52..66]   # SQL Server 2005-2008
	$binArray = ($data.uValue)[0..16] # SQL Server 2012
        $charsArray = "B","C","D","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","6","7","8","9"
        ## decrypt base24 encoded binary data
        For ($i = 24; $i -ge 0; $i--) {
            $k = 0
            For ($j = 14; $j -ge 0; $j--) {
                $k = $k * 256 -bxor $binArray[$j]
                $binArray[$j] = [math]::truncate($k / 24)
                $k = $k % 24
         }
            $productKey = $charsArray[$k] + $productKey
            If (($i % 5 -eq 0) -and ($i -ne 0)) {
                $productKey = "-" + $productKey
            }
        }
        $win32os = Get-WmiObject Win32_OperatingSystem -computer $target
        $obj = New-Object Object
        $obj | Add-Member Noteproperty Computer -value $target
        $obj | Add-Member Noteproperty OSCaption -value $win32os.Caption
        $obj | Add-Member Noteproperty OSArch -value $win32os.OSArchitecture
        $obj | Add-Member Noteproperty SQLver -value $SQLver
        $obj | Add-Member Noteproperty SQLedition -value $SQLedition
        $obj | Add-Member Noteproperty ProductKey -value $productkey
        $obj
    }
}

GetSqlServerProductKey
#Get-SQLserverKey