<#
	.SYNOPSIS
		A brief description of the Suspend-VMX function.

	.DESCRIPTION
		A detailed description of the Suspend-VMX function.

	.PARAMETER  name
		Name of the VM

	.EXAMPLE
		PS C:\> Suspend-VMX -name 'Value1'
		'This is the output'
		This example shows how to call the Suspend-VMX function with named parameters.

	.NOTES
		Additional information about the function or script.

#>
function Suspend-VMX
{
	[CmdletBinding(DefaultParameterSetName = '2',HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $True)][Alias('VMXUUID')][string]$UUID,
		[Parameter(ParameterSetName = "3", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
		[Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$Path
        <#
		[Parameter(Mandatory = $true,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,HelpMessage = 'Specify name for the VM to Suspend',				   ParameterSetName = '1')]
		[Alias('NAME','CloneName')]
		[string]$VMXname
        #>
	)
	
	Begin {}
	
	Process
	{
		if (($vmx = Get-VMX -Path $Path ) -and ($vmx.state -eq "running"))
			{
				Write-Verbose "Checking State for $($vmx.vmxname)  : $($vmx.state)"
				$Origin = $MyInvocation.MyCommand
    
                do
			    {
                    $cmdresult = &$vmrun suspend $vmx.config # 2>&1 | Out-Null
                    write-verbose "$Origin suspend $VMXname $cmdresult"
                }
				until ($VMrunErrorCondition -notcontains $cmdresult)
        
                $VMXSuspendtime = Get-Date -Format "MM.dd.yyyy hh:mm:ss"
				$Object = New-Object psobject
				$Object | Add-Member -Type 'NoteProperty' -Name VMXname -Value $VMX.VMXname
				$Object | Add-Member -Type 'NoteProperty' -Name Status -Value "Suspended"
                $Object | Add-Member -Type 'NoteProperty' -Name Suspendtime -Value $VMXSuspendtime
                Write-Output $Object
                $content = Get-Content $vmx.config | Where-Object { $_ -ne "" }
	    		$content = $content | Where-Object { $_ -NotMatch "guestinfo.suspendtime" }
	    		$content += 'guestinfo.suspendtime = "' + $VMXSuspendtime + '"'
                Start-Sleep 2
	    		Set-Content -Path $vmx.config -Value $content -Force
			}		
	}#end process
}#end function