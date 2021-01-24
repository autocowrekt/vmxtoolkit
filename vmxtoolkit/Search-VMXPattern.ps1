<#	
	.SYNOPSIS
		A brief description of the Search-VMXPattern function.
	
	.DESCRIPTION
		A detailed description of the Search-VMXPattern function.
	
	.PARAMETER name
		A description of the VMXname parameter.
	
	.PARAMETER pattern
		A description of the pattern parameter.
	
	.PARAMETER patterntype
		A description of the patterntype parameter.
	
	.PARAMETER value
		A description of the value parameter.
	
	.PARAMETER vmxconfig
		A description of the vmxconfig parameter.
	
	.EXAMPLE
		PS C:\> Search-VMXPattern -name $value1 -pattern $value2
	
	.NOTES
		Additional information about the function.
#>
function Search-VMXPattern  
{
    param($pattern,$vmxconfig,$name,$value,$patterntype,[switch]$nospace)
    #[array]$mypattern
    $getpattern = $vmxconfig| Where-Object {$_ -match $pattern}
    Write-Verbose "Patterncount : $getpattern.count"
    Write-Verbose "Patterntype : $patterntype"
        foreach ($returnpattern in $getpattern)
        {
            Write-Verbose "returnpattern : $returnpattern"
            $returnpattern = $returnpattern.Replace('"', '')
            if ($nospace.IsPresent)
            {
                Write-Verbose "Clearing Spaces"
                $returnpattern = $returnpattern.Replace(' ', '')#
                $returnpattern = $returnpattern.split("=")
            }
            else
            {
                $returnpattern = $returnpattern.split(" = ")
            }
            Write-Verbose "returnpattern: $returnpattern"
            Write-Verbose $returnpattern.count
    
            $nameobject = $returnpattern[0]
    Write-Verbose "nameobject fro returnpattern $nameobject "
    $nameobject = $nameobject.Replace($patterntype,"")
    $valueobject  = ($returnpattern[$returnpattern.count-1])
    Write-Verbose "Search returned Nameobject: $nameobject"
    Write-Verbose "Search returned Valueobject: $valueobject"
    
    # If ($getpattern.count -gt 1) {
    $Object = New-Object psobject
    
    if ($name) 
    {
        $Object | Add-Member -MemberType NoteProperty -Name $name -Value $nameobject
    }
    
    $Object | Add-Member -MemberType NoteProperty -Name $value -Value $valueobject
    Write-Output $Object
    
    # }
    # else
    # { Write-Output $valueobject
    # }
    }#end foreach
    # return $mypattern
}#end Search-VMXPattern