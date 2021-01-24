function Get-VMXscenario
{
	[CmdletBinding(DefaultParameterSetName = '1')]
	[OutputType([psobject])]
	param
	(
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $False, ValueFromPipelineByPropertyName = $True)]$Path
	)
    
    begin {}

	process
	{
  	    $vmxconfig = Get-VMXConfig -config $config
		$ObjectType = "Scenario"
		$patterntype = ".scenario\d{1,9}"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$Value = Search-VMXPattern -Pattern "guestinfo.scenario\d{1,9}" -vmxconfig $vmxconfig -name "Scenario" -value "Scenarioname" -patterntype $patterntype
        
        foreach ($Scenarioset in $value)
		{
			$Object = New-Object -TypeName psobject
			$Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
            $Object | Add-Member -MemberType NoteProperty -Name Scenario -Value $Scenarioset.Scenario.Trimstart("guestinfo.scenario")
			$Object | Add-Member -MemberType NoteProperty -Name Scenarioname -Value $Scenarioset.scenarioname
			$Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config
            $Object | Add-Member -MemberType NoteProperty -Name Path -Value $Path
			Write-Output $Object
		}
            
	}
    
    end {}
}