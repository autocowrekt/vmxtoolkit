<#
	.SYNOPSIS
		Synopsis

	.DESCRIPTION
		Create a linked Clone from a Snapshot

	.PARAMETER  BaseSnapshot
		Based Snapshot to Link from

	.PARAMETER  CloneName
		A description of the CloneName parameter.

	.EXAMPLE
		PS C:\> New-VMXLinkedClone -BaseSnapshot $value1 -CloneName $value2
		'This is the output'
		This example shows how to call the New-VMXLinkedClone function with named parameters.

	.OUTPUTS
		psobject

	.NOTES
		Additional information about the function or script.

#>
function New-VMXLinkedClone
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
		if (!$Clonepath) 
		{
			$Clonepath = $global:vmxdir 
		} #Split-Path -Path $Path -Parent 
		
		Write-Verbose "clonepath is $ClonePath"
		
		$Targetpath = Join-Path $Clonepath $CloneName 
		$CloneConfig = Join-path "$Targetpath" "$CloneName.vmx"
		$TemplateVM = Split-Path -Leaf $config
		$TemplateVM = $TemplateVM -replace ".vmx",""
		
		Write-Verbose "creating Linked Clone $Clonename from $TemplateVM $Basesnapshot in $Cloneconfig"
		Write-Host -ForegroundColor Gray " ==>creating Linked Clone from $TemplateVM $Basesnapshot for " -NoNewline
		Write-Host -ForegroundColor Magenta $Clonename -NoNewline

		$cmdresult = ""
		do
        {
			$snapcommand = "clone `"$config`" `"$Cloneconfig`" linked -snapshot=$($BaseSnapshot) -cloneName=$($Clonename)" # 2>&1 | Out-Null
			Write-Verbose "Trying $snapcommand"
			$cmdresult = Start-Process $Global:vmrun -ArgumentList "$snapcommand" -NoNewWindow -Wait 
        }
		until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
        if ($LASTEXITCODE -eq 0)
        {
			Write-Host -ForegroundColor Green "[success]"
			Start-Sleep 2
			$Addcontent = @()
			$Addcontent += 'guestinfo.buildDate = "'+$BuildDate+'"'
			Add-Content -Path "$Cloneconfig" -Value $Addcontent
			$Object = New-Object psobject
			$Object | Add-Member -MemberType 'NoteProperty' -Name CloneName -Value $Clonename
			$Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $Cloneconfig
			$Object | Add-Member -MemberType 'NoteProperty' -Name Path -Value $Targetpath
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