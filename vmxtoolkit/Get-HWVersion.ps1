function Get-VMXHWVersion
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/get-VMXHWVersion/")]
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
		$ObjectType = "HWversion"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = "virtualHW.version"
		$Value = Search-VMXPattern -Pattern "$patterntype" -vmxconfig $vmxconfig -value "HWVersion" -patterntype $patterntype
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name $ObjectType -Value $Value.HWVersion
		Write-Output $Object
	}
	end { }

}
