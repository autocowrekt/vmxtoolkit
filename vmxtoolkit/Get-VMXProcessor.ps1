<#	
	.SYNOPSIS
		A brief description of the Get-VMXProcessor function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXProcessor function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXProcessor -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXProcessor
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXProcessor/")]
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
        
        $ErrorActionPreference = "silentlyContinue"
		$Objecttype = "Processor"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = "numvcpus"
		$Value = Search-VMXPattern -Pattern "$patterntype" -vmxconfig $vmxconfig -value $patterntype -patterntype $patterntype
		# $vmxconfig = Get-VMXConfig -VMXName $VMXname
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name $ObjectType -Value $Value.numvcpus
		Write-Output $Object
	}
    
    end {}
	
} #end Get-VMXProcessor