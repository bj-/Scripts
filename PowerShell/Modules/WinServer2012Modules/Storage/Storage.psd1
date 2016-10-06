@{
    GUID = '41486F7D-842F-40F1-ACE4-8405F9C2ED9B'
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    ModuleVersion = '1.0.0.0'
    PowerShellVersion = '3.0'
    FormatsToProcess = 'Storage.format.ps1xml'
    TypesToProcess = 'Storage.types.ps1xml'
    NestedModules = @('Disk.cdxml', 'DiskImage.cdxml', 'Partition.cdxml', 'VirtualDisk.cdxml', 'PhysicalDisk.cdxml', 'StoragePool.cdxml', 'ResiliencySetting.cdxml', 'StorageProvider.cdxml', 'StorageSubSystem.cdxml', 'Volume.cdxml', 'StorageSetting.cdxml', 'MaskingSet.cdxml','InitiatorId.cdxml','InitiatorPort.cdxml','TargetPort.cdxml','TargetPortal.cdxml','StorageCmdlets.cdxml', 'OffloadDataTransferSetting.cdxml', 'StorageJob.cdxml', 'FileIntegrity.cdxml', 'StorageReliabilityCounter.cdxml')
    AliasesToExport = @(
        'Initialize-Volume'
        )
    FunctionsToExport = @(
        'Add-InitiatorIdToMaskingSet',
        'Add-PartitionAccessPath',
        'Add-PhysicalDisk',
        'Add-TargetPortToMaskingSet',
        'Add-VirtualDiskToMaskingSet',
        'Clear-Disk',
        'Connect-VirtualDisk',
        'Disable-PhysicalDiskIndication',
        'Disconnect-VirtualDisk',
        'Dismount-DiskImage',
        'Enable-PhysicalDiskIndication',
        'Format-Volume',
        'Get-Disk',
        'Get-DiskImage',
        'Get-FileIntegrity',
        'Get-InitiatorId',
        'Get-InitiatorPort',
        'Get-MaskingSet',
        'Get-Partition',
        'Get-PartitionSupportedSize',
        'Get-PhysicalDisk',
        'Get-ResiliencySetting',
        'Get-StorageJob',
        'Get-StoragePool',
        'Get-StorageProvider',
        'Get-StorageReliabilityCounter',
        'Get-StorageSetting',
        'Get-StorageSubSystem',
        'Get-SupportedFileSystems',
        'Get-SupportedClusterSizes',
        'Get-TargetPort',
        'Get-TargetPortal',
        'Get-VirtualDisk',
        'Get-VirtualDiskSupportedSize',
        'Get-OffloadDataTransferSetting'
        'Get-Volume',
        'Get-VolumeCorruptionCount',
        'Get-VolumeScrubPolicy',
        'Hide-VirtualDisk',
        'Initialize-Disk',
        'Mount-DiskImage',
        'New-MaskingSet',
        'New-Partition',
        'New-StoragePool',
        'New-StorageSubsystemVirtualDisk',
        'New-VirtualDisk',
        'New-VirtualDiskClone',
        'New-VirtualDiskSnapshot',
        'Optimize-Volume',
        'Remove-InitiatorId',
        'Remove-InitiatorIdFromMaskingSet',
        'Remove-MaskingSet',
        'Remove-Partition',
        'Remove-PartitionAccessPath',
        'Remove-PhysicalDisk',
        'Remove-StoragePool',
        'Remove-TargetPortFromMaskingSet',
        'Remove-VirtualDisk',
        'Remove-VirtualDiskFromMaskingSet',
        'Rename-MaskingSet',
        'Repair-FileIntegrity',
        'Repair-VirtualDisk',
        'Repair-Volume',
        'Reset-PhysicalDisk',
        'Reset-StorageReliabilityCounter',
        'Resize-Partition',
        'Resize-VirtualDisk',
        'Set-Disk',
        'Set-FileIntegrity',
        'Set-InitiatorPort',
        'Set-Partition',
        'Set-PhysicalDisk',
        'Set-ResiliencySetting',
        'Set-StoragePool',
        'Set-StorageSetting',
        'Set-StorageSubSystem',
        'Set-VirtualDisk',
        'Set-Volume',
        'Set-VolumeScrubPolicy',
        'Show-VirtualDisk',
        'Update-Disk',
        'Update-HostStorageCache',
        'Update-StorageProviderCache')
    HelpInfoUri="http://go.microsoft.com/fwlink/?LinkID=207182"
}


