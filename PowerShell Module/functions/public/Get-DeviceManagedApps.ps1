function Get-DeviceManagedApps { 
    <#
    .SYNOPSIS
    Displays the XMS managed apps for a given device specified by id. Managed Apps include those apps installed from the XenMobile Store.  

    .DESCRIPTION
    This command displays all managed applications on a particular device. Managed applications are those applications that have been installed from the XenMobile Store. 
    If a public store app is installed through policy on a device where the app is already installed, the user is given the option to have XMS manage the app. In that case, the app will be included in the output of this command. 
    If the user chooses not to let XMS manage the App, it will not be included in the output of this command. the get-XMDeviceApps will still list that app. 

    .PARAMETER Id
    Specify the ID of the device. Use get-XMDevice to find the id of each device.  

    .EXAMPLE
    Get-XMDeviceManagedApps -Id "8" 

    #>
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
        $Result = Get-XMObject -Entity "/device/$($Id)/managedswinventory"
        return $Result.softwareinventory
    }
    end {}
}
