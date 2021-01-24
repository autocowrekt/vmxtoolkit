function New-VMXClone
{
	[CmdletBinding(DefaultParameterSetName = '1',HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	[OutputType([psobject])]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('Snapshot')]
		$BaseSnapshot,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		$Config,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		$CloneName,
		[Parameter(Mandatory = $false)][ValidateScript({ Test-Path -Path $_ })]$Clonepath,
		[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]$Path
	)
	Begin {}
	
	Process
	{
		#foreach ($config in $getconfig)
		if (!$Clonepath) { $Clonepath = $global:vmxdir }
		Write-Verbose $ClonePath
		$CloneConfig =  Join-Path "$Clonepath" (Join-Path $Clonename "$CloneName.vmx")
		$TemplateVM = Split-Path -Leaf $config
		$Templatevm = $TemplateVM -replace ".vmx",""
		Write-Verbose $CloneConfig
		Write-Host -ForegroundColor Gray " ==>creating Fullclone from $TemplateVM $Basesnapshot for " -NoNewline
		Write-Host -ForegroundColor Magenta $Clonename -NoNewline
		Write-Verbose "creating Full Clone $Clonename for $Basesnapshot in $Cloneconfig"
		$clonecommand = "clone `"$config`" `"$Cloneconfig`" full -snapshot=$($BaseSnapshot) -cloneName=$($Clonename)" # 2>&1 | Out-Null
		Write-Verbose "Trying $clonecommand"
		do
        {
			Write-Verbose "Trying $clonecommand"
			$cmdresult = Start-Process $vmrun -ArgumentList $clonecommand -NoNewWindow -Wait
        }
		until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)	
        if ($LASTEXITCODE -eq 0 -and $cmdresult -ne "Error: The snapshot already exists")
        {
			Write-Host -ForegroundColor Green "[success]"
			$Object = New-Object psobject
			$Object | Add-Member -MemberType 'NoteProperty' -Name CloneName -Value $Clonename
			$Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $Cloneconfig
			$Object | Add-Member -MemberType 'NoteProperty' -Name Path -Value "$Clonepath\$Clonename"
			Write-Output $Object
        }
        else
        {
			Write-Host -ForegroundColor Red "[failed]"
            Write-Warning "could not create clone with $cmdresult"
            break
        }
	}	

    End {}
	
}