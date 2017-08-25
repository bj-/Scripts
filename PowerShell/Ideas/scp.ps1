[object] $objCred = $null
[string] $strUser = 'olimex'
[System.Security.SecureString] $strPass = $NULL 
#[System.Security.SecureString] $strPass = '' 


$strPass = ConvertTo-SecureString -String "olimex" -AsPlainText -Force
$objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strPass)


$HostName = "172.16.30.152"



# Закачка файла

Set-SCPFile -LocalFile "d:\a.a" -RemoteFile "/home/olimex/a.a" -ComputerName $HostName -Credential (Get-Credential $objCred)

# Скачивание файла

Get-SCPFile -LocalFile "d:\test.sh" -RemoteFile "/home/olimex/test.sh" -ComputerName $HostName -Credential (Get-Credential $objCred)



#------------------
New-SFTPSession -ComputerName $HostName -Credential (Get-Credential $objCred)

Get-SFTPFile -SessionId 0 -RemoteFile /home/olimex/test.sh -LocalPath "d:\" -Overwrite