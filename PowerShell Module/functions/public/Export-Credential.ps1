function Export-Credential { #TODO
	param(
        [Parameter(Mandatory = $false)]
		[pscredential]
        $Credential = (Get-Credential)
        ,
        [Parameter(Mandatory = $false)]
		[string]
        $Path = "credentials.enc.xml"
	)

	# Look at the object type of the $Credential parameter to determine how to handle it
	switch ($Credential.GetType().Name) {
		# It is a credential, so continue
		PSCredential { continue }
		# It is a string, so use that as the username and prompt for the password
		String       { $Credential = Get-Credential -Credential $Credential }
		# In all other caess, throw an error and exit
		default      { throw "You must specify a credential object to export to disk." }
	}

	# Create temporary object to be serialized to disk
	$Export = "" | Select-Object Username, EncryptedPassword

	# Give object a type name which can be identified later
	$Export.PSObject.TypeNames.Insert(0, ’ExportedPSCredential’)
	$Export.Username = $Credential.Username

	# Encrypt SecureString password using Data Protection API
	# Only the current user account can decrypt this cipher
	$Export.EncryptedPassword = $Credential.Password | ConvertFrom-SecureString

	# Export using the Export-Clixml cmdlet
	$Export | Export-Clixml $Path
	Write-Host -ForegroundColor Green "Credentials saved to: " -NoNewline

	# Return FileInfo object referring to saved credentials
	Get-Item $Path
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
