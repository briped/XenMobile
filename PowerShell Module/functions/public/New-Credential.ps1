function New-Credential { #TODO
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $false)]
        [string]
        $Username = "$($env:USERNAME)@citrix.com"
        ,
        # Parameter help description
        [Parameter(Mandatory = $false)]
        [string]
        $Path = 'HKCU:\Software\XenMobileShell'
    )
	[pscredential]$Credential = Get-Credential -Message 'Credential' -UserName $Username
    if (!(Test-Path -Path $Path)) {
        New-Item -Path $(Split-Path -Path $Path -Parent) -Name $(Split-Path -Path $Path -Leaf) -Force
    }
	$Secure = $Credential.Password | ConvertFrom-SecureString
    switch ($(Get-Item -Path $Path).PSProvider.Name) {
        'Registry' {
            Set-ItemProperty -Path $Path -Type String -Name $Username -Value $Secure -Force
            break
        }
        'FileSystem' {
            $File = Join-Path -Path $Path -ChildPath "$($Username).txt"
            Set-Content -Path $File -Value $Secure -Force
            break
        }
        Default {
            throw "Unsupported provider."
            break
        }
    }
    <#
    .SYNOPSIS
    Create a PSCredential for XenMobile login

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
}
