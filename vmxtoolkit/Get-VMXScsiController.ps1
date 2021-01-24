    <#	
	.SYNOPSIS
		A brief description of the Get-VMXScsiController function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXScsiController function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXScsiController -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXScsiController 
{
[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXScsiController/")]
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]	
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "3", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$vmxconfig
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
		
		$ObjectType = "SCSIController"
		$patterntype = ".virtualDev"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$Value = Search-VMXPattern -Pattern "scsi\d{1,2}$patterntype" -vmxconfig $vmxconfig -name "Controller" -value "Type" -patterntype $patterntype
        
        foreach ($controller in $Value)
        {
            $Object = New-Object -TypeName psobject
		    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXname
		    $Object | Add-Member -MemberType NoteProperty -Name SCSIController -Value $Controller.Controller
		    $Object | Add-Member -MemberType NoteProperty -Name Type -Value $Controller.Type
		    Write-Output $Object
        }
	}
    
    end {}
		
}#end Get-VMXScsiController

