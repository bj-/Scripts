#
# Basic functions
# Version 1.0.0
#
#
#
# ������� � �������.
# [Services]
# Check-Service ($ServiceName)	������� �� ������	return True/False, write status into console

# [Secirity]
# isAdmin	�������� ������� ���������������� ����������	return True/False, write status into console and stop script when False

# =============================================================================================
# [Services]
# ������� �� ������
function Check-Service ()
{
	param (
		[string]$ServiceName = "",
		[switch]$verbose
	)
		
	$x = Get-Service -Name $ServiceName
	if ($x.Status -eq "Running")
	{
		If ($verbose) {	WriteLog "Service [$ServiceName] is started" "MESS"; };
		return $TRUE
	}
	Else 
	{
		If ($verbose) {	WriteLog "Service [$ServiceName] is NOT started" "WARN"; };
#		Write-Host "[$ServiceName] service is NOT started" "WARN"
		return $FALSE
	}
}

# [Secirity]
# �������� ������� ���������������� ����������
function isAdmin
{  
	$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()  
	$principal = new-object System.Security.Principal.WindowsPrincipal($identity)  
	$admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator  
#	$principal.IsInRole($admin)
	If ($principal.IsInRole($admin) -eq $FALSE) 
	{
		Write-Host "Required Administrative previlegies. Please Run script under administrator." -foregroundcolor "red"; 
		Start-Sleep -Seconds 2; 
		break;
		#return $FALSE;
	}
	Else
	{
		return $TRUE;
	}
} 
