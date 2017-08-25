<#

# sessions list
Get-SSHSession

# список трастевых хостов
Get-SSHTrustedHost
#Удаление трастевого хоста
Remove-SSHTrustedHost -SSHHost 172.16.30.152

# пишет в консоль но энтер не нажимает
$SSH.Write("ls")

#>


[object] $objCred = $null
[string] $strUser = 'olimex'
[System.Security.SecureString] $strPass = $NULL 
#[System.Security.SecureString] $strPass = '' 


$strPass = ConvertTo-SecureString -String "olimex" -AsPlainText -Force
$objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strPass)


$HostName = "172.16.30.152"

# Kill old sessions
if (Get-SSHSession -HostName $HostName)
{
	$sessions = Get-SSHSession -HostName $HostName
	foreach ($session in $sessions)
	{
		if(Remove-SSHSession -SessionId $session.SessionId)
		{
			Write-host "LOG: Removed old session for host [$HostName] with ID:["$session.SessionId"]"
		}
	}
}

#$SSHSession = New-SSHSession -ComputerName $HostName -Credential (Get-Credential $objCred)

$SSHSession = New-SSHSession -ComputerName $HostName -Credential (Get-Credential $objCred)
#$SSHSession = New-SSHSession -ComputerName $HostName -Credential (Get-Credential -UserName olimex -Message a)

while ((Get-SSHSession -HostName $HostName) -eq $NULL){write-host "connecting"}

Start-Sleep -Seconds 2

$SSH = $SSHSession | New-SSHShellStream

#break;

Start-Sleep -Seconds 2
$SSH.WriteLine("ls")
Start-Sleep -Seconds 2
$SSH.Read()

# kill session
#Remove-SSHSession -SSHSession $SSHSession



# Invoke-SSHCommand -Index 0 -Command "uname -a"

