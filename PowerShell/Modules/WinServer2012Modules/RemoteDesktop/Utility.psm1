Import-LocalizedData -BindingVariable _script_resource -filename Resources.psd1
$_dll_resource = New-Object System.Resources.ResourceManager Microsoft.RemoteDesktopServices.Management.Activities.RDManagementResources

function Get-BoundParameter {

[CmdletBinding(DefaultParametersetName="NoMap")]
param (

    [Parameter(Mandatory=$true, Position=0)]
    [object]
    $BoundParameters,
    
    [Parameter(Mandatory=$true, Position=1, ParameterSetName="NoMap")]
    [String[]]
    $ParameterName,
    
    [Parameter(Mandatory=$true, Position=1, ParameterSetName="Map")]
    [Hashtable]
    $ParameterMap
)

    $params = @{}
    
    switch ($PsCmdlet.ParameterSetName)
    {
        "NoMap"     {
                        $ParameterName | ?{$BoundParameters.ContainsKey($_)} | %{$params[$_] = $BoundParameters[$_]}
                        break
                    }
        "Map"     {
                        $ParameterMap.Keys | ?{$BoundParameters.ContainsKey($_)} | %{$params[$ParameterMap[$_]] = $BoundParameters[$_]}
                        break
                    }
    }
    
    return $params
}

function Get-ResourceString {

param (

    [Parameter(Mandatory=$true)]
    [string]
    $Id,
    
    [Parameter(Mandatory=$false)]
    [object[]]
    $Parameter
)

    $resourceString = $null

    if ($_script_resource[$Id])
    {
        $resourceString = $_script_resource[$Id]
    }
    else
    {
        $resourceString = $_dll_resource.GetString($Id)
    }

    $resourceString -f $Parameter
}

