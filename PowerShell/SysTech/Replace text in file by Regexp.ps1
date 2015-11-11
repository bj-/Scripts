#
# Replace text in file by regexp
#
#  Version 1.0.1
#
param (
	[string]$FilePath = "D:\Shturman\Scripts\testScripts\21trains\TestScript_train01.scenario", 
	[string]$PathIn = "D:\Shturman\Scripts\testScripts\21trains\Original", 
	[string]$PathOut = "D:\Shturman\Scripts\testScripts\21trains\New", 
	[string]$Suffix = (Get-Date -Format "HH-mm-ss"),
	[string]$Timeout = "10000"

#	[string]$FilePrefix = "STB010-"
#	,
#	[string]$someone = $( Read-Host "Input password, please" )

)

# Settings
$Encoding = "default"




$arr = Get-ChildItem -Path $PathIn -Force -Include *.scenario -Name;

Foreach ($FileName in $arr) 
{
	$FullFilePath = $PathIn + "\" + $FileName;

	$OutputFile = $PathOut + "\" + $FileName;
#	$OutputFile =  $FilePath -replace '(\.scenario)', "_$suffix.scenario"

	# читаем файл и меняем в нем то что не надо на то что надо
	$Lines = Get-Content -Path $FullFilePath 

	Foreach ($line in $Lines)
	{
		$x =  $line -replace '(Timeout=\"[0-9]{4,})', 'Timeout="10000'
	#	write-host $x
		$x | Out-File $OutputFile -Encoding $Encoding -Append
	
	}

}




#$currTime = Get-Date -Format "HH-mm-ss"
#$OutputFile = "$FilePath - $suffix"

#Write-host $OutputFile;


#| Where-Object {$_ -match 'Timeout'}

# | ForEach-Object {$_ -replace '^\\\\ (\S+).+','$1'}