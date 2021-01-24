<#
	.SYNOPSIS
		A brief description of the get-vmxsnapshotconfig function.

	.DESCRIPTION
		gets detailed Information on the Snapshot Confguration
#>
function Get-VMXSnapshotconfig
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][Alias('TemplateName')][string]$VMXName,
		[Parameter(Mandatory = $false, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$Path = "$Global:vmxdir",
		[Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$VMXSnapconfig
	)
    
    Begin {}
    
    Process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{
                $config = Get-VMX -VMXName $VMXname -Path $Path 
            }
			"2"
			{
		
			}
		}
        
        Write-Verbose "Getting Snapshot configuration for $VMXName form $VMXSnapconfig"
        $Snapcfg = Get-VMXConfig -config $VMXSnapconfig -VMXName $VMXName
        $Snaps = @()
        
        $Snaps += Search-VMXPattern -pattern "snapshot\d{1,2}.uid" -vmxconfig $Snapcfg -name SnapshotNumber -value UID -patterntype ".uid"
        $CurrentUID = Search-VMXPattern -pattern "snapshot.current" -vmxconfig $Snapcfg -name CurrentUID -value UID -patterntype ".uid"
        Write-Verbose "got $($Snaps.count) Snapshots"
        write-verbose "Processing Snapshots"
        
        foreach ($snap in $Snaps)
        { 
            [bool]$isCurrent = $false
            Write-Verbose "Snapnumber: $($Snap.SnapshotNumber)"
            Write-Verbose "UID $($Snap.UID)"
            Write-verbose "Current UID $($CurrentUID.UID)"
        
            If ($snap.uid -eq $CurrentUID.uid)
            {
                $isCurrent = $True
            }
            $Parent = Search-VMXPattern -pattern "$($Snap.Snapshotnumber).parent" -vmxconfig $Snapcfg -name Parent -value ParentUID -patterntype ".parent"
            $Filename = Search-VMXPattern -pattern "$($Snap.Snapshotnumber).disk\d{1,2}.filename" -vmxconfig $Snapcfg -name Disk -value File -patterntype ".fileName"
            $Diskname = Search-VMXPattern -pattern "$($Snap.Snapshotnumber).disk\d{1,2}.node" -vmxconfig $Snapcfg -name Disk -value ID -patterntype ".node"
            $Disknum = Search-VMXPattern -pattern "$($Snap.Snapshotnumber).numDisks" -vmxconfig $Snapcfg -name Disk -value Diskcount -patterntype ".numDisks"
            $Displayname = Search-VMXPattern -pattern "$($Snap.Snapshotnumber).Displayname" -vmxconfig $Snapcfg -Name Displayname -value UserFriendlyName -patterntype ".displayName"
            $Object = New-Object psobject
            $Object | Add-Member -MemberType 'NoteProperty' -Name VMXname -Value $VMXname
            $Object | Add-Member -MemberType 'NoteProperty' -Name SnapShotnumber -Value $Snap.Snapshotnumber
            $Object | Add-Member -MemberType 'NoteProperty' -Name SnapUID -Value $Snap.UID
            $Object | Add-Member -MemberType 'NoteProperty' -Name IsCurrent -Value $isCurrent
            $Object | Add-Member -MemberType 'NoteProperty' -Name ParentUID -Value $Parent.ParentUID
            $Object | Add-Member -MemberType 'NoteProperty' -Name SnapshotName -Value $Displayname.UserFriendlyname
            $Object | Add-Member -MemberType 'NoteProperty' -Name NumDisks -Value $Disknum.Diskcount
            $Object | Add-Member -MemberType 'NoteProperty' -Name SnapFiles -Value $Filename
            $Object | Add-Member -MemberType 'NoteProperty' -Name SnapDisks -Value $Diskname
            Write-Output $Object
        }
    }
    
    End {}
}