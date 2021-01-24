<#
	.SYNOPSIS
		synopsis

	.DESCRIPTION
		description

	.PARAMETER  config
		A description of the config parameter.

	.EXAMPLE
		PS C:\> Disconnect-VMXNetworkAdapter -config $value1
		'This is the output'
		This example shows how to call the Set-VMXNetworkAdapter function with named parameters.

	.NOTES
		Additional information about the function or script.

#>
function Disconnect-VMXNetworkAdapter
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateRange(0,9)][int]$Adapter
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
                Write-Warning "Adapter not present" 
            }
            else
            {
                $Content = $Content -notmatch "ethernet$Adapter.StartConnected"
                $Content += 'ethernet'+$Adapter+'.StartConnected = "False"'
                $Content | Set-Content -Path $config
                $Object = New-Object -TypeName psobject
                $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
                $Object | Add-Member -MemberType NoteProperty -Name Adapter -Value "Ethernet$Adapter"
                $Object | Add-Member -MemberType NoteProperty -Name Connected -Value False
                Write-Output $Object
            }
        }
		else
        {
            Write-Warning "VM must be in stopped state"
        }
	}

    End {}
	
}