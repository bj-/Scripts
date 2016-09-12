@ECHO OFF
set fname=Drivers_state_%DATE:.=-%_%TIME:~0,2%%TIME:~3,2%.csv
rem set fname=Drivers_state_2000-00-00_00-00.csv
set ColSseparator=";"
rem set ColSseparator="	"
del %fname%

SetLocal EnableDelayedExpansion
Call :FromNow -1


chcp 1251 >NUL
set ttl=���������� �� ��������� ��� �� %DATE% %TIME:~0,2%:%TIME:~3,2%
rem set ttl=���������� �� ��������� ��� �� %ddmmyyyy% 
rem chcp 866 >NUL
echo %ttl% >> %fname%
@echo. >> %fname%

echo Processing FATP
rem @echo. >> %fname%
sqlcmd.exe -S 188.155.188.199,14331 -d shturman -U sa -P DER_PAROL -s %ColSseparator% -W -f o:1251 -i "Time_stat_of_user_sensor.sql" >> %fname%
echo FATP Done


echo Processing TRU
rem @echo. >> %fname%
sqlcmd.exe -h-1 -S 188.155.188.199,14332 -d shturman -U sa -P DER_PAROL -s %ColSseparator% -W -f o:1251 -i "Time_stat_of_user_sensor.sql" >> %fname%
echo TRU Done







rem pause

:FromNow
 SetLocal
 Set yyyy=%DATE:~-4%& set /a mm=100%DATE:~3,2%%%100& set /a dd=100%DATE:~,2%%%100
 Set /A JD=%~1+dd-32075+1461*(yyyy+4800+(mm-14)/12)/4+367*(mm-2-(mm-14)/12*12)/12-3*((yyyy+4900+(mm-14)/12)/100)/4
 Set /A L=JD+68569,N=4*L/146097,L=L-(146097*N+3)/4,I=4000*(L+1)/1461001
 Set /A L=L-1461*I/4+31,J=80*L/2447,K=L-2447*J/80,L=J/11
 Set /A J=J+2-12*L,I=100*(N-49)+I+L
 Set /A yyyy=I,mm=100+J,dd=100+K

rem  Set yyyymmdd=%yyyy%%mm:~-2%%dd:~-2%
 EndLocal& Set ddmmyyyy=%dd:~-2%.%mm:~-2%.%yyyy%
Exit /B
