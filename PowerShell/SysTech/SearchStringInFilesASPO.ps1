
#
# Поиск заданной строки в файлах
# 
#


param (
	[string]$Path = "D:\ASPO\",
	[string]$FileFilter = "*.log",
	[string]$HID = 'STH00-183',
	[switch]$CountOnly = $TRUE
	#,
	#[string]$someone = $( Read-Host "Input password, please" )
)

# Script Version
$scriptver = "1.0.1";



clear;

write-host "Гартитура	Замечена	Медосмотров_записано"


function search_str_in_files()
{

param (
	[string]$HID = 'STH00-183',
	[switch]$CountOnly = $TRUE
)


$arr = Get-ChildItem -Path $Path -Force -Recurse -Include $FileFilter -Name; # рекурсивно список всех файлов в каталоге и подкаталогах

$Lines = "";

$HitsCount1 = 0;
$HitsCount2 = 0;

$LookFor = 'Обнаружена новая гарнитура "'+$HID+'"';
$LookFor2 = 'Задача "Запись информации в датчик" для устройства '+$HID+' выполнена';



# Write-host "Look For [$LookFor]"

Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

	#write-host "File: $FullPath "

    $lines = Get-Content -Path $FullPath | where {$_ -match $LookFor};
    #write-host $lines.Count
    $HitsCount1 = $HitsCount1 + $lines.Count

    if ($CountOnly -eq $FALSE)
    {
	    Get-Content -Path $FullPath -Tail 1000 | where {$_ -match $LookFor}; # Выбираем строки датафрейм
    }


}

#Write-host "Look For [$LookFor]"



Foreach ($File in $arr) 
{
	$FullPath = $Path + $File;

#	write-host "File: $FullPath "

    $lines = Get-Content -Path $FullPath | where {$_ -match $LookFor2};
#    write-host $lines.Count
    $HitsCount2 = $HitsCount2 + $lines.Count

    if ($CountOnly -eq $FALSE)
    {
	    Get-Content -Path $FullPath -Tail 1000 | where {$_ -match $LookFor2}; # Выбираем строки датафрейм
    }


}

Write-host "$HID	$HitsCount1	$HitsCount2"
#Write-host "Total Hits Count for [$HID]: Замечена:   Записано ТО: "
#№Write-host "Look For [$LookFor]  : $HitsCount1"
#Write-host "Look For [$LookFor2] : $HitsCount2"
}


