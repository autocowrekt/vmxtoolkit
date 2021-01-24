#mainMem.useNamedFile = "FALSE"#
<#
	.DESCRIPTION
		Sets the Memory in MB for a VM
#>
function Set-VMXMainMemory 
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Set-VMXMEMFile/")]
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][switch]$usefile
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
            
            Write-Host -ForegroundColor Gray " ==>setting MainMemoryUseFile to $($usefile.IsPresent) for " -NoNewline
            Write-Host -ForegroundColor Magenta $vmxname -NoNewline
            Write-Verbose "We got to set mainMem.useNamedFile to $($usefile.IsPresent) "
            $vmxconfig = $vmxconfig | Where-Object{$_ -NotMatch "mainMem.useNamedFile"}
            
            If ($usefile.IsPresent)
            {
                $vmxconfig += 'mainMem.useNamedFile = "TRUE"'
            }
            else
            {
                $vmxconfig += 'mainMem.useNamedFile = "FALSE"'
            }

            $vmxconfig | Set-Content -Path $config
            Write-Host -ForegroundColor Green "[success]"
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name UseMemFile -Value $($usefile.IsPresent)
            Write-Output $Object
        }
        else
        {
            Write-Warning "VM must be in stopped state"
        }
	}
    
    end {}
    
} 
