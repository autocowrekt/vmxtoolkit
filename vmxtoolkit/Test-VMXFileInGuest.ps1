function Test-VMXFileInGuest
{
	[CmdletBinding(HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
    param 
    (
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$Filename,
        [Parameter(ParameterSetName = "1", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gu')]$Guestuser, 
        [Parameter(ParameterSetName = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)][Alias('gp')]$Guestpassword
    )

    begin {}

    process 
    {
        $fileok = .$vmrun -gu $Guestuser -gp $Guestpassword fileExistsInGuest  $config $Filename
        
        if ($fileok -match "exists")
	    {
            Write-Output $True
        }
	    else
	    {
            Write-Output $false
        }
    }
    
    end {}

}