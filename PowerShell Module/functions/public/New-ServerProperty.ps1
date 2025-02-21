function New-ServerProperty {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Value,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Description
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Name)) {
            $Request.Method    = 'POST'
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
    Create a new server property.  

    .DESCRIPTION
    Creates a new server property. All parameters are required.   

    .PARAMETER Name
    Specify the name of the property. The parameter name typically looks like xms.publicapi.static.timeout. 

    .PARAMETER Value
    Specify the value of the property. The value set during creation becomes the default value. 

    .PARAMETER DisplayName
    Specify a the display name.  

    .PARAMETER Description
    Specify a the description. 

    .EXAMPLE
    New-ServerProperty -Name "xms.something.something" -Value "indeed" -DisplayName "something" -Description "a something property."

    #>
}
