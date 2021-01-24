<#	
	.SYNOPSIS
	Get-VMXProcessesInGuest
	
	.DESCRIPTION
		Displays version Information on installed VMware version
	
	.EXAMPLE
		PS C:\> Get-VMwareversion
	
	.NOTES
		requires VMXtoolkit loaded
#>
function Get-VMXProcessesInGuest
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param 
    (
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword
     )
    begin {}

    process 
    {
    	Write-Verbose "running .$vmrun -gu $Guestuser -gp $Guestpassword listprocessesinguest  $config"
    
        try 
        {
	        [System.Collections.ArrayList]$Processlist = .$vmrun -gu $Guestuser -gp $Guestpassword listprocessesinguest  $config
	    }   
        catch 
        {
		    Write-Verbose $_.Exception
		    Write-Host "did not get processes"
		    return
	    }
    
        $Processlist.RemoveRange(0,2)
    
        if ($global:vmwareversion -lt 10.5)
        {
			foreach ($Process in $Processlist)
			{
				$Process = $Process.replace("pid=","")
				$Process = $Process.replace("owner=","")
				$Process = $Process.replace("cmd=","")
				$Process = $Process.split(', ')
				$Object = New-Object -TypeName psobject
				$Object | Add-Member -MemberType NoteProperty -Name PID -Value $Process[0]
				$Object | Add-Member -MemberType NoteProperty -Name USER -Value $Process[2]
				$Object | Add-Member -MemberType NoteProperty -Name Process -Value $Process[4]
				Write-Output $Object
			}
		}
		else
		{
			foreach ($Process in $Processlist)
			{
				$Process = $Process.replace("pid=","")
				$Process = $Process.replace("owner=","")
				$Process = $Process.replace("cmd=","")
				$Process = $Process -split ", "
				$Object = New-Object -TypeName psobject
				$Object | Add-Member -MemberType NoteProperty -Name PID -Value $Process[0]
				$Object | Add-Member -MemberType NoteProperty -Name USER -Value $Process[1]
				$Object | Add-Member -MemberType NoteProperty -Name Process -Value ($Process[2,3,4,5,6,7,8,9] -join " ")
        
                Write-Output $Object
			}
		}
        
    }

    end {}
}