function Get-AppDetails { #TODO
    [CmdletBinding()]
    param(
        [ValidateSet('mdx', 
            'enterprise', 
            'store', 
            'weblink', 
            'saas')]
        [string]$Type,

        [Parameter(ValueFromPipeLineByPropertyName, 
            ValueFromPipeLine)]
        [int]$Id,

        [string]$Connector
    )
    begin {
        checkSession
        $Method = 'GET'
    }
    process {
        switch ($Type.ToLower()) {
            'mdx' {
                $Entity = "/application/mobile/$($Id)"
                break
            }
            'enterprise' {
                $Entity = "/application/mobile/$($Id)"
                break
            }
            'weblink' {
                $Entity = "/application/weblink/$($Id)"
                break
            }
            'saas' {
                if ($Connector) {
                    $Entity = "/application/saas/connector/$($Connector)"
                }
                else {
                    $Entity = "/application/saas/$($Id)"
                }
                break
            }
            'store' {
                $Entity = "/application/store/$($Id)"
                break
            }
        }
        $Uri = "$($XMSBaseUri)$($Entity)"
        Write-Verbose -Message "Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers"
        $Response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers
        return $Response.container
    }
    end {}
    <#
    .SYNOPSIS
    NEEDS TEXT

    .DESCRIPTION
    NEEDS TEXT

    .PARAMETER Id
    NEEDS TEXT

    .PARAMETER Platform
    NEEDS TEXT

    .EXAMPLE
    NEEDS TEXT
    {
        "status": 0,
        "message": "Success",
        "container": {
            "id": 4,
            "name": "Microsoft Word",
            "description": "app description",
            "createdOn": null,
            "lastUpdated": null,
            "disabled": false,
            "nbSuccess": 0,
            "nbFailure": 0,
            "nbPending": 0,
            "schedule": {
                "enableDeployment": true,
                "deploySchedule": "LATER",
                "deployScheduleCondition": "EVERYTIME",
                "deployDate": "3/14/2018",
                "deployTime": "17:44",
                "deployInBackground": false
            },
            "permitAsRequired": true,
            "iconData": "/9j/4AAQSkZJRgABAQEA...",
            "appType": "App Store App",
            "categories": [ "Default" ],
            "roles": [ "AllUsers" ],
            "workflow": null,
            "vppAccount": null,
            "iphone": {
                "name": "MobileApp6",
                "displayName": "Microsoft Office Word",
                "description": "Microsoft Office Word app from app store",
                "paid": false,
                "removeWithMdm": true,
                "preventBackup": true,
                "changeManagementState": true,
                "associateToDevice": false,
                "canAssociateToDevice": false,
                "canDissociateVPP": true,
                "appVersion": "2.3",
                "store": {
                    "rating": {
                        "rating": 0,
                        "reviewerCount": 0
                    },
                    "screenshots": [],
                    "faqs": [ {
                        "question": "Question?",
                        "answer": "Answer",
                        "displayOrder": 1 
                    } ],
                    "storeSettings": {
                        "rate": false,
                        "review": false
                    }
                },
                "avppParams": null,
                "avppTokenParams": null,
                "rules": null,
                "appType": "mobile_ios",
                "uuid": "8b0f08d0-52ef-453f-8d99-d4c1a3e973d7",
                "id": 9,
                "vppAccount": -1,
                "iconPath": "/9j/4AAQSkZJRgABAQE..",
                "iconUrl": "http://is3.mzstatic.com/image/thumb/Purple127/v4/e1/35/d2/e135d280-67cf-7f63-ca16-3c5f970a1d70/source/60x60bb.jpg",
                "bundleId": "com.microsoft.Office.Word",
                "appId": "586447913",
                "appKey": null,
                "storeUrl": "https://itunes.apple.com/us/app/microsoft-word/id586447913?mt=8&uo=4",
                "b2B": false
            },
            "ipad": null,
            "android": {
                "name": "MobileApp5",
                "displayName": "Microsoft Office Word","description": "Microsoft Word", "paid": false, "removeWithMdm": true, "preventBackup": true, "changeManagementState": false, "associateToDevice": false, "canAssociateToDevice": false, "canDissociateVPP": true, "appVersion": "16.0.8326.2034", "store": { "rating": { "rating": 0, "reviewerCount": 0 }, "screenshots": [], "faqs": [],
        "storeSettings": { "rate": true, "review": true } }, "avppParams": null, "avppTokenParams": null, "rules": null, "appType": "mobile_android", "uuid": "40c514dd-1a8a-4e48-96ed-512b658fb333", "id": 8, "vppAccount": -1, "iconPath": "iVBORw0KGgoAAAANSU...", "iconUrl": "https://lh3.ggpht.com/j6aNgkpGRXp9PEinADFoSkyfup46-6Rb83bS41lfQC_Tc2qg96zQ_aqZcyiaV3M-Ai4", "bundleId": "com.microsoft.office.word", "appId": null, "appKey": null, "storeUrl": "https://play.google.com/store/apps/details?id=com.microsoft.office.word", "b2B": false }, "windows": null, "android_work": null, "windows_phone": null }
    }
    #>
}
