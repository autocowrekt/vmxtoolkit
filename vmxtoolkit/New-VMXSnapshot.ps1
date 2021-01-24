<#
	.SYNOPSIS
		A brief description of the  function.

	.DESCRIPTION
		Creates a new Snapshot for the Specified VM(s)

	.PARAMETER  Name
		VM name for Snapshot

	.PARAMETER  SnapshotName
		Name of the Snapshot

	.EXAMPLE
		PS C:\> New-VMXSnapshot -Name 'Value1' -SnapshotName 'Value2'
		'This is the output'
		This example shows how to call the New-VMXSnapshot function with named parameters.

	.NOTES
		Additional information about the function or script.

#>
function New-VMXSnapshot
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		#[Parameter(Mandatory = $true, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('TemplateName')][string]$VMXName,
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$Path = "$Global:vmxdir",
		[Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$config,
		[Parameter(Mandatory = $false)][string]$SnapshotName = (Get-Date -Format "MM-dd-yyyy_HH-mm-ss")
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
        
        Write-Verbose "creating Snapshot $Snapshotname for $vmxname"
		Write-Host -ForegroundColor Gray " ==>creating new Snapshot $Snapshotname for " -NoNewline
		Write-Host -ForegroundColor Magenta $VMXName -NoNewline
        
        do
        {
	        ($cmdresult = &$vmrun snapshot $config $SnapshotName) # 2>&1 | Out-Null
		}
        
        until ($VMrunErrorCondition -notcontains $cmdresult)
        
        if ($LASTEXITCODE -eq 0)
        {
			Write-Host -ForegroundColor Green "[success]"
		    $Object = New-Object psobject
		    $Object | Add-Member -MemberType 'NoteProperty' -Name VMXname -Value $VMXname
		    $Object | Add-Member -MemberType 'NoteProperty' -Name Snapshot -Value $SnapshotName
            $Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $config
            $Object | Add-Member -MemberType 'NoteProperty' -Name Path -Value $Path
            Write-Output $Object
		}
        else
        {
			Write-Host -ForegroundColor Red "[failed]"
            Write-Error "exit with status $LASTEXITCODE $cmdresult"
			Break
        }
    }
    
    End {}
    
}