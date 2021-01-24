function Get-VMXDisplayName
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXDisplayName/")]
    param 
    (
		[Parameter(ParameterSetName = "1", Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
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
                $vmxconfig = Get-VMXConfig -VMXName $VMXname $config
            }
			"2"
			{
                $vmxconfig = Get-VMXConfig -config $config
            }
        }	
        
        $ObjectType = "Displayname"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = "displayname"
		$vmxconfig = $vmxconfig | Where-Object {$_ -match '^DisplayName'}
		$Value = Search-VMXPattern -Pattern "$patterntype" -vmxconfig $vmxconfig -value $patterntype -patterntype $patterntype
		$Object = New-Object -TypeName psobject
		# $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name $ObjectType -Value $Value.displayname
		$Object | Add-Member -MemberType NoteProperty -Name Config -Value (Get-ChildItem -Path $Config)
		
		Write-Output $Object
	}
    
    end {}
    
}#end Get-VMXDisplayName