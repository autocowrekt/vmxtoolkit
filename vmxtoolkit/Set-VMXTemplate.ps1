<#
	.SYNOPSIS
		A brief description of the Set-vmxtemplate function.

	.DESCRIPTION
		A detailed description of the Set-vmxtemplate function.

	.PARAMETER  vmxname
		A description of the vmxname parameter.

	.PARAMETER  config
		A description of the config parameter.

	.EXAMPLE
		PS C:\> Set-vmxtemplate -vmxname $value1 -config $value2
		'This is the output'
		This example shows how to call the Set-vmxtemplate function with named parameters.

	.NOTES
		Additional information about the function or script.
#>

function Set-VMXTemplate
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param
    (
		[Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('vmxconfig')]$config,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
        [Parameter(Mandatory = $false)][switch]$unprotect
		# [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config
	)
    
    begin {}
	
	process
	{
		if ((get-vmx -Path $config).state -eq "stopped")
        {
			if (Test-Path $config)
			{
                Write-verbose $config
                $content = Get-Content -Path $config | Where-Object { $_ -ne "" }
                $content = $content | Where-Object{ $_ -NotMatch "templateVM" }
                $Object = New-Object psobject
                $Object | Add-Member -Type 'NoteProperty' -Name VMXName -Value $VMXName	
                $Object | Add-Member -Type 'NoteProperty' -Name VMXconfig -Value $config			
                
                if ($unprotect.IsPresent)
                {
                    Write-Host -ForegroundColor Gray " ==>releasing Template mode for " -NoNewline
                    Write-Host -ForegroundColor Magenta $VMXName -NoNewline
                    $content += 'templateVM = "FALSE"'
                    $Object | Add-Member -Type 'NoteProperty' -Name Template -Value $False
                }
                else
                {
                    Write-Host -ForegroundColor Gray " ==>setting Template mode for " -NoNewline
                    Write-Host -ForegroundColor Magenta $VMXName -NoNewline
                    $content += 'templateVM = "TRUE"'
                    $Object | Add-Member -Type 'NoteProperty' -Name Template -Value $True
                }
                
                Set-Content -Path $config -Value $content -Force
                Write-Host -ForegroundColor Green "[success]"
                Write-Output $Object
            }
        }
        else
        {
            Write-Warning "VM must be in stopped state"
        }
    }
    
    end {}
        
}