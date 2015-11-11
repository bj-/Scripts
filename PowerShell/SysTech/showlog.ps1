#
# Show Log. Show log ShturmanHub Service
#
#  Version 1.0.04
#

# Settings
param (
	# ��������� ����
	[string]$FilePath = "Z:\",
	[string]$FilePrefix = "ROOT-",
	[string]$DateFormat = "yy-MM-dd",
	[int]$RowsInTail = 100, # ������� ����� � ����� ������ �� �����

	[string]$WelcomeStr = "File: "

	#[string]$someone = $( Read-Host "Input password, please" )

)

Clear;
#$FilePath = "Z:\";
#$MaxRow = 55;

$ExcludeFromLog = "ALIVE|������� �����|������� �����|�������� ������ ������";
#$ExcludeFromLog = "";


#Colorer (��������� ��������������)
$Red = "ERR:"
$Yellow = "WRN:"
$Green = "HELLO|WELCOME|CLOSE|������ �����������|������ �����������"
$DarkBlue = "ALIVE|�������� ������"

Clear;
write-host "$WelcomeStr $LogFile";

#$LastLine = "";
#$FirstRun = 1;
while (1) 
{
	$CurDate = Get-Date -format $DateFormat;
	$LogFile = $FilePath + $FilePrefix + $CurDate +".log";

	if (test-path -path $LogFile)
	{
		# ������ ����� ����� ��� $RowsInTail = ���-�� �������� ����� � �����
		$Lines = Get-Content -Path $LogFile -Tail $RowsInTail | where  { $_ -notmatch $ExcludeFromLog }

#		$NewLineIndex = 0;
#		if ($FirstRun -eq 1) 
#		{
#			$FirstRun = 0;
#			$NewLineIndex = 0;
#		}

		# ���� ���� ��� ������, �� ��������� ������ �������� � ���������� $LastLine, �� � ���� � ���������� ������� ����� �� �����
		# ���� �� ������ - ���������� ��� ��� ��������� �� �����
		if ($LastLine)
		{

			#Log Errors
#			$currTime = Get-Date -Format " HH-mm-ss"
#			"----- $CurDate - $currTime ------" | Out-File showlog.log -Encoding "default" -Append
#			$LastLine | Out-File .\showlog.log -Encoding "default" -Append
#			$Lines.Count | Out-File .\showlog.log -Encoding "default" -Append
			"---------------------------------" | Out-File showlog.log -Encoding "default" -Append

			# ������ ������ � ������� � ������� ���������� ����������, ���� ���������� ����� ����� ���� ������, � ������ ����������
			$aa = [array]::indexof($Lines,$LastLine)
			if ($aa -gt -1)
			{
				$i = ($aa+1); # +1 ���� �� �������� ��������� ������ ��� ��������������� �����
			}
			Else 
			{
				$i = 0;
				write-host "...`n`rSome Lines were missed`n`r..." -foregroundcolor "gray";
			}
		}
		else
		{
			$i = 0;
		}

		# ���������� ����� ������. + ��������� �����. �� ����� ��������� ������������ - � �����
		while ($Lines.Count -gt $i)
		{
			$line = $Lines[$i];
			if ($line  -match $Yellow)
			{
	                	write-host $line -foregroundcolor "yellow" 
			}
			elseif ($line  -match $Red)
			{
	                	write-host $line -foregroundcolor "red" 
			}
			elseif ($line  -match $Green)
			{
	                	write-host $line -foregroundcolor "green" 
			}
			elseif ($line  -match $DarkBlue)
			{
	                	write-host $line -foregroundcolor "darkblue" 
			}
			else 
			{
	                	write-host $line
			}
			
			# ��������� ���������� ������ ����������
			# ToDo ���� �� ������ ��� ���� ���, �� ����, � �� �� ������ ������.
			$LastLine = $Lines[$i];
			
			$i++;
		}			
	}
	else
	{
		# ���� ���� ��������� - ��������
		write-host "File ���������." -foregroundcolor "yellow"
	}

	# ��� ����� ������� ����������� �����. ����� ���� ��������
	Start-Sleep -Seconds 1; 
}