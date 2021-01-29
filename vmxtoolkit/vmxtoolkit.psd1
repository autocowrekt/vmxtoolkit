
@{
    #RootModule = 'vmxtoolkit.psm1'
    ModuletoProcess = 'vmxtoolkit.psm1'

    # The version number of this module
    ModuleVersion = '4.5.3.2'

    # ID to uniquely identify this module
    GUID = 'abe3797c-5a42-4e80-a1fb-9e648872ee14'

    # Author of this module
    Author = 'Karsten Bott'

    # Company or manufacturer of this module
    CompanyName = 'labbuildr'
    
    # Copyright statement for this module
    Copyright = '(c) 2014 Karsten Bott. All rights reserved.
        Copyright 2014 Karsten Bott

    Licensed under the Apache License, Version 2.0 (the "License");
    You may not use this file except in compliance with the license.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    '
    # Description of the functions provided by this module
    Description = 'Powershell Modules for VMware Workstation on Windows / Linux and VMware Fusion on OSX, see https://github.com/bottkars/vmxtoolkit for details'

    # The minimum version of the Windows PowerShell module required for this module
    PowerShellVersion = '3.0'

    # The name of the Windows PowerShell host required for this module
    # PowerShellHostName = ''

    # The minimum version of Windows PowerShell host required for this module
    # PowerShellHostVersion = ''

    # The minimum Microsoft .NET Framework version required for this module
    # DotNetFrameworkVersion = ''

    # The minimum version of the CLR (Common Language Runtime) required for this module
    # CLRVersion = ''

    # The processor architecture required for this module ("None", "X86", "Amd64").
    # ProcessorArchitecture = ''

    # The modules that must be loaded into the global environment before importing this module
    # RequiredModules = @ ()

    # The assemblies that must be loaded before importing this module
    # RequiredAssemblies = @ ()
    
    # The script files (PS1 files) that will be run in the caller's environment before this module is imported.
    ScriptsToProcess = @("$PSScriptRoot\Vmxtoolkitinit.ps1")

    # The type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @ ()

    # The format files (.ps1xml) to be loaded when importing this module
 
    FormatsToProcess = @(
    "$PSScriptRoot\Formats\vmxtoolkit.virtualmachine.Format.ps1xml",
    "$PSScriptRoot\Formats\vmxtoolkit.virtualmachineinfo.Format.ps1xml",
    "$PSScriptRoot\Formats\vmxtoolkit.vmxscsidisk.Format.ps1xml",
    "$PSScriptRoot\Formats\vmxtoolkit.vmxsharedFolder.Format.ps1xml"
    )

    # The modules to be imported as nested modules of the module specified in "RootModule / ModuleToProcess".
    NestedModules = @()

    # Functions to export from this module
    FunctionsToExport = @(
        'Add-VMXScsiDisk',
        'Connect-VMXcdromImage',
        'Connect-VMXNetworkAdapter',
        'Convert-VMXdos2unix',
        'Copy-VMXDirHost2Guest',
        'Copy-VMXFile2Guest',
        'Copy-VMXFile2Host',
        'Disconnect-VMXNetworkAdapter',
        'Expand-VMXDiskfile',
        'Get-HWVersion',
        'Get-VMwareVersion',
        'Get-VMX',
        'Get-VMXActivationPreference',
        'Get-VMXAnnotation',
        'Get-VMXConfig',
        'Get-VMXConfigVersion',
        'Get-VMXDisplayName',
        'Get-VMXGuestOS',
        'Get-VMXHWVersion',
        'Get-VMXideDisk',
        'Get-VMXInfo',
        'Get-VMXIPAddress',
        'Get-VMwareLANSegment',
        'Get-VMXmemory',
        'Get-VMXNetwork',
        'Get-VMXNetworkAdapter',
        'Get-VMXNetworkAdapterDisplayName',
        'Get-VMXNetworkAddress',
        'Get-VMXNetworkConnection',
        'Get-VMXProcessesInGuest',
        'Get-VMXProcessor',
        'Get-VMXRun',
        'Get-VMXscenario',
        'Get-VMXScsiController',
        'Get-VMXScsiDisk',
        'Get-VMXsharedFolder',
        'Get-VMXSnapshot',
        'Get-VMXSnapshotconfig',
        'Get-VMXTemplate',
        'Get-VMXToolsState',
        'Get-VMXUUID',
        'Get-VMXVariable',
        'Get-VMXVTBit',
        'Import-VMXOVATemplate',
        'Invoke-VMXBash',
        'Invoke-VMXexpect',
        'Invoke-VMXPowerShell',
        'Invoke-VMXScript',
        'New-VMX',
        'New-VMXClone',
        'New-VMXGuestPath',
        'New-VMXLinkedClone',
        'New-VMXScsiDisk',
        'New-VMXSnapshot',
        'Optimize-VMXDisk',
        'Remove-VMX',
        'Remove-VMXScsiDisk',
        'Remove-VMXserial',
        'Remove-VMXSnapshot',
        'Repair-VMXDisk',
        'Resize-VMXDiskfile',
        'Restore-VMXSnapshot',
        'Search-VMXPattern',
        'Set-VMXActivationPreference',
        'Set-VMXAnnotation',
        'Set-VMXDisconnectIDE',
        'Set-VMXDisplayName',
        'Set-VMXDisplayScaling',
        'Set-VMXGuestOS',
        'Set-VMXHWversion',
        'Set-VMXIDECDrom',
        'Set-VMXLinuxDNS',
        'Set-VMXLinuxNetwork',
        'Set-VMXMainMemory',
        'Set-VMXmemory',
        'Set-VMXnestedHVEnabled',
        'Set-VMXNetAdapterDisplayName',
        'Set-VMXNetworkAdapter',
        'Set-VMXprocessor',
        'Set-VMXScenario',
        'Set-VMXScsiController',
        'Set-VMXserialPipe',
        'Set-VMXSharedFolder',
        'Set-VMXSharedFolderState',
        'Set-VMXSize',
        'Set-VMXTemplate',
        'Set-VMXToolsReminder',
        'Set-VMXUUID',
        'Set-VMXVnet',
        'Set-VMXVTBit',
        'Start-VMX',
        'Stop-VMX',
        'Suspend-VMX',
        'Test-VMXFileInGuest',
        'vmxtoolkitinit',
        'Wait-VMXuserloggedIn'
)

    # Cmdlets to export from this module
    CmdletsToExport = '*'

    # The variables to be exported from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport = '*'

    # List of all modules in this module package
    ModuleList = @()

    # List of all files in this module package
    FileList = @("vmxtoolkit.psd1","vmxtoolkit.psm1")

    # The private data to be passed to the module specified in "RootModule / ModuleToProcess".
    # PrivateData = ''

    # HelpInfo-URI of this module
    # HelpInfoURI = ''

    # Standard prefix for commands exported from this module. The standard prefix can be overwritten with "Import-Module -Prefix".
    # DefaultCommandPrefix = 'vmx'

}

