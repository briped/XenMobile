function Remove-ClientProperty {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string[]]$Key
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Key)) {
            Write-Verbose -Message "Deleting: $($Key)"
            Remove-XMObject -Entity "/clientproperties/$($Key)" -Target $null
        }
    }
    end {}
    <#
    .SYNOPSIS
    Removes a client property. 

    .DESCRIPTION
    Removes a client property. This command accepts pipeline input.  

    .PARAMETER Key
    Specify the key of the propery to remove. This parameter is mandatory. 

    .EXAMPLE
    Remove-XMClientProperty -Key "TEST_PROPERTY"

    #>
}