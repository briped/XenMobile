function Remove-Enrollment { # TODO
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeLineByPropertyName, 
            ValueFromPipeLine, 
            Mandatory = $true)]
        [string[]]$Token
    )
    begin {
        #check session state
        checkSession
    }
    process {
        $Body = "[`"$($Token -join '","')`"]"
        Remove-XMObject -Entity '/enrollment/revoke' -Target $Body -ErrorAction Stop
    }
    end {}
    <#
    .SYNOPSIS
    Remove Enrollment Token

    .DESCRIPTION
    NEEDS TEXT

    .PARAMETER Token
    NEEDS TEXT

    .EXAMPLE
    NEEDS TEXT

    .EXAMPLE
    NEEDS TEXT

    #>
}
