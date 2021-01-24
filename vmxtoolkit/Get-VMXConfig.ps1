<#	
	.SYNOPSIS
		A brief description of the Get-VMXConfig function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXConfig function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXConfig -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXConfig
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXConfig/")]
    param
    (
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
    #	[Parameter(ParameterSetName = "2", Mandatory = $false, Position = 1,  ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateScript({ Test-Path -Path $_ })]$Path,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config
    #	[Parameter(ParameterSetName = "2", Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $True)]$config
    )
    
    begin
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{
                $config = "$path\$VMXname.vmx" 
            }
		}
	}
    
    process
    {
        $vmxconfig = Get-Content $config
        Write-Output $vmxconfig
    }

    end{}

}#end get-vmxconfig