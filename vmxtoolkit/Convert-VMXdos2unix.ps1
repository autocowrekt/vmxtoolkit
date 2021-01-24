function Convert-VMXdos2unix
{
    param 
    (
	    [Parameter(ParameterSetName = "2", Mandatory = $true)]$Sourcefile
    )
    
    begin {}
	
	process
	{
        Get-ChildItem $Sourcefile | ForEach-Object 
        {
            # get the contents and replace line breaks by U+000A
            $contents = [IO.File]::ReadAllText($_) -replace "`r`n?", "`n"
            # create UTF-8 encoding without signature
            $utf8 = New-Object System.Text.UTF8Encoding $false
            # write the text back
            [IO.File]::WriteAllText($_, $contents, $utf8)
        }
	}

    end {}
	
}