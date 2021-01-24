function Remove-vmx {
	<#
		.SYNOPSIS
			A brief description of the function.

		.DESCRIPTION
			A detailed description of the function.

		.PARAMETER  ParameterA
			The description of the ParameterA parameter.

		.PARAMETER  ParameterB
			The description of the ParameterB parameter.

		.EXAMPLE
			PS C:\> Get-Something -ParameterA 'One value' -ParameterB 32

		.EXAMPLE
			PS C:\> Get-Something 'One value' 32

		.INPUTS
			System.String,System.Int32

		.OUTPUTS
			System.String

		.NOTES
			Additional information about the function go here.

		.LINK
			about_functions_advanced

		.LINK
			about_comment_based_help

	#>


	[CmdletBinding(DefaultParametersetName = "2",SupportsShouldProcess=$true,ConfirmImpact='high')]
    param 
    (
        #[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('VMNAME''NAME','CloneName')]$VMXName,	
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config
        #[Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$state
	)
    
    begin 
    {
        $Origin = $MyInvocation.MyCommand
        Write-Verbose $Origin
    }

    process 
    {
        if (!($config)) 
        {
            Write-Warning "$Origin : VM does not exist"
        }
        
        Write-Verbose $config
    
        switch ($PsCmdlet.ParameterSetName)
			{
				"1"
				{
                    $vmx = Get-VMX -VMXName $VMXname 
                }# -UUID $UUID }
				
				"2"
				{
                    $VMX = get-vmx -Path $config
                }
				
			}
		
		Write-Verbose "Testing VM $VMXname Exists and stopped or suspended"
        
        if ($vmx.state -eq "running")
		{
			Write-Verbose "Checking State for $vmxname : $state"
			Write-Verbose $config
			Write-Verbose -Message "Stopping vm $vmxname"
			stop-vmx -config $config -VMXName $VMXName  -mode hard #-state $vmx.state
		}
	
        $commit = 0
    
        if ($ConfirmPreference -match "none")
        { 
            $commit = 1 
        }
        else
        {
            $commit = Get-yesno -title "Confirm VMX Deletion" -message "This will remove the VM $VMXNAME Completely"
        }
    
        Switch ($commit)
        {
            1
            {
                do
                {
                    $cmdresult = &$vmrun deleteVM "$config" # 2>&1 | Out-Null
                    write-verbose "$Origin deleteVM $vmname $cmdresult"
                    write-verbose $LASTEXITCODE
                }
                until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
                
                if ($cmdresult -match "Error: This VM is in use.")
                {
                    write-warning "$cmdresult Please close VMX $VMXName in Vmware UI and try again"
                }
            
                if ($LASTEXITCODE -ne 0)
                {
                    Write-Warning $VMXname
                    Write-Warning $cmdresult
                }
                else       
                {
                    Remove-Item -Path $vmx.Path -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
                    $Object = New-Object psobject
                    $Object | Add-Member -Type 'NoteProperty' -Name VMXname -Value $VMXname
                    $Object | Add-Member -Type 'NoteProperty' -Name Status -Value "removed"
                    Write-Output $Object
                }
            }
            0
            {
                Write-Warning "VMX Deletion refused by user for VMX $VMXNAME"
                break
            }      
        }
    }#end process

	end {}

} 