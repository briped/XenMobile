function Get-Enrollment { # TODO
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$User,

        [Parameter()]
        [string]$Filter = '[]',

        [Parameter()]
        [int]$ResultSetSize = 999
    )
    begin {
        #check session state
        checkSession
    }
    process {
        $Searchresult = Find-XMObject  -Entity '/enrollment/filter' -Criteria $User -FilterIds $Filter -ResultSetSize $ResultSetSize
        $ResultSet =  $Searchresult.enrollmentFilterResponse.enrollmentList.enrollments
        $ResultSet | Add-Member -NotePropertyName AgentNotificationTemplateName -NotePropertyValue $Searchresult.enrollmentFilterResponse.enrollmentList.enrollments.notificationTemplateCategories.notificationTemplate.name
        return $ResultSet
    }
    end {}
    <#
    .SYNOPSIS
    Searches for enrollment invitations. 
    
    .DESCRIPTION
    Searches for enrollment invitations. Without parameters, it will return all invitations. You can get all enrollment for a given user by specifing a the criteria parameter. 
    
    .PARAMETER user
    Specify the user if you wnat enrollments for a particular user account. If you specify a UPN or username, all enrollments for the username will be returned. 
    
    .PARAMETER filter
    This parameter allows you to filter results based on other criteria. The syntax is "[filter]". For example, to see all BYOD device enrolments, use "[enrollment.ownership.byod]". 
    Multiple values can be specified, separated by a comma. Following are some of the filters that can be used (not an exhaustive list). 
    enrollment.ownership.byod
    enrollment.ownership.corporate
    enrollment.ownership.unknown
    enrollment.invitationMode#classic@_fn_@invitation
    enrollment.invitationMode#invitation@_fn_@invitation
    enrollment.invitationStatus.ios
    enrollment.invitationPlatform.android
    enrollment.invitationStatus.redeemed
    enrollment.invitationStatus.expired
    enrollment.invitationStatus.pending
    enrollment.invitationStatus.failed
    
    .PARAMETER ResultSetSize
    By default, only the first 1000 entries will be returned. You can override this value to get more (or less) results. 
    
    .EXAMPLE
    Get-XMEnrollment 
    
    .EXAMPLE
    Get-XMEnrollment -User "ward@citrix.com"
    
    .EXAMPLE
    Get-XMEnrollment -Filter "[enrollment.invitationStatus.expired]"
    
    #>
}