function Test-RDManagementServer {

param (

    [Parameter(Mandatory=$true)]
    [string]
    $RDManagementServer,

    [Parameter(Mandatory=$false)]
    [System.Management.Automation.PSCredential]
    $Credential
    
)
    $userContext = Get-BoundParameter $PSBoundParameters "Credential"
    
    $isRdms = Invoke-Command -ScriptBlock {(Get-Service RDMS -ErrorAction SilentlyContinue) -ne $null} `
                                 -ComputerName $RDManagementServer `
                                 -ErrorAction SilentlyContinue `
                                 @userContext

    if (-not $isRdms)
    {
        Write-Debug (Get-ResourceString RdmsRoleNotInstalled $RDManagementServer)
        return $false
    }
    
    $notRunningServices = Invoke-Command -ScriptBlock {@(Get-Service -Name WinRM, 'MSSQL$MICROSOFT##WID', RDMS, TScPubRPC, WinMgmt | where Status -ne Running | foreach DisplayName) } `
                                            -ComputerName $RDManagementServer `
                                            @userContext
    
    if ($notRunningServices.Count -gt 0)
    {
        Write-Debug (Get-ResourceString RdmsServicesNotRunning ($notRunningServices -join ", "))
        return $false
    }
    
    $rdmsActiveStatus = Invoke-Command  -ScriptBlock {
                                            $wmic = [WMICLASS]"ROOT\cimv2\rdms:Win32_RDMSEnvironment"
                                            $activeServer = $wmic.GetActiveServer().ServerName
                                            
                                            $localServer = [System.Net.Dns]::GetHostEntry("localhost").HostName
                                            
                                            New-Object PSObject -Property @{Active = ($activeServer -eq $localServer); ActiveServer = $activeServer} } `
                                        -ComputerName $RDManagementServer `
                                        @userContext
                                        
    if (-not $RdmsActiveStatus.Active)
    {
        Write-Debug (Get-ResourceString RdmsServerIsNotActive $RdmsActiveStatus.ActiveServer)
        return $false
    }
    
    return $true
}

function Test-SessionDesktopDeployment {

param (

    [Parameter(Mandatory=$true)]
    [string]
    $RDManagementServer,

    [Parameter(Mandatory=$false)]
    [System.Management.Automation.PSCredential]
    $Credential,
    
    [switch]
    $IgnoreHealthCheck
)
    $userContext = Get-BoundParameter $PSBoundParameters "Credential"
    
    if ((-not $IgnoreHealthCheck) -and (-not (Test-RDManagementServer -RDManagementServer $RDManagementServer @userContext)))
    {
        return $false
    }
    
    $hasRdshServers = Invoke-Command  -ScriptBlock { @(Get-WmiObject -Namespace ROOT\cimv2\rdms -Class Win32_RDMSJoinedNode | where IsRdsh).Count -gt 0 } `
                                        -ComputerName $RDManagementServer `
                                        @userContext
                                        
    if (-not $hasRdshServers)
    {
        Write-Debug (Get-ResourceString SessionDeploymentDoesNotExist $RDManagementServer)
        return $false
    }
    
    return $true
}

function Test-VirtualDesktopDeployment {

param (

    [Parameter(Mandatory=$true)]
    [string]
    $RDManagementServer,

    [Parameter(Mandatory=$false)]
    [System.Management.Automation.PSCredential]
    $Credential,
    
    [switch]
    $IgnoreHealthCheck
        
)
    $userContext = Get-BoundParameter $PSBoundParameters "Credential"
    
    if ((-not $IgnoreHealthCheck) -and (-not (Test-RDManagementServer -RDManagementServer $RDManagementServer @userContext)))
    {
        return $false
    }
    
    $hasRdvhServers = Invoke-Command  -ScriptBlock { @(Get-WmiObject -Namespace ROOT\cimv2\rdms -Class Win32_RDMSJoinedNode | where IsRdvh).Count -gt 0 } `
                                        -ComputerName $RDManagementServer `
                                        @userContext
                                        
    if (-not $hasRdvhServers)
    {
        Write-Debug (Get-ResourceString VirtualDeploymentDoesNotExist $RDManagementServer)
        return $false
    }
    
    return $true
}

function Test-RemoteDesktopDeployment {

param (

    [Parameter(Mandatory=$true)]
    [string]
    $RDManagementServer,

    [Parameter(Mandatory=$false)]
    [System.Management.Automation.PSCredential]
    $Credential,
    
    [switch]
    $IgnoreHealthCheck
        
)

    $params = Get-BoundParameter $PSBoundParameters "Credential", "Force"    
    
    if ((-not $IgnoreHealthCheck) -and (-not (Test-RDManagementServer -RDManagementServer $RDManagementServer @params)))
    {
        return $false
    }
    
    if(-not (Confirm-ValidHostname($RDManagementServer)))
    {
        return $false
    }

    $deploymentExists = (Test-VirtualDesktopDeployment -ErrorAction SilentlyContinue -IgnoreHealthCheck -RDManagementServer $RDManagementServer @params) -or `
                        (Test-SessionDesktopDeployment -ErrorAction SilentlyContinue -IgnoreHealthCheck -RDManagementServer $RDManagementServer @params)
                        
    if(-not $deploymentExists)
    {
        Write-Debug (Get-ResourceString DeploymentDoesNotExist $RDManagementServer)
        return $false
    }
    
    return $true
}

function Test-Fqdn {

param (

    [Parameter(Mandatory=$true)]
    [string]
    $Fqdn
    
)

    $uri = New-Object System.Uri "http://$Fqdn"
    if ($uri.IsAbsoluteUri)
    {
        $uriHost = $uri.Host
        if (($uriHost -eq $Fqdn) -and  $Fqdn.Contains('.') -and (-not $Fqdn.EndsWith('.')) -and ($Fqdn.Length -lt 255))
        {
            return $true
        }
    }
    
    Write-Debug (Get-ResourceString InvalidFqdn $Fqdn)
    return $false
}

function Initialize-Fqdn {

param (

    [Parameter(Mandatory=$false)]
    [string]
    $Fqdn
    
)
    if ((-not $PSBoundParameters["Fqdn"]) -or ([string]::IsNullOrEmpty($Fqdn)))
    {
        return [System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName()).HostName
    }
    else
    {
        if (Test-Fqdn($Fqdn))
        {
            return $Fqdn
        }
        else
        {
            return $null
        }
    }
}

function Test-FilePath {

param (

    [Parameter(Mandatory=$true)]
    [string]
    $Path,
    
    [switch]
    $Parent,

    [Parameter(Mandatory=$false)]
    [System.Management.Automation.PSCredential]
    $Credential
    
)

    $userContext = Get-BoundParameter $PSBoundParameters "Credential"
    
    if ($Parent)
    {
        $parentDirectory = Split-Path $Path
        if (-not $parentDirectory) { $parentDirectory = "." }
        if (Test-Path -Path $parentDirectory -ErrorAction SilentlyContinue @userContext)
        {
            return $true
        }
    }
    else
    {
        if (Test-Path -Path $Path -ErrorAction SilentlyContinue @userContext)
        {
            return $true
        }
    }
    
    Write-Debug (Get-ResourceString InvalidPath $Path)
    return $false
}

