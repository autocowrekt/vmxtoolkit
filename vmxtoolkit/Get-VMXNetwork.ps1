<#	
	.SYNOPSIS
		A brief description of the Get-VMXNetwork function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXNetwork function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXNetwork -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXNetwork
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXNetwork/")]
    param
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]	
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
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
                $vmxconfig = Get-VMXConfig -VMXName $VMXName
            }
		    "2"
		    {
                $vmxconfig = Get-VMXConfig -config $config
            }
	    }
    
        $patterntype = ".vnet"
        $ObjectType = "Network"
        $ErrorActionPreference = "silentlyContinue"
        Write-Verbose -Message "getting Network Controller"
        $Networklist = Search-VMXPattern -Pattern "ethernet\d{1,2}$patterntype" -vmxconfig $vmxconfig -name "Adapter" -value $ObjectType -patterntype $patterntype
        
        foreach ($Value in $Networklist)
        {
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Adapter -Value $Value.Adapter
            $Object | Add-Member -MemberType NoteProperty -Name Network -Value $Value.Network
            Write-Output $Object
        }
    }
    
    end {}

}#end Get-VMXNetwork