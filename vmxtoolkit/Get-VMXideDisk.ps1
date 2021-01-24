<#	
	.SYNOPSIS
		A brief description of the Get-VMXideDisk function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXideDisk function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXideDisk -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXIdeDisk
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXIdeDisk/")]
    param 
    (
	    [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]	
	    [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
	    [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
	    [Parameter(ParameterSetName = "3", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$vmxconfig
	)
    
    begin {}
	
	Process
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
        
        $ObjectType = "IDEDisk"
		$Patterntype = ".fileName"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$Value = Search-VMXPattern -Pattern "ide\d{1,2}:\d{1,2}$Patterntype" -vmxconfig $vmxconfig -name "IDEAddress" -value "Disk" -patterntype $Patterntype
        
        foreach ($IDEDisk in $Value)
        {
            $Object = New-Object -TypeName psobject
		    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		    $Object | Add-Member -MemberType NoteProperty -Name IDEAddress -Value $IDEDisk.IDEAddress
		    $Object | Add-Member -MemberType NoteProperty -Name Disk -Value $IDEDisk.Disk

		    Write-Output $Object
        }
	}
    
    end {}

}
####
#scsi0.virtualDev = "pvscsi"