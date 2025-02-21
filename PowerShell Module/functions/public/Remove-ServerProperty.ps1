function Remove-ServerProperty {
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string[]]$Name
    )
    begin {
        #check session state
        checkSession
    }
    process {
        if ($PSCmdlet.ShouldProcess($Name)) {
            Write-Verbose "Deleting $($Name)"
            Remove-XMObject -Entity "/serverproperties" -Target $Name
        }
    }
    end {}
    <#
    .SYNOPSIS
    Removes a server property. 

    .DESCRIPTION
    Removes a server property. This command accepts pipeline input.  

    .PARAMETER Name
    Specify the name of the propery to remove. This parameter is mandatory. 

    .EXAMPLE
    Remove-ServerProperty -Name "xms.something.something"

    #>
}
