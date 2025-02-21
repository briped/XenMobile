function New-Session { #TODO stuff
	[CmdletBinding()]
	param(
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
		,
		[Parameter(Mandatory = $false
					,ParameterSetName = 'Timeout')]
		[Parameter(Mandatory = $false
					,ParameterSetName = 'UserPass')]
		[Parameter(Mandatory = $false
					,ParameterSetName = 'Credential')]
		[ValidateSet('STATIC_TIMEOUT'
					,'INACTIVITY_TIMEOUT')]
		[string]
		$TimeoutType
		,
		[Parameter(Mandatory = $true
					,ParameterSetName = 'Timeout')]
		[int]
		$Timeout
	)
	begin {
		if (!$Credential) {
			throw 'No credentials were supplied.'
		}
	}
	process {
		$Global:XMSServer = $Server
		#Set-Variable -Name 'XMSServer' -Value $Server -Scope Global

		Write-Verbose -Message 'Setting the server port.'
		$Global:XMSServerPort = 4443
		#Set-Variable -Name 'XMSServerPort' -Value 4443 -Scope Global
		if ($Port -ne 4443) {
			$Global:XMSServerPort = $Port
			#Set-Variable -Name 'XMSServerPort' -Value $Port -Scope Global
		}
		$Global:XMSServerBaseUrl = "http://$($XMSServer):$($XMSServerPort)"
		#Set-Variable -Name 'XMSServerBaseUrl' -Value "http://$($XMSServer):$($XMSServerPort)" -Scope Global
		$Global:XMSServerApiPath = '/xenmobile/api/v1'
		#Set-Variable -Name 'XMSServerApiPath' -Value '/xenmobile/api/v1' -Scope Global
		$Global:XMSServerApiUrl = "$($XMSServerBaseUrl)$($XMSServerApiPath)"
		#Set-Variable -Name 'XMSServerApiUrl'  -Value "$($XMSServerBaseUrl)$($XMSServerApiPath)" -Scope Global

		Write-Verbose -Message 'Creating an authentication token, and setting the XMSAuthToken and XMSServer variables'
		try {
			$Global:XMSAuthToken = (Get-AuthToken -Credential $Credential -Api $XMSServerApiUrl)
			#Set-Variable -Name 'XMSAuthToken' -Value (Get-AuthToken -Credential $Credential -Api $XMSServerApiUrl) -Scope Global -ErrorAction Stop
		}
		catch {
			Write-host 'Authentication failed.' -ForegroundColor Yellow
			break
		}
		#create variables to establish the session timeout.
		$Global:XMSSessionStart = Get-Date
		#Set-Variable -Name 'XMSSessionStart' -Value (Get-Date) -Scope Global
		Write-Verbose -Message "Setting session start to: $($XMSSessionStart)"
		#check if the timeout type is set to inactivity or static and set the global value accordingly. 
		#if a static timeout is used, the session expiry can be set based on the static timeout. 
		if (!$TimeoutType) {
			Write-Verbose -Message "TimeoutType isn't defined. Will attempt to read timeout from server properties."
			Write-Verbose -Message 'Checking the type of timeout the server uses:'
			$XMSTimeoutType = Get-ServerProperty -Name 'xms.publicapi.timeout.type' -SkipCheck
			$XMSInactivityTimeout = Get-ServerProperty -Name 'xms.publicapi.inactivity.timeout' -SkipCheck
			if ($XMSTimeoutType.Value -eq 'INACTIVITY_TIMEOUT') {
				Write-Verbose -Message 'Server is using an inactivity timeout for the API session. This is preferred.'
				$Global:XMSSessionUseInactivity = $true
				#Set-Variable -Name 'XMSSessionUseInactivity' -Value $true -Scope Global
				$Global:XMSSessionInactivityTimer = [System.Convert]::ToInt32($XMSInactivityTimeout.Value)
				#Set-Variable -Name 'XMSSessionInactivityTimer' -Value ([System.Convert]::ToInt32($XMSInactivityTimeout.Value)) -Scope Global
				#due to network conditions and other issues, the actual timeout of the server may be quicker than here. So, we will reduce the timeout by 30 seconds.
				$TimeToExpiry = (($XMSSessionInactivityTimer) * 60) - 30
				$Global:XMSSessionExpiry = (Get-Date).AddSeconds($TimeToExpiry)
				#Set-Variable -Name 'XMSSessionExpiry' -Value (Get-Date).AddSeconds($TimeToExpiry) -Scope Global
				Write-Verbose -Message "The session expiry time is set to: $($XMSSessionExpiry)"
			}
			else {
				$XMSStaticTimeout = Get-ServerProperty -Name 'xms.publicapi.static.timeout' -SkipCheck
				Write-Verbose 'Server is using a static timeout. The use of an inactivity timeout is recommended.'
				$Global:XMSSessionUseInactivity = $false
				#Set-Variable -Name 'XMSSessionUseInactivity' -Value $false -Scope Global
				#get the static timeout and deduct 30 seconds. 
				$TimeToExpiry = ([System.Convert]::ToInt32($XMSStaticTimeout.Value)) * 60 - 30
				Write-Verbose -Message "Expiry in seconds: $($TimeToExpiry)"
				$Global:XMSSessionExpiry = (Get-Date).AddSeconds($TimeToExpiry)
				#Set-Variable -Name 'XMSSessionExpiry' -Value (Get-Date).AddSeconds($TimeToExpiry) -Scope Global
				Write-Verbose -Message "The session expiry time is set to: $($XMSSessionExpiry)"
			}
		}
		else {
			Write-Verbose -Message "TimeoutType is defined: $($TimeoutType)"
			if ($TimeoutType -eq "INACTIVITY_TIMEOUT") {
				Write-Verbose "   Server is using an inactivity timeout for the API session. This is preferred."
				$Global:XMSSessionUseInactivity = $true
				#Set-Variable -Name "XMSSessionUseInactivity" -Value $true -Scope Global
				$Global:XMSSessionInactivityTimer = $Timeout
				#Set-Variable -Name "XMSSessionInactivityTimer" -Value $Timeout -Scope Global
				#due to network conditions and other issues, the actual timeout of the server may be quicker than here. So, we will reduce the timeout by 30 seconds.
				$TimeToExpiry = (($XMSSessionInactivityTimer) * 60) - 30
				$Global:XMSSessionExpiry = (Get-Date).AddSeconds($TimeToExpiry)
				#Set-Variable -Name "XMSSessionExpiry" -Value (Get-Date).AddSeconds($TimeToExpiry) -Scope Global
				Write-verbose "The session expiry time is set to: $($XMSSessionExpiry)"
			}
			else {
				Write-Verbose "   Server is using a static timeout. The use of an inactivity timeout is recommended."
				$Global:XMSSessionUseInactivity = $false
				#Set-Variable -Name "XMSSessionUseInactivity" -Value $false -Scope Global
				#get the static timeout and deduct 30 seconds. 
				$TimeToExpiry = $Timeout * 60 - 30
				Write-Verbose "Expiry in seconds: $($TimeToExpiry)"
				$Global:XMSSessionExpiry = (Get-Date).AddSeconds($TimeToExpiry)
				#Set-Variable -Name "XMSSessionExpiry" -Value (Get-Date).AddSeconds($TimeToExpiry) -Scope Global
				Write-Verbose "The session expiry time is set to: $($XMSSessionExpiry)"
			}
		}
		Write-Verbose -Message 'A session has been started.'
		Write-Host "Authentication successfull. Token: $($XMSAuthToken)`nSession will expire at: $($XMSSessionExpiry)" -ForegroundColor Yellow
	}
	end {}
	<#
	.SYNOPSIS
	Starts a XMS session. Run this before running any other commands. 
	
	.DESCRIPTION
	This command will login to the server and get an authentication token. This command will set several session variables that are used by all the other commands.
	This command must be run before any of the other commands. 
	This command can use either a username or password pair entered as variables, or you can use a PScredential object. To create a PScredential object,
	run the get-credential command and store the output in a variable. 
	If both a user, password and credential are provided, the credential will take precedence. 
	
	.PARAMETER -User
	Specify the user with required permissions to access the XenMobile API. 
	
	.PARAMETER -Password
	Specify the password for the API user. 
	
	.PARAMETER -Credential
	Specify a PScredential object. This replaces the user and password parameters and can be used when stronger security is desired. 
	
	.PARAMETER -Server
	Specify the server you will connect to. This should be a FQDN, not IP address. PowerShell is picky with regards to connectivity to encrypted paths. 
	Therefore, the servername must match the certificate, be valid and trusted by system you are running these commands. 
	
	.PARAMETER -Port
	You can specify an alternative port to connect to the server. This is optional and will default to 4443 if not specified.
	
	.PARAMETER -TimeoutType
	If specified, this value, along with the -Timeout value, is used instead of querying the server for the values. This is useful if access to server properties is restricted using RBAC.
	Must be set to the same value as the Server Property "xms.publicapi.timeout.type". Can be "STATIC_TIMEOUT" or "INACTIVITY_TIMEOUT".
	
	.PARAMETER -Timeout
	If specified, this value, along with the -TimeoutType value, is used instead of querying the server for the values. This is useful if access to server properties is restricted using RBAC.
	Must be set to the same value as the Server Property associated with the timeout type; ie. "xms.publicapi.static.timeout" if STATIC_TIMEOUT and "xms.publicapi.inactivity.timeout" if INACTIVITY_TIMEOUT. 
	
	.EXAMPLE
	New-Session -User "admin" -Password "password" -Server "mdm.citrix.com"
	
	.EXAMPLE
	New-Session -User "admin" -Password "password" -Server "mdm.citrix.com" -Port "4443"
	
	.EXAMPLE
	$Credential = Get-Credential
	New-Session -Credential $Credential -Server mdm.citrix.com
	
	.EXAMPLE
	New-Session -Credential (Get-Credential) -Server mdm.citrix.com
	
	#>
}