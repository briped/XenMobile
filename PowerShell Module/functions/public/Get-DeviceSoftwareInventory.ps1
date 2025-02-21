function Get-DeviceSoftwareInventory { 
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Id
    )
    begin {
        #check session state
        checkSession
    }
    process {
        $Result = Get-XMObject -Entity "/device/$($Id)/softwareinventory"
        return $Result.softwareInventories
    }
    end {}
    <#
    .SYNOPSIS
    Displays the application inventory of a particular device.   

    .DESCRIPTION
    This command will list all installed applications as far as the server knows. Apps managed by the server are always included, other apps (such as personal apps) are only included if an inventory policy is deployed to the device. 

    .PARAMETER Id
    Specify the ID of the device. Use get-XMDevice to find the id of each device.  

    .EXAMPLE
    Get-XMDeviceSoftwareInventory -Id "8" 

    #>
}
