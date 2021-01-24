<#
	.SYNOPSIS
		A brief description of the Remove-VMXSnaphot function.

	.DESCRIPTION
		deleteSnapshot           Path to vmx file     Remove a snapshot from a VM
		                         Snapshot name
		                         [andDeleteChildren]

	.PARAMETER  Snaphot
		A description of the Snaphot parameter.

	.PARAMETER  VMXName
		A description of the VMXName parameter.

	.PARAMETER  Children
		A description of the Children parameter.

	.EXAMPLE
		PS C:\> Remove-VMXSnaphot -Snaphot $value1 -VMXName $value2
		'This is the output'
		This example shows how to call the Remove-VMXSnaphot function with named parameters.

	.NOTES
		Additional information about the function or script.

#>
function Remove-VMXSnapshot
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$Path = "$Global:vmxdir",
		[Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$config,
		[Parameter(Mandatory = $True, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('Snapshotname')][string]$Snapshot,
		[Parameter(Mandatory = $false)][switch]$Children
	)
	
	Begin {}
	
	Process
	{
		Write-Verbose "Snapshot in Process: $Snapshotname"
		Write-Verbose "VMXName in Process: $VMXName"
    
        if ($Children.IsPresent)
        {
            $parameter = "andDeleteChildren"
        }
   
        do
        {
            Write-Verbose $config
            Write-Verbose $Snapshot
            ($cmdresult = &$vmrun deleteSnapshot $config $Snapshot $parameter) # 2>&1 | Out-Null
            #write-log "$origin snapshot  $cmdresult"
        }
        until ($VMrunErrorCondition -notcontains $cmdresult)
    
        if ($LASTEXITCODE -eq 0)
        {
            $Object = New-Object psobject
            $Object | Add-Member -Type 'NoteProperty' -Name VMXname -Value $VMXname
            $Object | Add-Member -Type 'NoteProperty' -Name Snapshot -Value $Snapshot  
            $Object | Add-Member -Type 'NoteProperty' -Name SnapshotState -Value "removed$parameter"
            Write-Output $Object
        }
        else
        {
            Write-Warning "exit with status $LASTEXITCODE $cmdresult"
        }
    }
    
    End {}
	
}