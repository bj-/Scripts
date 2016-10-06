Add-Type -ReferencedAssemblies ([Microsoft.Management.Infrastructure.Ciminstance].Assembly.Location) -TypeDefinition @'
public class NetIPConfiguration
{
    public string ComputerName = null;

    public string InterfaceAlias = null;
    public int InterfaceIndex;
    public string InterfaceDescription = null;
    public Microsoft.Management.Infrastructure.CimInstance NetAdapter = null;

    public Microsoft.Management.Infrastructure.CimInstance NetIPv6Interface = null;
    public Microsoft.Management.Infrastructure.CimInstance NetIPv4Interface = null;

    public Microsoft.Management.Infrastructure.CimInstance NetProfile = null;
    public Microsoft.Management.Infrastructure.CimInstance[] AllIPAddresses = null;
    public Microsoft.Management.Infrastructure.CimInstance[] IPv6Address = null;
    public Microsoft.Management.Infrastructure.CimInstance[] IPv6TemporaryAddress = null;
    public Microsoft.Management.Infrastructure.CimInstance[] IPv6LinkLocalAddress = null;
    public Microsoft.Management.Infrastructure.CimInstance[] IPv4Address = null;

    public Microsoft.Management.Infrastructure.CimInstance[] IPv6DefaultGateway = null;
    public Microsoft.Management.Infrastructure.CimInstance[] IPv4DefaultGateway = null;

    public Microsoft.Management.Infrastructure.CimInstance[] DNSServer = null;

    public bool Detailed = false;
}
'@

