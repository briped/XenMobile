function Update-PublicStoreApp { #TODO
    [CmdletBinding(SupportsShouldProcess = $true, 
        ConfirmImpact = 'High')]
    param(
        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [string]$Id,

        [Parameter(ValueFromPipelineByPropertyName, 
            Mandatory = $true)]
        [ValidateSet('iphone', 
            'ipad', 
            'android', 
            'android_work', 
            'windows', 
            'windows_phone')]
        [string]$Platform,

        [switch]$CheckForUpdate
    )
    begin {
        Get-Session
        $Method = 'PUT'
    }
    process {
        $Entity = "/application/store/$($Id)/platform/$($Platform)"
        $Uri = "$($XMSBaseUri)$($Entity)"
        if ($PSCmdlet.ShouldProcess($Id)) {
            $Payload = @{
                checkForUpdate = $CheckForUpdate.ToString()
            }
            $JSON = $Payload | ConvertTo-Json
            Write-Verbose -Message "Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -Body $JSON"
            $Response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -Body $JSON
            return $Response.container
        }
    }
    end {}
    <#
    .SYNOPSIS


    .DESCRIPTION


    .PARAMETER Id


    .PARAMETER Platform


    .EXAMPLE

    {
        "removeWithMdm": false,
        "preventBackup": false,
        "changeManagementState": false,
        "displayName": "Microsoft Word - App Store",
        "description": "description",
        "faqs": [ {
            "question": "Question?",
            "answer": "Answer"
        } ],
        "storeSettings": {
            "rate": false,
            "review": false
        },
        "checkForUpdate": true
    }

    Valid plaforms are: iphone, ipad, android, android_work, windows, windows_phone.
    #>
}
