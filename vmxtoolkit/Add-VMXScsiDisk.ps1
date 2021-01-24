function Add-VMXScsiDisk
{
    [CmdletBinding()]
    param 
    (
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][string][Alias('Filenme')]$Diskname,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('VMXconfig')]$config,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$LUN,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$Controller,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][switch]$Shared,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][switch]$VirtualSSD
    )

    begin {}

    process 
    {
        Write-Verbose "adding Disk #$Disk with $Diskname to $VMXName as lun $lun controller $Controller"
        Write-Host -ForegroundColor Gray " ==>adding Disk $Diskname at Controller $Controller LUN $LUN to " -NoNewline
        Write-Host -ForegroundColor Magenta $VMXName -NoNewline
        $vmxConfig = Get-VMXConfig -config $config
        $vmxconfig = $vmxconfig | Where-Object{$_ -notmatch "scsi$($Controller):$($LUN)"}
        $AddDrives  = @('scsi'+$Controller+':'+$LUN+'.present = "TRUE"')
        $AddDrives += @('scsi'+$Controller+':'+$LUN+'.deviceType = "disk"')
        $AddDrives += @('scsi'+$Controller+':'+$LUN+'.fileName = "'+$diskname+'"')
        $AddDrives += @('scsi'+$Controller+':'+$LUN+'.mode = "persistent"')
        $AddDrives += @('scsi'+$Controller+':'+$LUN+'.writeThrough = "false"')
        
        if ($Shared.IsPresent)
        {
            $vmxconfig = $vmxconfig | Where-Object{$_ -notmatch "disk.locking"}
            $AddDrives += @('disk.locking = "false"')
            $AddDrives += @('scsi'+$Controller+':'+$LUN+'.shared = "true"')
        }
        
        if ($VirtualSSD.IsPresent )
        {
            $AddDrives += @('scsi'+$Controller+':'+$LUN+'.virtualSSD = "1"')
        }
	    else
        {
            $AddDrives += @('scsi'+$Controller+':'+$LUN+'.virtualSSD = "0"')
        }

        $vmxConfig += $AddDrives
        $vmxConfig | Set-Content -Path $config
        Write-Host -ForegroundColor Green "[success]"
        $Object = New-Object -TypeName psobject
        $Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
        $Object | Add-Member -MemberType NoteProperty -Name Filename -Value $Diskname
        $Object | Add-Member -MemberType NoteProperty -Name Cotroller -Value $Controller
        $Object | Add-Member -MemberType NoteProperty -Name LUN -Value $LUN
        $Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config
        $Object | Add-Member -MemberType NoteProperty -Name Shared -Value $Shared.IsPresent
        $Object | Add-Member -MemberType NoteProperty -Name VirtualSSD -Value $VirtualSSD.IsPresent
        Write-Output $Object
    }

    end {}

} 