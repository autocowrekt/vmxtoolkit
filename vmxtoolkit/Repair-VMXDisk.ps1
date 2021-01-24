function Repair-VMXDisk
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

        Write-Warning "Repairing $Diskfile"
	    & $Global:vmware_vdiskmanager -R $Diskfile | Out-Null
        Write-Verbose "Exitcode: $LASTEXITCODE"
	}
    
    end {}

}#end get-vmxConfigVersion