<#
  
  This module contains the implementation of the Set-VpnProxyConfiguration cmdlet.
  This script PInvokes into the wininet.dll API InternetSetOption and sets the appropriate proxy settings.

#>
# .ExternalHelp SetVpnConnectionProxy.psm1-help.xml
function Set-VpnConnectionProxy
{

#region Parameter declarations
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
Param(
    #
    # Name of the VPN Connection Profile
    #
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
    [System.String]
    ${Name},
    #
    # Web-proxy server and port pair in colon (:) separated format
    #
    [Parameter()]
    [System.String]
    ${ProxyServer},
    #
    # Automatically detect proxy settings
    #
    [Parameter()]
    [System.Management.Automation.SwitchParameter]
    ${AutoDetect},
    #
    # Use automatic configuration script. Requires the address of the automatic config wpad script
    #
    [Parameter()]
    [System.String]
    ${AutoConfigurationScript},
    #
    # Address prefixes for the addresses for which the proxy needs to skipped
    #
    [Parameter()]
    [System.String[]]
    ${ExceptionPrefix},
    #
    # To bypass web-proxy for local (intranet) addresses
    #
    [Parameter()]
    [System.Management.Automation.SwitchParameter]
    ${BypassProxyForLocal}
    )
#endregion

    Begin {
    }

    Process {
        try {

            Write-Debug "Process block entered."

            [System.Int32]$Script:MaxOptions  = 0
            [System.IntPtr]$Script:Buffer     = [System.IntPtr]::Zero
            [System.Array]$Script:ProxyOptions = @()

            #
            # Verify if VPN connection $Name exists on the system
            # Searching in local user connections as well as global user connections
            #
            Write-Debug ("Verifying if connection " + ${Name} + " exists on the system")
            try {
                $vpnConn = Get-VpnConnection -Name ${Name} -ErrorAction SilentlyContinue
                if ($vpnConn -ne $null) {
                    Write-Debug ("Connection " + ${Name} + " is a local user connection.")
                }
                else {
                    #
                    # If output of the above cmdlet is null, the topmost error object should be the NTE from the cmdlet
                    # Trace the error message as a debug message and remove it from the Global:Error list
                    #
                    Write-Debug ("Connection " + ${Name} + " is not a local user connection. Error: " + $Global:Error[0].ToString())
                    $Global:Error.RemoveAt(0)
                    #
                    # Now search in the all-user phonebook
                    #
                    $vpnConn = Get-VpnConnection -Name ${Name} -AllUserConnection -ErrorAction SilentlyContinue
                    if ($vpnConn -ne $null) {
                        Write-Debug ("Connection " + ${Name} + " is a global user connection.")
                    }
                    else {
                        #
                        # If output of the above cmdlet is null, the topmost error object should be the NTE from the cmdlet
                        # Trace the error message as a debug message and remove it from the Global:Error list
                        #
                        Write-Debug ("Connection " + ${Name} + " is not a global user connection. Error: " + $Global:Error[0].ToString())
                        $Global:Error.RemoveAt(0)
                        ThrowTerminatingError ($_system_translations.Error_VpnConnection_NotFound -f ${Name}) $EC_InvalidArgument $EC_InvalidArgument ${Name}
                    }
                }
            }
            catch {
                ThrowTerminatingError ($_system_translations.Error_VpnConnection_NotFound -f ${Name}) $EC_InvalidArgument $EC_InvalidArgument ${Name}
            }    
            
            #
            # Verifying that BypassProxyForLocal and ExceptionPrefix parameters have not been provided
            # when ProxyServer has not been specified
            #
            if ([System.String]::IsNullOrEmpty(${ProxyServer})) {
                if ((${BypassProxyForLocal} -eq $true) -or ![System.String]::IsNullOrEmpty(${ExceptionPrefix})) {
                    if ((${AutoDetect} -eq $false) -and [System.String]::IsNullOrEmpty($AutoConfigurationScript)) {
                        #
                        # If AutoDetect and AutoConfigurationScript have not been specified, this is a TE condition
                        #
                        ThrowTerminatingError $_system_translations.Error_Incorrect_Parameter_Combination $EC_InvalidArgument $EC_InvalidArgument
                    }
                    else {
                        #
                        # If AutoDetect and/or AutoConfigurationScript have been specified, write a warning that the BypassProxyForLocal
                        # and ExceptionPrefix are not applicable 
                        #
                        Write-Warning $_system_translations.Warning_Incorrect_Parameter_Combination
                        ${BypassProxyForLocal} = $false
                        ${ExceptionPrefix} = $null
                    }
                }
            }            
            else {
                #
                # If port is not specified, 80 will be used by default by the API 
                #
                [System.UInt16]$Port = 0
                ValidateProxyString ${ProxyServer} ([ref]$Port)
                #
                # If port has been specified as 0 - exception will be thrown
                # If port has not been specified, the ValidateProxyString method will return $Port as 0
                #
                if ($Port -eq 0) {
                    Write-Warning $_system_translations.Warning_Proxy_Port_NotSpecified
                    ${ProxyServer} += ":80"
                }
            }    

            #
            # Constructing the semicolon-separated list of proxy exception
            # entries - WinInet API accepts it in semicolon-separated format
            #
            $ExceptionPrefixList = [System.String]::Empty
            foreach ($Exception in ${ExceptionPrefix}) {
                $ExceptionPrefixList += $Exception
                $ExceptionPrefixList += ";"
            }

            #
            # The trick for setting the 'Bypass proxy server for local addresses' check
            # is to add a <local> entry in the Proxy exception list
            #
            if (${BypassProxyForLocal}) {
                $ExceptionPrefixList += "<local>;"
            }

            #
            # Adding the types from the $code segment to the type library
            #
            Add-Type $code            

            #
            # Calling ShouldProcess now that validations are done
            #
            $shouldProcessStr = $_system_translations.ShouldProcess_Message -f ${Name}
            if (!$PSCmdlet.ShouldProcess($shouldProcessStr, $null, $null)) {
                $DebugStr = "ShouldProcess returned false - returning."
                Write-Debug $DebugStr
                return
            }
        
            $Script:MaxOptions = [PInvokeLibrary.SetVpnProxy]::NUM_INTERNET_OPTIONS_VPN
            [PInvokeLibrary.SetVpnProxy+INTERNET_PER_CONN_OPTION_LIST]$ProxyOptionList = New-Object PInvokeLibrary.SetVpnProxy+INTERNET_PER_CONN_OPTION_LIST
            
            #
            # Fill out the basic properties of the Proxy Option List
            #
            $ProxyOptionList.Connection = ${Name}
            $ProxyOptionList.OptionCount = $Script:MaxOptions
            $ProxyOptionList.OptionError = 0

            1 .. $Script:MaxOptions | % { 
                $Script:ProxyOptions += New-Object PInvokeLibrary.SetVpnProxy+INTERNET_PER_CONN_OPTION             
            }

            #
            # Set the flags for the required proxy settings
            #
            $Script:ProxyOptions[0].dwOption = [PInvokeLibrary.SetVpnProxy]::INTERNET_PER_CONN_FLAGS
            $tempUnion = New-Object PInvokeLibrary.SetVpnProxy+OptionUnion
            $tempUnion.dwValue = [PInvokeLibrary.SetVpnProxy]::PROXY_TYPE_DIRECT
            
            if (${AutoDetect}) {
                #
                # Corresponds to 'Automatically detect settings' checkbox
                #
                $tempUnion.dwValue = $tempUnion.dwValue -bor [PInvokeLibrary.SetVpnProxy]::PROXY_TYPE_AUTO_DETECT
            }

            if (![System.String]::IsNullOrEmpty(${ProxyServer})) {
                #
                # Corresponds to 'Use a proxy server for this connection' checkbox
                #
                $tempUnion.dwValue = $tempUnion.dwValue -bor [PInvokeLibrary.SetVpnProxy]::PROXY_TYPE_PROXY
            }

            if (![System.String]::IsNullOrEmpty(${AutoConfigurationScript})) {
                #
                # Corresponds to 'Use automatic configuration script' checkbox
                #
                $tempUnion.dwValue = $tempUnion.dwValue -bor [PInvokeLibrary.SetVpnProxy]::PROXY_TYPE_AUTO_PROXY_URL
            }
            $Script:ProxyOptions[0].Value = $tempUnion

            #
            # Set the name of the proxy server (proxyServer:port or proxyServer)
            #
            $Script:ProxyOptions[1].dwOption = [PInvokeLibrary.SetVpnProxy]::INTERNET_PER_CONN_PROXY_SERVER
            $tempUnion = New-Object PInvokeLibrary.SetVpnProxy+OptionUnion
            $tempUnion.pszValue = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni(${ProxyServer})
            $Script:ProxyOptions[1].Value = $tempUnion
            
            #
            # Set the proxy bypass options - destinations which should not use proxy server
            #
            $Script:ProxyOptions[2].dwOption = [PInvokeLibrary.SetVpnProxy]::INTERNET_PER_CONN_PROXY_BYPASS
            $tempUnion = New-Object PInvokeLibrary.SetVpnProxy+OptionUnion
            $tempUnion.pszValue = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($ExceptionPrefixList)
            $Script:ProxyOptions[2].Value = $tempUnion

            #
            # Set the auto configuration URL
            #
            $Script:ProxyOptions[3].dwOption = [PInvokeLibrary.SetVpnProxy]::INTERNET_PER_CONN_AUTOCONFIG_URL
            $tempUnion = New-Object PInvokeLibrary.SetVpnProxy+OptionUnion
            $tempUnion.pszValue = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni(${AutoConfigurationScript})
            $Script:ProxyOptions[3].Value = $tempUnion

            #
            # Calculating the total size of the proxy options for marshalling the data
            #
            $TotalSize = 0
            foreach ($option in $Script:ProxyOptions) {
                $TotalSize = $TotalSize + [System.Runtime.InteropServices.Marshal]::SizeOf($option)
            }

            $Script:Buffer = [System.Runtime.InteropServices.Marshal]::AllocCoTaskMem($TotalSize)
            [System.IntPtr]$Current = $Script:Buffer

            foreach ($option in $Script:ProxyOptions) {
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($option, $Current, $false)
                $Current = [System.IntPtr]::Add($Current, [System.Runtime.InteropServices.Marshal]::SizeOf($option))
            }

            $ProxyOptionList.pOptions = $Script:Buffer
            $ProxyOptionList.Size = [System.Runtime.InteropServices.Marshal]::SizeOf($ProxyOptionList)
            $Size = $ProxyOptionList.Size

            #
            # Invoking the InternetSetOption API from WinInet.dll
            #
            if (![PInvokeLibrary.SetVpnProxy]::InternetSetOptionList(0, [PInvokeLibrary.SetVpnProxy]::INTERNET_OPTION_PER_CONNECTION_OPTION, [ref]$ProxyOptionList, $Size)) {
                $ret = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error();
                Write-Debug ("InternetSetOption returned false, failed with Win32 error " + $ret.ToString())
                ThrowTerminatingError ($_system_translations.Error_Call_Failed -f ${Name}) $EC_NotSpecified $EC_NotSpecified ${Name}
            }
        }
        catch {
            $DebugStr = "Exception caught by Process section."
            Write-Debug $DebugStr
            throw
        }
        finally {
            #
            # Freeing the unmanaged resources allocated above
            #
            if ($Script:Buffer -ne [System.IntPtr]::Zero) {
                [System.Runtime.InteropServices.Marshal]::FreeCoTaskMem($Script:Buffer)
            }
            for ($i  = 1; $i -lt $Script:MaxOptions; $i++) {
                [System.Runtime.InteropServices.Marshal]::FreeHGlobal($Script:ProxyOptions[$i].Value.pszValue)
            }                
        }
    }

    End {
        $DebugStr = "Successfully set the proxy options for the VPN Connection " + $Name
        Write-Debug $DebugStr
    }
}

