<#
	.SYNOPSIS
		

	.DESCRIPTION
		Sets the VMX Shared fOLDER State

	.PARAMETER  config
		Please Specify Valid Config File

	.EXAMPLE
		
	.NOTES
		Additional information about the function or script.

#>
function Set-VMXSharedFolderState
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		[Parameter(Mandatory = $false, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(Mandatory = $true, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$config,
		[Parameter(Mandatory = $True, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)][switch]$enabled,
		[Parameter(Mandatory = $True, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][switch]$disabled
	)
    
    Begin {}
	
	Process
	{
	    
		$Object = New-Object psobject
		$Object | Add-Member -MemberType 'NoteProperty' -Name VMXname -Value $VMXname
        $Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $config

		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
	        {
				Write-Host -ForegroundColor Gray " ==>enabling shared folders (hgfs) for " -NoNewline
				Write-Host -ForegroundColor Magenta $VMXName -NoNewline
                Write-Verbose "enabling Shared Folder State for $config"
            
                do 
                { 
                    $cmdresult = &$vmrun enableSharedFolders $config
                }
                until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
            
                $Object | Add-Member -MemberType 'NoteProperty' -Name State -Value "enabled"
            }
			"2"
			{
                Write-Host -ForegroundColor Gray " ==>disabling shared folders (hgfs) for " -NoNewline
                Write-Host -ForegroundColor Magenta $VMXName -NoNewline
                Write-Verbose "Disabling Shared Folder State for $config"
                
                do 
                { 
                    $cmdresult = &$vmrun disableSharedFolders $config
                }
                until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
            
                $Object | Add-Member -MemberType 'NoteProperty' -Name State -Value "disabled"
			}
		}
        
        if ($LASTEXITCODE -eq 0)
        {
			Write-Host -ForegroundColor Green "[success]"
            Write-Output $Object
		}
        else
        {
			Write-Host -ForegroundColor Red "[failed]"
            Write-Warning "exit with status $LASTEXITCODE $cmdresult"
        }
	}
    
    End {}
    
}