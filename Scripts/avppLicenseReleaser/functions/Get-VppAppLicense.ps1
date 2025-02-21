function Get-VppAppLicense {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true
                ,  Position = 0
                ,  ValueFromPipeline = $true
                ,  ValueFromPipelineByPropertyName = $true
                ,  ValueFromRemainingArguments = $false)]
        [int]
        $Id
    )
    begin {
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name)"
        $Attributes = @{
            Method = 'GET'
            Headers    = $Script:Config.Headers
            WebSession = $Script:Config.WebSession
        }
    }
    process {
        $Attributes.Uri = "$($Script:Config.Uri.AbsoluteUri)controlpoint/rest/application/appstore/$($Id)"
        try {
            $Response = Invoke-WebRequest @Attributes
        }
        catch {
            throw $_
        }
        $Data = $Response.Content | ConvertFrom-Json
        $PlatformData = $Data.result.platformData
        $Platforms = ($PlatformData.psobject.Members | Where-Object { $_.MemberType -eq 'NoteProperty' }).Name
        $Associations = @()
        foreach ($Platform in $Platforms) {
            $Associations += $PlatformData.${Platform}.avppTokenParams.avppTokenRecordParams
        }
        $Associations | Sort-Object -Unique -Property licenseId
    }
    end {}
}
