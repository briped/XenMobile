function Remove-DeviceProperty { 
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Id,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Name
    )
    begin {
        # Check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Id)) {
            #The property is deleted based on the id of the property which is unique. 
            #Thus, we first look for the property
            $Property = Get-XMDeviceProperty -Id $Id | Where-Object {
                $PSItem.name -eq $Name
            }
            Write-Verbose -Message "Property id for property: $($Name) is $($Property.id)"
            Remove-XMObject -Entity "/device/property/$($Property.id)" -Target $null
        }
    }
    end {}
    <#
    .SYNOPSIS
    Deletes a properties for a device. 

    .DESCRIPTION
    Delete a property from a device. 
    WARNING: be careful when using this function. There is no safety check to ensure you don't accidentally delete things you shouldn't.

    .PARAMETER Id
    Specify the ID of the device for which you want to get the properties. 

    .PARAMETER Name
    Specify the name of the property. Such as "CORPORATE_OWNED" 

    .EXAMPLE
    Remove-XMDeviceProperty -Id "8" -Name "CORPORATE_OWNED"

    #>
}
