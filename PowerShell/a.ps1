

switch ( $type.toLower() )
{
	"error"
	{			
		$global:errorcount++
		write-host $msg -ForegroundColor red			
	}
	"warning"
	{			
		$global:warningcount++
		write-host $msg -ForegroundColor yellow
	}
	"completed"
	{			
		write-host $msg -ForegroundColor green
	}
	"info"
	{			
		write-host $msg
	}			
	default 
	{ 
		write-host $msg
	}
}



 
Function Parse-MultilinedLog($logFile=${throw 'You must specify log file name'}, $value="^(.+?):(.*)$", $separator="^\-+$")
{
	get-content $logfile | foreach { #��� ������ ������ �� �����...
		#����������� switch ���������� �������� � ����������� �� ������������ �������� ��������
		switch -regex ($_) 
		{
			($separator) { #�����������
				$obj #������� ���������� ������
				$obj = new-object psobject #������ �����
			}
			($value) { #��������
				#��������� �������� � �������� � �������
				$obj | add-member -membertype noteproperty -name ($matches[1].trim()) -value ($matches[2].trim())
			}
		}
	}
}
