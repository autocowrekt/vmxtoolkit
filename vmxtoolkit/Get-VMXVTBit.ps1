<#	
	.SYNOPSIS
		A brief description of the Get-VMXVTBit function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXVTBit function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXVTBit -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>

function Get-VMXVTBit
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://github.com/bottkars/vmxtoolkit/wiki/Get-VMXVTBit")]
    param 
    (
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
		[Parameter(ParameterSetName = "1", Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $True)]
		[Alias('NAME','CloneName')]$VMXName,
		[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
		[Parameter(ParameterSetName = "3", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$vmxconfig
	)
    
    begin {}
	
	process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{
                $vmxconfig = Get-VMXConfig -VMXName $VMXname
            }
			"2"
			{ 
			    $vmxconfig = Get-VMXConfig -config $config
			}
		}	
        
        $ObjectType = "vhv"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = ".enable"
		$Value = Search-VMXPattern -Pattern "$ObjectType$patterntype" -vmxconfig $vmxconfig -name "Type" -value $ObjectType -patterntype $patterntype
		#$Value = Search-VMXPattern  -Pattern "uuid.bios" -vmxconfig $vmxconfig -Name "Type" -value $ObjectType -patterntype $patterntype -nospace

		$Object = New-Object -TypeName psobject
		# $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXName
        
        if (!$Value.vhv)
		{
			$Object | Add-Member -MemberType NoteProperty -Name VTbit -Value False
		}
		else
		{
			$Object | Add-Member -MemberType NoteProperty -Name VTbit -Value $($Value.vhv)
		}

		$Object | Add-Member -MemberType NoteProperty -Name Config -Value (Get-ChildItem -Path $Config)
		Write-Output $Object
	}
    
    end {}
    
}#end Get-VMXVTBit