#
# Module manifest for module 'PrintManagement'
#
#

@{


# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '8466ae97-2c03-4385-a501-7e74cf6bb1df'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = '© Microsoft Corporation. All rights reserved.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
PowerShellHostVersion = ''

# Minimum version of the .NET Framework required by this module
DotNetFrameworkVersion = ''

# Processor architecture (None, X86, Amd64, IA64) required by this module
ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @()


# Script files (.ps1) that are run in the caller's environment prior to importing this module
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = 'MSFT_Printer.types.ps1xml', 
               'MSFT_PrinterConfiguration.types.ps1xml', 
               'MSFT_PrintJob.types.ps1xml', 'MSFT_TcpIpPrinterPort.types.ps1xml', 
               'MSFT_WsdPrinterPort.types.ps1xml', 'MSFT_PrinterProperty.types.ps1xml'

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'MSFT_Printer.format.ps1xml', 'MSFT_PrinterPort.format.ps1xml', 
               'MSFT_PrinterDriver.format.ps1xml', 
               'MSFT_PrinterConfiguration.format.ps1xml', 
               'MSFT_PrintJob.format.ps1xml', 'MSFT_LprPrinterPort.format.ps1xml', 
               'MSFT_LocalPrinterPort.format.ps1xml', 
               'MSFT_TcpIpPrinterPort.format.ps1xml', 
               'MSFT_WsdPrinterPort.format.ps1xml',
               'MSFT_PrinterProperty.format.ps1xml'

# Modules to import as nested modules of the module specified in ModuleToProcess
NestedModules = 'MSFT_Printer_v1.0.cdxml', 'MSFT_PrinterPort_v1.0.cdxml', 
               'MSFT_PrinterPortTasks_v1.0.cdxml', 'MSFT_PrinterDriver_v1.0.cdxml', 
               'MSFT_PrinterConfiguration_v1.0.cdxml', 'MSFT_PrintJob_v1.0.cdxml', 
               'MSFT_LprPrinterPort_v1.0.cdxml', 
               'MSFT_LocalPrinterPort_v1.0.cdxml', 
               'MSFT_TcpIpPrinterPort_v1.0.cdxml', 
               'MSFT_WsdPrinterPort_v1.0.cdxml',
               'MSFT_PrinterProperty_v1.0.cdxml'

# Functions to export from this module
FunctionsToExport = 'Add-Printer',
                    'Add-PrinterDriver',
                    'Add-PrinterPort',
                    'Get-PrintConfiguration',
                    'Get-Printer',
                    'Get-PrinterDriver',
                    'Get-PrinterPort',
                    'Get-PrinterProperty',
                    'Get-PrintJob',
                    'Remove-Printer',
                    'Remove-PrinterDriver',
                    'Remove-PrinterPort',
                    'Remove-PrintJob',
                    'Rename-Printer',
                    'Restart-PrintJob',
                    'Resume-PrintJob',
                    'Set-PrintConfiguration',
                    'Set-Printer',
                    'Set-PrinterProperty',
                    'Suspend-PrintJob'

# List of all modules packaged with this module
ModuleList = @()

# List of all files packaged with this module
FileList = @()

# Private data to pass to the module specified in ModuleToProcess
PrivateData = ''

# HelpInfo URI of this module
HelpInfoURI = 'http://go.microsoft.com/fwlink/?LinkId=216901'
}