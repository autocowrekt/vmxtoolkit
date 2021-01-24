<#
function Set-VMXNetAdapterDisplayName
{
	[CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/Set-VMXNetAdapterDisplayName")]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Please Specify Valid Config File')]$config,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $False,
				   HelpMessage = 'Please Specify New Value for DisplayName')][Alias('Value')]$DisplayName,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateRange(0,9)][int]$Adapter	
		   
	)
	
	Begin
	{
		
		
	}
	Process
	{
        if ((get-vmx -Path $config).state -eq "stopped")
        {
        $Displayname = $DisplayName.replace(" ","_")
		$Content = Get-Content $config | Where-Object{ $_ -ne "" }
		$Content = $content | Where-Object{ $_ -NotMatch "^ethernet$($adapter).DisplayName" }
		$content += 'ethernet'+$adapter+'.DisplayName = "' + $DisplayName + '"'
		Set-Content -Path $config -Value $content -Force
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
		$Object | Add-Member -MemberType NoteProperty -Name "ethernet$($adapter).DisplayName" -Value $DisplayName
		Write-Output $Object
        }
		else
        {
        Write-Warning "VM must be in stopped state"
        }
	}
	End
	{
		
	}
}
#>