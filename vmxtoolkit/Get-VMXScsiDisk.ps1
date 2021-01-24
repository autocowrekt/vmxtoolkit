<#	
	.SYNOPSIS
		A brief description of the Get-VMXScsiDisk function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXScsiDisk function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXScsiDisk -config $value1 -Name $value2
	.EXAMPLE
        $VMX = Get-VMX .\ISINode1
        $Disks = $VMX | Get-VMXScsiDisk
        $Disks | ForEach-Object {[System.Math]::Round((Get-ChildItem "$($VM.Path)\$($_.Disk)").Length/1MB,2)}
        511,19
        269,44
        233,06
        230,06
        259,31
	.NOTES
		Additional information about the function.
#>
function Get-VMXScsiDisk
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXScsiDisk/")]
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]	
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "3", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$vmxconfig
	)
    
    begin {}

    process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
		    { 
                $vmxconfig = Get-VMXConfig -VMXName $VMXname
                $config = $vmxconfig.config
            }
			"2"
			{
                $vmxconfig = Get-VMXConfig -config $config
            }
		}
        
        $Patterntype = ".fileName"
		$ObjectType = "SCSIDisk"
		$ErrorActionPreference = "silentlyContinue"
		Write-Verbose -Message $ObjectType
		$Value = Search-VMXPattern -Pattern "scsi\d{1,2}:\d{1,2}.fileName" -vmxconfig $vmxconfig -name "SCSIAddress" -value "Disk" -patterntype $Patterntype
        
        foreach ($Disk in $value)
		{
			#$DiskProperties = Search-VMXPattern -Pattern "$($Disk.ScsiAddress)" -vmxconfig $vmxconfig -name "DiskPropreties" -value "Disk" -patterntype ".virtualSSD"
			$VirtualSSD = Search-VMXPattern -pattern "$($Disk.ScsiAddress).virtualssd" -vmxconfig $VMXconfig -patterntype ".virtualSSD" -name "virtualssd" -value "value"
			$Mode = Search-VMXPattern -pattern "$($Disk.ScsiAddress).mode" -vmxconfig $VMXconfig -patterntype ".mode" -name "mode" -value "value"
			$writeThrough = Search-VMXPattern -pattern "$($Disk.ScsiAddress).writeThrough" -vmxconfig $VMXconfig -patterntype ".writeThrough" -name "writeThrough" -value "value"

			$Object = New-Object -TypeName psobject
			$Object.pstypenames.insert(0,'vmxscsidisk')
			$Object | Add-Member -MemberType NoteProperty -Name VMXname -Value $VMXname
			$Object | Add-Member -MemberType NoteProperty -Name SCSIAddress -Value $Disk.ScsiAddress
            $Object | Add-Member -MemberType NoteProperty -Name Controller -Value ($Disk.ScsiAddress.Split(":")[0]).replace("scsi","")
            $Object | Add-Member -MemberType NoteProperty -Name LUN -Value $Disk.ScsiAddress.Split(":")[1]
			$Object | Add-Member -MemberType NoteProperty -Name Disk -Value $Disk.disk
			$Object | Add-Member -MemberType NoteProperty -Name VirtualSSD -Value $VirtualSSD.value
			$Object | Add-Member -MemberType NoteProperty -Name Mode -Value $mode.value
			$Object | Add-Member -MemberType NoteProperty -Name writeThrough -Value $writeThrough.value
        
            If ($PsCmdlet.ParameterSetName -eq 2)
                {
                    $Diskpath = split-path -Parent $config
                    $Diskfile = Join-Path $Diskpath $Disk.disk
                    $Object | Add-Member -MemberType NoteProperty -Name SizeonDiskMB -Value ([System.Math]::Round((get-item $Diskfile).length/1MB,2))
                    $Object | Add-Member -MemberType NoteProperty -Name DiskPath -Value $Diskpath
                }

            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
			Write-Output $Object
		}
	}
    
    end { }
    
} #end Get-VMXScsiDisk