function Get-CollectionAlias {

param(
    [Parameter(Mandatory=$true)]
    [string]
    $CollectionName,

    [Parameter(Mandatory=$true)]
    [string]
    $RDManagementServer

)
 
    $existingIdList = New-Object System.Collections.Generic.List[string]

    #get list of all the collections and prepare an alias list
    try
    {
        $poolList = Get-WmiObject -Namespace root\cimv2\terminalservices -Class Win32_RDCentralPublishedFarm -ComputerName $RDManagementServer -ErrorAction Stop `
                    -Authentication PacketPrivacy -Impersonation Impersonate
    }
    catch
    {
        Write-Debug $_.Exception
        return $null
    }

    foreach($pool in $poolList)
    {
        $existingIdList.Add($pool.Alias)
    }

    #genrate ID and verify it is not used by an existing collection
    $id = Remove-InvalidCollectionChars($CollectionName)
    $tempId=$id
    for($i=0; $existingIdList.Contains($tempId); $i++)
    {
        $tempId=$id+$i
    }

    $id=$tempId
    Write-Debug ("Generated collection alias: " + $id)

    return $id
}

function Remove-InvalidCollectionChars($PoolName)
{
    $name = $PoolName.Trim()
    if($name.Length -gt 16)
    {
        $name=$name.SubString(0,16)
    }
    [string]$alias= ""
    $nameChars=$name.ToCharArray()
    foreach($char in $nameChars)
    {
        if( ( ($char -ge [char]'a') -and ([char]'z' -ge $char)) -or
             ( ($char -ge [char]'A') -and ([char]'Z' -ge $char)) -or
             ( ($char -ge [char]'0') -and ([char]'9' -ge $char)) -or
             ($char -eq [char]'-') -or ($char -eq [char]'_') -or ($char -eq [char]' '))
        {
            $alias+=$char.ToString()
        }
    }
    $alias=$alias.Trim()
    if([System.string]::IsNullOrEmpty($alias))
    {
        $alias="farm"
    }
    return ([string]($alias.Replace(' ','_')))
}

function ConvertTo-Sid
{
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $NtAccount,
    
    [Parameter(Mandatory=$false, ParameterSetName="Domain", Position=1)]
    [string]
    $NtDomain
)
    try
    {
        if ($PsCmdlet.ParameterSetName -eq "Domain")
        {
            $acc = new-object system.security.principal.NtAccount($NtDomain, $NtAccount)
        }
        else
        {
            $acc = new-object system.security.principal.NtAccount($NTaccount)
        }
    
        $acc.Translate([system.security.principal.securityidentifier])
    }
    catch
    {
        return $null
    }
}

function ConvertTo-NtAccount ([string]$sid) 
{
    (new-object system.security.principal.securityidentifier($sid)).translate([system.security.principal.ntaccount])
}

#verifies if a collection with same name already exists
function Confirm-CollectionNameDoesNotExist{

param(
    [Parameter(Mandatory=$true)]
    [string]
    $CollectionName,

    [Parameter(Mandatory=$true)]
    [string]
    $RDMgmtServer
)

    Write-Debug ("Validating Input Collection Name: " + $CollectionName)

    #validate that a VM collection with same name does not exist
    try
    {
        $coll = Get-WmiObject Win32_RDMSVirtualDesktopCollection -Namespace root\cimv2\Rdms -ComputerName $RDMgmtServer  -ErrorAction Stop `
         -Authentication PacketPrivacy -Impersonation Impersonate -Filter "Name='$CollectionName'"            
    }
    catch
    {
        Write-Debug $_.Exception
        return $false
    }

    if($null -ne $coll)
    {
        Write-Debug (Get-ResourceString RDVHCollectionAlreadyExist)
        return $false
    }

    #validate that a RDSH collection with same name does not exist
    try
    {
        $rdshColl = Get-WmiObject Win32_RDSHCollection -Namespace root\cimv2\Rdms -ComputerName $RDMgmtServer  -ErrorAction Stop `
         -Authentication PacketPrivacy -Impersonation Impersonate -Filter "Name='$CollectionName'"            
    }
    catch
    {
        Write-Debug $_.Exception
        return $false
    }

    if($null -ne $rdshColl)
    {
        Write-Debug (Get-ResourceString RDSHCollectionAlreadyExist)
        return $false
    }
    return $true
}

#verifies if the specified input is a valid host name
function Confirm-ValidHostname{

param(
    [Parameter(Mandatory=$true)]
    [string]
    $Hostname
)

    Write-Debug ("Validating Hostname: " + $Hostname)

    $uriType = [System.Uri]::CheckHostName($Hostname)

    if ($uriType -eq "Unknown")
    {
	    Write-Debug (Get-ResourceString InvalidHostname $Hostname)

        return $false
    }

    return $true
}

function Get-UserGroupsFromSecurityDescriptor{
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $SecurityDescriptor
)
    $userGroups = New-Object System.Collections.Generic.List[string]

    $parts = $SecurityDescriptor.Split(( '(', ')' ));

    foreach ($entry in $parts)
    {
        if ([System.String]::IsNullOrEmpty($entry))
        {
            continue;
        }

        $index = $entry.LastIndexOf(';');
        if ( 0 -gt $index )
        {
            #no ; found, try next
            continue;
        }

        $sid = $entry.Substring($index + 1);
        if ([System.String]::IsNullOrEmpty($sid))
        {
            #no SID found
            continue;
        }

        try
        {
            $groupName = ConvertTo-NtAccount($sid)
        }
        catch
        {
            Write-Warning (Get-ResourceString UnableToMapSid $sid, $_)
            $groupName = $sid
        }
        
        $userGroups.Add($groupName)
    }
    return $userGroups
}

# Returns $null upon error to convert
function Get-SecurityDescriptorFromUserGroup {

param (
    [Parameter(Mandatory=$true, Position=0)]
    [string[]]
    $UserGroups
)
    
    $sddl = "O:WDG:WDD:ARP"
    foreach($userGroup in $UserGroups)
    {
        $sid = ConvertTo-Sid($userGroup)
        if( $null -eq $sid )
        {
            Write-Debug (Get-ResourceString InvalidUserGroup $userGroup, $_)
            return $null
        }

        $sddl += "(A;CIOI;CCLCSWLORCGR;;;" + $sid.ToString() + ")"
    }

    return $sddl
}

function Get-CollectionAliasFromName {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionName,
    
    [Parameter(Mandatory=$true)]
    [String]
    $ConnectionBroker
)

    $res = Get-SessionCollectionAliasFromName @PSBoundParameters
    
    if($null -eq $res)
    {
        $res = Get-VMCollectionAliasFromName @PSBoundParameters
    }

    return $res
}

function Get-SessionCollectionFromName {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionName,
    
    [Parameter(Mandatory=$false)]
    [String]
    $ConnectionBroker
)

    $ConnectionBroker = Initialize-Fqdn($ConnectionBroker)
    if ($null -eq $ConnectionBroker)
    {
        return $null
    }
    
    try
    {
        $rdshColl = Get-WmiObject Win32_RDSHCollection -Namespace root\cimv2\Rdms -Filter "Name='$CollectionName'" `
                    -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
    }
    catch
    {
        Write-Debug (Get-ResourceString LookupCollectionWmiError $_)
    }

    return $rdshColl
}

