<#++

Copyright (c) Microsoft Corporation

Module Name:

    NetSwitchTeam.psd1

Abstract:

    This module is the container schema for the NetSwitchTeam* CIM object
    CmdLets.

--#>

@{
    GUID = "{E83097B1-4470-4F37-8CE3-A6B0AC5ED8F5}"
    Author = "Microsoft Corporation"
    CompanyName = "Microsoft Corporation"
    Copyright = "� Microsoft Corporation. All rights reserved."
    HelpInfoUri = "http://go.microsoft.com/fwlink/?LinkId=230535"
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '3.0'
    NestedModules = @(
        'MSFT_NetSwitchTeam.cdxml',
        'MSFT_NetSwitchTeamMember.cdxml'
        )
    FormatsToProcess = @(
        'MSFT_NetSwitchTeam.format.ps1xml',
        'MSFT_NetSwitchTeamMember.format.ps1xml'
        )
    FunctionsToExport = @(
        'New-NetSwitchTeam',
        'Remove-NetSwitchTeam',
        'Get-NetSwitchTeam',
        'Rename-NetSwitchTeam',
        'Add-NetSwitchTeamMember',
        'Remove-NetSwitchTeamMember',
        'Get-NetSwitchTeamMember'
        )
}
