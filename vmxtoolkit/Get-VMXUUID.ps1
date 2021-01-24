function Get-VMXUUID
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param 
    (
		[Parameter(ParameterSetName = "1", Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(ParameterSetName = "2", Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
		[Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
		[Parameter(ParameterSetName = "3", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$vmxconfig,
		[switch]$unityformat
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
        
        $ObjectType = "UUID"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message "getting $ObjectType"
		$patterntype = ".bios"
		$Value = Search-VMXPattern  -Pattern "uuid.bios" -vmxconfig $vmxconfig -Name "Type" -value $ObjectType -patterntype $patterntype -nospace
		# $Value = Search-VMXPattern -Pattern "ethernet\d{1,2}.virtualdev" -vmxconfig $vmxconfig -name "Adapter" -value "Type" -patterntype $patterntype
        
        if ($unityformat.ispresent)
		{
			$out_uuid = $Value.uuid.Insert(8,"-")
			$out_uuid = $out_uuid.Insert(13,"-")
			$out_uuid = $out_uuid.Insert(23,"-")
		}
		else
		{
			$out_uuid = $Value.uuid
		}	
        
        $Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name $ObjectType -Value $out_uuid
		Write-Output $Object
	}
    
    end {}

}#end Get-UUID