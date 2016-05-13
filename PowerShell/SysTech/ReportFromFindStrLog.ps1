param (
	[string]$Path = "D:\Share\SomeLogs\",
	[string]$FileFilter = "*.txt"
)

# Script Version
$scriptver = "1.0.0";


$arr = Get-ChildItem -Path $Path -Force -Recurse -Include $FileFilter -Name; # рекурсивно список всех файлов в каталоге и подкаталогах

$Lines = "";

# в следующей строке будет находиться имя хоста выданное командой hostname
[bool]$NextLineIsHostname = $FALSE;

[string]$HostName = "";
[string]$SearchString = "";
[bool]$NewSearchString = $FALSE;

# массив в выходными данными
$myArray = @()


# Выбираем минимальную и максимальную дату из файлов
# сначала уводим даты в небывалые дали. т.е. сравнивает тупо не меньше/больше ли.
$MinDate = get-date ("2030-01-01");
$MaxDate = get-date ("1995-01-01");

# Пробегаемся по всем файлам в поисках всех дат.
Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	$Lines = Get-Content -Path $FullPath # | where {$_ -match $LookFor}; # Выбираем строки датафрейм

	Foreach ($line in $Lines) 
	{	
		# в строке с такми превиксом будет имя файла с результатом подсчета, а в имени файла - дата. ее и берем.
		if ($line.Contains("----------"))
		{
			# вычленяем дату
			$match = [regex]::Match($line,"((\d){2}-){2}(\d){2}")

			# добавляем 20 в начало, чтобы год был полностью указан и преобразовываем в дату
			$FileDate =  get-date ("20" + $match.Value)

			# сравнимаем то что нашли с минимумом и максимумом. если надо заменяем на то что нашли.
			# методом такого тыка и перебора всех возможных дат и подбираем реальные минимум и максимум.
			# TODO переделать на складывание в массив и потом выборку из массива минимума и максимума
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

# приводим к короткому варианту.
$MinDate = get-date($MinDate) -Format dd.MM.yyyy
$MaxDate = get-date($MaxDate) -Format dd.MM.yyyy
#write-host $MinDate
#write-host $MaxDate


# создаем шаблон таблички со всеми возможными датами т.к. резиновую таблицу создать не удалось. 
# (если в последующей строке есть колонки которых небыло в предыдущих - часть столбцов убъется)
$myObject = New-Object System.Object
$myObject | Add-Member -type NoteProperty -name Name -Value "BlockSerialNo" # имя блока
$myObject | Add-Member -type NoteProperty -name Type -Value "EventType" # строка по которой считали


# для каждой имеющейся даты создаем столбец
$dateCurrent = get-date($MinDate) # -Format dd.MM.yyyy

while ($dateCurrent -le (get-date($MaxDate)))
{
	$PropDate = get-date($dateCurrent) -Format dd.MM.yyyy
	$myObject | Add-Member -type NoteProperty -name $PropDate -Value "Events"
	$dateCurrent = $dateCurrent.AddDays(+1)
}

$myArray += $myObject # добавляем эту строку в массив. теперь есть шаблон таблицы. правда с левой строкой в начале.


# Теперь набиваем таблицу данными из файлов
Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	$Lines = Get-Content -Path $FullPath # | where {$_ -match $LookFor}; # Выбираем строки датафрейм

	$NewFile = $TRUE;

	Foreach ($line in $Lines) 
	{	
		# выдираем хоcтнейм из файла
		if ($NextLineIsHostname)
		{
			$HostName = $line
			$NextLineIsHostname = $FALSE; # сбрасываем флаг иначе перезапишет хостнейм мусором
		}
		if ($line.Contains("[Hostname]"))
		{
			# следующая строка будет с хостнеймом.
			$NextLineIsHostname = $TRUE;
		}

		# все что после этой строки, до следующей такой же - данные для одной строки таблицы.
		if ($line.Contains("SearchString="))
		{
			$SearchString = $line;
			$NewSearchString = $TRUE;

		}
		Else
		{
			# строки с названием файла и счетчиком строк найденных в файле.
			if ($line.Contains("----------"))
			{

				# опятьв ычленяем дату
				$match = [regex]::Match($line,"((\d){2}-){2}(\d){2}")

				# добавляем 20 в начало, чтобы год был полностью указан и преобразовываем в дату
				$FileDate =  get-date ("20" + $match.Value) -Format dd.MM.yyyy

				# выковыриваем значение счетчика
				$match = [regex]::Match($line," (\d){1,8}")

				if ($NewSearchString)
				{
					# если это новый файл (первый раз нашли строку с данными) то не закрываем пред строку таблицы
					if ($NewFile)
					{
						$NewFile = $FALSE;
					}
					else 
					{
						# а если не первое - то закрываем строку и добавляем в массив
						$myArray += $myObject
					}

					$NewSearchString = $FALSE;

					# создаем новую строчку
					$myObject = New-Object System.Object
					$myObject | Add-Member -type NoteProperty -name Name -Value $HostName
					$myObject | Add-Member -type NoteProperty -name Type -Value $SearchString
					# TODO выкусить из $SearchString текст "SearchString="
				}
				else 
				{
					# TODO значение надо затримить т.к. регэксп выдрал его с ведущим нулем
					$myObject | Add-Member -type NoteProperty -name $FileDate -Value $match.Value
				}
			}
		}
	}

        # в конце файла тоже собраем строку.
	$myArray += $myObject
		
}

#  Сохранение в файлы и показ на экран (на экране может часть колонок не поместиться и никак не будет показано что они скрыты. особеннсть PS
#  1. общий файл  (все события)
#  2. фильтр по типу события
# TODO Показываение и сохранение в отдельные файлы - выбрать типы сообщений и фильтровать автоматом. названия файлов = тексту типа с порезанными опасными символами
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
