
@{
    GUID = 'ef018256-3318-4e74-a823-158022778487'
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="� Microsoft Corporation. All rights reserved."
    NestedModules = @('SmbWitnessWmiClient.cdxml')
    FormatsToProcess = @('SmbWitness.format.ps1xml')
    TypesToProcess = @('SmbWitness.types.ps1xml')
    ModuleVersion = '1.0.0.0'
    AliasesToExport = @('gsmbw',
                        'msmbw')
    FunctionsToExport = @('Get-SmbWitnessClient',
                          'Move-SmbWitnessClient')
    PowerShellVersion = '3.0'
    HelpInfoUri= "http://go.microsoft.com/fwlink/?LinkID=216864"
}
        
