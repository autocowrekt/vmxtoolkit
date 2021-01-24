function Get-VMXSnapshot
{
	[CmdletBinding(DefaultParametersetName = "2",
    HelpUri = "http://labbuildr.bottnet.de/modules/get-vmxsnapshot/" )]
	param
	(
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('TemplateName')][string]$VMXName,
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$Path = "$Global:vmxdir",
		[Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$config,
        [Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][switch]$Tree
	)
	
	
	Begin {}
	
	Process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{
                $config = Get-VMX -VMXName $VMXname -Path $Path
            }
			"2"
			{
			    #$snapconfig = $config
			}
		}
		
		if ($Tree.IsPresent)
        {
            $parameter = "showTree"
        }
		if ($config)
		{
			do
            {
				($cmdresult = &$vmrun listsnapshots $config $parameter) 2>&1 | Out-Null
            }
			until ($VMrunErrorCondition -notcontains $cmdresult)

            Write-Verbose $cmdresult[0]
			Write-Verbose $cmdresult[1]
			Write-Verbose $cmdresult.count

            If ($cmdresult.count -gt 1)
            {
				$Snaphots = $cmdresult[1..($cmdresult.count)]

                foreach ($Snap in $Snaphots)
                {
					$Object = New-Object psobject
					$Object | Add-Member -Type 'NoteProperty' -Name VMXname -Value (Get-ChildItem -Path $Config).Basename
					$Object | Add-Member -Type 'NoteProperty' -Name Snapshot -Value $Snap
				    $Object | Add-Member -Type 'NoteProperty' -Name Config -Value $Config
				    $Object | Add-Member -MemberType NoteProperty -Name Path -Value (Get-ChildItem -Path $Config).Directory
				    Write-Output $Object
                }
            }
            else
            {
                Write-Warning "No Snapshot found for VMX $VMXName"
            }
		}
	}
    
    End {}
	
}