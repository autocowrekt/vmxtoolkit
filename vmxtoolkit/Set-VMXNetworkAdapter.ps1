<#
	.SYNOPSIS
		synopsis

	.DESCRIPTION
		description

	.PARAMETER  config
		A description of the config parameter.

	.EXAMPLE
		PS C:\> Set-VMXNetworkAdapter -config $value1
		'This is the output'
		This example shows how to call the Set-VMXNetworkAdapter function with named parameters.

	.NOTES
		Additional information about the function or script.

#>
function Set-VMXNetworkAdapter
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateRange(0,9)][int]$Adapter,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateSet('nat', 'bridged','custom','hostonly')]$ConnectionType,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateSet('e1000e','vmxnet3','e1000')]$AdapterType,
		[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][int]$PCISlot
	)
	
	Begin {}
	
	Process
	{
        if ((get-vmx -Path $config).state -eq "stopped")
        {
		    if (!$PCISlot)
            {
                $PCISlot = ((1+$Adapter) * 64)
            }
        
            $Content = Get-Content -Path $config
            Write-verbose "ethernet$Adapter.present"
            if (!($Content -match "ethernet$Adapter.present")) { Write-Warning "Adapter not present, will be added" }
            Write-Host -ForegroundColor Gray " ==>configuring Ethernet$Adapter as $AdapterType with $ConnectionType for " -NoNewline
            write-host -ForegroundColor Magenta $VMXName -NoNewline
            Write-Host -ForegroundColor Green "[success]"
            $Content = $Content -notmatch "ethernet$Adapter"
            $Addnic = @('ethernet'+$Adapter+'.present = "TRUE"')
            $Addnic += @('ethernet'+$Adapter+'.connectionType = "'+$ConnectionType+'"')
            $Addnic += @('ethernet'+$Adapter+'.wakeOnPcktRcv = "FALSE"')
            $Addnic += @('ethernet'+$Adapter+'.pciSlotNumber = "'+$PCISlot+'"')
            $Addnic += @('ethernet'+$Adapter+'.virtualDev = "'+$AdapterType+'"')
            $Content += $Addnic
            $Content | Set-Content -Path $config
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Adapter -Value "Ethernet$Adapter"
            $Object | Add-Member -MemberType NoteProperty -Name AdapterType -Value $AdapterType
            $Object | Add-Member -MemberType NoteProperty -Name ConnectionType -Value $ConnectionType
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config

            Write-Output $Object
        
            if ($ConnectionType -eq 'custom')
            {
                Write-Warning "Using Custom Network for Ethernet$($Adapter), make sure it is connect to the right VMNet (Set-VMXVNet)" 
            }
        }
		else
        {
            Write-Warning "VM must be in stopped state"
        }
	}
    
    End {}
	
}