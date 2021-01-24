<#
	.SYNOPSIS
		A brief description of the Restore-VMXSnapshot function.

	.DESCRIPTION
		Restores a new Snapshot for the Specified VM(s)

	.PARAMETER  SnapshotName
		Name of the Snapshot

	.EXAMPLE

	.NOTES
		Additional information about the function or script. bsed upon revertToSnapshot
#>
function Restore-VMXSnapshot
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		#[Parameter(Mandatory = $true, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$Path = "$Global:vmxdir",
		[Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$config,
		[Parameter(Mandatory = $True, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('Snapshotname')][string]$Snapshot
	)
    
    Begin {}
	
	Process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
            {
                $config = Get-VMX -VMXName $VMXname -Path $Path
            }
			"2"
			{
		
			}
		}
	        Write-Verbose "Restoring Snapshot $Snapshot for $vmxname"
        
        do
        {
	        ($cmdresult = &$vmrun revertToSnapshot $config $Snapshot) # 2>&1 | Out-Null
        }
		until ($VMrunErrorCondition -notcontains $cmdresult)
        
        if ($LASTEXITCODE -eq 0)
        {
            Write-Verbose "Sapshot $Snapshot restored"
		    $Object = New-Object psobject
		    $Object | Add-Member -MemberType 'NoteProperty' -Name VMXname -Value $VMXname
		    $Object | Add-Member -MemberType 'NoteProperty' -Name Snapshot -Value $Snapshot
            $Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $config
            $Object | Add-Member -MemberType 'NoteProperty' -Name Path -Value $Path
            $Object | Add-Member -MemberType 'NoteProperty' -Name State -Value "restored"

            Write-Output $Object
        }
        else
        {
            Write-Warning "exit with status $LASTEXITCODE $cmdresult"
        }
	}
    
    End {}
    
}