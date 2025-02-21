function Get-ServerProperty {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]
        $Name = $null
        ,
        [Parameter(DontShow)]
        [switch]
        $SkipCheck
    )
    begin {
        #The Get-ServerProperty function is called during the Session setup in order to specify the timeout values.
        #If you check the session during this time, the check will fail.
        #Using the hidden SkipCheck parameter, we can override the check during the initial session setup.
        if (!$SkipCheck) {
            Write-verbose -Message 'Checking the session state'
            #Check session state.
            checkSession
        }
        else {
            write-verbose -Message 'The session check is skipped.'
        }
    }
    process {
        Write-Verbose -Message 'Creating the Get-ServerProperty request.'
        $Request.Entity = ''
        $Request.Method    = 'POST'
        $Request.Uri       = "https://$($XMSServer):$($XMSServerPort)/xenmobile/api/v1/serverproperties/filter"
        $Request.header    = @{
            'auth_token'   = $XMSAuthToken;
            'Content-Type' = 'application/json'
        }
        $Request.body      = @{
            start          = '0';
            limit          = '1000';
            orderBy        = 'name';
            sortOrder      = 'desc';
            searchStr      = $Name;
        }
        Write-Verbose -Message 'Submitting the Get-ServerProperty request to the server.'
        $Results = Invoke-Request -Request $Request
        return $Results.allEwProperties
    }
    end {}
    <#
    .SYNOPSIS
    Queries the server for server properties. 

    .DESCRIPTION
    Queries the server for server properties. Without any parameters, this command will return all properties. 

    .PARAMETER name
    Specify the parameter for which you want to get the values. The parameter name typically looks like xms.publicapi.static.timeout. 

    .EXAMPLE
    Get-ServerProperty  #returns all properties

    .EXAMPLE
    Get-ServerProperty -Name "xms.publicapi.static.timeout"

    #>
}
