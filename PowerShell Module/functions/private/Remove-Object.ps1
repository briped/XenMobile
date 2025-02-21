function Remove-Object { #TODO HELP
    param(
        [Parameter(Mandatory = $true)]
        $Entity
        ,
        [Parameter(Mandatory = $false)]
        [string]$Target
    )
    begin {}
    process { 
        $Request.Method = 'DELETE'
        $Request.Entity = $Entity
        $Request.Url    = "$($XMSServerApiUrl)$($Entity)"
        $Request.Header = @{
            'auth_token'   = $XMSAuthToken;
            'Content-Type' = 'application/json'
        }
        $Request.Body = $Target
    }
    end {
        return Invoke-Request -Request $Request
    }
    <#
    .SYNOPSIS
    Used to submit REST DELETE requests.

    .DESCRIPTION
    Long description

    .PARAMETER Entity
    Parameter description

    .PARAMETER Target
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes

    .TODO

    #>
}