function Get-SessionCollectionAliasFromName {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionName,
    
    [Parameter(Mandatory=$true)]
    [String]
    $ConnectionBroker
)

    $rdshColl = Get-SessionCollectionFromName $CollectionName $ConnectionBroker
    if($null -eq $rdshColl)
    {
        return $null
    }
    else
    {
        return $rdshColl.Alias
    }
}

function Get-VMCollectionAliasFromName {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionName,
    
    [Parameter(Mandatory=$true)]
    [String]
    $ConnectionBroker
)

    try
    {
        $vmColl = Get-WmiObject Win32_RDMSVirtualDesktopCollection -Namespace root\cimv2\Rdms -Filter "Name='$CollectionName'" `
                    -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
    }
    catch
    {
        Write-Debug (Get-ResourceString LookupCollectionWmiError $_)
        return $null
    }

    if($null -eq $vmColl)
    {
        return $null
    }
    else
    {
        return $vmColl.Alias
    }
}

function Get-CollectionNameFromAlias {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionAlias,
    
    [Parameter(Mandatory=$true)]
    [String]
    $ConnectionBroker
)

    $res = Get-SessionCollectionNameFromAlias @PSBoundParameters
    
    if($null -eq $res)
    {
        $res = Get-VMCollectionNameFromAlias @PSBoundParameters
    }

    return $res
}

function Get-SessionCollectionNameFromAlias {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionAlias,
    
    [Parameter(Mandatory=$true)]
    [String]
    $ConnectionBroker
)

    try
    {
        $rdshColl = Get-WmiObject Win32_RDSHCollection -Namespace root\cimv2\Rdms -Filter "Alias='$CollectionAlias'" `
                    -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
    }
    catch
    {
        Write-Debug (Get-ResourceString LookupCollectionWmiError $_)
        return $null
    }

    if($null -eq $rdshColl)
    {
        return $null
    }
    else
    {
        return $rdshColl.Name
    }
}

