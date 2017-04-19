@ECHO OFF

rem     Simple Example
rem     net share Shturman$=D:\Shturman /GRANT:metro\Shturman,FULL

SET ShareName=Shturman$
SET ShareFolderPatch=D:\Shturman
SET ShareUserName=metro\Shturman
SET SharePermissions=FULL

net share %ShareName%=%ShareFolderPatch% /GRANT:%ShareUserName%,%SharePermissions%