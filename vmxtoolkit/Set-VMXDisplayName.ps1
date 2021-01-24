<#
	.SYNOPSIS
		A brief description of the Set-VMXDisplayName function.

	.DESCRIPTION
		Sets the VMX Friendly DisplayName

	.PARAMETER  config
		Please Specify Valid Config File

	.EXAMPLE
		PS C:\> Set-VMXDisplayName -config $value1
		'This is the output'
		This example shows how to call the Set-VMXDisplayName function with named parameters.

	.NOTES
		Additional information about the function or script.

#>
function Set-VMXDisplayName {
    [CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/Set-VMXDisplayName")]
    param
    (
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,HelpMessage = 'Please Specify Valid Config File')]$config,
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $False,HelpMessage = 'Please Specify New Value for DisplayName')][Alias('Value')]$DisplayName
    )
	
    Begin {}

    Process 
    {
        if ((get-vmx -Path $config).state -eq "stopped") 
        {
            $Displayname = $DisplayName.replace(" ", "_")
            $Content = Get-Content $config | Where-Object { $_ -ne "" }
            $Content = $content | Where-Object { $_ -NotMatch "^DisplayName" }
            $content += 'DisplayName = "' + $DisplayName + '"'
            Set-Content -Path $config -Value $content -Force
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
            $Object | Add-Member -MemberType NoteProperty -Name DisplayName -Value $DisplayName
            Write-Output $Object
        }
        else 
        {
            Write-Warning "VM must be in stopped state"
        }
    }

    End {}

}