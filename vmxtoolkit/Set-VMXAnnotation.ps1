#$Addcontent += 'annotation = "This is node '+$Nodename+' for domain '+$Domainname+'|0D|0A built on '+(Get-Date -Format "MM-dd-yyyy_hh-mm")+'|0D|0A using labbuildr by @Hyperv_Guy|0D|0A Adminpasswords: Password123! |0D|0A Userpasswords: Welcome1"'

function Set-VMXAnnotation
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "https://github.com/bottkars/vmxtoolkit/wiki")]
	param
	(
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
		[Parameter(ParameterSetName = "2", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]$config,
		[Parameter(ParameterSetName = "2", Mandatory = $True, ValueFromPipelineByPropertyName = $True)]$Line1,
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$Line2,
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$Line3,
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$Line4,
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)]$Line5,
		[Parameter(ParameterSetName = "2", Mandatory = $false, ValueFromPipelineByPropertyName = $True)][switch]$builddate
	)
	
	begin {}
	
	process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			"1"
			{}
			"2"
			{}
		}

        if ((get-vmx -Path $config).state -eq "stopped" )
        {
		    $VMXConfig = Get-VMXConfig -config $config
            $VMXConfig = $VMXConfig | Where-Object {$_ -NotMatch "annotation"}
            Write-Verbose -Message "setting Annotation"
            $date = get-date
			
			if ($builddate.IsPresent)
                {
                	$Line0 = "Builddate: $date"
                }
            else
                {
                	$Line0 ="EditDate: $date"
                }
			
			$VMXConfig += 'annotation = "'+"$Line0|0D|0A"+"$Line1|0D|0A"+"$Line2|0D|0A"+"$Line3|0D|0A"+"$Line4|0D|0A"+"$Line5|0D|0A"+'"'
            $VMXConfig | Set-Content -Path $config
		    $Object = New-Object -TypeName psobject
		    $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		    $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
		    $Object | Add-Member -MemberType NoteProperty -Name Line0 -Value $Line0
		    $Object | Add-Member -MemberType NoteProperty -Name Line1 -Value $Line1
		    $Object | Add-Member -MemberType NoteProperty -Name Line2 -Value $Line2
		    $Object | Add-Member -MemberType NoteProperty -Name Line3 -Value $Line3
		    $Object | Add-Member -MemberType NoteProperty -Name Line4 -Value $Line4
		    $Object | Add-Member -MemberType NoteProperty -Name Line5 -Value $Line5
		    Write-Output $Object
        }
        else
        {
            Write-Warning "VM must be in stopped state"
        }
	}
	
	end {}
    
}#Set-VMXAnnotation