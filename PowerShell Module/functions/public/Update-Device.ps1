function Update-Device {
    [CmdletBinding()]
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
        write-verbose -Message "This will send an update to device $($Id)"
        Submit-XMObject -Entity '/device/refresh' -Target $Id
    }
    end {}
    <#
    .SYNOPSIS
    Sends a deploy command to the selected device. A deploy will trigger a device to check for updated policies. 

    .DESCRIPTION
    Sends a deploy command to the selected device. 

    .PARAMETER Id
    This parameter specifies the id of the device to target. This can be pipelined from a search command. 

    .EXAMPLE
    Update-XMDevice -Id "24" 

    .EXAMPLE
    Get-XMDevice -User "aford@corp.vanbesien.com" | Update-XMDevice

    #>
}
