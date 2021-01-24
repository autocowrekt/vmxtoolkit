function Set-VMXnestedHVEnabled
{
	[CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/Set-VMXVTBit")]
	param
	(
		[Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,HelpMessage = 'Please Specify Valid Config File')]$config,
		[Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $False)][switch]$nestedHVEnabled,
		[Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]
		[string]$VMXName
	)
	
	Begin {}
	
	Process
	{
        if ((get-vmx -Path $config).state -eq "stopped")
        {
            Write-Host -ForegroundColor Gray " ==>setting Virtual VTbit to $($VTBit.IsPresent.ToString()) for " -NoNewline
            Write-Host -ForegroundColor Magenta $vmxname -NoNewline
            Write-Host -ForegroundColor Green "[success]"
            $Content = Get-Content $config | Where-Object { $_ -ne "" }
            $Content = $content | Where-Object { $_ -NotMatch "vhv.enable" }
            $content += 'nestedHVEnabled = "' + $nestedHVEnabled.IsPresent.ToString() + '"'
            Set-Content -Path $config -Value $content -Force
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
            $Object | Add-Member -MemberType NoteProperty -Name "nestedHVEnabled" -Value $VTBit.IsPresent.ToString()
            Write-Output $Object
        }
		else
        {
            Write-Warning "VM must be in stopped state"
        }
	}
	End {}
		
}