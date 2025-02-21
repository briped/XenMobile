function Set-ServerProperty {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Value,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DisplayName = $null,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description = $null
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Name)) {
            #if no displayname or description is provided, search for the existing values and use those. 
            if (!$DisplayName) {
                $DisplayName = (Get-ServerProperty -Name $Name).displayName
            }
            if (!$Description) {
                $Description = (Get-ServerProperty -Name $Name).description
            }
            $Request.Method    = 'PUT'
            $Request.Url       = "https://$($XMSServer):$($XMSServerPort)/xenmobile/api/v1/serverproperties" 
            $Request.Header    = @{
                'auth_token'   = $XMSAuthToken;
                'Content-Type' = 'application/json'
            }
            $Request.Body      = @{
                name           = $Name;
                value          = $Value;
                displayName    = $DisplayName;
                description    = $Description;
            }
            Invoke-Request -Request $Request
        } 
    }
    end {}
    <#
    .SYNOPSIS
    Sets the server for server properties. 

    .DESCRIPTION
    Changes the value of an existing server property.  

    .PARAMETER Name
    Specify the name of the property to change. The parameter name typically looks like xms.publicapi.static.timeout. 

    .PARAMETER Value
    Specify the new value of the property. 

    .PARAMETER DisplayName
    Specify a new display name. This parameter is optional. If not specified the existing display name is used. 

    .PARAMETER Description
    Specify a new description. This parameter is optional. If not specified the existing description is used. 

    .EXAMPLE
    Set-ServerProperty -Name "xms.publicapi.static.timeout" -Value "45"

    #>
}