# 
# This is an utility method to throw a Terminating Error
#
function ThrowTerminatingError([System.String]$ErrorString, [System.String]$ErrorId, [System.Management.Automation.ErrorCategory]$ErrorCategory, [System.Object]$Target = $null)
{
    $Exception = New-Object System.Exception $ErrorString
    $Error = New-Object System.Management.Automation.ErrorRecord($Exception, $ErrorId, $ErrorCategory, $Target)
    $PSCmdlet.ThrowTerminatingError($Error)
}

#
# This is an utility method to validate the proxy server string
# This method should not propagate any exceptions - all TEs should be handled here
#
function ValidateProxyString([System.String]$Proxy, [ref][System.UInt16]$Port)
{
    $colonIndex = 0
    $bracketIndex = $Proxy.IndexOf('[')
    $closingBracketIndex = $Proxy.IndexOf(']')
    #
    # For IPv4/Host:Port form - bracketIndex and closingBracketIndex both should be -1
    # For [IPv6]:Port form - bracketIndex and closingBracketIndex both should be other than -1, bracketIndex should be less than closingBracketIndex
    #   and bracketIndex should be 0
    #
    if ((($bracketIndex -eq -1) -and ($closingBracketIndex -eq -1)) -or
        (($bracketIndex -ne -1) -and ($closingBracketIndex -ne -1) -and ($bracketIndex -lt $closingBracketIndex) -and ($bracketIndex -eq 0))) {

        if ($closingBracketIndex -ne -1) {
            #
            # This should be an IPv6 address
            #                  
            $tempProxy = $Proxy.Substring($closingBracketIndex)
            $colonIndex = $tempProxy.IndexOf(':')
            #
            # If the ':' is there, and Index is not 1 - ie. not the cell next to ']' throw an exception
            #
            if (($colonIndex -ne -1) -and ($colonIndex -ne 1)) {
                ThrowTerminatingError $_system_translations.Error_Incorrect_Proxy $EC_InvalidArgument $EC_InvalidArgument $Proxy
            }
            #
            # Calculate the actual offset if ':' is next to ']' - should just be closingBracketIndex + 1
            #
            if ($colonIndex -ne -1) {
                $colonIndex += $closingBracketIndex
            }
        }
        else {
            #
            # This should be IPv4/hostname
            #
            $colonIndex = $Proxy.IndexOf(':')
        }
                    
        if ($colonIndex -eq -1) {
            #
            # Returning the port as 0
            #
            $Port.Value = 0
            return
        }
        elseif ($colonIndex -ne ($Proxy.Length - 1)) {
            #
            # Validate that the port is a valid UInt16
            #
            $portStr = $Proxy.Substring($colonIndex + 1)
            if ([System.UInt16]::TryParse($portStr, $Port)) {
                #
                # Port is a valid UInt16
                # Check for '0' - it is an invalid port
                #
                if ($Port.Value -ne 0) {
                    return               
                }
            }            
        }
    }

    #
    # All success cases return from above, failure cases reach here - hence exception is thrown
    #
    ThrowTerminatingError $_system_translations.Error_Incorrect_Proxy $EC_InvalidArgument $EC_InvalidArgument $Proxy
}