function Get-VMCollectionNameFromAlias {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionAlias,
    
    [Parameter(Mandatory=$true)]
    [String]
    $ConnectionBroker
)

    try
    {
        $vmColl = Get-WmiObject Win32_RDMSVirtualDesktopCollection -Namespace root\cimv2\Rdms -Filter "Alias='$CollectionAlias'" `
                    -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
    }
    catch
    {
        Write-Debug (Get-ResourceString LookupCollectionWmiError $_)
        return $null
    }

    if($null -eq $vmColl)
    {
        return $null
    }
    else
    {
        return $vmColl.Name
    }
}

function Open-RDVMFirewall {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $VMName,
    
    [Parameter(Mandatory=$true)]
    [String]
    $VMHostName
)
    # VMName and VMHostName should be validated by the caller

    try
    {
        $ret = Invoke-WmiMethod -Class "Win32_RDVHManagement" -namespace "root\cimv2\TerminalServices" `
                                -Name "RdvSetupVMPermissions" -ArgumentList @($VMName) `
                                -ComputerName $VMHostName -Authentication PacketPrivacy -Impersonation Impersonate `
                                -ErrorAction Stop
    }
    catch
    {
        Write-Debug (Get-ResourceString FirewallDisableFailedWmiError $VMName, $_)
        return $false
    }

    if ($ret.ReturnValue -ne 0)
    {
        Write-Debug (Get-ResourceString FirewallDisableFailedErrorCode $VMName, $ret.ReturnValue)
        return $false
    }
    
    return $true
}

function Close-RDVMFirewall {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $VMName,
    
    [Parameter(Mandatory=$true)]
    [String]
    $VMHostName
)
    # VMName and VMHostName should be validated by the caller

    try
    {
        $ret = Invoke-WmiMethod -Class "Win32_RDVHManagement" -namespace "root\cimv2\TerminalServices" `
                                -Name "RdvUndoVMPermissions" -ArgumentList @($VMName) `
                                -ComputerName $VMHostName -Authentication PacketPrivacy -Impersonation Impersonate `
                                -ErrorAction Stop
    }
    catch
    {
        Write-Debug (Get-ResourceString FirewallEnableFailedWmiError $VMName, $_)
        return $false
    }
                            
    if ($ret.ReturnValue -ne 0)
    {
        Write-Debug (Get-ResourceString FirewallEnableFailedErrorCode $VMName, $ret.ReturnValue)
        return $false
    }
                     
    return $true
}


#
# Returns string in distinguishedName format for the specified OU: OU=ITServices,DC=redmond,DC=corp,DC=microsoft,DC=com
# if the specified OrganizationalUnit is not a valid distinguishedName.
# If no orgunit is specified, it looks up default compouters container

function Get-DistinguishedName {
param (
    [Parameter(Mandatory=$true)]
    [string]
    $Domain,

    [Parameter(Mandatory=$false)]
    [String]
    $OrganizationalUnit
)

    try
    {
        # Check if the specified OU is already in distinguished name format.
        #   see if we can use a proper API
        $distinguishedNameFormat = (($OrganizationalUnit.ToLower().StartsWith("ou=")) -or `
                                    ($OrganizationalUnit.ToLower().StartsWith("cn=computers")) )

        $distinguishedName = $null

        if ($distinguishedNameFormat -eq $true)
        {
            Write-Debug "Validating OU already specified in distinguished name format."
            $ldapString = "LDAP://" + $organizationalUnit
            $distinguishedName = ([ADSI]$ldapString).distinguishedName
        }

        if ($distinguishedName -eq $null)
        {
        
            if( ([string]::IsNullOrEmpty($OrganizationalUnit)) -or 
                (0 -eq [string]::Compare($OrganizationalUnit,'computers',$true)) )
            {
                $filter = "(&(CN=computers))"
            }
            else
            {
                $filter = "(&(objectClass=organizationalUnit)(OU="+$OrganizationalUnit+"))"        
            }
            $ldapDomain = "LDAP://" + $Domain
            $directoryEntry = New-Object System.DirectoryServices.DirectoryEntry($ldapDomain)
            $ouSearch = New-Object System.DirectoryServices.DirectorySearcher($directoryEntry)
            $ouSearch.Filter = $filter
            $distinguishedName = $ouSearch.Findall() | %{([ADSI]($_.Path)).distinguishedName}
        }

        Write-Debug ("Distinguished Name: " + $distinguishedName)
    }
    catch
    {
        Write-Verbose $_.Exception.Message
    }
    return $distinguishedName
}

