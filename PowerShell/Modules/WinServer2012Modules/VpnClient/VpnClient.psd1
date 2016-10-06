@{
    GUID = '3389cc73-daa3-4d25-bd50-b1730925d2df'
    Author = 'Microsoft Corporation'
    CompanyName = 'Microsoft Corporation'
    Copyright = '© Microsoft Corporation. All rights reserved.'
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '3.0'

    FormatsToProcess = 'VpnClientPsProvider.Format.ps1xml'
    TypesToProcess = 'VpnClientPSProvider.Types.ps1xml'

    HelpInfoUri="http://go.microsoft.com/fwlink/?LinkId=246609"
		    
    NestedModules = @("PS_VpnConnection_v1.0.0.cdxml", "PS_EapConfiguration_v1.0.0.cdxml", "SetVpnConnectionProxy.psm1")

    FunctionsToExport = @("Add-VpnConnection", "Set-VpnConnection", "Remove-VpnConnection", "Get-VpnConnection", "New-EapConfiguration", "Set-VpnConnectionProxy")
}

