function Get-App { #TODO
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeLineByPropertyName, 
            ValueFromPipeLine)]
        [string]$Search,

        [Parameter(ValueFromPipeLine)]
        [ValidateSet('mdx', 
            'enterprise', 
            'store', 
            'weblink', 
            'saas', 
            'all')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string]$FilterByType = 'all',

        [Parameter(ValueFromPipeLine)]
        [ValidateSet('iOS', 
            'Android', 
            'AndroidKNOX', 
            'WinPhone', 
            'Windows8', 
            'WindowsCE', 
            'All')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string]$FilterByPlatform = 'All',

        [Parameter()]
        [int]$Start = 0,

        [Parameter()]
        [int]$Limit = 10,

        [Parameter()]
        [ValidateSet('ASC', 
            'DESC')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string]$Sort = 'ASC',

        [Parameter()]
        [switch]$EnableCount
    )
    begin {
        checkSession
        $Body = @{
            enableCount = $EnableCount.ToString()
            start = $Start
            limit = $Limit
        }
    }
    process {
        if ($Search) {
            $Body.Add('search', $Search)
        }
        $Filter = @()
        if ($FilterbyType -and $FilterByType -ne 'All') {
            $Filter += "[application.type.$($FilterByType.ToLower())]"
        }
        if ($FilterByPlatform -and $FilterByPlatform -ne 'All') {
            $Filter += "[application.platform.$($FilterByPlatform.ToLower())]"
        }
        if ($Filter.Length -gt 0) {
            $Body.Add('filterIds', $($Filter -join ','))
        }
        $Response = Submit-XMObject -Entity '/application/filter' -Target $Body
        return $Response.applicationListData.appList
    }
    end {}
    <#
    .SYNOPSIS
    Get Applications by Filter

    .DESCRIPTION
    NEEDS TEXT

    .PARAMETER Search
    NEEDS TEXT

    .PARAMETER FilterByType
    NEEDS TEXT

    .PARAMETER FilterByPlatform
    NEEDS TEXT

    .PARAMETER Start
    NEEDS TEXT

    .PARAMETER Limit
    NEEDS TEXT

    .PARAMETER Sort
    NEEDS TEXT

    .PARAMETER EnableCount
    NEEDS TEXT

    .EXAMPLE
    NEEDS TEXT

    .EXAMPLE
    NEEDS TEXT

    #>
}
