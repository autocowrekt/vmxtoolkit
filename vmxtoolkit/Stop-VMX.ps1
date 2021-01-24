<#	
	.SYNOPSIS
		A brief description of the Stop-VMX function.
	
	.DESCRIPTION
		A detailed description of the Stop-VMX function.
	
	.PARAMETER Mode
		Valid modes are Soft ( shutdown ) or Stop (Poweroff)
	
	.PARAMETER Name
		A description of the Name parameter.
	
	.EXAMPLE
		PS C:\> Stop-VMX -Mode $value1 -Name 'Value2'
	
	.NOTES
		Additional information about the function.
#>
function Stop-VMX
{
	[CmdletBinding(DefaultParameterSetName = '2',HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param 
    (
		[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $True)]
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $True)]
        [Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(ParameterSetName = "1", Mandatory = $false,ValueFromPipelineByPropertyName = $True)]
        [Alias('VMXUUID')][string]$UUID,
		[Parameter(ParameterSetName = "2", Mandatory = $true,ValueFromPipelineByPropertyName = $True)]$config,
		[Parameter(HelpMessage = "Valid modes are Soft ( shutdown ) or Stop (Poweroff)", Mandatory = $false)]
		[ValidateSet('Soft', 'Hard')]$Mode
    )

    begin {}
		
	process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{ 
                Write-Verbose "Getting vmx by Config and UUID"
                $vmx = Get-VMX -VMXName $VMXname -UUID $UUID  -Path $config
				$state = $VMX.state
           	}
			"2"
			{
                Write-Verbose "Parameter Set 2"
                Write-Verbose "Config: $config"
                $state = (get-vmx -config $config).state
            }    
        }
			
    Write-Verbose "State for $($VMXname) : $State"

	if ($state -eq "running")
	{
    $Origin = $MyInvocation.MyCommand
	do
        {
	
		($cmdresult = &$vmrun stop $config $Mode) # 2>&1 | Out-Null
		Write-Verbose "$Origin $vmxname $cmdresult"
	    }
	until ($VMrunErrorCondition -notcontains $cmdresult)
	$Object = New-Object psobject
	$Object | Add-Member -Type 'NoteProperty' -Name VMXname -Value $VMXname
	$Object | Add-Member -Type 'NoteProperty' -Name Status -Value "Stopped $Mode"
	Write-Output $Object

    } # end if-vmx
    else 
        {
        Write-Warning "VM $vmxname not running"
        } # end if-vmx
#}#end foreach
} # end process
}
