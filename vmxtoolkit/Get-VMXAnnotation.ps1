<#	
	.SYNOPSIS
		A brief description of the Get-VMXAnnotation function.
	
	.DESCRIPTION
		A detailed description of the Get-VMXAnnotation function.
	
	.PARAMETER config
		A description of the config parameter.
	
	.PARAMETER Name
		A description of the VMXname parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Get-VMXAnnotation -config $value1 -Name $value2
	
	.NOTES
		Additional information about the function.
#>
function Get-VMXAnnotation 
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXAnnotation/")]
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
            }
			"2"
			{
                $vmxconfig = Get-VMXConfig -config $config
            }
        }	
        
        $ErrorActionPreference = "silentlyContinue"
	    Write-Verbose -Message "getting annotation"
        $Annotation = $vmxconfig | Where-Object{$_ -match "annotation" }
        $annotation = $annotation -replace "annotation = "
        $annotation = $annotation -replace '"',''
        $Annotation = $annotation.replace("|0D|0A",'"')
        $Annotation = $Annotation.split('"')
		$Object = New-Object -TypeName psobject
		$Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
		$Object | Add-Member -MemberType NoteProperty -Name Line0 -Value $Annotation[0]
		$Object | Add-Member -MemberType NoteProperty -Name Line1 -Value $Annotation[1]
		$Object | Add-Member -MemberType NoteProperty -Name Line2 -Value $Annotation[2]
		$Object | Add-Member -MemberType NoteProperty -Name Line3 -Value $Annotation[3]
		$Object | Add-Member -MemberType NoteProperty -Name Line4 -Value $Annotation[4]
		$Object | Add-Member -MemberType NoteProperty -Name Line5 -Value $Annotation[5]
        Write-Output $Object
	}
    
    end {}
	
} #end Get-VMXAnnotation