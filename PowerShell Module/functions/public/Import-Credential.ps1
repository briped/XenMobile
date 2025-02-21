function Import-Credential { #TODO
	param(
		[string]
        $Path = "credentials.enc.xml"
	)

	# Import credential file
	$Import = Import-Clixml $Path

	# Test for valid import
	if (!$Import.UserName -or !$Import.EncryptedPassword) {
		throw "Input is not a valid ExportedPSCredential object, exiting."
	}
	$Username = $Import.Username

	# Decrypt the password and store as a SecureString object for safekeeping
	$SecurePass = $Import.EncryptedPassword | ConvertTo-SecureString

	# Build the new credential object
	$Credential = New-Object System.Management.Automation.PSCredential $Username, $SecurePass
	Write-Output $Credential
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
