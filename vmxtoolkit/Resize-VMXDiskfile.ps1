<#	
	.SYNOPSIS
	Resize-VMXDiskfile
	
	.DESCRIPTION
		Shrinks the VMS Disk File
	
	.EXAMPLE
		get-vmx test | get-vmxscsidisk | Resize-VMXDiskfile
	
	.NOTES
		requires VMXtoolkit loaded
#>
function Resize-VMXDiskfile
{
	[CmdletBinding(DefaultParametersetName = "1",HelpUri = "http://labbuildr.bottnet.de/modules")]
	param (
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
        
        Write-Warning "Shrinking $Diskfile"
	    & $Global:vmware_vdiskmanager -k $Diskfile
        Write-Verbose "Exitcode: $LASTEXITCODE"
	}
	end {}
}