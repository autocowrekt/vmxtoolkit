function Get-VMXConfigVersion
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXConfigVersion/")]
	param (
	[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]	
	[Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
	[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
	[Parameter(ParameterSetName = "3", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$vmxconfig
	)
	begin
	{
	}
	process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{ $vmxconfig = Get-VMXConfig -VMXName $VMXname }
			"2"
			{ $vmxconfig = Get-VMXConfig -config $config }
		}
		$ObjectType = "ConfigVersion"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = "config.version"
		$Value = Search-VMXPattern -Pattern "$patterntype" -vmxconfig $vmxconfig -value "Config" -patterntype $patterntype
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name $ObjectType -Value $Value.config
		Write-Output $Object
	}
	end { }

}#end get-vmxConfigVersion