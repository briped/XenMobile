function Get-DeviceProperty {
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
        $Result = Get-XMObject -Entity "/device/properties/$($Id)"
        return $Result.devicePropertiesList.deviceProperties.devicePropertyParameters
    }
    end {}
    <#
    .SYNOPSIS
    Gets the properties for the device. 

    .DESCRIPTION
    Gets the properties for the device. This is different from the get-xmdeviceinfo command which includes the properties but also returns all other information about a device. This command returns a subset of that data. 

    .PARAMETER Id
    Specify the ID of the device for which you want to get the properties. 

    .EXAMPLE
    Get-XMDeviceProperty -Id "8"

    .EXAMPLE
    Get-XMDevice -Name "Ward@citrix.com" | Get-XMDeviceProperties

    #>
}