function Test-PathWritable {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $Path
)
    
    $writable = $true
    
    $filename = [System.IO.Path]::GetRandomFileName()
    
    try
    {
        $file = [System.IO.File]::Create([System.IO.Path]::Combine($Path, $filename), 1, [System.IO.FileOptions]::DeleteOnClose)
        $file.Close()
    }
    catch
    {
        $writable = $false
    }
    
    return $writable
}

function Test-PathNotInUse {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $Path,
    
    [Parameter(Mandatory=$true)]
    [String]
    $RDMgmtServer
)
    
    #validate that a VM collection with same path does not exist
    
    $vmCollections = Get-WmiObject Win32_RDMSVirtualDesktopCollection -Namespace root\cimv2\Rdms -ComputerName $RDMgmtServer -Authentication PacketPrivacy -ErrorAction SilentlyContinue

    if ($null -ne $vmCollections)
    {
        foreach ($coll in $vmCollections)
        {
            $vmFarmSettingsXml = [xml]$coll.VmFarmSettings
            $userVHDSettingXml = [xml]$coll.UserVHDSetting
            
            $isUserVHDEnabledXml = $vmFarmSettingsXml.SelectSingleNode("/Farm/Metadata[@Name='UvhdProfRoamingEnabled']")
            if ($isUserVHDEnabledXml -ne $null)
            {
                $isUserVHDEnabled = $isUserVHDEnabledXml.Attributes["Value"].ValueAsBoolean
            }
            
            if ($isUserVHDEnabled)
            {
                $userVHDShare = $vmFarmSettingsXml.SelectSingleNode("/Farm/Metadata[@Name='UvhdShareUrl']").Attributes["Value"].Value
                
                if ($userVHDShare -eq $Path)
                {
                    return $false
                }
            }

        }
    }
        
    #validate that a RDSH collection with same path does not exist
    
    $rdshCollections = Get-WmiObject Win32_RDSHCollection -Namespace root\cimv2\Rdms -ComputerName $RDMgmtServer -Authentication PacketPrivacy -ErrorAction SilentlyContinue

    if ($null -ne $rdshCollections)
    {
        foreach ($coll in $rdshCollections)
        {
            $isUserVHDEnabled = $coll.GetInt32Property("IsUserVHDEnabled").Value
            if ($isUserVHDEnabled -eq 1)
            {
                $userVHDShare = $coll.GetStringProperty("UserVHDShare").Value

                if ($userVHDShare -eq $Path)
                {
                    return $false
                }
            }
        }
    }
    
    return $true
}

function Get-RDManagementServerDomain{

param(
    [Parameter(Mandatory=$true)]
    [string]
    $HostName
)

    try
    {
        $compObject = Get-WmiObject Win32_ComputerSystem -ComputerName $HostName -ErrorAction Stop
    }
    catch 
    {
        Write-Debug (Get-ResourceString FailedToGetComputerObjectWmi $HostName,$_.Exception.Message)
        return $null
    }

    return ($compObject.Domain)
}


#This is an internal function to get the collection type
function Get-RDVirtualDesktopCollectionType
{
param(
    [Parameter(Mandatory=$true, Position=0)]
    [int]
    $BackEndCollectionType,

    [Parameter(Mandatory=$true, Position=1)]
    [int]
    $IsManaged,

    [Parameter(Mandatory=$true, Position=2)]
    [ref][int]
    $CollectionType,

    [Parameter(Mandatory=$true, Position=3)]
    [ref][int]
    $AutoAssignPersonalDesktop
)
    $AutoAssignPersonalDesktop.Value = $false
    $CollectionType.Value = 0

    if ($BackEndCollectionType -eq 1)
    {
        if ($IsManaged)
        {
            $CollectionType.Value = 1; #PooledManaged
        }
        else
        {
            $CollectionType.Value = 2; #PooledUnManaged
        }
    }
    elseif ($BackEndCollectionType -eq 2)
    {
        if ($IsManaged)
        {
            $CollectionType.Value = 3; #PersonalManaged
        }
        else
        {
            $CollectionType.Value = 4; #PersonalUnmanaged
        }
    }
    elseif ($BackEndCollectionType -eq 3)
    {
        if ($IsManaged)
        {
            $CollectionType.Value = 3; #PersonalManaged
        }
        else
        {
            $CollectionType.Value = 4; #PersonalUnmanaged
        }
        $AutoAssignPersonalDesktop.Value = $true
    }    
}

