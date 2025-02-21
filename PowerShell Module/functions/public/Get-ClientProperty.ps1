function Get-ClientProperty {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Key = $null
    )
    begin {
        #check session state
        checkSession
    }
    process {
        $Result = Get-XMObject -Entity "/clientproperties/$($Key)"
        return $Result.allClientProperties
    }
    end {}
    <#
    .SYNOPSIS
    Queries the server for client properties. 

    .DESCRIPTION
    Queries the server for server properties. Without any parameters, this command will return all properties. 

    .PARAMETER Key
    Specify the parameter for which you want to get the values. The parameter key typically looks like ENABLE_PASSWORD_CACHING. 

    .EXAMPLE
    Get-XMClientProperty  #returns all properties

    .EXAMPLE
    Get-XMClientProperty -Key "ENABLE_PASSWORD_CACHING"

    #>
}
