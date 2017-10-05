<# 


[TODO]
- Подсчет чексумм и генерирование файла для проверки корректности закачки
  [Имя файла],[MD5 Hash],[Путь назначения]
- путь назначения берется из файла Dest.txt
  Файл в формате [имя файла],[Путь назначения]
- выполнение проверяющего скрипта
- запрос файла с результатами проверки
- заливка недостающих/битых файлов


#>

[object] $objCred = $null
[string] $strUser = 'olimex'
[System.Security.SecureString] $strPass = $NULL 
#[System.Security.SecureString] $strPass = '' 


$strPass = ConvertTo-SecureString -String "olimex" -AsPlainText -Force
$objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strPass)


$HostName = "172.16.30.152"



# Закачка файла

Set-SCPFile -LocalFile "d:\b.b" -RemoteFile "/home/olimex/b.b" -ComputerName $HostName -Credential (Get-Credential $objCred)

# Скачивание файла

Get-SCPFile -LocalFile "d:\test.sh" -RemoteFile "/home/olimex/test.sh" -ComputerName $HostName -Credential (Get-Credential $objCred)



#------------------
New-SFTPSession -ComputerName $HostName -Credential (Get-Credential $objCred)

Get-SFTPFile -SessionId 0 -RemoteFile /home/olimex/test.sh -LocalPath "d:\" -Overwrite