search_str_in_files -HID STH00-001
search_str_in_files -HID STH00-012
search_str_in_files -HID STH00-018
search_str_in_files -HID STH00-021
search_str_in_files -HID STH00-022
search_str_in_files -HID STH00-027
search_str_in_files -HID STH00-028
search_str_in_files -HID STH00-029
search_str_in_files -HID STH00-034
search_str_in_files -HID STH00-035
search_str_in_files -HID STH00-039
search_str_in_files -HID STH00-041
search_str_in_files -HID STH00-043
search_str_in_files -HID STH00-044
search_str_in_files -HID STH00-046
search_str_in_files -HID STH00-049
search_str_in_files -HID STH00-052
search_str_in_files -HID STH00-053
search_str_in_files -HID STH00-054
search_str_in_files -HID STH00-059
search_str_in_files -HID STH00-061
search_str_in_files -HID STH00-063
search_str_in_files -HID STH00-064
search_str_in_files -HID STH00-066
search_str_in_files -HID STH00-067
search_str_in_files -HID STH00-068
search_str_in_files -HID STH00-069
search_str_in_files -HID STH00-070
search_str_in_files -HID STH00-071
search_str_in_files -HID STH00-072
search_str_in_files -HID STH00-074
search_str_in_files -HID STH00-075
search_str_in_files -HID STH00-076
search_str_in_files -HID STH00-078
search_str_in_files -HID STH00-079
search_str_in_files -HID STH00-080
search_str_in_files -HID STH00-081
search_str_in_files -HID STH00-083
search_str_in_files -HID STH00-084
search_str_in_files -HID STH00-085
search_str_in_files -HID STH00-086
search_str_in_files -HID STH00-087
search_str_in_files -HID STH00-088
search_str_in_files -HID STH00-089
search_str_in_files -HID STH00-090
search_str_in_files -HID STH00-091
search_str_in_files -HID STH00-092
search_str_in_files -HID STH00-093
search_str_in_files -HID STH00-094
search_str_in_files -HID STH00-095
search_str_in_files -HID STH00-096
search_str_in_files -HID STH00-097
search_str_in_files -HID STH00-098
search_str_in_files -HID STH00-099
search_str_in_files -HID STH00-100
search_str_in_files -HID STH00-101
search_str_in_files -HID STH00-102
search_str_in_files -HID STH00-103
search_str_in_files -HID STH00-104
search_str_in_files -HID STH00-106
search_str_in_files -HID STH00-108
search_str_in_files -HID STH00-110
search_str_in_files -HID STH00-120
search_str_in_files -HID STH00-121
search_str_in_files -HID STH00-122
search_str_in_files -HID STH00-123
search_str_in_files -HID STH00-124
search_str_in_files -HID STH00-125
search_str_in_files -HID STH00-126
search_str_in_files -HID STH00-127
search_str_in_files -HID STH00-128
search_str_in_files -HID STH00-129
search_str_in_files -HID STH00-130
search_str_in_files -HID STH00-131
search_str_in_files -HID STH00-132
search_str_in_files -HID STH00-133
search_str_in_files -HID STH00-134
search_str_in_files -HID STH00-135
search_str_in_files -HID STH00-136
search_str_in_files -HID STH00-137
search_str_in_files -HID STH00-138
search_str_in_files -HID STH00-139
search_str_in_files -HID STH00-140
search_str_in_files -HID STH00-141
search_str_in_files -HID STH00-142
search_str_in_files -HID STH00-143
search_str_in_files -HID STH00-144
search_str_in_files -HID STH00-145
search_str_in_files -HID STH00-146
search_str_in_files -HID STH00-147
search_str_in_files -HID STH00-148
search_str_in_files -HID STH00-149
search_str_in_files -HID STH00-150
search_str_in_files -HID STH00-151
search_str_in_files -HID STH00-152
search_str_in_files -HID STH00-154
search_str_in_files -HID STH00-155
search_str_in_files -HID STH00-157
search_str_in_files -HID STH00-158
search_str_in_files -HID STH00-159
search_str_in_files -HID STH00-160
search_str_in_files -HID STH00-161
search_str_in_files -HID STH00-162
search_str_in_files -HID STH00-163
search_str_in_files -HID STH00-164
search_str_in_files -HID STH00-165
search_str_in_files -HID STH00-166
search_str_in_files -HID STH00-167
search_str_in_files -HID STH00-168
search_str_in_files -HID STH00-169
search_str_in_files -HID STH00-170
search_str_in_files -HID STH00-171
search_str_in_files -HID STH00-172
search_str_in_files -HID STH00-173
search_str_in_files -HID STH00-174
search_str_in_files -HID STH00-175
search_str_in_files -HID STH00-176
search_str_in_files -HID STH00-177
search_str_in_files -HID STH00-178
search_str_in_files -HID STH00-179
search_str_in_files -HID STH00-180
search_str_in_files -HID STH00-181
search_str_in_files -HID STH00-182
search_str_in_files -HID STH00-183
search_str_in_files -HID STH00-184
search_str_in_files -HID STH00-185
search_str_in_files -HID STH00-186
search_str_in_files -HID STH00-187
search_str_in_files -HID STH00-188
search_str_in_files -HID STH00-189
search_str_in_files -HID STH00-190
search_str_in_files -HID STH00-191
search_str_in_files -HID STH00-192
search_str_in_files -HID STH00-193
search_str_in_files -HID STH00-194
search_str_in_files -HID STH00-195
search_str_in_files -HID STH00-196
search_str_in_files -HID STH00-197
search_str_in_files -HID STH00-198
search_str_in_files -HID STH00-199
search_str_in_files -HID STH00-200
search_str_in_files -HID STH00-201
search_str_in_files -HID STH00-202
search_str_in_files -HID STH00-203
search_str_in_files -HID STH00-204
search_str_in_files -HID STH00-205
search_str_in_files -HID STH00-206
search_str_in_files -HID STH00-207
search_str_in_files -HID STH00-208
search_str_in_files -HID STH00-209
search_str_in_files -HID STH00-210
search_str_in_files -HID STH00-211
search_str_in_files -HID STH00-212
search_str_in_files -HID STH00-213
search_str_in_files -HID STH00-214
search_str_in_files -HID STH00-215
search_str_in_files -HID STH00-216
search_str_in_files -HID STH00-217
search_str_in_files -HID STH00-218
search_str_in_files -HID STH00-219
search_str_in_files -HID STH00-220
search_str_in_files -HID STH00-221
search_str_in_files -HID STH00-222
search_str_in_files -HID STH00-223
search_str_in_files -HID STH00-224
search_str_in_files -HID STH00-225
search_str_in_files -HID STH00-226
search_str_in_files -HID STH00-227
search_str_in_files -HID STH00-228
search_str_in_files -HID STH00-229
search_str_in_files -HID STH00-230
search_str_in_files -HID STH00-232
search_str_in_files -HID STH00-233
search_str_in_files -HID STH00-234
search_str_in_files -HID STH00-236
search_str_in_files -HID STH00-237
search_str_in_files -HID STH00-238
search_str_in_files -HID STH00-239