# .Link
# http://go.microsoft.com/fwlink/?LinkId=253567
# .ExternalHelp NetIPConfiguration.psm1-help.xml
function Get-NetIPConfiguration
{
    [CmdletBinding(DefaultParametersetName="Alias" )]
    Param(
        [Parameter(ParameterSetName = "Alias", Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 0)] [Alias('ifAlias')] [string]$InterfaceAlias = "*",
        [Parameter(ParameterSetName = "Index", Mandatory = $true, ValueFromPipelineByPropertyName = $true)] [Alias('ifIndex')] [int]$InterfaceIndex = -1,
        [Parameter(ParameterSetName = "All", Mandatory = $true)] [switch]$All = $false,
        [Parameter(Mandatory = $false)] [switch]$Detailed = $false,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)] [Alias('PSComputerName','ComputerName')] [Microsoft.Management.Infrastructure.CimSession]$CimSession = $null
        )
    Process
    {
        #
        # Session defaults to localhost.
        #
        if($CimSession -eq $null)
        {
            $CimSession = New-CimSession
            $ComputerName = (Get-WmiObject win32_ComputerSystem).Name
        }
        else
        {
            $ComputerName = $CimSession.ComputerName
        }

        #
        # Include hidden interfaces if the user query is for a specific interface.
        #
        if(($InterfaceAlias -ne "*") -or ($InterfaceIndex -ne -1))
        {
            $All = $true
        }

        #
        # Retrieve NetAdapters matching the user query.
        #
        if($All)
        {
            if($InterfaceIndex -ne -1)
            {
                $Adapters = Get-NetAdapter -InterfaceIndex $InterfaceIndex -IncludeHidden -CimSession $CimSession
            }
            else
            {
                $Adapters = Get-NetAdapter -Name $InterfaceAlias -IncludeHidden -CimSession $CimSession
            }
        }
        else
        {
            $Adapters = Get-NetAdapter -CimSession $CimSession
        }

        #
        # Find the subset of NetAdapters that are bound to IP.
        #
        $IPBoundAdapters = @()

        foreach($Adapter in $Adapters)
        {
            $IPInterface = Get-NetIPInterface -InterfaceIndex $Adapter.InterfaceIndex -PolicyStore ActiveStore -CimSession $CimSession -ErrorAction SilentlyContinue
            if($IPInterface -ne $null)
            {
                $IPBoundAdapters += $Adapter
            }
        }

        #
        # Sort adapters in
        # descending Status order so that "Up" interfaces are displayed before "Disconnected",
        # ascending MediaType order so that physical interfaces are displayed before tunnels.
        #
        $Adapters = $IPBoundAdapters | Sort MediaType | Sort Status -Descending

        #
        # Create a NetIPConfiguration for each Adapter.
        #
        $Return = @()

        foreach($Adapter in $Adapters)
        {
            $IPConfig = New-Object NetIPConfiguration

            #
            # Escape wilcard characters in interface alias.
            #
            $IfAlias = [System.Management.Automation.WildcardPattern]::Escape($Adapter.Name)

            #
            # Get NetAdapter properties.
            #
            $IPConfig.ComputerName = $ComputerName
            $IPConfig.InterfaceAlias = $Adapter.Name
            $IPConfig.InterfaceIndex = $Adapter.InterfaceIndex
            $IPConfig.InterfaceDescription = $Adapter.InterfaceDescription
            $IPConfig.NetAdapter = $Adapter
            $IPConfig.NetProfile = Get-NetConnectionProfile -InterfaceAlias $IfAlias -CimSession $CimSession -ErrorAction SilentlyContinue
            $IPConfig.NetIPv6Interface = Get-NetIPInterface -InterfaceAlias $IfAlias -AddressFamily IPv6 -PolicyStore ActiveStore -CimSession $CimSession -ErrorAction SilentlyContinue
            $IPConfig.NetIPv4Interface = Get-NetIPInterface -InterfaceAlias $IfAlias -AddressFamily IPv4 -PolicyStore ActiveStore -CimSession $CimSession -ErrorAction SilentlyContinue
            $IPConfig.Detailed = $Detailed

            # Begin Verbose Section
            write-verbose "----------------------------------------"
            write-verbose "Interface $IfAlias"
            write-verbose "----------------------------------------"
            write-verbose "InterfaceAlias: Get-NetAdapter -Name '$IfAlias' -CimSession $ComputerName | select InterfaceAlias"
            write-verbose "InterfaceIndex: Get-NetAdapter -Name '$IfAlias' -CimSession $ComputerName | select InterfaceIndex"
            write-verbose "InterfaceDescription: Get-NetAdapter -Name '$IfAlias' -CimSession $ComputerName | select InterfaceDescription"
            write-verbose "NetProfile: Get-NetConnectionProfile -InterfaceAlias '$IfAlias' -CimSession $ComputerName"
            write-verbose "NetIPv6Interface: Get-NetIPInterface -InterfaceAlias '$IfAlias' -AddressFamily IPv6 -PolicyStore ActiveStore -CimSession $ComputerName"
            write-verbose "NetIPv4Interface: Get-NetIPInterface -InterfaceAlias '$IfAlias' -AddressFamily IPv4 -PolicyStore ActiveStore -CimSession $ComputerName"
            # End Verbose Section

            $IPv6Addresses = @()
            $IPv6LinkLocalAddresses = @()
            $IPv6TemporaryAddresses = @()

            #
            # Get IPv6 addresses.
            #
            $Addresses = Get-NetIPAddress -InterfaceAlias $IfAlias -AddressFamily IPv6 -PolicyStore ActiveStore -CimSession $CimSession -ErrorAction SilentlyContinue
            write-verbose "IPv6Address: Get-NetIPAddress -InterfaceAlias '$IfAlias' -AddressFamily IPv6 -PolicyStore ActiveStore -CimSession $ComputerName"

            foreach($Address in $Addresses)
            {
                if(($Address.PrefixOrigin -eq "RouterAdvertisement") -and ($Address.SuffixOrigin -eq "Random"))
                {
                    $IPv6TemporaryAddresses += $Address
                }
                elseif(($Address.PrefixOrigin -eq "WellKnown") -and ($Address.SuffixOrigin -eq "Link"))
                {
                    $IPv6LinkLocalAddresses += $Address
                }
                else
                {
                    $IPv6Addresses += $Address
                }
            }

            $IPConfig.IPv6Address = $IPv6Addresses
            $IPConfig.IPv6TemporaryAddress = $IPv6TemporaryAddresses
            $IPConfig.IPv6LinkLocalAddress = $IPv6LinkLocalAddresses

            #
            # Get IPv4 addresses.
            #
            $IPConfig.IPv4Address = Get-NetIPAddress -InterfaceAlias $IfAlias -AddressFamily IPv4 -PolicyStore ActiveStore -CimSession $CimSession -ErrorAction SilentlyContinue
            write-verbose "IPv4Address: Get-NetIPAddress -InterfaceAlias '$IfAlias' -AddressFamily IPv4 -PolicyStore ActiveStore -CimSession $ComputerName"

            $IPConfig.AllIPAddresses = $IPConfig.IPv4Address + $IPv6Addresses + $IPv6TemporaryAddresses + $IPv6LinkLocalAddresses

            #
            # Get default gateway.
            #
            $IPConfig.IPv6DefaultGateway = Get-NetRoute -DestinationPrefix "::/0" -InterfaceAlias $IfAlias -PolicyStore ActiveStore -CimSession $CimSession -ErrorAction SilentlyContinue
            $IPConfig.IPv4DefaultGateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -InterfaceAlias $IfAlias -PolicyStore ActiveStore -CimSession $CimSession -ErrorAction SilentlyContinue
            write-verbose "IPv6DefaultGateway: Get-NetRoute -DestinationPrefix '::/0' -InterfaceAlias '$IfAlias' -PolicyStore ActiveStore -CimSession $ComputerName | select NextHop"
            write-verbose "IPv4DefaultGateway: Get-NetRoute -DestinationPrefix '0.0.0.0/0' -InterfaceAlias '$IfAlias' -PolicyStore ActiveStore -CimSession $ComputerName | select NextHop"

            #
            # Get DNS servers.
            #
            $IPConfig.DNSServer = Get-DnsClientServerAddress -InterfaceAlias $IfAlias -CimSession $CimSession -ErrorAction SilentlyContinue | Sort AddressFamily -Descending
            write-verbose "DNSServer: Get-DnsClientServerAddress -InterfaceAlias '$IfAlias' -CimSession $ComputerName | select ServerAddresses"

            $Return += $IPConfig
        }

        return $Return
    }
}

New-Alias gip Get-NetIPConfiguration
Export-ModuleMember -Alias gip -Function Get-NetIPConfiguration
