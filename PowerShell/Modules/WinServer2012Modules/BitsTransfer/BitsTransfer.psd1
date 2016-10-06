@{
GUID="{8FA5064B-8479-4c5c-86EA-0D311FE48875}"
Author="Microsoft Corporation"
CompanyName="Microsoft Corporation"
Copyright="© Microsoft Corporation. All rights reserved."
ModuleVersion="1.0.0.0"
PowerShellVersion="2.0"
CLRVersion="2.0"
NestedModules="Microsoft.BackgroundIntelligentTransfer.Management"
FormatsToProcess="BitsTransfer.Format.ps1xml"
RequiredAssemblies=Join-Path $psScriptRoot "Microsoft.BackgroundIntelligentTransfer.Management.Interop.dll"
CmdletsToExport="Add-BitsFile","Complete-BitsTransfer","Get-BitsTransfer","Remove-BitsTransfer","Resume-BitsTransfer","Set-BitsTransfer","Start-BitsTransfer","Suspend-BitsTransfer"
}
