<#	
	.SYNOPSIS
	Get-VMwareversion
	.DESCRIPTION
		Displays version Information on installed VMware version
	.EXAMPLE
		PS C:\> Get-VMwareversion
	.NOTES
		requires VMXtoolkit loaded
#>


function Get-VMwareVersion
{
	[CmdletBinding(HelpUri = "http://labbuildr.bottnet.de/modules/get-vmwareversion/")]
	param ()

    begin {}

    process {}

    end 
    {
        Write-Output $vmwareversion
    }
} 