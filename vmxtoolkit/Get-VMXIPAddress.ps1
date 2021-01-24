function Get-VMXIPAddress
{
	[CmdletBinding(DefaultParametersetName = "1",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXIPAddress/")]
    param
    (
		[Parameter(ParameterSetName = "1", Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
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
        
        try
        {
            $IPAddress = .$vmrun getguestipaddress $config
        }
        catch {}
        
        If ($LASTEXITCODE -ne 0)
            {
                Write-Warning "$LASTEXITCODE , $IPAddress"
            }
        Else
            {
                Write-Verbose -Message "getting $ObjectType"
                
                $Object = New-Object -TypeName psobject
                $Object | Add-Member -MemberType NoteProperty -Name "VMXName" -Value $VMXName
                $Object | Add-Member -MemberType NoteProperty -Name "IPAddress" -Value $IPAddress
                Write-Output $Object
                
            }
	}
    
    end {}

}#end Get-VMXIPAddress