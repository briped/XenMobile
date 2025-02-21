function Get-VppApp {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]
        $Query
        ,
        [Parameter()]
        [int]
        $Limit = 10
    )
    Write-Verbose -Message "$($MyInvocation.MyCommand.Name)"

    $Index = 0
    do {
        $Attributes = @{
            Method     = 'POST'
            Uri        = "$($Script:Config.Uri.AbsoluteUri)controlpoint/rest/application/filter/appandfilter"
            Headers    = $Script:Config.Headers
            WebSession = $Script:Config.WebSession
            Body       = "start=$($Index)&limit=$($Limit)&sortOrder=ASC&sortColumn=name&enableCount=true&filterIds=%5B%22application.type.store%22%5D&search=$([uri]::EscapeDataString($Query))"
        }
        try {
            $Response = Invoke-WebRequest @Attributes
        }
        catch {
            throw $_
        }
        $Data = $Response.Content | ConvertFrom-Json
        $Data.result.listData.list
        $Index += $Limit
    } while ($Data.result.listData.list.Count -gt 0)
}
