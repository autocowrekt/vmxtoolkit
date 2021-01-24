function Connect-VMXcdromImage
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')][string]$VMXName,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$config,
		[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]$ISOfile,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][ValidateSet('ide','sata')]$Contoller = 'sata',
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][ValidateSet('0:0','0:1','1:0','1:1')]$Port = '0:1',
        [Parameter(Mandatory = $false)][switch]$connect=$true
	)
	
	Begin {}

    Process
	{
        if ((get-vmx -Path $config).state -eq "stopped")
        {
		    $Content = Get-Content -Path $config
		    Write-verbose "Checking for $($Contoller)$($Port).present"
        
            if (!($Content -notmatch " $($Contoller)$($Port).present"))
            {
                Write-Warning "Controller $($Contoller)$($Port) not present"
            }
        else
            {
                Write-Host -ForegroundColor Gray -NoNewline " ==> Configuring IDE $($Contoller)$($Port) on "
                Write-Host -ForegroundColor Magenta -NoNewline $VMXName
                $Object = New-Object -TypeName psobject		    
                $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
                $Object | Add-Member -MemberType 'NoteProperty' -Name Config -Value $config
                $Object | Add-Member -MemberType NoteProperty -Name Controller -Value "$($Contoller)$($Port)"
                $Content = $Content -notmatch "$($Contoller)$($Port)"
                $Content += "$($Contoller)$($Port)"+'.present = "TRUE"'
                $Content += "$($Contoller)$($Port)"+'.autodetect = "TRUE"'
            If ($connect.IsPresent -and $ISOfile)
            {
                $Content += "$($Contoller)$($Port)"+'.deviceType = "cdrom-image"'
                $Content += "$($Contoller)$($Port)"+'.startConnected = "TRUE"'
                $Content += "$($Contoller)$($Port)"+'.fileName = "'+$ISOfile+'"'
                $Object | Add-Member -MemberType NoteProperty -Name ISO -Value $ISOfile
                
            }
            else
            {
                $Content += "$($Contoller)$($Port)"+'.deviceType = "cdrom-raw"'
                $Content += "$($Contoller)$($Port)"+'.startConnected = "FALSE"'
            }
            
                $Content | Set-Content -Path $config
                Write-Host -ForegroundColor Green "[success]"
                $Object | Add-Member -MemberType 'NoteProperty' -Name Connected -Value $connect
                Write-Output $Object
            
            }
        }
        else
        {
            Write-Warning "VM must be in stopped state"
        }
	}

    End {}
	{

}
