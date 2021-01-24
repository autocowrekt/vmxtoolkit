<#
	.SYNOPSIS
		A brief description of the Set-VMXserial function.

	.DESCRIPTION
		A detailed description of the Set-VMXserial function.

	.PARAMETER  config
		A description of the config parameter.

	.PARAMETER  VMXname
		A description of the VMXname parameter.

	.EXAMPLE
		PS C:\> Set-VMXserial -config $value1 -VMXname $value2
		'This is the output'
		This example shows how to call the Set-VMXserial function with named parameters.

	.NOTES
		Additional information about the function or script.

#>
function Remove-VMXserial
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
		
		$content = Get-Content -Path $config | Where-Object{ $_ -Notmatch "serial0" }
		#	$AddSerial = @('serial0.present = "True"', 'serial0.fileType = "pipe"', 'serial0.fileName = "\\.\pipe\\console"', 'serial0.tryNoRxLoss = "TRUE"')
		Set-Content -Path $config -Value $Content
		#	$AddSerial | Add-Content -Path $config
		$Object = New-Object psobject
		$Object | Add-Member -MemberType 'NoteProperty' -Name CloneName -Value $VMXname
		$Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $config
		$Object | Add-Member -MemberType 'NoteProperty' -Name Path -Value $Path
		
		Write-Output $Object
	}
    
    end {}
    
}