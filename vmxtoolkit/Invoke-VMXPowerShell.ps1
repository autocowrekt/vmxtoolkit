<#
		.SYNOPSIS
			start a Powershell inside the vm

		.DESCRIPTION
			start a Powershell inside the vm

		.PARAMETER  VMXname
			Optional, name of the VMX

#>	
function Invoke-VMXPowerShell
{
	[CmdletBinding(DefaultParameterSetName = 1,SupportsShouldProcess=$true,ConfirmImpact="Medium")][OutputType([psobject])]
	param
	(
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('NAME','CloneName')][string]$VMXName,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)]$ScriptPath,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)]$Script, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)]$Parameter = "", 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$nowait, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$interactive,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$activewindow, 
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $false)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][Alias('gp')]$Guestpassword,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][Alias('pe')]$Possible_Error_Fix
	)

    begin
    {	
        $Origin = $MyInvocation.MyCommand
        $nowait_parm = ""
        $interactive_parm = ""
    
        if ($nowait) 
        { 
            $nowait_parm = "-nowait" 
        }
    
        if ($interactive) 
        {
            $interactive_parm = "-interactive" 
        }
	}

    process
    {
    $myscript = ".'$ScriptPath\$Script'"
    Write-Host -ForegroundColor Gray " ==>starting '$Script $Parameter' on " -NoNewline
    Write-Host -ForegroundColor Magenta $VMXName -NoNewline
    #Write-Host  -ForegroundColor Magenta (Split-Path -Leaf $config ).Replace(".vmx","") -NoNewline

        do
        {
            $Myresult = 1
            do
	        {
                Write-Verbose "c:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe '$myscript' '$Parameter'"
                $cmdresult = (&$vmrun  -gu $Guestuser -gp $Guestpassword  runPrograminGuest $config -activewindow "$nowait_parm" $interactive_parm c:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Executionpolicy bypass "$myscript" "$Parameter")
            }
	        until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
            
            Write-Verbose "Exitcode : $Lastexitcode"
        
            if ($Lastexitcode -ne 0)
            {
		    	Write-Host -ForegroundColor Red "[failed]"
                Write-Warning "Script Failure for $Script with $cmdresult"
            
                If ($Possible_Error_Fix)
				{
                    Write-Host -ForegroundColor White " ==>Possible Resolution from Calling Command:"
                    Write-Host -ForegroundColor Yellow $Possible_Error_Fix
				}
            
                Write-Verbose "Confirmpreference: $ConfirmPreference"
                
                if ($ConfirmPreference -notmatch "none")
                {
                    $Myresult = Get-yesnoabort -title "Scriptfailure for $Script" -message "May be VPN Issue, retry ?"
                    Write-Verbose "Question response: $Myresult"
                
                    If ($Myresult -eq 2)
                    {
                        exit
                    }
                }
                else 
                {
                    $Myresult = 0
                }
            }
        }
        until ($Myresult -eq 1)
    
        Write-Host  -ForegroundColor Green "[success]"
        Write-Verbose "Myresult: $Myresult"
        $Object = New-Object psobject
        $Object | Add-Member -MemberType 'NoteProperty' -Name config -Value $config
        $Object | Add-Member -MemberType 'NoteProperty' -Name Script -Value $Script
        $Object | Add-Member -MemberType 'NoteProperty' -Name Exitcode -Value $Lastexitcode
        
        if ($cmdresult)
        {
            $Object | Add-Member -MemberType 'NoteProperty' -Name Result -Value $cmdresult
        }
        else 
        {
            $Object | Add-Member -MemberType 'NoteProperty' -Name Result -Value success
        }
        
        Write-Output $Object
    }

    end {}
    
}