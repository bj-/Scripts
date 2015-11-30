
$arr = Get-Content D:\Shturman\Bin\Log\STB010-15-10-27.log -Tail 500 | where  {$_ -notmatch "ALIVE|������� �����|������� �����|�������� ������ ������"}

$Linescnt = $arr.Count;
$MaxRow = 25


if ($Linescnt -gt 0) # ���� ���������� ������ ������� ������ - ��������� � ����� ������� ���� ��� ����������
{
	if ( $MaxRow -gt $Linescnt ) { $iStartRow = 0; }
	else { $iStartRow = $Linescnt-$MaxRow; }
	
}
else
{
	$iStartRow = 0;
}


$Lines = @();
while ($iStartRow -lt $Linescnt)
{
	$Lines += $arr[$iStartRow];
#	write-host $arr[$iStartRow];
	$iStartRow++;
#	echo $i;
}

foreach ($line in $Lines)
{
	write-host $line;

}