#region Localized Strings

data _system_translations {
    ConvertFrom-StringData @'
    #
    # Error messages
    #
    Error_VpnConnection_NotFound = VPN connection profile {0} cannot be found.
    Error_Incorrect_Parameter_Combination = Parameters BypassProxyForLocal and ExceptionPrefix cannot be used without the ProxyServer value.
    Error_Call_Failed = The web-proxy for VPN connection profile {0} cannot be configured.
    Error_Incorrect_Proxy = The proxy server address format is invalid.
    #
    # Warning messages
    #
    Warning_Proxy_Port_NotSpecified = A proxy server port is not specified. Default port number 80 will be used.
    Warning_Incorrect_Parameter_Combination = Parameters BypassProxyForLocal and ExceptionPrefix will be skipped. These parameters cannot be used without the ProxyServer value.
    #
    # ShouldProcess
    #
    ShouldProcess_Message = Setting the web-proxy for VPN connection profile {0}.
'@
}

Import-LocalizedData -BindingVariable _system_translations -FileName SetVpnConnectionProxy.psd1

#endregion

#region Constants
#
# Defining the constants used - primarily for Error handling
#
New-Variable -Option Constant -Name EC_InvalidArgument                  -Value "InvalidArgument"
New-Variable -Option Constant -Name EC_NotSpecified                     -Value "NotSpecified"

