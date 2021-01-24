function Set-VMXScsiController 
{
    [CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Set-VMXScsiController/")]
    param 
    (
    	[Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
    	[Parameter(ParameterSetName = "1", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
	    [ValidateRange(0,3)]$SCSIController=0,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
	    [ValidateSet('pvscsi','lsisas1068','lsilogic')]$Type="pvscsi"
	)
    
    begin {}
	
	process
	{
        
        if ((get-vmx -Path $config).state -eq "stopped")
        { 
            $content = Get-VMXConfig -config $config
            $Content = $content -notmatch "scsi$SCSIController.present"
            $Content = $Content -notmatch "scsi$SCSIController.virtualDev"
            $Content = $Content += 'scsi'+$SCSIController+'.virtualDev = "'+$Type+'"'
            $Content = $Content += 'scsi'+$SCSIController+'.present = "TRUE"'
            $Content | Set-Content -Path $config
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXname
            $Object | Add-Member -MemberType NoteProperty -Name SCSIController -Value $SCSIController
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
            $Object | Add-Member -MemberType NoteProperty -Name Type -Value $Type
            Write-Output $Object
        }
    	else
        {
            Write-Warning "VM must be in stopped state"
        }
	}
    
    end {}
	
}#end Set-VMXScsiController