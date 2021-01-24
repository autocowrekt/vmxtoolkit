function Get-VMXsharedFolder{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXsharedFolder/")]
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
                $config = $vmxconfig.config
            }
			"2"
			{
                $vmxconfig = Get-VMXConfig -config $config
            }
		}
        
        $Patterntype = ".guestName"
		$ObjectType = "sharedFolder"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message $ObjectType
		$Value = Search-VMXPattern -Pattern "$ObjectType\d{1,2}$PatternType" -vmxconfig $vmxconfig -name "sharedFolder" -value "Name" -patterntype $Patterntype
        
        foreach ($folder in $value)
		{
			<#
			sharedFolder0.present = "true"
			sharedFolder0.enabled = "true"
			sharedFolder0.readAccess = "true"
			sharedFolder0.writeAccess = "true"
			sharedFolder0.hostPath = "C:\test\labbuildr-scripts"
			sharedFolder0.guestName = "Scripts"
			sharedFolder0.expiration = "never"
			#>
			$FolderNumber = $Folder.sharedFolder.replace("$ObjectType","")	
			$Folderpath = Search-VMXPattern -Pattern "$ObjectType$Foldernumber.hostPath" -vmxconfig $vmxconfig -name "Folderpath" -value "Path" -patterntype ".hostPath"
			$Folder_present = Search-VMXPattern -Pattern "$ObjectType$Foldernumber.present" -vmxconfig $vmxconfig -name "present" -value "value" -patterntype ".present"
			$Folder_enabled = Search-VMXPattern -Pattern "$ObjectType$Foldernumber.enabled" -vmxconfig $vmxconfig -name "enabled" -value "value" -patterntype ".enabled"
			$Folder_readAccess = Search-VMXPattern -Pattern "$ObjectType$Foldernumber.readAccess" -vmxconfig $vmxconfig -name "readAccess" -value "value" -patterntype ".readAccess"
			$Folder_writeAccess = Search-VMXPattern -Pattern "$ObjectType$Foldernumber.writeAccess" -vmxconfig $vmxconfig -name "writeAccess" -value "value" -patterntype ".writeAccess"
			$Folder_expiration = Search-VMXPattern -Pattern "$ObjectType$Foldernumber.expiration" -vmxconfig $vmxconfig -name "expiration" -value "value" -patterntype ".expiration"
			$Object = New-Object -TypeName psobject
			$Object.pstypenames.insert(0,'vmxsharedFolder')
			$Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
            $Object | Add-Member -MemberType NoteProperty -Name FolderNumber -Value $Foldernumber
            $Object | Add-Member -MemberType NoteProperty -Name FolderName -Value $Folder.Name
			$Object | Add-Member -MemberType NoteProperty -Name Folderpath -Value $Folderpath.Path
			$Object | Add-Member -MemberType NoteProperty -Name enabled -Value $Folder_enabled.Value
			$Object | Add-Member -MemberType NoteProperty -Name present -Value $Folder_present.Value
			$Object | Add-Member -MemberType NoteProperty -Name readAccess -Value $Folder_readAccess.Value
			$Object | Add-Member -MemberType NoteProperty -Name writeAccess -Value $Folder_writeAccess.Value
			$Object | Add-Member -MemberType NoteProperty -Name expiration -Value $Folder_expiration.Value
			Write-Output $Object
		}
	}
    
    end {}

} #end Get-VMXsharedFolder