#endregion
    
#
# C-Sharp Code for PInvoke 
#
$code = @'
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Text;
using System.Globalization;
using System.IO;

namespace PInvokeLibrary
{
    public class SetVpnProxy
    {
        // number of options set for VPN connections 
        public const int NUM_INTERNET_OPTIONS_VPN = 4;

        // flag for using API per connection
        public const int INTERNET_OPTION_PER_CONNECTION_OPTION = 75;

        // option codes          
        public const int INTERNET_PER_CONN_FLAGS = 1;
        public const int INTERNET_PER_CONN_PROXY_SERVER = 2;
        public const int INTERNET_PER_CONN_PROXY_BYPASS = 3;
        public const int INTERNET_PER_CONN_AUTOCONFIG_URL = 4;

        // Proxy Types for   INTERNET_OPTION_PER_CONN_FLAGS           
        public const int PROXY_TYPE_DIRECT = 0x00000001;   // direct to net          
        public const int PROXY_TYPE_PROXY = 0x00000002;   // via named proxy          
        public const int PROXY_TYPE_AUTO_PROXY_URL = 0x00000004;   // autoconfig URL          
        public const int PROXY_TYPE_AUTO_DETECT = 0x00000008;   // use autoproxy detection  

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct INTERNET_PER_CONN_OPTION_LIST
        {
            public Int32 Size;
            public string Connection;
            public Int32 OptionCount;
            public Int32 OptionError;
            public System.IntPtr pOptions;  // LPINTERNET_PER_CONN_OPTION          
        }

        [StructLayout(LayoutKind.Sequential)]
        public class INTERNET_PER_CONN_OPTION
        {
            public Int32 dwOption;
            public OptionUnion Value;
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct OptionUnion
        {
            [FieldOffset(0)]
            public Int32 dwValue;
            [FieldOffset(0)]
            public System.IntPtr pszValue;
            [FieldOffset(0)]
            public System.Runtime.InteropServices.ComTypes.FILETIME ftValue;
        }

        [DllImport("wininet.dll", SetLastError = true, CharSet = CharSet.Unicode, EntryPoint = "InternetSetOption")]
        public extern static bool InternetSetOptionList(int hInternet, int Option, ref INTERNET_PER_CONN_OPTION_LIST OptionList, Int32 size);
    }
}
'@

Set-StrictMode -Version 3
Export-ModuleMember Set-VpnConnectionProxy