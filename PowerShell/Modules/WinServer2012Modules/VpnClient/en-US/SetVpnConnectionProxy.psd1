# Localized	07/26/2012 03:15 AM (GMT)	303:4.80.0411 	SetVpnConnectionProxy.psd1
# Only add new (name,value) pairs to the end of this table
# Do not remove, insert or re-arrange entries
    ConvertFrom-StringData @'
    ###PSLOC start localizing
    #
    # helpID = VersionTooLow
    #
    #
    # Error messages
    #
Error_VpnConnection_NotFound=VPN connection profile {0} cannot be found.
Error_Incorrect_Parameter_Combination=Parameters BypassProxyForLocal and ExceptionPrefix cannot be used without the ProxyServer value.
Error_Call_Failed=The web-proxy for VPN connection profile {0} cannot be configured.
Error_Incorrect_Proxy=The proxy server address format is invalid.
    #
    # Warning messages
    #
Warning_Proxy_Port_NotSpecified=A proxy server port is not specified. Default port number 80 will be used.
Warning_Incorrect_Parameter_Combination=Parameters BypassProxyForLocal and ExceptionPrefix will be skipped. These parameters cannot be used without the ProxyServer value.
    #
    # ShouldProcess
    #
ShouldProcess_Message=Setting the web-proxy for VPN connection profile {0}.

'@
