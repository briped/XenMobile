function Switch-DeviceAppLock {
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
            Submit-XMObject -Entity '/device/appLock' -Target $Id
        }
    }
    end {}
    <#
    .SYNOPSIS
    Sends app lock/unlock command.

    .DESCRIPTION
    The appLock api is a toggle api. Subsequent requests lock/unlock in a toggle fashion.

    .PARAMETER Id
    This parameter specifies the id of the device(s) to switch/toggle the App Lock for.

    .EXAMPLE
    Switch-XMDeviceAppLock -Id "8"

    .EXAMPLE
    Switch-XMDeviceAppLock -Id "8", "11"

    #>
}
