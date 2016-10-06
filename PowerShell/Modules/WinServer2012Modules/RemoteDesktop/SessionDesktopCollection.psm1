
Import-Module $PSScriptRoot\Utility.psm1

# .ExternalHelp RemoteDesktop.psm1-help.xml
function Get-SessionHost {
[CmdletBinding(HelpURI="http://go.microsoft.com/fwlink/?LinkId=254082")]
param (

    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
    [string]
    $CollectionName,

    [Parameter(Mandatory=$false)]
    [string]
    $ConnectionBroker

)
    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ([string]::IsNullOrEmpty($ConnectionBroker))
    {
        Write-Error (Get-ResourceString InvalidFqdn $ConnectionBroker)
        return
    }

    if (-not (Test-RemoteDesktopDeployment -RDManagementServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString DeploymentDoesNotExist $ConnectionBroker)
        return
    }

    $rdshCollection = Get-SessionCollectionFromName $CollectionName $ConnectionBroker
    if ( $rdshCollection -eq $null )
    {
        Write-Error (Get-ResourceString RDSHCollectionNotFound $CollectionName)
        return
    }

    try
    {
        $wmiNamespace = "root\cimv2\rdms"
        $wmiRDSHServerQuery = "SELECT * FROM Win32_RDSHServer WHERE CollectionAlias='" + $rdshCollection.Alias + "'"
        $rdshServers = Get-WmiObject -Namespace $wmiNamespace -Query $wmiRDSHServerQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
    }
    catch
    {
        Write-Error (Get-ResourceString ErrorWmiSessionCollectionServer $_.Exception.Message)
    }

    if ( $rdshServers -eq $null )
    {
        return
    }

    foreach ($rdshServer in $rdshServers)
    {

        try
        {
            $res = $rdshServer.GetInt32Property("DrainMode")
        }
        catch
        {
            Write-Error (Get-ResourceString ErrorWmiDrainModeRDSessionHost $rdshServer.Name, $_.Exception.Message)
            continue
        }

        if ($null -ne $res -and 0 -ne $res.ReturnValue)
        {
            Write-Error (Get-ResourceString ErrorWmiDrainModeRDSessionHost $rdshServer.Name, $res.ReturnValue)
            continue
        }

        if ($null -ne $res -and 0 -eq $res.ReturnValue)
        {
            $NewConnectionAllowed = $res.Value -as [Microsoft.RemoteDesktopServices.Management.RDServerNewConnectionAllowed]
        }

        # Check RDSH too since RDMS may not be updated about NewConnectionAllowed, if it is NotUntilReboot.
        if ( $NewConnectionAllowed -eq [Microsoft.RemoteDesktopServices.Management.RDServerNewConnectionAllowed]::NotUntilReboot )
        {
            try
            {
                $wmiObj = Get-WmiObject -Class "Win32_TerminalServiceSetting" -Namespace "root\cimv2\TerminalServices" `
                                        -ComputerName $rdshServer.Name -Authentication PacketPrivacy -ErrorAction Stop

                $NewConnectionAllowed = $wmiObj.SessionBrokerDrainMode -as [Microsoft.RemoteDesktopServices.Management.RDServerNewConnectionAllowed]
            }
            catch
            {
                # WMI Error - assume the RDSH is offline 
                Write-Error (Get-ResourceString ErrorRdshOffline $rdshServer.Name, $_)
                continue
            }
        }

        New-Object Microsoft.RemoteDesktopServices.Management.RDServer `
           -ArgumentList $CollectionName, $rdshServer.Name, $NewConnectionAllowed
    }        
}

# .ExternalHelp RemoteDesktop.psm1-help.xml
function Set-SessionHost
{
[CmdletBinding(HelpURI="http://go.microsoft.com/fwlink/?LinkId=254083")]
param (

    [Parameter(Mandatory=$true, Position=0)]
    [string[]]
    $SessionHost,

    [Parameter(Mandatory=$true, Position=1)]
    [Microsoft.RemoteDesktopServices.Management.RDServerNewConnectionAllowed]
    $NewConnectionAllowed,

    [Parameter(Mandatory=$false)]
    [string]
    $ConnectionBroker

)
    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ([string]::IsNullOrEmpty($ConnectionBroker))
    {
        Write-Error (Get-ResourceString InvalidFqdn $ConnectionBroker)
        return
    }

    foreach ($rdshServerName in $SessionHost)
    {
        if(-not (Test-Fqdn($rdshServerName)))
        {
            Write-Error (Get-ResourceString InvalidFqdn $rdshServerName)
            return
        }
    }

    if (-not (Test-RemoteDesktopDeployment -RDManagementServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString DeploymentDoesNotExist $ConnectionBroker)
        return
    }

    $ValidSessionHostNames = New-Object System.Collections.Generic.List[string]
    $ValidSessionHost = New-Object System.Collections.Generic.List[System.Management.ManagementObject]
    $wmiNamespace = "root\cimv2\rdms"
    foreach ($rdshServerName in $SessionHost)
    {
        $rdshServer = $null
        try
        {
            $wmiRDSHServerQuery = "SELECT * FROM Win32_RDSHServer WHERE Name='" + $rdshServerName + "'"
            $rdshServer = Get-WmiObject -Namespace $wmiNamespace -Query $wmiRDSHServerQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
        }
        catch
        {
            Write-Error (Get-ResourceString ErrorWmiSessionCollectionServer $_.Exception.Message)
        }

        if ( $rdshServer -eq $null )
        {
            Write-Error (Get-ResourceString RDSHNotFound $rdshServerName)
        }
        else
        {
            $ValidSessionHostNames.Add($rdshServerName)
            $ValidSessionHost.Add($rdshServer)
        }
    }

    if ( $ValidSessionHostNames.Count -gt 0 )
    {
        # Make sure we can safely make changes on these servers
        try
        {
            Test-RDSessionHostOnline -SessionHost $ValidSessionHost
        }
        catch
        {
            Write-Error $_
            return
        }

        try
        {
            $workflowSession = New-PSSession -ConfigurationName Microsoft.Windows.ServerManagerWorkflows -EnableNetworkAccess

            Invoke-Command -Session $workflowSession -ArgumentList @($ConnectionBroker, $ValidSessionHostNames, $NewConnectionAllowed) `
            {
                param($ConnectionBroker, $SessionHost, $NewConnectionAllowed)
                RDManagement\Set-RDSHServerSetting -RDManagementServer $ConnectionBroker -Name $SessionHost -DrainMode $NewConnectionAllowed
            } | Out-Null
        }
        finally
        {   
            if($null -ne $workflowSession)
            {
                Remove-PSSession -Session $workflowSession
            }
        }
    }
}

# .ExternalHelp RemoteDesktop.psm1-help.xml
function Remove-SessionHost
{

[CmdletBinding(SupportsShouldProcess=$true,
HelpURI="http://go.microsoft.com/fwlink/?LinkId=254084")]
param (

    [Parameter(Mandatory=$true, Position=0)]
    [string[]]
    $SessionHost,

    [Parameter(Mandatory=$false)]
    [string]
    $ConnectionBroker,

    [Parameter(Mandatory=$false)]
    [switch]
    $Force

)
    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ([string]::IsNullOrEmpty($ConnectionBroker))
    {
        Write-Error (Get-ResourceString InvalidFqdn $ConnectionBroker)
        return
    }

    foreach ($rdshServerName in $SessionHost)
    {
        if(-not (Test-Fqdn($rdshServerName)))
        {
            Write-Error (Get-ResourceString InvalidFqdn $rdshServerName)
            return
        }
    }

    if (-not (Test-RemoteDesktopDeployment -RDManagementServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString DeploymentDoesNotExist $ConnectionBroker)
        return
    }

    $RemoveRDSessionCollectionServerCaption       =   (Get-ResourceString RemoveRDSessionCollectionServerCaption)
    $RemoveRDSessionCollectionServerMessage       =   (Get-ResourceString RemoveRDSessionCollectionServerMessage $CollectionName)
    $RemoveRDSessionCollectionServerMessageWhatif =   (Get-ResourceString RemoveRDSessionCollectionServerMessageWhatif $CollectionName)
 
    if( -not ($PSCmdlet.ShouldProcess($RemoveRDSessionCollectionServerMessageWhatif, $RemoveRDSessionCollectionServerMessage, $RemoveRDSessionCollectionServerCaption)) )
    {
        return
    }

    if( (-not $Force) -and (-not $PSCmdlet.ShouldContinue("", "")) )
    {
        return
    }

    $ValidSessionHost = New-Object System.Collections.Generic.List[string]
    $wmiNamespace = "root\cimv2\rdms"
    foreach ($rdshServerName in $SessionHost)
    {
        $rdshServer = $null
        try
        {
            $wmiRDSHServerQuery = "SELECT * FROM Win32_RDSHServer WHERE Name='" + $rdshServerName + "'"
            $rdshServer = Get-WmiObject -Namespace $wmiNamespace -Query $wmiRDSHServerQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
        }
        catch
        {
            Write-Error (Get-ResourceString ErrorWmiSessionCollectionServer $_.Exception.Message)
        }

        if ( $rdshServer -eq $null )
        {
            Write-Error (Get-ResourceString RDSHNotFound $rdshServerName)
        }
        else
        {
            $ValidSessionHost.Add($rdshServerName)
        }
    }

    if ( $ValidSessionHost.Count -gt 0 )
    {
        try
        {
            $workflowSession = New-PSSession -ConfigurationName Microsoft.Windows.ServerManagerWorkflows -EnableNetworkAccess

            Invoke-Command -Session $workflowSession -ArgumentList @($ConnectionBroker, $ValidSessionHost) `
            {
                param($ConnectionBroker, $SessionHost)
                RDManagement\Remove-RDSessionHost -RDManagementServer $ConnectionBroker -RDSHServer $SessionHost
            } | Out-Null
        }
        finally
        {   
            if($null -ne $workflowSession)
            {
                Remove-PSSession -Session $workflowSession -Confirm:$false
            }
        }
    }
}

# .ExternalHelp RemoteDesktop.psm1-help.xml
function Add-SessionHost 
{
[CmdletBinding(HelpURI="http://go.microsoft.com/fwlink/?LinkId=254085")]
param (

    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
    [string]
    $CollectionName,

    [Parameter(Mandatory=$true)]
    [string[]]
    $SessionHost,

    [Parameter(Mandatory=$false)]
    [string]
    $ConnectionBroker

)
    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ([string]::IsNullOrEmpty($ConnectionBroker))
    {
        Write-Error (Get-ResourceString InvalidFqdn $ConnectionBroker)
        return
    }

    foreach ($rdshServerName in $SessionHost)
    {
        if(-not (Test-Fqdn($rdshServerName)))
        {
            Write-Error (Get-ResourceString InvalidFqdn $rdshServerName)
            return
        }
    }

    if (-not (Test-RemoteDesktopDeployment -RDManagementServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString DeploymentDoesNotExist $ConnectionBroker)
        return
    }
    
    $rdshCollection = Get-SessionCollectionFromName $CollectionName $ConnectionBroker
    if ( $rdshCollection -eq $null )
    {
        Write-Error (Get-ResourceString RDSHCollectionNotFound $CollectionName)
        return
    }

    $ValidSessionHost = New-Object System.Collections.Generic.List[string]
    $wmiNamespace = "root\cimv2\rdms"
    foreach ($rdshServerName in $SessionHost)
    {
        $rdshServer = $null
        try
        {
            $wmiRDSHServerQuery = "SELECT * FROM Win32_RDSHServer WHERE Name='" + $rdshServerName + "'"
            $rdshServer = Get-WmiObject -Namespace $wmiNamespace -Query $wmiRDSHServerQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
        }
        catch
        {
            Write-Error (Get-ResourceString ErrorWmiSessionCollectionServer $_.Exception.Message)
        }

        if ( $rdshServer -eq $null )
        {
            Write-Error (Get-ResourceString RDSHNotFound $rdshServerName)
        }
        elseif (-not [string]::IsNullOrEmpty($rdshServer.CollectionAlias))
        {
            Write-Error (Get-ResourceString RDSHAlreadyExistInCollection $rdshServerName)
        }
        else
        {
            $ValidSessionHost.Add($rdshServerName)
        }
    }    

    if ( $ValidSessionHost.Count -gt 0 )
    {
        try
        {
            $workflowSession = New-PSSession -ConfigurationName Microsoft.Windows.ServerManagerWorkflows -EnableNetworkAccess

            Invoke-Command -Session $workflowSession -ArgumentList @($ConnectionBroker, $rdshCollection.Alias, $ValidSessionHost) `
            {
                param($ConnectionBroker, $CollectionAlias, $SessionHost)
                RDManagement\Add-RDSessionHost -RDManagementServer $ConnectionBroker -CollectionAlias $CollectionAlias -RDSHServer $SessionHost
            } | Out-Null
        }
        finally
        {   
            if($null -ne $workflowSession)
            {
                Remove-PSSession -Session $workflowSession -Confirm:$false
            }
        }
    }
}

# .ExternalHelp RemoteDesktop.psm1-help.xml
function Get-SessionCollection {
[CmdletBinding(HelpURI="http://go.microsoft.com/fwlink/?LinkId=254086")]
param (

    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true, Position=0)]
    [string]
    $CollectionName,

    [Parameter(Mandatory=$false)]
    [string]
    $ConnectionBroker

)
    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ([string]::IsNullOrEmpty($ConnectionBroker))
    {
        Write-Error (Get-ResourceString InvalidFqdn $ConnectionBroker)
        return
    }

    if (-not (Test-RemoteDesktopDeployment -RDManagementServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString DeploymentDoesNotExist $ConnectionBroker)
        return
    }

    try
    {
        $wmiNamespace = "root\cimv2\rdms"
        $wmiQuery = "SELECT * FROM Win32_RDSHCollection"
        if($CollectionName)
        {
            $wmiQuery = $wmiQuery + " WHERE Name='" + $CollectionName + "'"
        }
        $rdSessionCollections = Get-WmiObject -Namespace $wmiNamespace -Query $wmiQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
    }
    catch
    {
        Write-Error (Get-ResourceString ErrorWmiSessionCollectionServer $_.Exception.Message)
    }

    if ( $rdSessionCollections -eq $null )
    {
        if ($PSBoundParameters["CollectionName"])
        {
            Write-Error (Get-ResourceString RDSHCollectionNotFound $CollectionName)
        }
        return
    }

    $ResourceTypeUnknown = (Get-ResourceString ResourceTypeUnknown)
    $ResourceTypeRemoteApp = (Get-ResourceString ResourceTypeRemoteApp)
    $ResourceTypeRemoteDesktop = (Get-ResourceString ResourceTypeRemoteDesktop)

    foreach ($rdSessionCollection in $rdSessionCollections)
    {

        # default or error case value
        $rdSessionServerCount = 0
        $RdSessionResurceType = $ResourceTypeRemoteApp
        try
        {
            $wmiQuery = "SELECT * FROM Win32_RDSHServer WHERE CollectionAlias='" + $rdSessionCollection.Alias + "'"
            $rdSessionServerCount = [int]( ([array](Get-WmiObject -Namespace $wmiNamespace -Query $wmiQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop)).Count)
        }
        catch
        {
            Write-Warning (Get-ResourceString ErrorWmiSessionCollectionServer $_.Exception.Message)
        }

        try
        {
            $wmiRemoteAppQuery = "SELECT * FROM Win32_RDMSPublishedApplication WHERE PoolName='" + $rdSessionCollection.Alias + "'"
            $rdRemoteAppCount = [int]( ([array](Get-WmiObject -Namespace $wmiNamespace -Query $wmiRemoteAppQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop)).Count)
            if ( $rdRemoteAppCount -eq 0 )
            {
                $RdSessionResurceType = $ResourceTypeRemoteDesktop
            }
        }
        catch
        {
            Write-Warning (Get-ResourceString GetRemoteAppsWmiError $_.Exception.Message)
            $RdSessionResurceType = $ResourceTypeUnknown
        }

        New-Object Microsoft.RemoteDesktopServices.Management.RDSessionCollection `
            -ArgumentList $rdSessionCollection.Name, $rdSessionCollection.Alias, $rdSessionCollection.Description, $rdSessionServerCount, $RdSessionResurceType

    }
}

# .ExternalHelp RemoteDesktop.psm1-help.xml
function Remove-SessionCollection 
{

[CmdletBinding(SupportsShouldProcess=$true,
HelpURI="http://go.microsoft.com/fwlink/?LinkId=254087")]
param (

    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
    [string]
    $CollectionName,

    [Parameter(Mandatory=$false)]
    [string]
    $ConnectionBroker,

    [Parameter(Mandatory=$false)]
    [switch]
    $Force
)
    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ([string]::IsNullOrEmpty($ConnectionBroker))
    {
        Write-Error (Get-ResourceString InvalidFqdn $ConnectionBroker)
        return
    }

    if (-not (Test-RemoteDesktopDeployment -RDManagementServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString DeploymentDoesNotExist $ConnectionBroker)
        return
    }

    $rdSessionCollection = Get-SessionCollectionFromName $CollectionName $ConnectionBroker
    if ( $rdSessionCollection -eq $null )
    {
        Write-Error (Get-ResourceString RDSHCollectionNotFound $CollectionName)
        return
    }

    $CollectionAlias = $rdSessionCollection.Alias

    $RemoveRDSessionCollectionCaption       =   (Get-ResourceString RemoveRDSessionCollectionCaption)
    $RemoveRDSessionCollectionMessage       =   (Get-ResourceString RemoveRDSessionCollectionMessage $CollectionName)
    $RemoveRDSessionCollectionMessageWhatif =   (Get-ResourceString RemoveRDSessionCollectionMessageWhatif $CollectionName)

    if( -not ($PSCmdlet.ShouldProcess($RemoveRDSessionCollectionMessageWhatif, $RemoveRDSessionCollectionMessage, $RemoveRDSessionCollectionCaption)) )
    {
        return
    }

    if( (-not $Force) -and (-not $PSCmdlet.ShouldContinue("", "")) )
    {
        return
    }

    try
    {
        $workflowSession = New-PSSession -ConfigurationName Microsoft.Windows.ServerManagerWorkflows -EnableNetworkAccess

        Invoke-Command -Session $workflowSession -ArgumentList @($ConnectionBroker, $CollectionAlias) `
        {
            param($ConnectionBroker, $CollectionAlias)
            RDManagement\Remove-RDSHCollection -RDManagementServer $ConnectionBroker -CollectionAlias $CollectionAlias
        } | Out-Null
    }
    finally
    {   
        if($null -ne $workflowSession)
        {
            Remove-PSSession -Session $workflowSession -Confirm:$false
        }
    }

    $rdSessionCollection = Get-SessionCollectionFromName $CollectionName $ConnectionBroker
    if ( $rdSessionCollection -ne $null )
    {
        Write-Error (Get-ResourceString ErrorDeletingRDSHCollection $CollectionName)
        return
    }

}

# .ExternalHelp RemoteDesktop.psm1-help.xml
function New-SessionCollection 
{
[CmdletBinding(HelpURI="http://go.microsoft.com/fwlink/?LinkId=254088")]
param (

    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
    [string]
    $CollectionName,

    [Parameter(Mandatory=$false)]
    [string]
    $CollectionDescription,

    [Parameter(Mandatory=$true)]
    [string[]]
    $SessionHost,

    [Parameter(Mandatory=$false)]
    [string]
    $ConnectionBroker

)
    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ([string]::IsNullOrEmpty($ConnectionBroker))
    {
        Write-Error (Get-ResourceString InvalidFqdn $ConnectionBroker)
        return
    }

    foreach ($rdshServerName in $SessionHost)
    {
        if(-not (Test-Fqdn($rdshServerName)))
        {
            Write-Error (Get-ResourceString InvalidFqdn $rdshServerName)
            return
        }
    }

    # Validate Parameters
    $params = Get-BoundParameter $PSBoundParameters @{
                        "CollectionName" = "Name"
                        "CollectionDescription" = "Description"
                        "SessionHost" = "RDSHServer"
                        }
   
    $defUserGroup = ConvertTo-NtAccount([microsoft.remotedesktopservices.common.commonutility]::GetCurrentDomainUserSid())
    $params.Add('User',$defUsergroup)

    if (-not (Test-RemoteDesktopDeployment -RDManagementServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString DeploymentDoesNotExist $ConnectionBroker)
        return
    }

    if(-not (Confirm-CollectionNameDoesNotExist -CollectionName $CollectionName -RDMgmtServer $ConnectionBroker))
    {
        Write-Error (Get-ResourceString CannotDetermineCollectionExists)
        return
    }


    $wmiNamespace = "root\cimv2\rdms"
    foreach ($rdshServerName in $SessionHost)
    {
        $rdshServer = $null
        try
        {
            $wmiQuery = "SELECT * FROM Win32_RDSHServer WHERE Name='" + $rdshServerName + "'"; 
            $rdshServer = Get-WmiObject -Namespace $wmiNamespace -Query $wmiQuery -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
        }
        catch
        {
            Write-Error (Get-ResourceString ErrorWmiSessionCollectionServer $_.Exception.Message)
        }

        if ( $rdshServer -eq $null )
        {
            Write-Error (Get-ResourceString RDSHNotFound $rdshServerName)
            return
        }

        if ( $rdshServer.CollectionAlias -ne $null -and $rdshServer.CollectionAlias -ne "" )
        {
            Write-Error (Get-ResourceString RDSHAlreadyExistInCollection $rdshServerName)
            return
        }
    }

    $CollectionAlias = Get-CollectionAlias -CollectionName $CollectionName -RDManagementServer $ConnectionBroker
    if([string]::IsNullOrEmpty($CollectionAlias))
    {
        Write-Error (Get-ResourceString CannotCreateCollectionAlias)
        return
    }

    try
    {
        $workflowSession = New-PSSession -ConfigurationName Microsoft.Windows.ServerManagerWorkflows -EnableNetworkAccess

        Invoke-Command -Session $workflowSession -ArgumentList @($ConnectionBroker, $CollectionAlias, $params) `
        {
            param($ConnectionBroker, $CollectionAlias, $params)
            RDManagement\New-RDSHCollection -RDManagementServer $ConnectionBroker -CollectionAlias $CollectionAlias @params
        } | Out-Null
    }
    finally
    {   
        if($null -ne $workflowSession)
        {
            Remove-PSSession -Session $workflowSession
        }
    }

    $rdSessionCollection = Get-SessionCollectionFromName $CollectionName $ConnectionBroker
    if ( $rdSessionCollection -eq $null )
    {
        Write-Error (Get-ResourceString ErrorCreatingRDSHCollection)
        return
    }

    $ResourceTypeRemoteDesktop = (Get-ResourceString ResourceTypeRemoteDesktop)

    New-Object Microsoft.RemoteDesktopServices.Management.RDSessionCollection `
        -ArgumentList $rdSessionCollection.Name, $rdSessionCollection.Alias, $rdSessionCollection.Description, $SessionHost.Count, $ResourceTypeRemoteDesktop

}
