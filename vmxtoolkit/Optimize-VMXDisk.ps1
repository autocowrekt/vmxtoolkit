<#	
	.SYNOPSIS
        Optimize-VMXDisk
	
	.DESCRIPTION
		Shrinks the VMS Disk File
	
	.EXAMPLE
		get-vmx test | get-vmxscsidisk | Optimize-VMXDisk
	
	.NOTES
		requires VMXtoolkit loaded
#>
function Optimize-VMXDisk
{
	[CmdletBinding(DefaultParametersetName = "1",HelpUri = "http://labbuildr.bottnet.de/modules")]
    param 
    (
    	[Parameter(ParameterSetName = "1", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]$DiskPath,
        [Parameter(ParameterSetName = "1", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]$Disk,
        [Parameter(ParameterSetName = "2", Mandatory = $True, ValueFromPipelineByPropertyName = $false)]$Diskfile
	)
	begin {}
	
	process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{
                $Diskfile = Join-Path $DiskPath $Disk
            }
                default
            {

            }
		}

        Write-Warning "Defragmenting $Diskfile"
	    & $Global:vmware_vdiskmanager -d $Diskfile
        Write-Verbose "Exitcode: $LASTEXITCODE"
		
	}

    end {}

}