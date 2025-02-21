function Get-Object { #TODO HELP
    param(
        [Parameter(Mandatory = $true)]
        $Entity
    )
    begin {}
    process {
        $Request.Method = 'GET'
        $Request.Entity = $Entity
        $Request.Url    = "$($XMSServerApiUrl)$($Entity)"
        $Request.Header = @{
            'auth_token'   = $XMSAuthToken;
            'Content-Type' = 'application/json'
        }
        $Request.Body   = $null
    }
    end {
        return Invoke-Request -Request $Request
    }
    <#
    .SYNOPSIS
    Used to submit REST GET requests.
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Entity
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
}
