<#
	.DESCRIPTION
		Sets the Memory in MB for a VM
#>
function Set-VMXmemory 
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXMemory/")]
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Validaterange(8,131072)][int]$MemoryMB
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
            Write-Verbose "We got to set $MemoryMB MB"
            $vmxconfig = $vmxconfig | Where-Object{$_ -NotMatch "memsize"}
            $vmxconfig += 'memsize = "'+$MemoryMB+'"'
            $vmxconfig | Set-Content -Path $config
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Memory -Value $MemoryMB
            Write-Output $Object
        }
        else
        {
          Write-Warning "VM must be in stopped state"
        }
	}
    
    end {}
    
} 


