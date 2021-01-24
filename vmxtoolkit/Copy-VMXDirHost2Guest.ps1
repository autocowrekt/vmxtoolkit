function Copy-VMXDirHost2Guest
{
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "2", Mandatory = $true)]$Sourcepath,
        [Parameter(ParameterSetName = "2", Mandatory = $true)]$targetpath,
        [Parameter(ParameterSetName = "2", Mandatory = $false)][switch]$recurse,
        [Parameter(ParameterSetName = "2", Mandatory = $false)][switch]$linux,
        [Parameter(ParameterSetName = 2, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 2, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword
    )

    if (!$VMXName)
    {
        $VMXName = (Split-Path -Leaf -Path $config).Replace(".vmx","") 
    }
    
    if ($recurse.IsPresent)
    {
        $files = (Get-ChildItem -Path $Sourcepath -file -Recurse)
    }
    else
    {
        $files = (Get-ChildItem -Path $Sourcepath -File )
    }

    $NoQSourcepath =Split-Path $Sourcepath -NoQualifier
    $Sourcebranch = (Split-Path $NoQSourcepath) -replace ("\\","\\")
    write-verbose "Source Branch Directory: $Sourcebranch"
    $incr = 1

    If ($Linux.IsPresent)
    {
        $targetpath =$targetpath.Replace("\","/")
    }

    $cmdresult = &$vmrun -gu $Guestuser -gp $Guestpassword directoryExistsInGuest $config $targetpath # 2>&1 | Out-Null

    if ($cmdresult -eq "The directory does not exist.")
    {
        Write-warning "$cmdresult : $targetpath, creating it"
        Write-verbose "we will create $targetpath"
        $newpath = New-VMXGuestPath -config $config -targetpath $targetpath -Guestuser $Guestuser -Guestpassword $Guestpassword
    }

    foreach ($file in $files)
    {
        Write-Progress -Activity "Copy Files to $VMXName" -Status $file.FullName -PercentComplete (100/$files.count * $incr)
    
        do
        {
            $Targetfile = Join-Path -Path $targetpath -ChildPath ((Split-Path -NoQualifier $file.FullName) -replace ("$Sourcebranch",""))
        
            If ($Linux.IsPresent)
            {
                $Targetfile = $Targetfile.Replace("\","/")
            }			
        
            write-verbose "Target File will be $Targetfile"
            $TargetDir = Split-Path -LiteralPath $Targetfile 
            Write-Verbose "Sourcefile: $($file.fullname)"
            Write-Verbose "Targetfile: $Targetfile"
            $cmdresult = &$vmrun -gu $Guestuser -gp $Guestpassword copyfilefromhosttoguest $config $file.FullName $Targetfile # 2>&1 | Out-Null

            if ($cmdresult -eq "Error: A file was not found")
            {
                If ($Linux.IsPresent)
                {            
                    $targetdir =$targetdir.Replace("\","/")
                }

                Write-verbose "we will create $TargetDir"
                Write-Verbose $config
                $newpath = New-VMXGuestPath -config $config -targetpath $TargetDir -Guestuser $Guestuser -Guestpassword $Guestpassword
            }
        }
        until ($VMrunErrorCondition -notcontains $cmdresult)
    
        if ($LASTEXITCODE -ne 0)
        {
            Write-Warning "$cmdresult , does $Targetdir exist ? "
        }
        else 
        {
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Source -Value $file.FullName
            $Object | Add-Member -MemberType NoteProperty -Name Direction -Value "==>"
            $Object | Add-Member -MemberType NoteProperty -Name Target -Value $Targetfile
            $Object | Add-Member -MemberType NoteProperty -Name CreateTime -Value (Get-Date -Format "yyyy.MM.dd hh:mm")
            Write-Output $Object
        }
    
        $incr++
    }
}