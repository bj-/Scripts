@ECHO OFF

for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%_%ldt:~8,2%%ldt:~10,2%
rem echo Local date is [%ldt%] > C:\BackUp\a.a

SET SVNRepositoryDir=C:\Repositories
SET BackUpDir=C:\BackUp

rem set SVNBackUpDir=SVN_%DATE:.=-%_%TIME:~0,2%%TIME:~3,2%
set SVNBackUpDir=SVN_%ldt%


cd %BackUpDir%
md %SVNBackUpDir%

cd %BackUpDir%\%SVNBackUpDir%
md conf

copy %SVNRepositoryDir%\*.conf %BackUpDir%\%SVNBackUpDir%\conf\*
copy %SVNRepositoryDir%\*.pid %BackUpDir%\%SVNBackUpDir%\conf\*
copy %SVNRepositoryDir%\htpasswd %BackUpDir%\%SVNBackUpDir%\conf\*

svnadmin dump %SVNRepositoryDir%\Clinique > %BackUpDir%\%SVNBackUpDir%\Clinique.dump
svnadmin dump %SVNRepositoryDir%\D7Components > %BackUpDir%\%SVNBackUpDir%\D7Components.dump
svnadmin dump %SVNRepositoryDir%\DelphiChromiumEmbedded.local > %BackUpDir%\%SVNBackUpDir%\DelphiChromiumEmbedded.Local.dump
svnadmin dump %SVNRepositoryDir%\Devicer > %BackUpDir%\%SVNBackUpDir%\Devicer.dump
svnadmin dump %SVNRepositoryDir%\Hardware > %BackUpDir%\%SVNBackUpDir%\Hardware.dump
svnadmin dump %SVNRepositoryDir%\Jcl > %BackUpDir%\%SVNBackUpDir%\Jcl.dump
svnadmin dump %SVNRepositoryDir%\Qt > %BackUpDir%\%SVNBackUpDir%\Qt.dump
svnadmin dump %SVNRepositoryDir%\Reports > %BackUpDir%\%SVNBackUpDir%\Reports.dump
svnadmin dump %SVNRepositoryDir%\Shturman.3 > %BackUpDir%\%SVNBackUpDir%\Shturman.3.dump
svnadmin dump %SVNRepositoryDir%\Shturman.Android > %BackUpDir%\%SVNBackUpDir%\Shturman.Android.dump
svnadmin dump %SVNRepositoryDir%\Shturman.Lazarus > %BackUpDir%\%SVNBackUpDir%\Shturman.Lazarus.dump
svnadmin dump %SVNRepositoryDir%\Shturman.Qt > %BackUpDir%\%SVNBackUpDir%\Shturman.Qt.dump
svnadmin dump %SVNRepositoryDir%\ShturmanXE6 > %BackUpDir%\%SVNBackUpDir%\ShturmanXE6.dump
svnadmin dump %SVNRepositoryDir%\SystemT > %BackUpDir%\%SVNBackUpDir%\SystemT.dump