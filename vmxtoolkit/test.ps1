Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath *.ps1) | ForEach-Object -Process {
    write-host $_.FullName
}