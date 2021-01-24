function Set-VMXToolsReminder {
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXMemory/")]
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Switch]$enabled
	)
    
    begin {}
    
    process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{
                $vmxconfig = Get-VMXConfig -VMXName $VMXname
            }
			"2"
			{
                $vmxconfig = Get-VMXConfig -config $config
            }
		}
        
        if ((get-vmx -Path $config).state -eq "stopped" )
        {
            Write-Verbose "We got to set Tools Reminder to $enabled"
            $vmxconfig = $vmxconfig | Where-Object{$_ -NotMatch "tools.remindInstall"}
            $vmxconfig += 'tools.remindInstall = "'+$enabled+'"'
            $vmxconfig | Set-Content -Path $config
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name ToolsReminder -Value $enabled
            Write-Output $Object
        }
        else
        {
          Write-Warning "VM must be in stopped state"
        }
	}
    
    end {}
    
} 