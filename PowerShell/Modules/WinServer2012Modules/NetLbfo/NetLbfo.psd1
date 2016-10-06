@{
    GUID = "{80CF4C6D-30B7-4B0F-A035-DBB23A65EF1D}"
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "© Microsoft Corporation. All rights reserved."
    HelpInfoUri = "http://go.microsoft.com/fwlink/?LinkId=225664"
    ModuleVersion = "1.0.0.0"
    PowerShellVersion = "3.0"
    NestedModules = @('MSFT_NetLbfoTeam.cdxml', 'MSFT_NetLbfoTeamMember.cdxml', 'MSFT_NetLbfoTeamNic.cdxml')
    FormatsToProcess = @('MSFT_NetLbfoTeam.format.ps1xml', 'MSFT_NetLbfoTeamMember.format.ps1xml', 'MSFT_NetLbfoTeamNic.format.ps1xml')
    TypesToProcess = @('NetLbfo.Types.ps1xml')
    FunctionsToExport = @(
        'Add-NetLbfoTeamMember',
        'Add-NetLbfoTeamNic',
        'Get-NetLbfoTeam',
        'Get-NetLbfoTeamMember',
        'Get-NetLbfoTeamNic',
        'New-NetLbfoTeam',
        'Remove-NetLbfoTeam',
        'Remove-NetLbfoTeamMember',
        'Remove-NetLbfoTeamNic',
        'Rename-NetLbfoTeam',
        'Set-NetLbfoTeam',
        'Set-NetLbfoTeamMember',
        'Set-NetLbfoTeamNic'
    )
}
