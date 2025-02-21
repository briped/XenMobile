function Get-Credential { #TODO
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
    switch ($(Get-Item -Path $Path).PSProvider.Name) {
        'Registry' {
            $SecurePass = Get-ItemProperty -Path $Path -Name $Username | Select-Object -ExpandProperty $Username | ConvertTo-SecureString
            break
        }
        'FileSystem' {
            $File = Join-Path -Path $Path -ChildPath "$($Username).txt"
            $SecurePass = Get-Content -Path $File | ConvertTo-SecureString
            break
        }
        Default {
            throw "Unsupported provider."
            break
        }
    }
	$Credential = New-Object System.Management.Automation.PsCredential($Username, $SecurePass)
	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)
	$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
	return $Password
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
}
