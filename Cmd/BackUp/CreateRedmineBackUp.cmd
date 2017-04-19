rem @ECHO OFF

set MySQLLogin=login
set MySQLPassword=password


for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%_%ldt:~8,2%%ldt:~10,2%
rem echo Local date is [%ldt%] > C:\BackUp\a.a

SET BackUpDir=C:\BackUp

SET RedmineFilesDir=C:\redmine\apps\redmine\htdocs\files
rem set RedmineBackUpDir=Redmine_%DATE:.=-%_%TIME:~0,2%%TIME:~3,2%
set RedmineBackUpDir=Redmine_%ldt%


cd %BackUpDir%
md %RedmineBackUpDir%

cd %BackUpDir%\%RedmineBackUpDir%
md Files

xcopy /E %RedmineFilesDir%\* %BackUpDir%\%RedmineBackUpDir%\Files\*

C:\Redmine\mysql\bin\mysqldump.exe -u %MySQLLogin% -p%password% bitnami_redmine > %BackUpDir%\%RedmineBackUpDir%\redmine_%ldt%.sql