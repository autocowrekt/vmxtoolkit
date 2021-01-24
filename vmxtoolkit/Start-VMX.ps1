<#	
	.SYNOPSIS
		A brief description of the start-vmx function.
	
	.DESCRIPTION
		A detailed description of the start-vmx function.
	
	.PARAMETER Name
		A description of the Name parameter.
	
	.EXAMPLE
		PS C:\> start-vmx -Name 'vmname'
	
	.NOTES
		Additional information about the function.
#>
function Start-VMX
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param 
    (
		[Parameter(ParameterSetName = "1", Position = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		#[Parameter(ParameterSetName = "2",Position = 2,Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
		[Parameter(ParameterSetName = "3", Mandatory = $false)]		
        [Alias('Clonename')][string]$VMXName,
		[Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
		[Parameter(ParameterSetName = "3", Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('VMXUUID')][string]$UUID,
        #[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
        [Parameter(ParameterSetName = "3", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(Mandatory=$false)]$Path,
        [Parameter(Mandatory=$false)][Switch]$nowait,
        [Parameter(Mandatory=$false)][Switch]$nogui
	)
    
    begin {}
		
	process
	{
    
        switch ($PsCmdlet.ParameterSetName)
        {
			"1"
			{
                Write-Verbose $_
        
                if ($VMXName -match "\*")
                {
                    Write-Warning "Wildcard names are not allowed, use get-vmx $VMXName | start-vmx instead"
                    break
                }
                
                $vmx = Get-VMX -VMXName $VMXname -UUID $UUID
            }
			"2"
			{
                Write-Verbose $_ 
                $vmx = Get-VMX -Path $path
            }
            "3"
            {
                Write-Verbose " by config with $_ "
                $vmx = Get-VMX -config $config
            }      
        }
		
		if ($VMX)
		{
		    Write-Verbose "Testing VM $VMXname Exists and stopped or suspended"
            
            if (($vmx) -and ($vmx.state -ne "running"))
		    {
                [int]$vmxhwversion = (Get-VMXHWVersion -config $vmx.config).hwversion
            
                if ($vmxHWversion -le $vmwareversion.major)
                {
                    Write-Verbose "Checking State for $vmxname : $($vmx.vmxname)  : $($vmx.state)"
                    Write-Verbose "creating Backup of $($vmx.config)"
                    Copy-Item -Path $vmx.config -Destination "$($vmx.config).bak" 
                    Write-Verbose -Message "setting Startparameters for $vmxname"
                    $VMXStarttime = Get-Date -Format "MM.dd.yyyy hh:mm:ss"
                    $content = Get-Content $vmx.config | Where-Object { $_ -ne "" }
                    $content = $content | Where-Object { $_ -NotMatch "guestinfo.hypervisor" }
                    $content += 'guestinfo.hypervisor = "' + $env:COMPUTERNAME + '"'
                    $content = $content | Where-Object { $_ -NotMatch "guestinfo.powerontime" }
                    $content += 'guestinfo.powerontime = "' + $VMXStarttime + '"'
                    $content = $content |Where-Object { $_ -NotMatch "guestinfo.vmwareversion" }
                    $content += 'guestinfo.vmwareversion = "' + $Global:vmwareversion + '"'
                    Set-Content -Path $vmx.config -Value $content -Force
                    Write-Verbose "starting VM $vmxname"
                    Write-Host -ForegroundColor Gray " ==>starting Virtual Machine " -NoNewline
                    Write-Host -ForegroundColor Magenta $VMX.vmxname -NoNewline
                
                    if ($nowait.IsPresent)
                    {
                        if ($nogui.IsPresent)
                        {
                            Start-Process -FilePath $vmrun -ArgumentList "start $($vmx.config) nogui" -NoNewWindow
                        }
                        else
                        {
                            Start-Process -FilePath $vmrun -ArgumentList "start $($vmx.config) " -NoNewWindow
                        }
                    }
                    else
                    {
                        do
                        {
		    		        if ($nogui.IsPresent)
                            {
                                $cmdresult = &$vmrun start $vmx.config nogui #  2>&1 | Out-Null
                            }
                            else
                            {
		    		            $cmdresult = &$vmrun start $vmx.config #  2>&1 | Out-Null
                            }
                        }
    			        until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
                        }
                    
                    if ($LASTEXITCODE -eq 0) 
                    {
                        Write-Host -ForegroundColor Green "[success]"
                        $Object = New-Object psobject
                        $Object | Add-Member -Type 'NoteProperty' -Name VMXname -Value $VMX.VMXname
                        $Object | Add-Member -Type 'NoteProperty' -Name Status -Value "Started"
                        $Object | Add-Member -Type 'NoteProperty' -Name Starttime -Value $VMXStarttime
                        Write-Output $Object 
                    }
                    else
                    {
                        Write-Warning "There was an error starting the VM: $cmdresult"
                    }
                }
                else 
                {
                    Write-Error "Vmware version does not match, need version $vmxhwversion "	
                }
            }
            elseif ($vmx.state -eq "running") 
            {
                Write-Verbose "VM $VMXname already running" 
            } # end elseif
            else 
            { 
                Write-Verbose "VM $VMXname not found" 
            } # end if-vmx
        }	
    }# end process
      
    end {}

}#end start-vmx