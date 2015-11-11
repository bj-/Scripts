#
# Error Log monitor. looking for *.Error files in specified folder
# When file found - show message box Abort / nothing do / rename file to *.* Current time
#
#
param (
	[string]$ErrLogPath = "D:\Shturman\Bin\Errors"
	#,
	#[string]$someone = $( Read-Host "Input password, please" )
)

# Script Version
$scriptver = "1.0.2";

#$ErrLogPath = "D:\Shturman\Bin\Errors"

#echo $arr[0];
#echo $arr[1];

$a = new-object -comobject wscript.shell

# ������� �� ������ - ��� ������� ����������.
Clear;


function errFile ($FilePath, $b)
{
	# ��������� ������� ������ ������. 
	# ��������: ���� �������, ������ �� ������, ������������ ����� ���� � ���������� ������
	$currTime = Get-Date -Format "HH-mm-ss"
	$newName = "$FilePath $currTime.txt"

	switch ( $b )
	{
		"3"
		{	
			# ���� �������		
			write-host "Script was stopped by user" -ForegroundColor red
			Exit;
		}
		"4"
		{			
			write-host $msg -ForegroundColor yellow
		}
		"5"
		{	
			# ������������ ����� ���� (��������� ������� ����� � ���������) � ���������� ������
			Rename-Item -Path $FilePath -NewName $newName
			write-host "File $FilePath was renamed `r`n to $newName" -ForegroundColor yellow
			Start-Sleep -Seconds 3;
		}
		default 
		{ 
			write-host "� ����� ���� ��� ������ � ��. �� ����� �����."
		}
	}

}


while (1)
{
	$arr = Get-ChildItem -Path $ErrLogPath -Force -Recurse -Include *.Error -Name;

	echo "Service's Error Logs Sensor [version: $scriptver]`r`nMonitoring *.Error files in folder $ErrLogPath"

	$i = 0;

	Foreach ($errFile in $arr) 
	{
		$path = $ErrLogPath + "\" + $errFile;

#		Get-Content -Path $path -Tail 10
		Get-Content -Path $path;
		$b = $a.popup("Found Errors in " + $errFile,0,"Found Errors",2)
		errFile $path $b;
	}

	Start-Sleep -Seconds 3;
	Clear;

}