function Update-CollectionPropertiesToDefault {

param (
    [Parameter(Mandatory=$true)]
    [String]
    $CollectionName,
    
    [Parameter(Mandatory=$false)]
    [bool]
    $IsVMCollection,
    
    [Parameter(Mandatory=$true)]
    [String]
    $ConnectionBroker
)

    # Parameters are all validated in the caller

    if(!$PSBoundParameters.ContainsKey("IsVMCollection"))
    {
        $collectionAlias = Get-VMCollectionAliasFromName -ConnectionBroker $ConnectionBroker -CollectionName $CollectionName
        
        # Since $CollectionName has already been validated, no need to double-check that we can find the alias of a matching session collection
        $IsVMCollection = ($null -ne $collectionAlias)
    }

    $redirectionOptions = [Microsoft.RemoteDesktopServices.Management.RDClientDeviceRedirectionOptions]::AudioRecording -bOR `
                          [Microsoft.RemoteDesktopServices.Management.RDClientDeviceRedirectionOptions]::AudioVideoPlayback -bOR `
                          [Microsoft.RemoteDesktopServices.Management.RDClientDeviceRedirectionOptions]::SmartCard -bOR `
                          [Microsoft.RemoteDesktopServices.Management.RDClientDeviceRedirectionOptions]::PlugAndPlayDevice -bOR `
                          [Microsoft.RemoteDesktopServices.Management.RDClientDeviceRedirectionOptions]::Drive -bOR `
                          [Microsoft.RemoteDesktopServices.Management.RDClientDeviceRedirectionOptions]::Clipboard

    if($IsVMCollection)
    {
        Set-RDVirtualDesktopCollectionConfiguration -CollectionName $CollectionName `
                                                 -ClientDeviceRedirectionOptions $redirectionOptions `
                                                 -RedirectAllMonitors $true `
                                                 -RedirectClientPrinter $true `
                                                 -ConnectionBroker $ConnectionBroker
    }
    else
    {
        Set-RDSessionCollectionConfiguration -CollectionName $CollectionName `
                                          -ClientDeviceRedirectionOptions $redirectionOptions `
                                          -MaxRedirectedMonitors 16 `
                                          -ClientPrinterRedirected $true `
                                          -RDEasyPrintDriverEnabled $true `
                                          -ClientPrinterAsDefault $true `
                                          -ConnectionBroker $ConnectionBroker
    }
}

function Set-RemoteWebConfig {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $RemoteServer,
        
        [Parameter(Mandatory=$true)]
        [string]
        $workspaceName      
    )

    $results = Invoke-Command -ScriptBlock {
        param($workspaceName)
        try
        {
            $path = echo $env:windir\Web\RDWeb\Web.Config;
            $indentation = 4;        
            $xml = New-Object System.Xml.XmlDocument;
            $xml.Load($path);
            if ($xml.configuration.appSettings.SelectSingleNode("./add[@key=""WorkspaceName""]"))
            {
                $xml.configuration.appSettings.SelectSingleNode("./add[@key=""WorkspaceName""]").Attributes["value"].value = $workspaceName
            }
            else
            {
                $xml.configuration.appSettings.InnerXml += ("<add key=""WorkspaceName"" value=""$workspaceName"" />")
            }
            $encoding = [System.Text.Encoding].UTF8;
            $xmlWriter = New-Object System.Xml.XmlTextWriter $path, $encoding;
            $xmlWriter.Formatting = "indented";
            $xmlWriter.Indentation = $indentation;
            $XmlWriter.Flush();
            $xml.Save($xmlWriter);
            $xmlWriter.Close();
            $res = $true
        }
        catch
        {
            $res = $false
        }
        
        return $res
    }`
    -ComputerName $RemoteServer `
    -ArgumentList $workspaceName

    if (-not $results) {
        return $false
    } 
    return $true
}

function Test-LocalUser{
    $userDomain=[System.Environment]::UserDomainName
    $machineName=[System.Environment]::MachineName
    return !([bool]([String]::Compare($userDomain, $machineName, $true)))
}

# Throws an exception if it cannot contact the server
# Returns false if it can contact the server but cannot find the Web.config file
# Returns true otherwise
function Test-CanSetRemoteWebConfig {

param (
    [Parameter(Mandatory=$true)]
    [string]
    $RemoteServer
)

    $results = Invoke-Command -ScriptBlock {
        $path = echo $env:windir\Web\RDWeb\Web.Config;
        Test-Path -Path $path -PathType Leaf
    } `
    -ComputerName $RemoteServer `
    -ErrorAction Stop
    
    return $results
}

function Test-CollectionOnline {

param (
    [Parameter(Mandatory=$true)]
    [string]
    $CollectionName,
    
    [Parameter(Mandatory=$true)]
    [string]
    $CollectionAlias,
    
    [Parameter(Mandatory=$false)]
    [bool]
    $IsVmCollection,
    
    [Parameter(Mandatory=$true)]
    [string]
    $ConnectionBroker
)
    # All parameters are validated in caller
 
    if(!$PSBoundParameters.ContainsKey("IsVmCollection"))
    {
        $temp = Get-VMCollectionAliasFromName -ConnectionBroker $ConnectionBroker -CollectionName $CollectionName
        
        # Since $CollectionName has already been validated, no need to double-check that we can find the alias of a matching session collection
        $IsVMCollection = ($null -ne $temp)
    }
 
    if($IsVmCollection)
    {
        # Nothing to test, this can only go wrong with session collections
        return
    }

    # Get the list of session hosts in this collection
    try
    {
        $sessionHosts = Get-WmiObject Win32_RDSHServer -Namespace "root\cimv2\rdms" -Filter "CollectionAlias='$CollectionAlias'" `
                            -ComputerName $ConnectionBroker -Authentication PacketPrivacy -ErrorAction Stop
    }
    catch
    {
        throw (Get-ResourceString ErrorWmiSessionCollectionServer $_)
    }

    if ($null -eq $sessionHosts)
    {
        throw (Get-ResourceString NoSessionHostsFoundInCollectionError $CollectionName)
    }
    
    # Callers will catch the exception
    Test-RDSessionHostOnline -SessionHost $sessionHosts -CollectionName $CollectionName
}

