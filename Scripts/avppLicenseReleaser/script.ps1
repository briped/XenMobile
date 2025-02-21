# dot-source functions
$FunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath 'functions'
Get-ChildItem -Recurse -File -Path $FunctionsPath -Filter '*.ps1' | 
    Where-Object { $_.BaseName -notmatch '(^\.|\.dev$|\.test$)' } | 
    ForEach-Object {
        . $_.FullName
    }

# Update with the base URI for the XenMobile server, and the cookie value of JSESSIONID after logging into XenMobile in the browser.
$Script:Config = @{
    Uri       = [uri]'https://XENMOBILEHOST:4443'
    Session   = @{
        Name  = 'JSESSIONID'
        Value = 'THESESSIONIDGOESHERE'
    }
}
# Create web session object.
$Session = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
$Cookie = New-Object -TypeName System.Net.Cookie($Script:Config.Session.Name, $Script:Config.Session.Value, '/', $Script:Config.Uri.Host)
$Session.Cookies.Add($Cookie)
$Script:Config.WebSession = $Session
# Headers copied from a browsersession. Session specific values are retrived from above table.
$Headers = @{
    'Accept'             = 'application/json, text/javascript, */*; q=0.01'
    'Cache-Control'      = 'no-cache'
    'Content-Type'       = 'application/x-www-form-urlencoded'
    'Cookie'             = "$($Script:Config.Session.Name)=$($Script:Config.Session.Value)"
    'Host'               = "$($Script:Config.Uri.Host):$($Script:Config.Uri.Port)"
    'Origin'             = "$($Script:Config.Uri.Scheme)://$($Script:Config.Uri.Host):$($Script:Config.Uri.Port)"
    'Pragma'             = 'no-cache'
    'Referer'            = $Script:Config.Uri.AbsoluteUri
    'Sec-Fetch-Dest'     = 'empty'
    'Sec-Fetch-Mode'     = 'cors'
    'Sec-Fetch-Site'     = 'same-origin'
    'X-Requested-With'   = 'XMLHttpRequest'
}
$Script:Config.Headers = $Headers
$Exclude = @(
    3 # Citrix Secure Hub
)
# Get all VPP Apps from XenMobile |
#     exclude the app IDs in the $Exclude array |
#     Get the VPP licenses fro the app |
#     Revoke/release the VPP app license.
Get-VppApp | 
    Where-Object { $_.id -notin $Exclude } | 
    Get-VppAppLicense | 
    Revoke-VppAppLicense -Force