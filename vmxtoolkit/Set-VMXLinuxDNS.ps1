<#
	.DESCRIPTION
		The Script will configure DNS in a Linux VM Manually
    .Synopsis
        $vmx | Set-VMXLinuxDNS -rootuser root -rootpassword Password123! -Verbose -device eth0
#>
function Set-VMXLinuxDNS {
    [CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param (
            [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
            [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
            [Parameter(Mandatory=$true)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$Nameserver1 = "192.168.2.10",
            [Parameter(Mandatory=$false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$Nameserver2,
            [Parameter(Mandatory=$true)]$Domain = "labbuildr.local",
            [Parameter(Mandatory=$true)]$Search1 = "labbuildr.local",
            [Parameter(Mandatory=$false)]$Search2,
            [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$rootuser, 
            [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$rootpassword
        )
    
    begin 
    {
    
        If ($Nameserver2)
        {
            $Nameserver = "$Nameserver1,$Nameserver2"
        }
        else
        {
            $Nameserver = $Nameserver1
        }
    
        If ($Search2)
        {
            $Search = "$Search1,$Search2"
        }
        else
        {
            $Search = $Search1
        }
    }
    process 
    {
        Write-Verbose $vmxname
        write-verbose $config
    
        if (!($vmx = get-vmx -Path $config))
        {
            Write-Warning "Could not find vm with Name $VMXName and Config $config"
            break
        }
        if (!($VMX | Get-VMXToolsState) -match "running")
        {
            Write-Warning "VMwareTool must be installed and Running"
            break
        }
            $Scriptblock = "echo 'nameserver $Nameserver' > /etc/resolv.conf"
            Write-Verbose "Invoking $Scriptblock"
            $VMX | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
            $Scriptblock = "echo 'domain $Domain'  >> /etc/resolv.conf"
            Write-Verbose "Invoking $Scriptblock"
            $VMX | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
            $Scriptblock = "echo 'search $Search'  >> /etc/resolv.conf"
            Write-Verbose "Invoking $Scriptblock"
            $VMX | Invoke-VMXBash -Scriptblock $Scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Domain -Value $Domain
            $Object | Add-Member -MemberType NoteProperty -Name Search -Value $Search
            $Object | Add-Member -MemberType NoteProperty -Name Nameserver -Value $Nameserver
            Write-Output $Object
    }
    
    end {}
    
}