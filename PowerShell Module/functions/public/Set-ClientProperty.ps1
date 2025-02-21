function Set-ClientProperty {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Displayname = $null,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description = $null,

        [Parameter(ValueFromPipelineByPropertyName, 
            mandatory)]
        [string]$Key,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Value = $null
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Key)) {
            if (!$Displayname) {
                $Displayname = (Get-XMClientProperty -Key $Key).displayName
            }
            if (!$Description) {
                $Description = (Get-XMClientProperty -Key $Key).description
            }
            if (!$Value) {
                $Value = (Get-XMClientProperty -Key $Key).value
            }
            $Body = @{
                displayName = $Displayname;
                description = $Description;
                value       = $Value
            }
            Write-Verbose -Message "Changing: displayName: $($Displayname), description: $($Description), key: $($Key), value: $($Value)"
            Set-XMObject -Entity "/clientproperties/$($Key)" -Target $Body
        }
    }
    end {}
    <#
    .SYNOPSIS
    Edit a client property. 

    .DESCRIPTION
    Edit a client property. Specify the key. All other properties are optional and will unchanged unless otherwise specified. 

    .PARAMETER Displayname
    Specify name of the property. 

    .PARAMETER Description
    Specify the description of the property.

    .PARAMETER Key
    Specify the key. 

    .PARAMETER Value
    Specify the value of the property. 

    .EXAMPLE
    Set-XMClientProperty -Key "ENABLE_TOUCH_ID_AUTH" -Value "false"

    #>
}
