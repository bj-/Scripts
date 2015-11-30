

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
	get-content $logfile | foreach { #для каждой строки из файла...
		#конструкция switch выбирающая действие в зависимости от соответствия элемента регекспу
		switch -regex ($_) 
		{
			($separator) { #разделитель
				$obj #выводим предыдущий объект
				$obj = new-object psobject #создаём новый
			}
			($value) { #параметр
				#добавляем параметр и значение к объекту
				$obj | add-member -membertype noteproperty -name ($matches[1].trim()) -value ($matches[2].trim())
			}
		}
	}
}
