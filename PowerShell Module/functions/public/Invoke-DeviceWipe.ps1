function Invoke-DeviceWipe {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [int[]]$Id
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Id)) {
            Submit-XMObject -Entity '/device/wipe' -Target $Id
        }
    }
    end {}
    <#
    .SYNOPSIS
    Sends a device wipe command to the selected device.

    .DESCRIPTION
    Sends a device wipe command. this is similar to a factory reset

    .PARAMETER id
    This parameter specifies the id of the device to wipe. This can be pipelined from a search command. 

    .EXAMPLE
    Invoke-XMDeviceWipe -Id "24" 

    .EXAMPLE
    Get-XMDevice -User "ward@citrix.com" | Invoke-XMDeviceWipe

    #>
}
