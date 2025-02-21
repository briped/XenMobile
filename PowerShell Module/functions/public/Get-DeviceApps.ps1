function Get-DeviceApps { 
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
        $Result = Get-XMObject -Entity "/device/$($Id)/apps"
        return $Result.applications
    }
    end {}
    <#
    .SYNOPSIS
    Displays all XenMobile store apps installed on a device, whether or ot the app was installed from the XenMobile Store 

    .DESCRIPTION
    This command will display all apps from the XenMobile Store installed on a device. This includes apps that were installed by the user themselves without selecting it from the XenMobile store. Thus is includes apps that are NOT managed but listed as available to the device.
    For apps that are NOT managed, an inventory policy is required to detect them. 

    This command is useful to find out which of the XenMobile store apps are installed (whether or not they are managed or installed from the XenMobile store).  

    .PARAMETER Id
    Specify the ID of the device. Use get-XMDevice to find the id of each device.  

    .EXAMPLE
    Get-XMDeviceApps -Id "8" 

    #>
}
