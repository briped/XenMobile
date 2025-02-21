function Get-Device { # TODO
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$Criteria,

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
        $Results = Find-XMObject -Entity '/device/filter' -Criteria $Criteria -FilterIds $Filter -ResultSetSize $ResultSetSize
        return $Results.filteredDevicesDataList 
    }
    end {}
    <#
    .SYNOPSIS
    Basic search function to find devices

    .DESCRIPTION
    Search function to find devices. If you specify the user parameter, you get all devices for a particular user. 
    The devices are returned as an array of objects, each object representing a single device. 

    .PARAMETER Criteria
    Specify a search criteria. If you specify a UPN or username, all enrollments for the username will be returned. 
    It also possible to provide other values such as serial number to find devices. Effectively, anything that will work in the 'search' field in the GUI will work here as well.    

    .PARAMETER Filter
    Specify a filter to further reduce the amount of data returned.  The syntax is "[filter]". For example, to see all MDM device enrolments, use "[device.mode.mdm.managed,device.mode.mdm.unmanaged]".
    Here are some of the filters: 
    device.mode.enterprise.managed
    device.mode.enterprise.unmanaged
    device.mode.mdm.managed
    device.mode.mdm.unmanaged
    device.mode.mam.managed
    device.mode.mam.unmanaged 
    device.status.jailbroken
    device.status.as.gateway.blocked
    device.status.out.of.compliance
    device.status.samsung.knox.not.attested
    device.status.enrollment.program.registred (for Apple DEP)
    group#/group/ActiveDirectory/citrix/com/XM-Users@_fn_@normal   (for users in AD group XM-users in the citrix.com AD)
    device.platform.ios
    device.platform.android
    device.platform#10.0.1@_fn_@device.platform.ios.version   (for iOS device, version 10.0.1)
    device.ownership.byod
    device.ownership.corporate
    device.ownership.unknown
    device.inactive.time.30.days
    device.inactive.time.more.than.30.days
    device.inactive.time.8.hours

    .PARAMETER ResultSetSize
    By default only the first 1000 records are returned. Specify the resultsetsize to get more records returned. 

    .EXAMPLE
    Get-XMDevice -Criteria "ward@citrix.com" -Filter "[device.mode.enterprise.managed]"

    #>
}
