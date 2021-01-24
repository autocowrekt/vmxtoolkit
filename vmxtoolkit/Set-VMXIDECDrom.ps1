function Set-VMXIDECDrom
{
	[CmdletBinding(DefaultParametersetName = "file",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param (
	[Parameter(ParameterSetName = "file", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
	[Alias('NAME','CloneName')]$VMXName,
	[Parameter(ParameterSetName = "file", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	$config,
	[Parameter(ParameterSetName = "file", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	[ValidateSet('0','1')]$IDEcontroller,
	[Parameter(ParameterSetName = "file", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	[ValidateSet('0','1')]$IDElun,
	[Parameter(ParameterSetName = "file", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	$ISOfile
	)
	begin
	{
	}
	process
		{
		$VMXConfig = Get-VMXConfig -config $config
		$IDEdevice = "ide$($IDEcontroller):$($IDElun)"
        $VMXConfig = $VMXConfig | Where-Object {$_ -NotMatch $IDEdevice}
        Write-Host -ForegroundColor Gray " ==>configuring $IDEdevice"		
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
		switch ($PsCmdlet.ParameterSetName)
		{
			"file"
			{
			$VMXConfig += $IDEdevice +'.startConnected = "TRUE"'
			$VMXConfig += $IDEdevice +'.present = "TRUE"'
			$VMXConfig += $IDEdevice +'.fileName = "'+$ISOfile+'"'
			$VMXConfig += $IDEdevice +'.deviceType = "cdrom-image"'
			$Object | Add-Member -MemberType NoteProperty -Name "$($IDEdevice).present" -Value True
			$Object | Add-Member -MemberType NoteProperty -Name "$($IDEdevice).startconnected" -Value True
			$Object | Add-Member -MemberType NoteProperty -Name "$($IDEdevice).type" -Value file
			$Object | Add-Member -MemberType NoteProperty -Name "$($IDEdevice).file" -Value $ISOfile
			}
			"raw"
			{}
		}

        $VMXConfig | Set-Content -Path $config
		Write-Output $Object
	}
	end { }

}#Set-VMXIDECDrom