function Import-VMXOVATemplate
{
 [CmdletBinding(DefaultParameterSetName='Parameter Set 1',HelpUri = "https://github.com/bottkars/LABbuildr/wiki/LABtools#Import-VMXOVATemplate")]
    param
    (
        [string]$OVA,
        [string]$destination=$vmxdir,
        [string]$Name,
        [switch]$acceptAllEulas,
        [Switch]$AllowExtraConfig,
        [Switch]$Quiet
    )

    if (test-path($OVA))
	{
        $OVAPath = Get-ChildItem -Path $OVA -Recurse -include "*.ova","*.ovf" |Sort-Object -Descending
        $OVAPath = $OVApath[0]
        
        if (!$Name)
        {
            $Name = $($ovaPath.Basename)
        }
        
        $ovfparam = "--skipManifestCheck"
        Write-Host -ForegroundColor Gray " ==>Importing from OVA $($ovaPath.Basename), may take a while" # -NoNewline
        
        if ($Quiet.IsPresent)
        {
            $ovfparam = "$ovfparam --quiet"
        }
        if ($acceptAllEulas.IsPresent)
        {
            $ovfparam = "$ovfparam --acceptAllEulas"
        }
        if ($AllowExtraConfig.IsPresent)
        {
            $ovfparam = "$ovfparam --allowExtraConfig"
        }
        
        Start-Process -FilePath  $Global:VMware_OVFTool -ArgumentList "--lax $ovfparam --name=$Name $($ovaPath.FullName) `"$destination" -NoNewWindow -Wait
        
        switch ($LASTEXITCODE)
            {
                0
                
                {
                    Write-Host -ForegroundColor Green "[success]"
                    $Object = New-Object -TypeName psobject
                    $Object | Add-Member -MemberType NoteProperty -Name OVA -Value $OVAPath.BaseName
                    $Object | Add-Member -MemberType NoteProperty -Name VMname -Value $Name
                    $Object | Add-Member -MemberType NoteProperty -Name Success -Value $true
                }
            
                default
                
                {
                    Write-Host -ForegroundColor Red "[failed]"
                    Write-Warning "Error $LASTEXITCODE when importing $OVAPath"
                    $Object = New-Object -TypeName psobject
                    $Object | Add-Member -MemberType NoteProperty -Name OVA -Value $OVAPath.BaseName
                    $Object | Add-Member -MemberType NoteProperty -Name VMname -Value $Name
                    $Object | Add-Member -MemberType NoteProperty -Name Success -Value $false
                }
            }
            
            Write-Output $Object
    }
    Else
    {
        Write-Host "$OVA not found"
    }
}

