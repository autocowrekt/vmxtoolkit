function New-VMXGuestPath
{
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "2", Mandatory = $true)]$targetpath,
        [Parameter(ParameterSetName = 2, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 2, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword
    )

    if (!$VMXName)
    {
        $VMXName = (Split-Path -Leaf -Path $config).Replace(".vmx","") 
    }
    
    $cmdresult = &$vmrun -gu $Guestuser -gp $Guestpassword directoryExistsInGuest $config $targetpath # 2>&1 | Out-Null
    Write-Verbose $cmdresult
    
    if ($cmdresult -eq "The directory exists.")
    {
        Write-Warning "$cmdresult : $targetpath"
    }        
    else
    {
        Write-Verbose $targetpath
    
        do
        {
            $cmdresult = &$vmrun -gu $Guestuser -gp $Guestpassword createDirectoryInGuest $config $targetpath # 2>&1 | Out-Null
        }
		until ($VMrunErrorCondition -notcontains $cmdresult)
 
        if ($LASTEXITCODE -ne 0)
        {
            Write-Warning "$cmdresult , does $targetpath already exist ? "
        }
        else 
        {
            $Object = New-Object -TypeName psobject
		    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		    $Object | Add-Member -MemberType NoteProperty -Name Targetpath -Value $targetpath
            $Object | Add-Member -MemberType NoteProperty -Name CreateTime -Value (Get-Date -Format "yyyy.MM.dd hh:mm")
            Write-Output $Object
        }
    }
}
