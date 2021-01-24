foreach ($Script in (Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath *.ps1)))
{
    Import-Module $Script.FullName *>&1 > $null
}



