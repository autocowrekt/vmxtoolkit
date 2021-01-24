function Get-VMXNetworkAdapterDisplayName
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXDisplayName/")]
    param 
    (
		[Parameter(ParameterSetName = "1", Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
		[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
		[Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
	#	[Parameter(ParameterSetName = "3", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$vmxconfig,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][ValidateSet('ethernet0',
		'ethernet1',
		'ethernet2',
		'ethernet3',
		'ethernet4',
		'ethernet5',
		'ethernet6',
		'ethernet7',
		'ethernet8',
		'ethernet9')]$Adapter	
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
        
        $ObjectType = "$($Adapter)Displayname"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = "displayname"
		$vmxconfig = $vmxconfig | Where-Object {$_  -match "$Adapter"}
		$Value = Search-VMXPattern -Pattern "$patterntype" -vmxconfig $vmxconfig -value $patterntype -patterntype $patterntype
		$Object = New-Object -TypeName psobject
		# $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name Displayname -Value $Value.displayname
		$Object | Add-Member -MemberType NoteProperty -Name Config -Value (Get-ChildItem -Path $Config)
		$Object | Add-Member -MemberType NoteProperty -Name Adapter -Value $Adapter
				
		Write-Output $Object
	}
    
    end {}

} # end Get-VMXNetworkAdapterDisplayName