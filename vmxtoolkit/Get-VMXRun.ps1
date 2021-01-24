<#	
	.SYNOPSIS
		A brief description of the Get-VMXRun function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXRun function.
	
	.EXAMPLE
		PS C:\> Get-VMXRun
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXRun
{
	$runvms = @()
	# param ($Name)
	
	$Origin = $MyInvocation.MyCommand
	do
	{
		(($cmdresult = &$vmrun List) 2>&1 | Out-Null)
		write-verbose "$origin $cmdresult"
	}
	until ($VMrunErrorCondition -notcontains $cmdresult)

    write-verbose "$origin $cmdresult"

    foreach ($runvm in $cmdresult)
	{
		if ($runvm -notmatch "Total running VMs")
		{
			[System.IO.FileInfo]$runvm = $runvm
			# $runvm = $runvm.TrimEnd(".vmx")
			$Object = New-Object -TypeName psobject
			#$Object.pstypenames.insert(0,'virtualmachine')
			$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value ([string]($runvm.BaseName))
			$Object | Add-Member -MemberType NoteProperty -Name config -Value $runvm.FullName
			$Object | Add-Member -MemberType NoteProperty -Name Status -Value running
			Write-Output $Object
			# Shell opject will be cretaed in next version containing name, vmpath , status
		}# end if
	}#end foreach
} #end get-vmxrun