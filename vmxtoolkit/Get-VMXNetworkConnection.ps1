function Get-VMXNetworkConnection
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXNetworkConnection")]
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
                $vmxconfig = Get-VMXConfig -VMXName $VMXname
            }
			"2"
			{
                $vmxconfig = Get-VMXConfig -config $config
            }
		}
        
        $ObjectType = "NetworkConnection"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = ".connectionType"
		$value = Search-VMXPattern -Pattern "ethernet\d{1,2}$patterntype" -vmxconfig $vmxconfig -name "Adapter" -value "ConnectionType" -patterntype $patterntype
        
        foreach ($Connection in $Value)
        {
            $Object = New-Object -TypeName psobject
		    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		    $Object | Add-Member -MemberType NoteProperty -Name Adapter -Value $Connection.Adapter
		    $Object | Add-Member -MemberType NoteProperty -Name ConnectionType -Value $Connection.ConnectionType
		    Write-Output $Object
        }
	}
    
    end {}
    
}#end Get-VMXNetwork