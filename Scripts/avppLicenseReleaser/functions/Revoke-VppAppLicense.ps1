function Revoke-VppAppLicense {
    [CmdletBinding(SupportsShouldProcess = $true
                ,  ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true
                ,  Position = 0
                ,  ValueFromPipeline = $true
                ,  ValueFromPipelineByPropertyName = $true
                ,  ValueFromRemainingArguments = $false)]
        [long[]]
        $LicenseId
        ,
        [Parameter()]
        [int]
        $XdmID = 13
        ,
        [Parameter()]
        [int]
        $StoreId = 1474254492
        ,
        [Parameter()]
        [int]
        $Start = 0
        ,
        [Parameter()]
        [int]
        $Limit = 10
        ,
        [Parameter()]
        [switch]
        $Force
    )
    begin {
        if ($Force -and !$PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }
        Write-Verbose -Message "$($MyInvocation.MyCommand.Name)"
        $Attributes = @{
            Method     = 'POST'
            Uri        = "$($Script:Config.Uri.AbsoluteUri)controlpoint/rest/application/appstore/avpp/disassociate"
            Headers    = $Script:Config.Headers
            WebSession = $Script:Config.WebSession
        }
    }
    process {
        for ($i = 0; $i -lt $LicenseId.Count; $i += $Limit) {
            $Data = @()
            $Data += "xdmId=$($XdmId)"
            $Data += "storeId=$($StoreId)"
            # Only revoke the $Limit number of licenses at a time.
            $IdSet = $LicenseId[$i..([math]::Min($i + $Limit - 1, $LicenseId.Count - 1))]
            if ($PSCmdlet.ShouldProcess($IdSet -join ',')) {
                $IdSet | ForEach-Object { $Data += "licenseIds%5B%5D=$($_)" }
                $Attributes.Body = ($Data -join '&')
                try {
                    $Response = Invoke-WebRequest @Attributes
                }
                catch {
                    throw $_
                }
            }
        }
    }
    end {}
}
