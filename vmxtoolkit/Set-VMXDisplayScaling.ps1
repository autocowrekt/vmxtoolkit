function Set-VMXDisplayScaling {
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXMemory/")]
    param
    (
        <#name of the VMX #>
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$Path,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$enable
	)

    begin {}
    
    process
	{
    
        switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{ 
	    		$vmxconfig = Get-VMXConfig -VMXName $VMXname 
			}
			"2"
			{
		    	$vmxconfig = Get-VMXConfig -config $config
            }
		}
        
        if ((get-vmx -Path $config).state -eq "stopped" )
        {
            $vmxconfig = $vmxconfig -notmatch 'gui.applyHostDisplayScalingToGuest'
            $vmxconfig = $vmxconfig -notmatch 'unity.wasCapable'
            Write-Host -ForegroundColor Gray " ==>Setting Gui Scaleing To $($enable.IsPresent)"
            $vmxconfig += 'gui.applyHostDisplayScalingToGuest = "'+"$($enable.IsPresent)"+'"'
            $vmxconfig += 'unity.wasCapable = "'+"$($enable.IsPresent)"+'"'
            $vmxconfig | Set-Content $config
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Size -Value $Size
            $Object | Add-Member -MemberType NoteProperty -Name DisplayScaling -Value $($enable.IsPresent)
            Write-Output $Object
        }
        else
        {
            Write-Warning "VM must be in stopped state"
        }
	}
    
    end {}

}