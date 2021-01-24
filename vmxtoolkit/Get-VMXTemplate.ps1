<#
	.SYNOPSIS
		A brief description of the Get-VMXTemplate function.

	.DESCRIPTION
		Gets Template VM(s) for Rapid Cloning

	.PARAMETER  TemplateName
		Please Specify Template Name

	.PARAMETER  VMXUUID
		A description of the VMXUUID parameter.

	.PARAMETER  ConfigPath
		A description of the ConfigPath parameter.

	.EXAMPLE
		PS C:\> Get-VMXTemplate -TemplateName $value1 -VMXUUID $value2
		'This is the output'
		This example shows how to call the Get-VMXTemplate function with named parameters.

	.OUTPUTS
		psobject

	.NOTES
		Additional information about the function or script.

#>
function Get-VMXTemplate
{
	[CmdletBinding(DefaultParameterSetName = '1',HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	[OutputType([psobject])]
	param
	(
		[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config
	)
    
    begin {}

	process
	{

		$Content = Get-Content $config | Where-Object{ $_ -ne '' }
		if ($content -match 'templateVM = "TRUE"')
		{
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name TemplateName -Value (Get-ChildItem $config).basename
            $Object | Add-Member -MemberType NoteProperty -Name GuestOS -Value (Get-VMXGuestOS -config $config).GuestOS
            $Object | Add-Member -MemberType NoteProperty -Name UUID -Value (Get-VMXUUID -config $config).uuid
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
            $Object | Add-Member -MemberType NoteProperty -Name Template -Value $true
		}
	
	    Write-Output $Object
	}
    
    end {}
	
}