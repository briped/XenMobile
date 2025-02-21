function Revoke-Enrollment { # TODO
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
        Submit-XMObject -Entity '/enrollment/revoke' -Target $Body -ErrorAction Stop
    }
    end {}
    <#
    .SYNOPSIS
    Revoke Enrollment Token

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
