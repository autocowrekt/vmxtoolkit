function Set-VMXScenario
{
	[CmdletBinding()]
	param
	(
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]$path,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $false)][ValidateRange(1,9)][int]$Scenario,
		[Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $False)][Validatelength(1, 10)][string]$Scenarioname
	)
	
	Begin {}

	Process
	{
		if ((get-vmx -Path $config).state -eq "stopped")
        {
            Copy-Item -Path $config -Destination "$($config).bak"
            $Content = Get-Content -Path $config
            $Content = ($Content -notmatch "guestinfo.Scenario$Scenario")
            $content += 'guestinfo.scenario'+$Scenario+' = "'+$ScenarioName+'"'
            Set-Content -Path $config -Value $Content
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMX.VMXname
            $Object | Add-Member -MemberType NoteProperty -Name Scenario -Value $Scenario
            $Object | Add-Member -MemberType NoteProperty -Name Scenarioname -Value $scenarioname
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config
            $Object | Add-Member -MemberType NoteProperty -Name Path -Value $Path
            Write-Output $Object
            # $content
        }
		else
        {
          Write-Warning "VM must be in stopped state"
        }
	}

    End {}
}