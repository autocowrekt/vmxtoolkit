Function Get-VMwareLANSegment {
    <#
    .SYNOPSIS
    Gets the VMware LAN Segments for VMware Workstation Pro.
    .DESCRIPTION
    This command outputs VMware LAN Segment objects with Name and ID properties.
    A LAN segment is a private network that is shared by other virtual machines.
    A LAN segment can be useful for multitier testing, network performance analysis,
    and situations where virtual machine/appliance isolation are important.
    .EXAMPLE
    Get-VMwareLANSegment
    This default example will return each of the VMWare LAN Segments as a custom object.
    .EXAMPLE
    Get-VMwareLANSegment -Verbose
    In addition to the default output, this will display the total number of VMware LAN Segments.
    .EXAMPLE
    Get-VMwareLANSegment | where Name -eq 'link005'
    This example will return a specific VMWare LAN Segment object with the value 'link005' 
    for the Name property.
    .LINK
    https://docs.vmware.com/en/VMware-Workstation-Pro/15.0/com.vmware.ws.using.doc/GUID-DEE1E2F1-5DA4-4C83-B7C5-A1165C84C757.html
    #>
    
        [CmdletBinding()]
        Param()
    
        BEGIN {
            # VMware Workstation Pro preferences file location (default)
            $vmPref = "$env:APPDATA\VMware\preferences.ini"
        }
    
        PROCESS {
            if (Test-Path -Path $vmPref -PathType Leaf) {
                # Get total number of VMware LAN Segments aka "private virtual network"
                [int]$pvnCount = Select-String -Pattern "namedPVNs\.count" -Path $vmPref |
                Select-Object -ExpandProperty Line |
                ForEach-Object { $_.Split(' ')[2] -replace '"', "" }
                Write-Verbose "Total number of VMware LAN Segments: $pvncount"
    
                for ($i = 0; $i -lt $pvnCount; $i++) {
                    # Parse Name
                    $matchName = Select-String -Pattern "namedPVNs$i\.name" -Path $vmPref |
                    Select-Object -ExpandProperty Line
                
                    foreach ($name in $matchName) {
                        $pvnName = $name.Split(' ')[2] -replace '"', ""
                    }
    
                    # Parse ID
                    $matchID = Select-String -Pattern "namedPVNs$i\.pvnID" -Path $vmPref |
                    Select-Object -ExpandProperty Line
    
                    foreach ($id in $matchID) {
                        $pvnID = $id.SubString($id.Length-49) -replace '"', ""
                    }
    
                    # Aggregate properties
                    $pvnProp = New-Object System.Collections.Specialized.OrderedDictionary
                    $pvnProp.Add('Name',$pvnName)
                    $pvnProp.Add('ID',$pvnID)
    
                    # Create the custom object
                    $pvnObj = New-Object -TypeName PSObject -Property $pvnProp
                    $pvnObj.PSObject.TypeNames.Insert(0,'BinaryNature.VMwareLANSegment')
    
                    Write-Output $pvnObj
                }
            }
            else { Write-Warning "Failed to locate or verify $vmPref" }
        }
    
        END {}
    
    }
    