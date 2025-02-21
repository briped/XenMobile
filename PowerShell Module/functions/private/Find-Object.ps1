function Find-Object { #TODO HELP
    param(
        [Parameter(Mandatory = $false)]
        $Criteria = $null
        ,
        [Parameter(Mandatory = $true)]
        $Entity
        ,
        [Parameter(Mandatory = $false)]
        $FilterIds = '[]'
        ,
        [Parameter(Mandatory = $false)]
        $ResultSetSize = 999
    )
    begin {}
    process { 
        $Request.Method = 'POST'
        $Request.Entity = $Entity
        $Request.Uri    = "$($XMSServerApiUrl)$($Entity)"
        $Request.Header = @{
            'auth_token'   = $XMSAuthToken;
            'Content-Type' = 'application/json'
        }
        $Request.Body   = @{
            start          = '0';
            limit          = [int]$ResultSetSize;
            sortOrder      = 'ASC';
            sortColumn     = 'ID';
            search         = $Criteria;
            enableCount    = 'true';
            filterIds      = $FilterIds
        }
    }
    end {
        return Invoke-Request -Request $Request
    }
    <#
    .SYNOPSIS
    Used to submit a search request to the server and return the results.
    
    .DESCRIPTION
    This function submits a search request to the server and returns the results.
    A token is required, server, as well as the url which specifies the API this goes to. 
    The url is the portion after https://<server>:4443/xenmobile/api/v1 beginning with slash. 
    
    .PARAMETER Criteria
    Parameter description
    
    .PARAMETER Entity
    Parameter description
    
    .PARAMETER FilterIds
    Parameter description
    
    .PARAMETER ResultSetSize
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
}
