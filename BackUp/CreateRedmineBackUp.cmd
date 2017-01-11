@ECHO OFF

SET BackUpDir=d:\BackUp

SET RedmineFilesDir=D:\Redmine\files
rem set RedmineBackUpDir=Redmine_%DATE:.=-%_%TIME:~0,2%%TIME:~3,2%
set RedmineBackUpDir=Redmine_%DATE:~-4%-%DATE:~3,2%-%DATE:~,2%_%TIME:~0,2%%TIME:~3,2%


cd %BackUpDir%
md %RedmineBackUpDir%

cd %BackUpDir%\%RedmineBackUpDir%
md Files

xcopy /E %RedmineFilesDir%\* %BackUpDir%\%RedmineBackUpDir%\Files\*

D:\Redmine\mysql\bin\mysqldump.exe -u root -pPAssw0rd bitnami_redmine > %BackUpDir%\%RedmineBackUpDir%\redmine_2016-09-07.sql