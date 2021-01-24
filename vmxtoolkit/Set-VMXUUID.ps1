function Set-VMXUUID
{
	[CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/Set-VMXUUID")]
	param
	(
		[Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true,HelpMessage = 'Please Specify Valid Config File')]$config,
		[Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $False,HelpMessage = 'Please Specify New Value for UUID')] [ValidatePattern('^[0-9a-f]{16}-[0-9a-f]{16}$')][Alias('Value')]$UUID
	)
	
	Begin {}
	
	Process
	{
        if ((get-vmx -Path $config).state -eq "stopped")
        {
            $Content = Get-Content $config | Where-Object { $_ -ne "" }
            $Content = $content | Where-Object { $_ -NotMatch "uuid.bios" }
            $content += 'uuid.bios = "' + $UUID + '"'
            Set-Content -Path $config -Value $content -Force
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
            $Object | Add-Member -MemberType NoteProperty -Name UUID -Value $UUID
            Write-Output $Object
        }
		else
        {
          Write-Warning "VM must be in stopped state"
        }
	}
    
    End {}
	
}