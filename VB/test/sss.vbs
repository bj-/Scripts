Option Explicit
Dim objShell, intCount
Set objShell = CreateObject("WScript.Shell")
'objShell.AppActivate('Calculator')
Wscript.Sleep 3000
intCount = 0

Do While intCount < 500
objShell.SendKeys "+{F10}"
objShell.SendKeys "{DOWN}"
objShell.SendKeys "{ENTER}"
objShell.SendKeys "^A"
objShell.SendKeys "^C"
objShell.SendKeys "{TAB}"
objShell.SendKeys "{ENTER}"
objShell.SendKeys "{DOWN}"
Wscript.Sleep 100
intCount = intCount + 1
Loop