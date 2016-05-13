param (
	[string]$Path = "D:\Share\SomeLogs\",
	[string]$FileFilter = "*.txt"
)

# Script Version
$scriptver = "1.0.0";


$arr = Get-ChildItem -Path $Path -Force -Recurse -Include $FileFilter -Name; # ���������� ������ ���� ������ � �������� � ������������

$Lines = "";

# � ��������� ������ ����� ���������� ��� ����� �������� �������� hostname
[bool]$NextLineIsHostname = $FALSE;

[string]$HostName = "";
[string]$SearchString = "";
[bool]$NewSearchString = $FALSE;

# ������ � ��������� �������
$myArray = @()


# �������� ����������� � ������������ ���� �� ������
# ������� ������ ���� � ��������� ����. �.�. ���������� ���� �� ������/������ ��.
$MinDate = get-date ("2030-01-01");
$MaxDate = get-date ("1995-01-01");

# ����������� �� ���� ������ � ������� ���� ���.
Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	$Lines = Get-Content -Path $FullPath # | where {$_ -match $LookFor}; # �������� ������ ���������

	Foreach ($line in $Lines) 
	{	
		# � ������ � ����� ��������� ����� ��� ����� � ����������� ��������, � � ����� ����� - ����. �� � �����.
		if ($line.Contains("----------"))
		{
			# ��������� ����
			$match = [regex]::Match($line,"((\d){2}-){2}(\d){2}")

			# ��������� 20 � ������, ����� ��� ��� ��������� ������ � ��������������� � ����
			$FileDate =  get-date ("20" + $match.Value)

			# ���������� �� ��� ����� � ��������� � ����������. ���� ���� �������� �� �� ��� �����.
			# ������� ������ ���� � �������� ���� ��������� ��� � ��������� �������� ������� � ��������.
			# TODO ���������� �� ����������� � ������ � ����� ������� �� ������� �������� � ���������
			if ($FileDate -lt $MinDate)
			{
				$MinDate = $FileDate
			}
			if ($FileDate -gt $MaxDate)
			{
				$MaxDate = $FileDate
			}
		}
	}
}

# �������� � ��������� ��������.
$MinDate = get-date($MinDate) -Format dd.MM.yyyy
$MaxDate = get-date($MaxDate) -Format dd.MM.yyyy
#write-host $MinDate
#write-host $MaxDate


# ������� ������ �������� �� ����� ���������� ������ �.�. ��������� ������� ������� �� �������. 
# (���� � ����������� ������ ���� ������� ������� ������ � ���������� - ����� �������� �������)
$myObject = New-Object System.Object
$myObject | Add-Member -type NoteProperty -name Name -Value "BlockSerialNo" # ��� �����
$myObject | Add-Member -type NoteProperty -name Type -Value "EventType" # ������ �� ������� �������


# ��� ������ ��������� ���� ������� �������
$dateCurrent = get-date($MinDate) # -Format dd.MM.yyyy

while ($dateCurrent -le (get-date($MaxDate)))
{
	$PropDate = get-date($dateCurrent) -Format dd.MM.yyyy
	$myObject | Add-Member -type NoteProperty -name $PropDate -Value "Events"
	$dateCurrent = $dateCurrent.AddDays(+1)
}

$myArray += $myObject # ��������� ��� ������ � ������. ������ ���� ������ �������. ������ � ����� ������� � ������.


# ������ �������� ������� ������� �� ������
Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	$Lines = Get-Content -Path $FullPath # | where {$_ -match $LookFor}; # �������� ������ ���������

	$NewFile = $TRUE;

	Foreach ($line in $Lines) 
	{	
		# �������� ��c����� �� �����
		if ($NextLineIsHostname)
		{
			$HostName = $line
			$NextLineIsHostname = $FALSE; # ���������� ���� ����� ����������� �������� �������
		}
		if ($line.Contains("[Hostname]"))
		{
			# ��������� ������ ����� � ����������.
			$NextLineIsHostname = $TRUE;
		}

		# ��� ��� ����� ���� ������, �� ��������� ����� �� - ������ ��� ����� ������ �������.
		if ($line.Contains("SearchString="))
		{
			$SearchString = $line;
			$NewSearchString = $TRUE;

		}
		Else
		{
			# ������ � ��������� ����� � ��������� ����� ��������� � �����.
			if ($line.Contains("----------"))
			{

				# ������ �������� ����
				$match = [regex]::Match($line,"((\d){2}-){2}(\d){2}")

				# ��������� 20 � ������, ����� ��� ��� ��������� ������ � ��������������� � ����
				$FileDate =  get-date ("20" + $match.Value) -Format dd.MM.yyyy

				# ������������ �������� ��������
				$match = [regex]::Match($line," (\d){1,8}")

				if ($NewSearchString)
				{
					# ���� ��� ����� ���� (������ ��� ����� ������ � �������) �� �� ��������� ���� ������ �������
					if ($NewFile)
					{
						$NewFile = $FALSE;
					}
					else 
					{
						# � ���� �� ������ - �� ��������� ������ � ��������� � ������
						$myArray += $myObject
					}

					$NewSearchString = $FALSE;

					# ������� ����� �������
					$myObject = New-Object System.Object
					$myObject | Add-Member -type NoteProperty -name Name -Value $HostName
					$myObject | Add-Member -type NoteProperty -name Type -Value $SearchString
					# TODO �������� �� $SearchString ����� "SearchString="
				}
				else 
				{
					# TODO �������� ���� ��������� �.�. ������� ������ ��� � ������� �����
					$myObject | Add-Member -type NoteProperty -name $FileDate -Value $match.Value
				}
			}
		}
	}

        # � ����� ����� ���� ������� ������.
	$myArray += $myObject
		
}

#  ���������� � ����� � ����� �� ����� (�� ������ ����� ����� ������� �� ����������� � ����� �� ����� �������� ��� ��� ������. ���������� PS
#  1. ����� ����  (��� �������)
#  2. ������ �� ���� �������
# TODO ������������ � ���������� � ��������� ����� - ������� ���� ��������� � ����������� ���������. �������� ������ = ������ ���� � ����������� �������� ���������
Write-Output $myArray | Where-Object {$_.Type -match 'PID'} | FT -Auto
Write-Output $myArray | Where-Object {$_.Type -match 'command R'} | FT -Auto
Write-Output $myArray | Where-Object {$_.Type -match 'Operation'} | FT -Auto
Write-Output $myArray | Where-Object {$_.Type -match 'IMEI'} | FT -Auto


Write-Output $myArray | Where-Object {$_.Type -match 'PID'} | export-csv BlockLog_MU-PID.csv
Write-Output $myArray | Where-Object {$_.Type -match 'command R'} | export-csv BlockLog_MU-CommR.csv
Write-Output $myArray | Where-Object {$_.Type -match 'Operation'} | export-csv BlockLog_Mod-OperEr.csv
Write-Output $myArray | Where-Object {$_.Type -match 'IMEI'} | export-csv BlockLog_IMEI.csv

Write-Output $myArray | export-csv BlockLog_FullReport.csv



# write-host $myArray -Type *PID*  | FT -Auto
