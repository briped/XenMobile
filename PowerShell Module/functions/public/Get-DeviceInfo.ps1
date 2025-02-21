function Get-DeviceInfo {
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
        $Result = Get-XMObject -Entity "/device/$($Id)"
        return $Result.device
    }
    end {}
    <#
    .SYNOPSIS
    Displays the properties of a particular device.   

    .DESCRIPTION
    This command will output all properties, settings, configurations, certificates etc of a given device. This is typically an extensive list that may need to be further filtered down.
    This command aggregates a lot of information available through other commands as well. 

    .PARAMETER Id
    Specify the ID of the device. Use get-XMDevice to find the id of each device.  

    .EXAMPLE
    Get-XMDeviceInfo -Id "8"

    #>  
}
