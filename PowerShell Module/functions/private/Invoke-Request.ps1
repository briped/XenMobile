function Invoke-Request { #TODO HELP
    param(
        [Parameter(Mandatory = $true)]
        $Request
    )
    try {
        $Result = Invoke-RestMethod -Method $Request.Method -Headers $Request.Header -Uri $Request.Uri -Body (ConvertTo-Json -Depth 8 $Request.Body) -ErrorAction Stop
        Write-Verbose -Message ($Result | ConvertTo-Json)
        return $Result
    }
    catch {
        Write-Host 'Submission of the request to the server failed.' -ForegroundColor Red
        $ErrorMessage = $_.Exception.Message
        Write-Host $ErrorMessage -ForegroundColor Red
    }
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Request
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
}
