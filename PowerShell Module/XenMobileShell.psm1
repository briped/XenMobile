#
# Version: 2.0.0-beta
# Revision 2016.10.19: improved the new-xmenrollment function: added parameters of notification templates as well as all other options. Also included error checking to provide a more useful error message in case incorrect information is provided to the function. 
# Revision 2016.10.21: adjusted the confirmation on new-xmenrollment to ensure "YesToAll" actually works when pipelining. Corrected typo in notifyNow parameter name.
# Revision 1.1.4 2016.11.24: corrected example in new-xmenrollment
# Revision 1.2.0 2016.11.25: added the use of a PScredential object with the New-Session command.   
# Revision 1.2.1 2022-02-20: Code beautification and consistency.
# Revision 1.3.0 2022-02-21: Modified New-Session with static timeout parameters. This is a quick fix/workaround for making it work when the account used is RBAC limited, and not able to read server properties.
# Revision 1.4.0 2022-02-21: Added Revoke-XMEnrollment, Remove-XMEnrollment, Switch-XMDeviceAppLock, Get-XMApp
# Revision 1.4.1 2022-10-21: More code beautification and consistency.
# Revision 2.0.0-beta 2022-11-11: 
#   * Switching to follow Semantic Versioning.
#   * Change to use a PowerShell Module Manifest and CommandPrefix. Rewriting all function names and more as part of this.
#   * More code beautification and consistency.

# The request object is used by many of the functions. Do not delete.  
$Request = [PSCustomObject]@{
    Method = $null
    Entity = $null
    Uri    = $null
    Header = $null
    Body   = $null
}

$FunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath 'functions'
Get-ChildItem -Recurse -File -Path $FunctionsPath -Filter '*.ps1' | 
    Where-Object { $_.BaseName -notmatch '(^\.|\.dev$|\.test$)' } | 
    ForEach-Object {
        . $_.FullName
    }
