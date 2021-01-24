function Wait-VMXuserloggedIn
{
    param 
    (
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword,
        $testuser
	)
    	Write-Host -ForegroundColor Gray -NoNewline " ==>waiting for user $whois logged in machine $machine"
	    $vmx = get-vmx $machine
	do
    {
		$sleep = 1
		$ProcInGuest = Get-VMXProcessesInGuest -config $config -Guestuser $Guestuser -Guestpassword $Guestpassword
    
        foreach ($i in  (1..$sleep))
        {
			Write-Host -ForegroundColor Yellow "-`b" -NoNewline
			Start-Sleep 1
			Write-Host -ForegroundColor Yellow "\`b" -NoNewline
			Start-Sleep 1
			Write-Host -ForegroundColor Yellow "|`b" -NoNewline
			Start-Sleep 1
			Write-Host -ForegroundColor Yellow "/`b" -NoNewline
			Start-Sleep 1
        }
	}
    until ($ProcInGuest -match $testuser) 
    
    Write-Host	-ForegroundColor Green "[success]"
    $Object = New-Object -TypeName psobject
    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
    $Object | Add-Member -MemberType NoteProperty -Name Config -Value $Config
    $Object | Add-Member -MemberType NoteProperty -Name User -Value $testuser
    $Object | Add-Member -MemberType NoteProperty -Name LoggedIn -Value $true
	Write-Output $Object
}