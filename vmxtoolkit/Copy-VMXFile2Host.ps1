function Copy-VMXFile2Host
{
    param 
    (
        [Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = "2", Mandatory = $true)]$Sourcefile,
        [Parameter(ParameterSetName = "2", Mandatory = $true)]$targetfile,
        [Parameter(ParameterSetName = 2, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 2, Mandatory = $false, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword
    )
    
    begin {}
    
    process
	{
	    do
	    {
            ($cmdresult = &$vmrun -gu $Guestuser -gp $Guestpassword copyfilefromguesttohost $config $Sourcefile "$targetfile")  2>&1 | Out-Null
            write-verbose "$cmdresult"
		}
		until ($VMrunErrorCondition -notcontains $cmdresult)
     
        if ($LASTEXITCODE -eq 0)
        {
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Sourcefile -Value $sourcefile
            $Object | Add-Member -MemberType NoteProperty -Name Direction -Value "==>"
            $Object | Add-Member -MemberType NoteProperty -Name Target -Value $targetfile
            $Object | Add-Member -MemberType NoteProperty -Name CreateTime -Value (Get-Date -Format "yyyy.MM.dd hh:mm")
            Write-Output $Object
        }
        else 
        {
            Write-Warning $cmdresult
        }
	}
    
    end {}

}