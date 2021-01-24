<#	
	.SYNOPSIS
		A brief description of the Get-VMXNetworkAdapter function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXNetworkAdapter function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the Name parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXNetworkAdapter -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXNetworkAdapter
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXNetworkAdapter/")]
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
                $vmxconfig = Get-VMXConfig -VMXName $VMXName
            }
			"2"
			{
                $vmxconfig = Get-VMXConfig -config $config
            }
		}	
        
        $ObjectType = "NetworkAdapter"
		$patterntype = ".virtualDev"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$Value = Search-VMXPattern -Pattern "ethernet\d{1,2}.virtualdev" -vmxconfig $vmxconfig -name "Adapter" -value "Type" -patterntype $patterntype
        
        foreach ($Adapter in $value)
		{
			$Object = New-Object -TypeName psobject
			$Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
			$Object | Add-Member -MemberType NoteProperty -Name Adapter -Value $Adapter.Adapter
			$Object | Add-Member -MemberType NoteProperty -Name Type -Value $Adapter.type
			$Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
			Write-Output $Object
		}
	}
    
    end {}
    
}#end Get-VMXNetworkAdapter