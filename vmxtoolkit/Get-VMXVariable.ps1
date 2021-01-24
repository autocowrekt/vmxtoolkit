function Get-VMXVariable
{
	[CmdletBinding(DefaultParametersetName = "1",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXIPAddress/")]
    param 
    (
		[Parameter(ParameterSetName = "1", Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$GuestVariable,
		[Parameter(ParameterSetName = "1", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$config
	)
    
    begin {}
	
	process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{

            }
			"2"
			{ 
                $vmx = Get-VMX -Path $config
                $Config = $vmx.config
            }
		}	
        
        #$ErrorActionPreference = "silentlyContinue"
        $Value = .$vmrun readVariable $config guestVar $GuestVariable
        
        If ($LASTEXITCODE -ne 0)
        {
            Write-Warning "$LASTEXITCODE , $Guestvariable"
        }
        Else
        {
            Write-Verbose -Message "getting $GuestVariable vor $VMXName"
		    $Object = New-Object -TypeName psobject
		    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		    $Object | Add-Member -MemberType NoteProperty -Name $GuestVariable -Value $Value
		    Write-Output $Object
        }
	}
    
    end {}

}