<#

Parser "netsh ras show portstatus" command

Should be ran on RRAS server with VPN Role. Under Administrator.

#>

# Destination File
$File  = "\\ST-DC1\NetworkConfig$\VPNClients.txt";

# Date Time Format
[string]$LogDateFormat = "yyyy-MM-dd HH-mm-ss";
#Current Date and Time
$currDateTime = Get-Date -Format $LogDateFormat

"Last Updated: $currDateTime " | Out-File $File -Encoding "default" -Force
"`n========================================================`n`nVPN Clients List:`n" | Out-File $File -Encoding "default" -Append

$Lines = netsh ras show portstatus

$newPort = $FALSE;

$Device = "";
$Condition = "";
$LineBPS = "";
$Duration = "";
$BytesIn = "";
$BytesOut = "";
$CRCErrors = "";
$FramingErrors = "";
$TimeOut = "";
$HardwareOverruns = "";
$Alignment = "";
$BufferOverruns = "";
$IPAddress = "";
$IPv6Prefix = "";
$IPv6Address = "";
$NetBEUIname = "";


foreach ($line in $Lines)
{
    if ($line -match "Device")
    {
        $newPort = $TRUE;

        # reset all values
        $Device = "";
        $Condition = "";
        $LineBPS = "";
        $Duration = "";
        #$BytesIn = "";
        #$BytesOut = "";
        $Bytes = ""
        $CRCErrors = "";
        $FramingErrors = "";
        $TimeOut = "";
        $HardwareOverruns = "";
        $Alignment = "";
        $BufferOverruns = "";
        $IPAddress = "";
        $IPv6Prefix = "";
        $IPv6Address = "";
        $NetBEUIname = "";



        $Value = $line.TrimEnd();
        #$Device = $Device -replace ".*?\(", ""
        $x = $Value -match "(\(.+\)).*(\-.+\))"  # get Port type and num
        $Value = $Matches[1] + $Matches[2]
        $Device = $Value -replace "[\)]|[\(]", ""
        # write-host $Device;

    }
    if ($line -match "Condition" -and $newPort)
    {
        $Value = $line.TrimEnd();
        $x = $Value -match ".*(:\s)(.*)"  # get Port type and num
        #$Matches
        $Value = $Matches[2]
        $Condition = $Value -replace "Authenticated\s\(|[\)]", ""
        #$Condition = $Value
        
    }
    if ($line -match "IP Address" -and $newPort)
    {
        $Value = $line.TrimEnd();
        $x = $Value -match ".*(:\s)(.*)"  # get Port type and num
        #$Matches
        $Value = $Matches[2]
        $IPAddress = $Value -replace "Authenticated\s\(|[\)]", ""
        #$Condition = $Value
        if ($IPAddress -ne ""){ $IPAddress = " | IP: $IPAddress"}
        
    }

    if ($line -match "Duration" -and $newPort)
    {
        $Value = $line.TrimEnd();
        $x = $Value -match ".*(:\s)(.*)"  # get Port type and num
        #$Matches
        $Value = $Matches[2]
        #$Duration = $Value
        #$Condition = $Value
        if ($Value -ne "0 Days, 0 Hrs, 0 Mins"){ $Duration = " | Active: $Value"}
        
    }


    if ($line -match "Bytes In" -and $newPort)
    {
        $Value = $line.TrimEnd();
        $Value = $Value -replace "Out", "/"
        $Value = $Value -replace "[a-z]|[\s]|[:]", ""
        #Out
        #$x = $Value -match "(\d{1,10})"  # get Port type and num
        #$Matches
        #$Value = $Matches[2]
        #$Duration = $Value
        #$Condition = $Value
        if ($Value -ne "0/0"){ $Bytes = " | In/Out: $Value"}
        #write-host $line
        
    }

    if ($line -match "NetBEUI name" -and $newPort)
    {
        $newPort = $FALSE
        $NetBEUIname = $line.TrimEnd();

        #write-host "$Device | $Condition $IPAddress $Duration $Bytes"
        "$Device | $Condition $IPAddress $Duration $Bytes" | Out-File $File -Encoding "default" -Append
    }

}

"`n========================================================`n`nRAW Data:" | Out-File $File -Encoding "default" -Append

foreach ($line in $Lines)
{

     $line | Out-File $File -Encoding "default" -Append
}
<#
Device        : WAN Miniport (PPTP) (VPN3-15) 
Condition     : Authenticated (Shturman4sVPN)         
Line bps      : 1410065408    Duration          : 0 Days, 0 Hrs, 11 Mins 
Bytes In      : 1028430       Bytes Out         : 408609    
CRC Errors    : 0             Framing Errors    : 0  
Time Out      : 0             Hardware Overruns : 0   
Alignment     : 0             Buffer Overruns   : 0   
IP Address    : 172.16.30.254                                 
IPv6 Prefix   :                                   
IPv6 Address  :                                   
NetBEUI name  : 
#>