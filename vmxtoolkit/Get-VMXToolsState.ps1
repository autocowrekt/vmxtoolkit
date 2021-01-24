function Get-VMXToolsState
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
		
        if ($vmwareversion.major -gt 9)
        {

        switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{}
			"2"
			{}
		}
		Write-Verbose -Message "getting Toolsstate from $config"
		$cmdresult = .$vmrun checkToolsState $config
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
		$Object | Add-Member -MemberType NoteProperty -Name State -Value $cmdresult

		Write-Output $Object
        }
        else
            {
             Write-Warning "VMware Workstation 9 or less does not support the check of Tools State. Recommended Action: Upgrade to VMware 10 greater"
             }
	}
	end { }

}#end get-VMXToolState