function New-VMX
{
    [CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki/Commands/New-VMX")]
    param 
    (
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1",Mandatory = $true, ValueFromPipelineByPropertyName = $True,
        HelpMessage = 'Please Specify New Value for guestos')]
        [ValidateSet(
        'win31',
        'win95',
        'win98',
        'winMe',
        'nt4',
        'win2000',
        'win2000Pro',
        'win2000Serv',
        'win2000ServGues',
        'win2000AdvServ',
        'winXPHome',
        'whistler',
        'winXPPro-64',
        'winNetWeb',
        'winNetStandard',
        'winNetEnterprise',
        'winNetDatacenter',
        'winNetBusiness',
        'winNetStandard-64',
        'winNetEnterprise-64',
        'winNetDatacenter-64',
        'longhorn',
        'longhorn-64',
        'winvista',
        'winvista-64',
        'windows7',
        'windows7-64',
        'windows7srv-64',
        'windows8',
        'windows8-64',
        'windows8srv-64',
        'windows9',
        'windows9-64',
        'windows9srv-64',
        'winHyperV',
        'winServer2008Cluster-32',
        'winServer2008Datacenter-32',
        'winServer2008DatacenterCore-32',
        'winServer2008Enterprise-32',
        'winServer2008EnterpriseCore-32',
        'winServer2008EnterpriseItanium-32',
        'winServer2008SmallBusiness-32',
        'winServer2008SmallBusinessPremium-32',
        'winServer2008Standard-32',
        'winServer2008StandardCore-32',
        'winServer2008MediumManagement-32',
        'winServer2008MediumMessaging-32',
        'winServer2008MediumSecurity-32',
        'winServer2008ForSmallBusiness-32',
        'winServer2008StorageEnterprise-32',
        'winServer2008StorageExpress-32',
        'winServer2008StorageStandard-32',
        'winServer2008StorageWorkgroup-32',
        'winServer2008Web-32',
        'winServer2008Cluster-64',
        'winServer2008Datacenter-64',
        'winServer2008DatacenterCore-64',
        'winServer2008Enterprise-64',
        'winServer2008EnterpriseCore-64',
        'winServer2008EnterpriseItanium-64',
        'winServer2008SmallBusiness-64',
        'winServer2008SmallBusinessPremium-64',
        'winServer2008Standard-64',
        'winServer2008StandardCore-64',
        'winServer2008MediumManagement-64',
        'winServer2008MediumMessaging-64',
        'winServer2008MediumSecurity-64',
        'winServer2008ForSmallBusiness-64',
        'winServer2008StorageEnterprise-64',
        'winServer2008StorageExpress-64',
        'winServer2008StorageStandard-64',
        'winServer2008StorageWorkgroup-64',
        'winServer2008Web-64',
        'winVistaUltimate-32',
        'winVistaHomePremium-32',
        'winVistaHomeBasic-32',
        'winVistaEnterprise-32',
        'winVistaBusiness-32',
        'winVistaStarter-32',
        'winVistaUltimate-64',
        'winVistaHomePremium-64',
        'winVistaHomeBasic-64',
        'winVistaEnterprise-64',
        'winVistaBusiness-64',
        'winVistaStarter-64',
        'redhat',
        'rhel2',
        'rhel3',
        'rhel3-64',
        'rhel4',
        'rhel4-64',
        'rhel5',
        'rhel5-64',
        'rhel6',
        'rhel6-64',
        'rhel7',
        'rhel7-64',
        'centos',
        'centos-64',
        'centos6',
        'centos6-64',
        'centos7',
        'centos7-64',
        'oraclelinux',
        'oraclelinux-64',
        'oraclelinux6',
        'oraclelinux6-64',
        'oraclelinux7',
        'oraclelinux7-64',
        'suse',
        'suse-64',
        'sles',
        'sles-64',
        'sles10',
        'sles10-64',
        'sles11',
        'sles11-64',
        'sles12',
        'sles12-64',
        'mandrake',
        'mandrake-64',
        'mandriva',
        'mandriva-64',
        'turbolinux',
        'turbolinux-64',
        'ubuntu-64',
        'debian4',
        'debian4-64',
        'debian5',
        'debian5-64',
        'debian6',
        'debian6-64',
        'debian7',
        'debian7-64',
        'debian8',
        'debian8-64',
        'debian9',
        'debian9-64',
        'debian10',
        'debian10-64',
        'asianux3',
        'asianux3-64',
        'asianux4',
        'asianux4-64',
        'asianux5-6',
        'asianux7-64',
        'nld9',
        'oes',
        'sjds',
        'opensuse',
        'opensuse-64',
        'fedora',
        'fedora-64',
        'coreos-64',
        'vmware-photon-64',
        'other24xlinux-64',
        'other26xlinux',
        'other26xlinux-64',
        'other3xlinux',
        'other3xlinux-64',
        'otherlinux',
        'otherlinux-64',
        'genericlinux',
        'netware4',
        'netware5',
        'solaris6',
        'solaris7',
        'solaris8',
        'solaris9',
        'solaris10-64',
        'solaris11-64',
        'darwin-64',
        'darwin10',
        'darwin10-64',
        'darwin11',
        'darwin11-64',
        'darwin12-64',
        'darwin13-64',
        'darwin14-64',
        'darwin15-64',
        'darwin16-64',
        'darwin17-64',
        'vmkernel',
        'vmkernel5',
        'vmkernel6',
        'vmkernel65',
        'dos',
        'os2',
        'os2experimenta',
        'eComStation',
        'eComStation2',
        'freeBSD-64',
        'freeBSD11',
        'freeBSD11-64',
        'openserver5',
        'openserver6',
        'unixware7',
        'other-64',
        'Server2016',
        'Server2012',
        'Hyper-V')]	
        [Alias('Type')]$GuestOS,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $true)][ValidateSet('BIOS','EFI')][string]$Firmware = 'BIOS',
        [Parameter(ParameterSetName = "1", HelpMessage = "Please enter an optional root Path to you VMs (default is vmxdir)",Mandatory = $false)]$Path = $vmxdir
    )
    
    $VMXpath = Join-Path $Path $VMXName
    Write-Verbose $VMXpath
    
    if (get-vmx -Path $VMXpath -WarningAction SilentlyContinue | Out-Null)
    {
        Write-Warning "Vm Already Exists" 
        break
    }
    
    if (!(Test-Path $VMXpath))
    {
        New-Item -ItemType Directory -Path $VMXpath -WarningAction SilentlyContinue| Out-Null
    }
		switch ($GuestOS)
		{
    		"Server2016"
			{
	    		$GuestOS = "windows9srv-64"     
			}   
		    "Server2012"
			{
			    $GuestOS = "windows8srv-64"      
			}
		    "Hyper-V"
			{
			    $GuestOS = "winhyperv"      
			}
		}		
    
        $Firmware = $Firmware.ToLower()
        Write-Host -ForegroundColor Gray " ==>Creating new VM " -NoNewline
        Write-Host -ForegroundColor Magenta $VMXName -NoNewline
        $VMXConfig =@('.encoding = "windows-1252"
config.version = "8"
virtualHW.version = "11"
numvcpus = "2"
vcpu.hotadd = "TRUE"
scsi0.present = "TRUE"
scsi0.virtualDev = "lsisas1068"
sata0.present = "TRUE"
memsize = "2048"
mem.hotadd = "TRUE"
sata0:1.present = "TRUE"
sata0:1.autodetect = "TRUE"
sata0:1.deviceType = "cdrom-raw"
sata0:1.startConnected = "FALSE"
usb.present = "TRUE"
ehci.present = "TRUE"
ehci.pciSlotNumber = "0"
usb_xhci.present = "TRUE"
serial0.present = "TRUE"
serial0.fileType = "thinprint"
pciBridge0.present = "TRUE"
pciBridge4.present = "TRUE"
pciBridge4.virtualDev = "pcieRootPort"
pciBridge4.functions = "8"
pciBridge5.present = "TRUE"
pciBridge5.virtualDev = "pcieRootPort"
pciBridge5.functions = "8"
pciBridge6.present = "TRUE"
pciBridge6.virtualDev = "pcieRootPort"
pciBridge6.functions = "8"
pciBridge7.present = "TRUE"
pciBridge7.virtualDev = "pcieRootPort"
pciBridge7.functions = "8"
vmci0.present = "TRUE"
hpet0.present = "TRUE"
virtualHW.productCompatibility = "hosted"
powerType.powerOff = "soft"
powerType.powerOn = "soft"
powerType.suspend = "soft"
powerType.reset = "soft"
floppy0.present = "FALSE"
tools.remindInstall = "FALSE"') 
    
        $VMXConfig += 'extendedConfigFile = "'+$vmxname+'.vmxf"'        
        $VMXConfig += 'nvram = "'+$VMXName+'.nvram"'
        $VMXConfig += 'firmware = "'+$Firmware+'"'
        $Config = join-path $VMXpath "$VMXName.vmx"
        $VMXConfig | Set-Content -Path $Config
        $Object = New-Object -TypeName psobject
        $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
        $Object | Add-Member -MemberType NoteProperty -Name Type -Value $GuestOS
        $Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config
        $Object | Add-Member -MemberType NoteProperty -Name Path -Value $VMXpath
        Write-Host -ForegroundColor Green [success]
        Write-Output $Object
        Set-VMXGuestOS -config $Config -GuestOS $GuestOS  -VMXName $VMXName | out-null
}