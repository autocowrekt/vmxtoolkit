function Set-VMXDisconnectIDE
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param (
	[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
	[Parameter(ParameterSetName = "2", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]$config

	)
	begin
	{
	}
	process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{}
			"2"
			{}
		}
		$VMXConfig = Get-VMXConfig -config $config
        $VMXConfig = $VMXConfig | Where-Object {$_ -NotMatch "ide0:0.startConnected"}
        Write-Verbose -Message "Disabling IDE0"
		$VMXConfig += 'ide0:0.startConnected = "FALSE"'
        $VMXConfig | Set-Content -Path $config
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
		$Object | Add-Member -MemberType NoteProperty -Name IDE0:0 -Value disabled

		Write-Output $Object
	}
	end { }

}#Set-VMXDisconnectIDE