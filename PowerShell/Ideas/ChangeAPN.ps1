# Microsoft provides programming examples for illustration only, without warranty either expressed or implied.
# This includes, but is not limited to, the implied warranties of merchantability or fitness for a particular purpose. 
# This article assumes that you are familiar with the programming language that is being demonstrated and 
# with the tools that are used to create and to debug procedures. 
# Microsoft support engineers can help explain the functionality of a particular procedure, 
# but they will not modify these examples to provide added functionality or construct procedures to meet your specific requirements.

param(
  [string]$name = "Inet connection Profile name",
#  [string]$name = $(Read-Host -prompt "Profile name "),
  [string]$APN = "metro.nw",
#  [string]$APN = $(Read-Host -prompt "APN name "),
  [string]$username = "",
#  [string]$username = $(Read-Host -prompt "User name "),
  [string]$password = ""
#  [string]$password = $(Read-Host -prompt "Password ")
  )


 $IsDefault = "true"
 $ProfileCreationType = "UserProvisioned"


$netshmbn = "netsh mbn sh ready int=*"
$SubscriberID = Invoke-Expression $netshmbn
$SubscriberID = $SubscriberID[5]
$SubscriberID = $SubscriberID.Split(" ")[-1]

[xml]$mbnprofile = 
@"
<MBNProfile xmlns="http://www.microsoft.com/networking/WWAN/profile/v1">
<Name>$name</Name>
<IsDefault>$IsDefault</IsDefault>
<ProfileCreationType>$ProfileCreationType</ProfileCreationType>
<SubscriberID>$SubscriberID</SubscriberID>
<AutoConnectOnInternet>true</AutoConnectOnInternet> 
<ConnectionMode>manual</ConnectionMode>
<Context>
<AccessString>$APN</AccessString>
<UserLogonCred> 
<UserName>$username</UserName> 
<Password>$password</Password> 
</UserLogonCred> 
<Compression>DISABLE</Compression>
<AuthProtocol>PAP</AuthProtocol>
</Context>
</MBNProfile>
"@

$file = "$env:TEMP\tempProfile.xml"
$mbnprofile.Save($file)

$importprof = "netsh mbn add profile interface=* name=$file"
Invoke-Expression $importprof
#Remove-Item $file
start $file