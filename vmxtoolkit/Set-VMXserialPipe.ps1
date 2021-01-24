function Set-VMXserialPipe
{
	[CmdletBinding()]
	param
	(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]$config,
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)][Alias('Clonename')]$VMXname,
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]$Path
	)

    begin {}
    
    process
    
    {
		if ((get-vmx -Path $config).state -eq "stopped")
        {
            $content = Get-Content -Path $config | Where-Object{ $_ -Notmatch "serial0"}
            $AddSerial = @('serial0.present = "True"', 'serial0.fileType = "pipe"', 'serial0.fileName = "\\.\pipe\\console"', 'serial0.tryNoRxLoss = "TRUE"')
            Set-Content -Path $config -Value $Content
            $AddSerial | Add-Content -Path $config
            $Object = New-Object psobject
            $Object | Add-Member -MemberType 'NoteProperty' -Name CloneName -Value $VMXname
            $Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $config
            $Object | Add-Member -MemberType 'NoteProperty' -Name Path -Value $Path
            
            Write-Output $Object
        }
		else
        {
            Write-Warning "VM must be in stopped state"
        }

	}
    
    end {}
}