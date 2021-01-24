function New-VMXScsiDisk
{
    [CmdletBinding()]
    param 
    (
        [Parameter(ParameterSetName = "1",HelpMessage = "Please specify a Size between 2GB and 2000GB",
                    Mandatory = $true, ValueFromPipelineByPropertyName = $True)][validaterange(2MB,8192GB)][int64]$NewDiskSize,	
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][string]$NewDiskname,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$Path,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('Config','CloneConfig')]$vmxconfig

    )

    begin {}

    process 
    {
        Write-Host -ForegroundColor Gray " ==>creating new $($NewDiskSize/1GB)GB SCSI Disk $NewDiskName at $Path" -NoNewline

        if (!$NewDiskname.EndsWith(".vmdk")) 
        {
            $NewDiskname = $NewDiskname+".vmdk" 
        }
        
        $Diskpath = Join-Path $Path $NewDiskname    

        if ($PSCmdlet.MyInvocation.BoundParameters["debug"].IsPresent)
        {
            $returncommand = & $Global:VMware_vdiskmanager -c -s "$($NewDiskSize/1MB)MB" -t 0 -a lsilogic $Diskpath # 2>&1 
            write-host -ForegroundColor Cyan "Debug message start"
            Write-Host -ForegroundColor White "Command Returned: $returncommand"
            Write-Host -ForegroundColor White "Exitcode: $LASTEXITCODE"
            Write-Host -ForegroundColor White "Running $Global:vmwareversion"
            Write-Host -ForegroundColor White "Machines Dir $Global:vmxdir"
            Write-Host -ForegroundColor Cyan "Debug Message end"
            pause
        }
        else
        {
            $returncommand = &$Global:VMware_vdiskmanager -c -s "$($NewDiskSize/1MB)MB" -t 0 -a lsilogic $Diskpath  #2>&1 
        }

        if ($LASTEXITCODE -eq 0)
        {
            Write-Host -ForegroundColor Green "[success]"
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
            $Object | Add-Member -MemberType NoteProperty -Name Disktype -Value "lsilogic"
            $Object | Add-Member -MemberType NoteProperty -Name Diskname -Value $NewDiskname
            $Object | Add-Member -MemberType NoteProperty -Name Size -Value "$($NewDiskSize/1GB)GB"
            $Object | Add-Member -MemberType NoteProperty -Name Path -Value $Path
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $vmxconfig
            Write-Output $Object
        
            if ($PSCmdlet.MyInvocation.BoundParameters["debug"].IsPresent)
            {
                Write-Host -ForegroundColor White $Object
            }
        }
        else 
        {
            Write-Error "Error creating disk"
            Write-Host -ForegroundColor White "Command Returned: $returncommand"
            return
        }
        }
        
        end {}

}