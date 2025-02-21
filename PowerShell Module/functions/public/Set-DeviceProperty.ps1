function Set-DeviceProperty {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact='High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Id,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Value
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Id)) {
            $Body     = @{
                name  = $Name;
                value = $Value
            }
            Submit-XMObject -Entity "/device/property/$($Id)" -Target $Body
        }
    }
    end {}
    <#
    .SYNOPSIS
    adds, changes a properties for a device. 

    .DESCRIPTION
    add or change properties for a device. Specify the device by ID, and property by name. To get the name of the property, search using get-xmdeviceproperties or get-xmdeviceknownproperties. 
    WARNING, avoid making changes to properties that are discovered by the existing processes. Use to to configure/set new properties. Most properties should not be changed this way.

    One property that is often changed is the ownership of a device. That property is called "CORPORATE_OWNED". Value '0' means BYOD, '1' means corporate and for unknown the property doesn't exist. 

    .PARAMETER Id
    Specify the ID of the device for which you want to get the properties. 

    .PARAMETER Name
    Specify the name of the property. Such as "CORPORATE_OWNED" 

    .PARAMETER Value
    Specify the value of the property. 

    .EXAMPLE
    Set-XMDeviceProperty -Id "8" -Name "CORPORATE_OWNED" -Value "1"

    #>
}
