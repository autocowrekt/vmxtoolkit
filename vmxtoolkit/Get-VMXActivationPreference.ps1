<#
		.SYNOPSIS
			

		.DESCRIPTION
			Get the Activation Preference Number

		.PARAMETER  VMXname
			Optional, name of the VMX

		.PARAMETER  Config
			requires, the Config File Path

		.EXAMPLE
			PS C:\> Get-VMX dcnode | get-vmxactivationpreference

		.INPUTS

		.OUTPUTS

#>	
function Get-VMXActivationPreference
{
	[CmdletBinding(DefaultParameterSetName = 1,HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXActivationPreference/")]
	[OutputType([psobject])]
	param
	(
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('NAME','CloneName')][string]$VMXName,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]$Path
	)
    
    begin {}
    
	process
	{
        $vmxconfig = Get-VMXConfig -config $config	    
		$ObjectType = "ActivationPreference"
		$patterntype = "ActivationPreference"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$Value = Search-VMXPattern -Pattern $patterntype -vmxconfig $vmxconfig  -value $patterntype -patterntype $patterntype
        $Object = New-Object -TypeName psobject
        $Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
        $Object | Add-Member -MemberType NoteProperty -Name $ObjectType -Value $Value.ActivationPreference
        $Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config
        $Object | Add-Member -MemberType NoteProperty -Name Path -Value $Path
        Write-Output $Object
	}
    
    end {}
}