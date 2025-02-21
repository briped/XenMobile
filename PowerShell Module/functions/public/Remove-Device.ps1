function Remove-Device {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipeLineByPropertyName, 
            Mandatory = $true)]
        [string[]]$Id
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Id)) {
            Remove-XMObject -Entity '/device' -Target $Id
        }
    }
    end {}
    <#
    .SYNOPSIS
    Removes a device from the XMS server and database. 

    .DESCRIPTION
    Removes a devices from the XMS server. Requires the id of the device. 

    .PARAMETER Id
    The id parameter identifies the device. You can get the id by searching for the correct device using get-device. 

    .EXAMPLE
    Remove-XMDevice -Id "21" 

    .EXAMPLE
    Get-XMDevice -User "ward@citrix.com | ForEach-Object { Remove-XMDevice -Id $PSItem.id }

    #>
}
