function Get-DeviceDeliveryGroups {
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
        $Result = Get-XMObject -Entity "/device/$($Id)/deliverygroups"
        return $Result.deliveryGroups
    }
    end {}
    <#
    .SYNOPSIS
    Displays the delivery groups for a given device specified by id.

    .DESCRIPTION
    This command lets you find all the delivery groups that apply to a particular device. You search based the ID of the device.
    To find the device id, use get-XMDevice.

    .PARAMETER Id
    Specify the ID of the device. Use get-XMDevice to find the id of each device.  

    .EXAMPLE
    Get-XMDeviceDeliveryGroups -Id "8"

    #>
}