function Test-RDSessionHostOnline {

param (
    [Parameter(Mandatory=$true)]
    [System.Management.ManagementObject[]]
    $SessionHost,

    [Parameter(Mandatory=$false)]
    [string]
    $CollectionName
)    
    $offlineSessionHosts = @()
    $misconfiguredSessionHosts = @()

    foreach ($rdsh in $SessionHost)
    {
        # Make a simple WMI query that should work to test if the RDSH server is accepting WMI calls...
        $testWmiClass = "Win32_TSSystemInfo"
        try
        {
            $res = Get-WmiObject -Class $testWmiClass -Namespace "root\cimv2\TerminalServices" `
                                 -ComputerName $rdsh.Name -Authentication PacketPrivacy -ErrorAction Stop
        }
        catch
        {
            # WMI Error - assume the RDSH is offline
            Write-Debug (Get-ResourceString ErrorRdshOffline $rdsh.Name, $_)
            $offlineSessionHosts += $rdsh.Name
            continue
        }
            
        if ($null -eq $res)
        {
            # If we cannot get an instance of that WMI class, something is seriously wrong with the session host
            Write-Debug (Get-ResourceString ErrorRdshMisconfigured $testWmiClass, $rdsh.Name)
            $misconfiguredSessionHosts += $rdsh.Name
            continue
        }
    }
    
    if (($offlineSessionHosts.Length -gt 0) -or ($misconfiguredSessionHosts.Length -gt 0))
    {
        if ($PSBoundParameters["CollectionName"])
        {
            throw (Get-ResourceString ErrorInvalidSessionHostsCollection $CollectionName, ([System.String]::Join(", ", $offlineSessionHosts)), ([System.String]::Join(", ", $misconfiguredSessionHosts)))
        }
        else
        {
            throw (Get-ResourceString ErrorInvalidSessionHosts ([System.String]::Join(", ", $offlineSessionHosts)), ([System.String]::Join(", ", $misconfiguredSessionHosts)))
        }
    }
}
