function Get-VMXNetworkAddress
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
		$patterntype = ".generatedAddress"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$Value = Search-VMXPattern -Pattern "ethernet\d{1,2}$patterntype " -vmxconfig $vmxconfig -name "Adapter" -value "Address" -patterntype $patterntype
        
        foreach ($Adapter in $value)
		{
			$Object = New-Object -TypeName psobject
			$Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
			$Object | Add-Member -MemberType NoteProperty -Name Adapter -Value $Adapter.Adapter
			$Object | Add-Member -MemberType NoteProperty -Name Address -Value $Adapter.Address
			Write-Output $Object
		}
	}
    
    end {}
    
}#end Get-VMXNetworkAdapter