function Set-VMXVnet
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		$config,
		[Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateRange(0, 19)][int]$Adapter,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateSet('vmnet1','vmnet2','vmnet3','vmnet4','vmnet5','vmnet6','vmnet7','vmnet9','vmnet10','vmnet11','vmnet12','vmnet13','vmnet14','vmnet15','vmnet16','vmnet17','vmnet18','vmnet19')][Alias('VMnet')]$Vnet
	)
	
	Begin {}
	
	Process
	{
		if ((get-vmx -Path $config).state -eq "stopped")
        {
            $Content = Get-Content -Path $config
            Write-verbose "ethernet$Adapter.present"
            if (!($Content -match "ethernet$Adapter.present")) 
            {
                write-error "Adapter not present " 
            }
        
            $Content = ($Content -notmatch "ethernet$Adapter.vnet")
            $Content = ($Content -notmatch "ethernet$Adapter.connectionType")
            Set-Content -Path $config -Value $Content
            $Addcontent = 'ethernet' + $Adapter + '.vnet = "' + $vnet + '"'
            #, 'ethernet' + $Adapter + '.connectionType = "custom"', 'ethernet' + $Adapter + '.wakeOnPcktRcv = "FALSE"', 'ethernet' + $Adapter + '.pciSlotNumber = "' + $PCISlot + '"', 'ethernet' + $Adapter + '.virtualDev = "e1000e"')
            Write-Verbose "setting $Addcontent"
            $Addcontent | Add-Content -Path $config
            $AddContent = 'Ethernet'+$Adapter+'.connectionType = "custom"'
            Write-Verbose "setting $Addcontent"
            $Addcontent | Add-Content -Path $config
            Write-Host -ForegroundColor Gray -NoNewline " ==>setting ethernet$Adapter to $Vnet for "
            Write-Host -ForegroundColor Magenta $VMXName -NoNewline
            Write-Host -ForegroundColor Green "[success]"
            $Object = New-Object psobject
            $Object | Add-Member -MemberType 'NoteProperty' -Name VMXname -Value $VMXName
            $Object | Add-Member -MemberType 'NoteProperty' -Name Adapter -Value "ethernet$Adapter"
            $Object | Add-Member -MemberType 'NoteProperty' -Name VirtualNet -Value $vnet
            $Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $config
            Write-Output $Object
        }
		else
        {
            Write-Warning "VM must be in stopped state"
        }
	}

    End {}

}