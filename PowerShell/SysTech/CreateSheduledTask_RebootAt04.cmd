cd C:\Shturman\PSS\Systech
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe  ".\CreateSheduledTask.ps1 -Name 'Reboot PC' -Description 'Automaticaly reboot every 1 day at 4 Am' -Execute 'shutdown.exe' -Argument '/r /t 0' -Time '04:00:00' -ReCreateIfExist -Interval 'day:1'"