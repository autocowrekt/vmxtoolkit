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
function Set-VMXSharedFolder
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		[Parameter(Mandatory = $false, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(Mandatory = $true, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$config,
        [Parameter(Mandatory = $True, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)][switch]$add,
		[Parameter(Mandatory = $True, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][switch]$remove,
        [Parameter(Mandatory = $True, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		[Parameter(Mandatory = $True, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][ValidateLength(3,10)][ValidatePattern("^[a-zA-Z\s]+$")]$Sharename,
        [Parameter(Mandatory = $True, ParameterSetName = 1, ValueFromPipelineByPropertyName = $True)]
		#[ValidateScript({ Test-Path -Path $_ })]
		$Folder
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
                    Write-Host -ForegroundColor Gray " ==>adding Share $Sharename for Folder $Folder to " -NoNewline
                    Write-Host -ForegroundColor Magenta $VMXName -NoNewline                
                    Write-Verbose "adding Share $Sharename for Folder $Folder for $config"
                do 
                { 
                    $cmdresult = &$vmrun addSharedFolder $config $Sharename $Folder
                }
                until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
    
                $Object | Add-Member -MemberType 'NoteProperty' -Name Share -Value $Sharename
                $Object | Add-Member -MemberType 'NoteProperty' -Name Folder -Value $Folder
    
            }
			"2"
			{
				Write-Host -ForegroundColor Gray " ==>removing Share $Sharename for Folder $Folder to " -NoNewline
				Write-Host -ForegroundColor Magenta $VMXName -NoNewline                
				Write-Verbose "removing Shared Folder for $config"
            
                do 
                { 
                    $cmdresult = &$vmrun removeSharedFolder $config $Sharename
                }
                until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
            
                $Object | Add-Member -MemberType 'NoteProperty' -Name Sharename -Value "removed"
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
            Write-Error "exit with status $LASTEXITCODE $cmdresult"
			Break
        }
	}
    
    End {}

}