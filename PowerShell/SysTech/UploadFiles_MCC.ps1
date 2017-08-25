$UploadPath = "\\shturman\MCC$"
$SrcPath = "D:\Share\MCC_DB\"
$username = "SHTURMAN\Upload"
$pass = "Chi79Mai"


$Files = Get-ChildItem -Path $SrcPath -Force | % { $_.FullName }

net use /D $UploadPath
net use $UploadPath /u:$username $pass


"Start move"
foreach ($OneFile in $Files)
{
    Move-Item -Path $OneFile -Destination $UploadPath -Force # -Credential (Get-Credential $objCred)
}
"Copied"

Start-Sleep -Seconds 10

net use /D $UploadPath