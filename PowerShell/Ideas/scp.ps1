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


# Parameters
param(  

    [object] $objCred = $null,
    [string] $UserName = 'olimex',
    [string] $UserPass = 'olimex', 
    [array] $Servers = ("a","b","c"),
    #[System.Security.SecureString] $strPass = 'olimex', 

    #$Port = 22,
    #$KeyfilePath = "",
    #$Command = "echo '0:Hello World'",
    $AutoUpdateFingerprint = $TRUE
)


# Check if our module loaded properly
#if (Get-Module -ListAvailable -Name Posh-SSH) { <# do nothing #> }
#else { 
    # install the module automatically
#    iex (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")
#    if (-ne (Get-Module -ListAvailable -Name Posh-SSH)) { 
#        break; # Stop Script 
#    }
#}

function UloadFile ()
{
    # Закачка файла
    param(  
        [string] $FileSrc = "",
        [string] $PathTarget = "",
        [string] $HostName = "",
        [object] $objCred = $null,
        [switch] $AutoUpdateFingerprint = $FALSE
    )

    # Проверка входящих переменных

    # проверка существования адреса
    # TODO

    # Проверка наличия исходного файла
    # TODO

    # Путь, куда заливать, существует
    # TODO

    # Удаление существующего Fingerprint
    if ($AutoUpdateFingerprint)
    {
        Remove-SSHTrustedHost $HostName
    }
    
    # заливка
    ##Set-SCPFile -LocalFile "d:\b.b" -RemoteFile "/home/olimex/b.b" -ComputerName $HostName -Credential (Get-Credential $objCred)
    #Set-SCPFile -LocalFile "d:\b.b" -RemotePath "/home/olimex/" -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey $TRUE
    Set-SCPFile -LocalFile $FileSrc -RemotePath $PathTarget -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey $TRUE

    # провека целостности залитого файла
    # TODO

}


# Создаем объект с "правами" доступа
$strPass = ConvertTo-SecureString -String $UserPass -AsPlainText -Force
$objCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($UserName, $strPass)

$HostName = "172.16.30.142"


UloadFile -FileSrc "d:\b.b" -PathTarget "/home/olimex/" -HostName $HostName -objCred $objCred -AutoUpdateFingerprint


# Скачивание файла

# Get-SCPFile -LocalFile "d:\test.sh" -RemoteFile "/home/olimex/test.sh" -ComputerName $HostName -Credential (Get-Credential $objCred)
#Get-SCPFile -LocalFile "d:\test.sh" -RemoteFile "/home/olimex/test.sh" -ComputerName $HostName -Credential (Get-Credential $objCred)



#------------------
$Session = New-SFTPSession -ComputerName $HostName -Credential (Get-Credential $objCred) -AcceptKey

Get-SFTPFile -SessionId $Session.SessionId -RemoteFile /home/olimex/test.sh -LocalPath "d:\" -Overwrite

Remove-SFTPSession -SessionId $Session.SessionId


#Set-SCPFile -
 