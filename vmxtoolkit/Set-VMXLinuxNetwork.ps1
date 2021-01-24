<#
.DESCRIPTION
	The Function will configure Networking in a Linux VM using networking scripts ( redhat, centos, suse )
.Example
	$vmx = get-vmx -path c:\centos

	$vmx | Set-VMXLinuxNetwork -ipaddress 192.168.2.110 -network 192.168.2.0 -netmask 255.255.255.0 -gateway 192.168.2.10 -device eth0 -Peerdns -DNS1 192.168.2.10 -DNSDOMAIN labbuildr.local -Hostname centos3 -rootuser root -rootpassword Password123!
#>
function Set-VMXLinuxNetwork {
    [CmdletBinding(DefaultParametersetName = "1",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param
    (
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(Mandatory=$false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$ipaddress = "192.168.2.100",
        [Parameter(Mandatory=$false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$network = "192.168.2.0",
        [Parameter(Mandatory=$false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$netmask = "255.255.255.0",
        [Parameter(Mandatory=$false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$gateway = "192.168.2.103",
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$device = "eth0",
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][switch]$Peerdns,
        [Parameter(ParameterSetName = "2", Mandatory = $true)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$DNS1 = "192.168.2.10",
        [Parameter(ParameterSetName = "2", Mandatory = $false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$DNS2,
        [Parameter(ParameterSetName = "2", Mandatory = $true)]$DNSDOMAIN,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$Hostname,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$suse,
        #[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$systemd,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$rootuser, 
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$rootpassword
    )
    
    begin {}
    
    process {
        Write-Verbose $vmxname
        Write-Verbose $config
            
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
        
        Write-Verbose "configuring $device"
        
        if ($suse.IsPresent)
        {
            $File = "/etc/sysconfig/network/ifcfg-$device"
        }
        else
        {
            $File = "/etc/sysconfig/network-scripts/ifcfg-$device"
        }

        if ($suse.IsPresent)
        {
            $vmx | Invoke-VMXBash -Scriptblock "yast2 lan edit id=0 ip=$ipaddress netmask=$netmask prefix=24 verbose" -gu $rootuser -gp $rootpassword
            $vmx | Invoke-VMXBash -Scriptblock "hostname $Hostname" -Guestuser $rootuser -Guestpassword $rootpassword
            $Scriptblock = "echo 'default "+$gateway+" - -' > /etc/sysconfig/network/routes"
            $vmx | Invoke-VMXBash -Scriptblock $Scriptblock  -Guestuser $rootuser -Guestpassword $rootpassword
            $sed = "sed -i -- 's/NETCONFIG_DNS_STATIC_SEARCHLIST=`"`"/NETCONFIG_DNS_STATIC_SEARCHLIST=`"$DNSDomain`"/g' /etc/sysconfig/network/config" 
            $vmx | Invoke-VMXBash -Scriptblock $sed -Guestuser $rootuser -Guestpassword $rootpassword
            $sed = "sed -i -- 's/NETCONFIG_DNS_STATIC_SERVERS=`"`"/NETCONFIG_DNS_STATIC_SERVERS=`"$DNS1`"/g' /etc/sysconfig/network/config"
            $vmx | Invoke-VMXBash -Scriptblock $sed -Guestuser $rootuser -Guestpassword $rootpassword
            $vmx | Invoke-VMXBash -Scriptblock "/sbin/netconfig -f update" -Guestuser $rootuser -Guestpassword $rootpassword
            $Scriptblock = "echo '"+$Hostname+"."+$DNSDOMAIN+"'  > /etc/HOSTNAME"
            $vmx | Invoke-VMXBash -Scriptblock $Scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
            $vmx | Invoke-VMXBash -Scriptblock "/sbin/rcnetwork restart" -Guestuser $rootuser -Guestpassword $rootpassword
    
            <#
            if ($systemd.IsPresent)
                {
                $vmx | Invoke-VMXBash -Scriptblock "/sbin/rcnetwork restart" -Guestuser $rootuser -Guestpassword $rootpassword
                }
            else
                {
                $vmx | Invoke-VMXBash -Scriptblock "/etc/init.d/network restart" -Guestuser $rootuser -Guestpassword $rootpassword
                }
            #>
        }
        else
        {
            $Property = "DEVICE"
            $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$device/' $file || echo '$Property=$device' >> $file"
            # $Scriptblock = "echo  'DEVICE=eth0' > /etc/sysconfig/network-scripts/ifcfg-$device"
            Write-Verbose "Invoking $Scriptblock"
            $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
    
            $Property = "BOOTPROTO"
            $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=static/' $file || echo '$Property=static' >> $file"
            Write-Verbose "Invoking $Scriptblock"
            $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
    
            $Property = "IPADDR"
            $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$ipaddress/' $file || echo '$Property=$ipaddress' >> $file"
            #$Scriptblock = "echo  'IPADDR=$ipaddress' >> /etc/sysconfig/network-scripts/ifcfg-$device"
            Write-Verbose "Invoking $Scriptblock"
            $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
    
            $Property = "NETWORK"
            $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$network/' $file || echo '$Property=$network' >> $file"
            #$Scriptblock = "echo  'NETWORK=$network' >> /etc/sysconfig/network-scripts/ifcfg-$device"
            Write-Verbose "Invoking $Scriptblock"
    
            $Property = "ONBOOT"
            $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=yes/' $file || echo '$Property=yes' >> $file"
            #$Scriptblock = "echo  'NETWORK=$network' >> /etc/sysconfig/network-scripts/ifcfg-$device"
            Write-Verbose "Invoking $Scriptblock"
    
    
            $Property = "NETMASK"
            $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$netmask/' $file || echo '$Property=$netmask' >> $file"
            #$Scriptblock = "echo  'NETMASK=$netmask' >> /etc/sysconfig/network-scripts/ifcfg-$device"
            Write-Verbose "Invoking $Scriptblock"
            $vmx | Invoke-VMXBash -Scriptblock $Scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
    
            $Property = "GATEWAY"
            $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$gateway/' $file || echo '$Property=$gateway' >> $file"
            #$Scriptblock = "echo  'GATEWAY=$gateway' >> /etc/sysconfig/network-scripts/ifcfg-$device"
            Write-Verbose "Invoking $Scriptblock"
            $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
            
            if ($peerdns.IsPresent)
            {
                $Property = "PEERDNS"
                $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=yes/' $file || echo '$Property=yes' >> $file"
                Write-Verbose "Invoking $Scriptblock"
                $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
                
                $Property = "DOMAIN"
                $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$DNSDOMAIN/' $file || echo '$Property=$DNSDOMAIN' >> $file"
                Write-Verbose "Invoking $Scriptblock"
                $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
    
    
                $Property = "DNS1"
                $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$DNS1/' $file || echo '$Property=$DNS1' >> $file"
                Write-Verbose "Invoking $Scriptblock"
                $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
            
                if ($DNS2)
                {
                    $Property = "DNS2"
                    $Scriptblock = "grep -q '^$Property' $file && sed -i 's/^$Property.*/$Property=$DNS2/' $file || echo '$Property=$DNS2' >> $file"
                    Write-Verbose "Invoking $Scriptblock"
                    $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
                }
            }
            
            if ($Hostname)
            {
                Write-Verbose "setting Hostname $Hostname"
                $Scriptblock = "sed -i -- '/HOSTNAME/c\HOSTNAME=$Hostname' /etc/sysconfig/network"
                Write-Verbose "Invoking $Scriptblock"
                $vmx | Invoke-VMXBash -Scriptblock $scriptblock -Guestuser $rootuser -Guestpassword $rootpassword
            }
    
            $vmx | Invoke-VMXBash -Scriptblock "/sbin/service network restart" -Guestuser $rootuser -Guestpassword $Rootpassword
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name IPAddress -Value $ipaddress
            $Object | Add-Member -MemberType NoteProperty -Name Gateway -Value $gateway
            $Object | Add-Member -MemberType NoteProperty -Name Network -Value $network
            $Object | Add-Member -MemberType NoteProperty -Name Netmask -Value $netmask
            $Object | Add-Member -MemberType NoteProperty -Name DNS -Value "$DNS1 $DNS2"
            Write-Output $Object
        }
    }
    
    end {}
    
}