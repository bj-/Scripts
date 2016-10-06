@{
    GUID = '743692B7-A227-4389-B082-2B47DE1D0D2D'
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    ModuleVersion = '1.0'
    PowerShellVersion = '3.0'
    NestedModules = @('MSFT_NetQosPolicy.cdxml')
    FormatsToProcess = @('MSFT_NetQosPolicy.format.ps1xml')
    TypesToProcess = @('MSFT_NetQosPolicy.types.ps1xml')
    HelpInfoUri = "http://go.microsoft.com/fwlink/?LinkId=216150"
    FunctionsToExport = @(
        'Get-NetQosPolicy',
        'Set-NetQosPolicy',
        'Remove-NetQosPolicy',
        'New-NetQosPolicy')
}
