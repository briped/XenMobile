function Invoke-DeviceSelectiveWipe {
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
        if ($PSCmdlet.ShouldProcess($id)) {
            Submit-XMObject -Entity '/device/selwipe' -Target $Id
        }
    }
    end {}
    <#
    .SYNOPSIS
    Sends a selective device wipe command to the selected device.

    .DESCRIPTION
    Sends a selective device wipe command. This removes all policies and applications installed by the server but leaves the rest of the device alone.

    .PARAMETER Id
    This parameter specifies the id of the device to wipe. This can be pipelined from a search command. 

    .EXAMPLE
    Invoke-XMDeviceSelectiveWipe -Id "24"

    .EXAMPLE
    Get-XMDevice -User "ward@citrix.com" | Invoke-XMDeviceSelectiveWipe

    #>
}
