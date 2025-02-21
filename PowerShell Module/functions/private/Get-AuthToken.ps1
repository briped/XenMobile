function Get-AuthToken { # TODO stuff
	param(
		[Parameter(Mandatory = $false
					,ValueFromPipelineByPropertyName = $true
					,ValueFromPipeLine = $true)]
		[string]
		$Api
		,
		[Parameter(Mandatory = $false
					,ValueFromPipelineByPropertyName = $true
					,ValueFromPipeLine = $true)]
		[ValidateNotNull()]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credential = [System.Management.Automation.PSCredential]::Empty
		,
		[Parameter(Mandatory = $false
					,ValueFromPipelineByPropertyName = $true
					,ValueFromPipeLine = $true)]
		[string]
		$Server
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLIneByPropertyName = $true)]
		[int]
		$Port = 4443
	)
	$Entity = '/authentication/login'
	$URL    = "$($Api)$($Entity)"

	#if a credential object is used, convert the secure password to a clear text string to submit to the server. 
	if ($null -ne $Credential) {
		$User = $Credential.UserName
		$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)
	}

	$Header = @{
		'Content-Type' = 'application/json'
	}
	$Body = @{
		login          = $User;
		password       = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
	}
	Write-Verbose -Message 'Submitting authentication request.'
	$Token = Invoke-RestMethod -Uri $URL -Method POST -Body (ConvertTo-Json $Body) -Headers $Header
	Write-Verbose -Message "Received token: $($Token)"
	return [string]$Token.auth_token
	<#
	.SYNOPSIS
	This function will authenticate against the server and will provide you with an authentication token.
	Most cmdlets in this module require a token in order to authenticate against the server. 
	
	.DESCRIPTION
	This cmdlet will authenticate against the server and provide you with a token. It requires a username, password and server address. 
	The cmdlet assumes you are connecting to port 4443. All parameters can be piped into this command.  
	
	.PARAMETER Api
	Specify the API address. Example: https://mdm.citrix.com:4443/xenmobile/api/v1
	
	.PARAMETER -Credential
	Specify a PScredential object. This replaces the user and password parameters and can be used when stronger security is desired. 
	
	.PARAMETER User
	Specify the username. This username must have API access. 
	
	.PARAMETER Password
	Specify the password to use. 
	
	.PARAMETER Server
	Specify the servername. IP addresses cannot be used. Do no specify a port number. Example: mdm.citrix.com
	
	.PARAMETER Port
	Specify the port to connect to. This defaults to 4443. Only specify this parameter is you are using a non-standard port. 
	
	.EXAMPLE
	$Token = Get-AuthToken -User "admin" -Password "citrix123" -Server "mdm.citrix.com
	
	.EXAMPLE
	$Token = Get-AuthToken -Api "https://mdm.citrix.com:4443/xenmobile/api/v1" -Credential $StoredPSCredential
	
	#> 
}