function Invoke-VMXScript
{
	[CmdletBinding(DefaultParameterSetName = 1,
    ConfirmImpact="Medium")]

	[OutputType([psobject])]
	param
	(
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('NAME','CloneName')][string]$VMXName,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $false)]$Scriptblock, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$nowait, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$interactive,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$activewindow,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][Validaterange(0,300)][int]$SleepSec,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('log')]$logfile

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
        $interactive_parm = "-interactive" }
	}

    process
    {
    
        if ($Logfile) 
        {
            $Scriptblock = "$Scriptblock >> $logfile 2>&1"
        }
	
        Write-host -ForegroundColor Gray " ==>running $Scriptblock on: " -NoNewline
        Write-Host -ForegroundColor Magenta $VMXName -NoNewline
        
        do
	    {
            $Myresult = 1
            
            do
	        {
	            $cmdresult = (&$vmrun  -gu $Guestuser -gp $Guestpassword  runScriptinGuest $config -activewindow "$nowait_parm" $interactive_parm $Scriptblock)
	        }
	        until ($VMrunErrorCondition -notcontains $cmdresult -or !$cmdresult)
        
            Write-Verbose "Exitcode : $Lastexitcode"
        
            if ($Lastexitcode -ne 0)
            {
                Write-Warning "Script Failure for $Scriptblock with $cmdresult"
                Write-Verbose "Confirmpreference: $ConfirmPreference"
            
                if ($ConfirmPreference -notmatch "none")
                {
                    $Myresult = Get-yesnoabort -title "Scriptfailure for $Scriptblock" -message "May be VPN Issue, retry ?"
                    Write-Verbose "Question response: $Myresult"
                    
                    If ($Myresult -eq 2)
                    {
                        Write-Host -ForegroundColor Red "[failed]"
                        exit
                    }
                }
                else 
                {
                    $Myresult = 0
                
                    If ($SleepSec)
                    { 
                        Write-Warning "Waiting $SleepSec Seconds"
                        Start-Sleep $SleepSec 
                    }
                }
            }
        }
        until ($Myresult -eq 1)
    
        Write-Host -ForegroundColor Green "[success]"
        Write-Verbose "Myresult: $Myresult"
        $Object = New-Object psobject
        $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
        $Object | Add-Member -MemberType 'NoteProperty' -Name Scriptblock -Value $Scriptblock
        $Object | Add-Member -MemberType 'NoteProperty' -Name config -Value $config
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