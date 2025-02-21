function New-ClientProperty {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Displayname,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Description,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Key,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Value
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Key)) {
            $Body           = @{
                displayName = $Displayname;
                description = $Description;
                key         = $Key;
                value       = $Value
            }
            Write-Verbose -Message "Creating: displayName: $($Displayname), description: $($Description), key: $($Key), value: $($Value)"
            Submit-XMObject -Entity '/clientproperties' -Target $Body
        }
    }
    end {}
    <#
    .SYNOPSIS
    Creates a new client property. 

    .DESCRIPTION
    Creates a new client property. All parameters are required. Use this to create/add new properties. To change an existing property, use set-xmclientproperty

    .PARAMETER Displayname
    Specify name of the property. 

    .PARAMETER Description
    Specify the description of the property.

    .PARAMETER Key
    Specify the key. 

    .PARAMETER Value
    Specify the value of the property. The value set when the property is created is used as the default value. 

    .EXAMPLE
    New-XMClientProperty -Displayname "Enable touch ID" -Description "Enables touch ID" -Key "ENABLE_TOUCH_ID_AUTH" -Value "true"

    #>
}
