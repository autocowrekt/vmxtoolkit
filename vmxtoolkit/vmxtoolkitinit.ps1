[CmdletBinding()]
param
(
    $VMX_Path
)
    # Some Globals

if ($PSVersionTable.PSVersion -lt [version]"6.0.0") 
{
    Write-Verbose "[+] this will check if we are on 6"
}

Write-Verbose "[+] Trying to get os type ... "

if ($env:windir) 
{
    $OS_Version = Get-Command "$env:windir\system32\ntdll.dll"
    $OS_Version = "Product Name: Windows $($OS_Version.Version)"
    $Global:vmxtoolkit_type = "win_x86_64"
    write-verbose "getting VMware Path from Registry"

    if (!(Test-Path "HKCR:\")) 
    {
        $NewPSDrive = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT 
    }
    
    if (!($VMware_Path = Get-ItemProperty HKCR:\Applications\vmware.exe\shell\open\command -ErrorAction SilentlyContinue)) 
    {
        Write-Error "[*] VMware Binaries not found from registry"
        Break
    }

    $preferences_file = "$env:AppData\VMware\preferences.ini"
    $VMX_BasePath = '\Documents\Virtual Machines\'	
    $VMware_Path = Split-Path $VMware_Path.'(default)' -Parent
    $VMware_Path = $VMware_Path -replace '"', ''
    $Global:vmwarepath = $VMware_Path
    $Global:vmware = "$VMware_Path\vmware.exe"
    $Global:vmrun = "$VMware_Path\vmrun.exe"
    $Global:vmware_vdiskmanager = Join-Path $VMware_Path 'vmware-vdiskmanager.exe'
    $Global:VMware_OVFTool = Join-Path $Global:vmwarepath 'OVFTool\ovftool.exe'
    $GLobal:VMware_packer = Join-Path $Global:vmwarepath '7za.exe'
    $VMwarefileinfo = Get-ChildItem $Global:vmware
    $Global:vmxinventory = "$env:appdata\vmware\inventory.vmls"
    $Global:vmwareversion = New-Object System.Version($VMwarefileinfo.VersionInfo.ProductMajorPart, $VMwarefileinfo.VersionInfo.ProductMinorPart, $VMwarefileinfo.VersionInfo.ProductBuildPart, $VMwarefileinfo.VersionInfo.ProductVersion.Split("-")[1])
    $webrequestor = ".Net"
    $Global:mkisofs = "$Global:vmwarepath/mkisofs.exe"
}
elseif ($OS = uname) 
{
    Write-Verbose "[+] Found OS $OS"
    Switch ($OS) 
    {
        "Darwin" 
        {
            $Global:vmxtoolkit_type = "OSX"
            $OS_Version = (sw_vers)
            $OS_Version = $OS_Version -join " "
            $VMX_BasePath = 'Documents/Virtual Machines.localized'
            # $VMware_Path = "/Applications/VMware Fusion.app"
            $VMware_Path = mdfind -onlyin /Applications "VMware Fusion"                
            $Global:vmwarepath = $VMware_Path
            [version]$Fusion_Version = defaults read $VMware_Path/Contents/Info.plist CFBundleShortVersionString
            $VMware_BIN_Path = Join-Path $VMware_Path  '/Contents/Library'
            $preferences_file = "$HOME/Library/Preferences/VMware Fusion/preferences"
        
            try 
            {
                $webrequestor = (get-command curl).Path
            }
            catch 
            {
                Write-Warning "[!] Curl not found"
                exit
            }
            try 
            {
                $GLobal:VMware_packer = (get-command 7za -ErrorAction Stop).Path 
            }
            catch 
            {
                Write-Warning "[!] 7za not found, pleas install p7zip full"
                Break
            }

            $Global:VMware_vdiskmanager = Join-Path $VMware_BIN_Path 'vmware-vdiskmanager'
            $Global:vmrun = Join-Path $VMware_BIN_Path "vmrun"
            
            switch ($Fusion_Version.Major) 
            {
                "10" 
                {
                    $Global:VMware_OVFTool = "/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool"
                    [version]$Global:vmwareversion = "14.0.0.0"
                }
					
                default 
                {
                    $Global:VMware_OVFTool = Join-Path $VMware_Path 'ovftool'
                    [version]$Global:vmwareversion = "12.0.0.0"
                }
            }

        }
        'Linux' 
        {
            $Global:vmxtoolkit_type = "LINUX"
            $OS_Version = (uname -o)
            #$OS_Version = $OS_Version -join " "
            $preferences_file = "$HOME/.vmware/preferences"
            $VMX_BasePath = '/var/lib/vmware/Shared VMs'
            
            try 
            {
                $webrequestor = (get-command curl).Path
            }
            catch 
            {
                Write-Warning "[!] curl not found"
                exit
            }
            
            try 
            {
                $VMware_Path = Split-Path -Parent (get-command vmware).Path
            }
            catch 
            {
                Write-Warning "[!] VMware Path not found"
                exit
            }

            $Global:vmwarepath = $VMware_Path
            $VMware_BIN_Path = $VMware_Path  
            
            try
            {
                $Global:VMware_vdiskmanager = (get-command vmware-vdiskmanager).Path
            }
            catch 
            {
                Write-Warning "[!] vmware-vdiskmanager not found"
                break
            }
            
            try 
            {
                $GLobal:VMware_packer = (get-command 7za).Path
            }
            catch 
            {
                Write-Warning "[!] 7za not found, pleas install p7zip full"
            }
				
            try 
            {
                $Global:vmrun = (Get-Command vmrun).Path
            }	
            catch 
            {
                Write-Warning "[!] vmrun not found"
                break
            }
            
            try
            {
                $Global:VMware_OVFTool = (Get-Command ovftool).Path
            }
            catch 
            {
                Write-Warning "[!] ovftool not found"
                break
            }
            
            try
            {
                $Global:mkisofs = (Get-Command mkisofs).Path
            }
            catch 
            {
                Write-Warning "[!] mkisofs not found"
                break
            }
            
            $Vmware_Base_Version = (vmware -v)
            $Vmware_Base_Version = $Vmware_Base_Version -replace "VMware Workstation "
            
            [version]$Global:vmwareversion = ($Vmware_Base_Version.Split(' '))[0]
        }
        default 
        {
            Write-Verbose "[+] Sorry, rome was not build in one day"
            exit
        }
					
        'default' 
        {
            Write-Verbose "[+] unknown linux OS"
            break
        }
    }
}
else 
{
    Write-Verbose "[+] error detecting OS"
}

if (Test-Path $preferences_file) 
{
    Write-Verbose "[+] Found VMware Preferences file"
    Write-Verbose "[+] Trying to get vmx path from preferences"
    $defaultVMPath = get-content $preferences_file | Select-String prefvmx.defaultVMPath
    
    if ($defaultVMPath) 
    {
        $defaultVMPath = $defaultVMPath -replace "`""
        $defaultVMPath = ($defaultVMPath -split "=")[-1]
        $defaultVMPath = $defaultVMPath.TrimStart(" ")
        Write-Verbose "[+] Default vmpath from preferences is $defaultVMPath"
        $VMX_default_Path = $defaultVMPath
        $defaultselection = "preferences"
    }
    else 
    {
        Write-Verbose "[+] No defaultVMPath in prefernces"
    }
}

if (!$VMX_Path) 
{
    if (!$VMX_default_Path) 
    {
        Write-Verbose "[+] trying to use default vmxdir in homedirectory" 
        try 
        {
            $defaultselection = "homedir"
            $Global:vmxdir = Join-Path $HOME $VMX_BasePath
        }
        catch 
        {
            Write-Warning "[!] could not evaluate default Virtula machines home, using $PSScriptRoot"
            $Global:vmxdir = $PSScriptRoot
            $defaultselection = "ScriptRoot"
            Write-Verbose "[+] Using psscriptroot as vmxdir"
        }
    }
    else 
    {
        if (Test-Path $VMX_default_Path) 
        {
            $Global:vmxdir = $VMX_default_Path	
        }
        else 
        {
            $Global:vmxdir = $PSScriptRoot
        }
    }
}
else 
{
    $Global:vmxdir = $VMX_Path
}

#### some vmx api error handlers :-) false positives from experience
$Global:VMrunErrorCondition = @(
    "Waiting for Command execution Available",
    "Error",
    "Unable to connect to host.",
    "Error: Unable to connect to host.",
    "Error: The operation is not supported for the specified parameters",
    "Unable to connect to host. Error: The operation is not supported for the specified parameters",
    "Error: The operation is not supported for the specified parameters",
    "Error: vmrun was unable to start. Please make sure that vmrun is installed correctly and that you have enough resources available on your system.",
    "Error: The specified guest user must be logged in interactively to perform this operation",
    "Error: A file was not found",
    "Error: VMware Tools are not running in the guest",
    "Error: The VMware Tools are not running in the virtual machine" 
    )

if (!$GLobal:VMware_packer) 
{
    Write-Warning "[!] Please install 7za/p7zip, otherwise labbtools can not expand OS Masters"
}

if ($OS_Version) 
{
    Write-Verbose  "[*] $OS_Version"
}
else	
{
    Write-Verbose "[+] error Detecting OS"
    Break
}

Write-Verbose "[*] running vmxtoolkit for $Global:vmxtoolkit_type"
Write-Verbose "[*] vmrun is $Global:vmrun"
Write-Verbose "[*] vmwarepath is $Global:vmwarepath"

if ($VMX_Path) 
{
    Write-Verbose "[*] Using virtual machine directory from module load $Global:vmxdir"
}
else
{
Write-Verbose  "[*] Using virtual machine directory from $defaultselection`: $Global:vmxdir"
}	

Write-Verbose  "[*] Running VMware Version Mode $Global:vmwareversion"
Write-Verbose  "[*] OVFtool is $Global:VMware_OVFTool"
Write-Verbose  "[*] Packertool is $GLobal:VMware_packer"
Write-Verbose  "[*] vDisk manager is $Global:vmware_vdiskmanager"
Write-Verbose  "[*] Webrequest tool is $webrequestor"
Write-Verbose  "[*] isotool is $Global:mkisofs"
Write-Verbose  "[*] Importing helper functions..."

function Get-yesno
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  PositionalBinding=$false,
                  HelpUri = 'http://labbuildr.com/',
                  ConfirmImpact='Medium')]
    Param
    (
$title = "Delete Files",
$message = "Do you want to delete the remaining files in the folder?",
$Yestext = "Yestext",
$Notext = "notext"
    )
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","$Yestext"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","$Notext"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
$result = $host.ui.PromptForChoice($title, $message, $options, 0)
return ($result)
}
function Get-yesnoabort
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  PositionalBinding=$false,
                  HelpUri = 'http://labbuildr.com/',
                  ConfirmImpact='Medium')]
Param
    (
    $title = "Delete Files",
    $message = "Do you want to delete the remaining files in the folder?",
    $Yestext = "Yes",
    $Notext = "No",
    $AbortText = "Abort"
    )
$yes = New-Object System.Management.Automation.Host.ChoiceDescription ("&Yes","$Yestext")
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","$Notext"
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Abort","$Aborttext"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $Abort )
$result = $host.ui.PromptForChoice($title, $message, $options, 0)
return ($result)
}
