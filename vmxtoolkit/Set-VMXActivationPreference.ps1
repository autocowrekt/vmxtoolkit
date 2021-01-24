<#
		.SYNOPSIS
			

		.DESCRIPTION
			Set the Activation Preference Number

		.PARAMETER  VMXname
			Optional, name of the VMX

		.PARAMETER  Config
			requires, the Config File Path

        .PARAMETER activationpreference
            Activation numer from 0 to 9
		.EXAMPLE
			PS C:\> Get-VMX dcnode | Set-vmxactivationpreference $activationpreference 0

		.EXAMPLE
			PS C:\> Get-Something 'One value' 32

		.INPUTS

		.OUTPUTS

#>	

function Set-VMXActivationPreference
{
	[CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/Set-VMXActivationPreference/")]
	param
	(   [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]$path,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $false)][ValidateRange(0,99)][alias ('apr')][int]$activationpreference
		
	)
	
	Begin {}

	Process
	{
		if ((get-vmx -Path $config).state -eq "stopped")
        {
            Copy-Item -Path $config -Destination "$($config).bak"
            $Content = Get-Content -Path $config
            $Content = ($Content -notmatch "guestinfo.activationpreference")
            $content += 'guestinfo.activationpreference = "' + $activationpreference + '"'
            Set-Content -Path $config -Value $Content
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
            $Object | Add-Member -MemberType NoteProperty -Name ActivationPreference -Value $activationpreference
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config
            $Object | Add-Member -MemberType NoteProperty -Name Path -Value $Path
            Write-Output $Object
        }
		else
        {
            Write-Warning "VM must be in stopped state"
        }
	}

    End	{}
    
}