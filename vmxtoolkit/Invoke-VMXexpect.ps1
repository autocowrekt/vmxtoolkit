function Invoke-VMXexpect
{
	[CmdletBinding(DefaultParameterSetName = 1)]
	[OutputType([psobject])]
	param
	(
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('NAME','CloneName')][string]$VMXName,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $false)]$Scriptblock, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$nowait, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$interactive,
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $false)][switch]$activewindow, 
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 1, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword
	)
    
    begin
    {	
        $Origin = $MyInvocation.MyCommand
        $nowait_parm = ""
        $interactive_parm = ""
        
        if ($nowait) { $nowait_parm = "-nowait" }
        
        if ($interactive) { $interactive_parm = "-interactive" }
	}


    process
    {	
        Write-Verbose "starting $Scriptblock"	
        do
    	{
	        $cmdresult = (&$vmrun  -gu $Guestuser -gp $Guestpassword  runScriptinGuest $config -activewindow "$nowait_parm" $interactive_parm "/usr/bin/expect -c "  "$Scriptblock")
	    }
	    until ($VMrunErrorCondition -notcontains $cmdresult)
        
            $Object = New-Object psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType 'NoteProperty' -Name Scriptblock -Value $Scriptblock
            $Object | Add-Member -MemberType 'NoteProperty' -Name config -Value $config

        if ($cmdresult)
        { 
            $Object | Add-Member -MemberType 'NoteProperty' -Name Result -Value $cmdresult
        }
    
        Write-Output $Object
    }

    end {}
}
