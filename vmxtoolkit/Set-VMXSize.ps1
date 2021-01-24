<#
	.DESCRIPTION
		A brief description of the Set-vmxsize function
    .Synopsis
        Set-VMXSize -Size <Object> {XS | S | M | L | XL | TXL | XXL} [-VMXName <Object>] [-config <Object>]
        [<CommonParameters>]
#>
function Set-VMXSize 
{
	[CmdletBinding(DefaultParametersetName = "2",HelpUri = "http://labbuildr.bottnet.de/modules/Get-VMXMemory/")]
    param 
    (
        <#name of the VMX #>
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)][Alias('NAME','CloneName')]$VMXName,
        [Parameter(Mandatory = $true, ParameterSetName = 2, ValueFromPipelineByPropertyName = $True)][string]$Path,
        [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $True)]$config,
        <#
        Size
        'XS'  = 1vCPU, 512MB
        'S'   = 1vCPU, 768MB
        'M'   = 1vCPU, 1024MB
        'L'   = 2vCPU, 2048MB
        'XL'  = 2vCPU, 4096MB 
        'TXL' = 4vCPU, 6144MB
        'XXL' = 4vCPU, 8192MB
        #>
	    [Parameter(ParameterSetName = "2", Mandatory = $true, ValueFromPipelineByPropertyName = $false)][ValidateSet('XS', 'S', 'M', 'L', 'XL','TXL','XXL')]$Size
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
            
            }
		}
        
        if ((get-vmx -Path $config).state -eq "stopped" )
        {
    
            switch ($Size)
            { 
                "XS"
                {
                    $Memory = 512
                    $Processor = 1
                }
                "S"
                {
                    $memory  = 768
                    $Processor  = 1
                }
                "M"
                {
                    $memory  = 1024
                    $Processor  = 1
                }
                "L"
                {
                    $memory  = 2048
                    $Processor  = 2
                }
                "XL"
                {
                    $memory  = 4096
                    $Processor  = 2
                }
                "TXL"
                {
                    $memory  = 6144
                    $Processor  = 2
                }
                "XXL"
                {
                    $memory  = 8192
                    $Processor  = 4
                }
            }
        
            Write-Host -ForegroundColor Gray " ==>adjusting VM to size $Size with $Processor CPU and $Memory MB"
            $cpuout = (Set-VMXprocessor -VMXName $config -Processorcount $Processor -config $config).Processor
            $memout = (Set-VMXmemory -VMXName $config -MemoryMB $Memory -config $config).Memory 
            $Object = New-Object -TypeName psobject
            $Object | Add-Member -MemberType NoteProperty -Name VMXName -Value $VMXName
            $Object | Add-Member -MemberType NoteProperty -Name Size -Value $Size
            $Object | Add-Member -MemberType NoteProperty -Name Processor -Value $cpuout
            $Object | Add-Member -MemberType NoteProperty -Name Memory -Value $Memout
            $Object | Add-Member -MemberType NoteProperty -Name Config -Value $config
            $Object | Add-Member -MemberType NoteProperty -Name Path -Value $Path

            Write-Output $Object
        }
        else
        {
            Write-Warning "VM must be in stopped state"
        }
	}
    
    end {}
    
}