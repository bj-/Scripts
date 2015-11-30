
# SQL модули
if(Test-Path "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS") { #Sql Server 2012
    Import-Module SqlPs -DisableNameChecking
    C: # Switch back from SqlServer
} else { #Sql Server 2008
    Add-PSSnapin SqlServerCmdletSnapin100 # here live Invoke-SqlCmd
}
