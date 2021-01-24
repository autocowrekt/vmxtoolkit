function Remove-VMXScsiDisk
{

    [CmdletBinding()]

    param 
    (
        #[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][string][Alias('Filenme')]$Diskname,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('VMXconfig')]$config,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$LUN,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$Controller
    )

    begin {}

    process 
    {
        if ((get-vmx -Path $config).state -eq "stopped")
        {
            $vmxConfig = Get-VMXConfig -config $config
            $vmxconfig = $vmxconfig | Where-Object{$_ -notmatch "scsi$($Controller):$($LUN)"}
            Write-Verbose "Removing Disk #$Disk lun $lun from controller $Controller"
            $vmxConfig | Set-Content -Path $config
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
            $Object | Add-Member -MemberType NoteProperty -Name Cotroller -Value $Controller
            $Object | Add-Member -MemberType NoteProperty -Name LUN -Value $LUN
            $Object | Add-Member -MemberType NoteProperty -Name Status -Value "removed"
            Write-Output $Object
        }
        else
        {
            Write-Warning "VM must be in stopped state"
        }
    }

    end {}

} 