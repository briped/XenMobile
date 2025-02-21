function New-Enrollment {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true
					,ValueFromPipeLineByPropertyName = $true
					,ValueFromPipeLine = $true)]
		[string]
		$User
		,
		[Parameter(Mandatory = $true
					,ValueFromPipeLineByPropertyName = $true
					,ValueFromPipeLine = $true)]
		[ValidateSet('iOS'
					,'SHTP')]
		[string]
		$OS
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[string]
		$PhoneNumber
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[string]
		$Carrier
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[ValidateSet('SERIALNUMBER'
					,'UDID'
					,'IMEI')]
		[string]
		$DeviceBindingType = 'SERIALNUMBER',

		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		$DeviceBindingData
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true
					,ValueFromPipeline = $true)]
		[ValidateSet('CORPORATE'
					,'BYOD'
					,'NO_BINDING')]
		[string]
		$Ownership = 'NO_BINDING'
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[ValidateSet('classic'
					,'high_security'
					,'invitation'
					,'invitation_pin'
					,'invitation_pwd'
					,'username_pin'
					,'two_factor')]
		[string]
		$Mode = 'classic'
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[string]
		$AgentTemplate
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[string]
		$InvitationTemplate
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[string]
		$PinTemplate
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[string]
		$ConfirmationTemplate
		,
		[Parameter(Mandatory = $false
					,ValueFromPipeLineByPropertyName = $true)]
		[ValidateSet('true'
					,'false')]
		[string]
		$NotifyNow = 'false'
		,
		[Parameter(Mandatory = $false)]
		[switch]
		$Force
	)
	begin {
		#check session state
		checkSession
		$RejectAll  = $false
		$ConfirmAll = $false
	}
	process {
		if ($Force -or $PSCmdlet.ShouldContinue('Do you want to continue?', "Creating enrollment for '$($User)'", [ref]$ConfirmAll, [ref]$RejectAll)) {
			$Body = @{
				platform = $OS
				deviceOwnership = $Ownership
				mode = @{
					name = $Mode
				}
				userName = $User
				notificationTemplateCategories = @(
					@{
						notificationTemplate = @{
							name = $AgentTemplate
						}
						category = 'ENROLLMENT_AGENT'
					}
					@{
						notificationTemplate = @{
							name = $InvitationTemplate
						}
						category = 'ENROLLMENT_URL'
					}
					@{
						notificationTemplate = @{
							name = $PinTemplate
						}
						category = 'ENROLLMENT_PIN'
					}
					@{
						notificationTemplate = @{
							name = $ConfirmationTemplate
						}
						category = 'ENROLLMENT_CONFIRMATION'
					}
				)
				phoneNumber = $PhoneNumber
				carrier = $Carrier
				deviceBindingType = $DeviceBindingType
				deviceBindingData = $DeviceBindingData
				notifyNow = $NotifyNow
			}
			Write-Verbose -Message 'Created enrollment request object for submission to server.'
			$EnrollmentResult = Submit-XMObject -Entity '/enrollment' -Target $Body -ErrorAction Stop
			Write-Verbose -Message "Enrollment invitation submitted."
			# the next portion of the function will download additional information about the enrollment request
			# this is pointless if the invitation was not correctly created due to an error with the request. 
			# Hence, we only run this, if there is an actual invitation in the enrollmentResult value. 
			if ($null -ne $EnrollmentResult) {
				Write-Verbose -Message 'An enrollment invication was created. Searching for additional details.'
				$SearchResult = Find-XMObject -Entity '/enrollment/filter' -Criteria $EnrollmentResult.token
				$Enrollment = $SearchResult.enrollmentFilterResponse.enrollmentList.enrollments
				$Enrollment | Add-Member -NotePropertyName url -NotePropertyValue $EnrollmentResult.url
				$Enrollment | Add-Member -NotePropertyName message -NotePropertyValue $EnrollmentResult.message
				$Enrollment | Add-Member -NotePropertyName AgentNotificationTemplateName -NotePropertyValue $SearchResult.enrollmentFilterResponse.enrollmentList.enrollments.notificationTemplateCategories.notificationTemplate.name
				return $Enrollment 
			} 
			else {
				Write-Host "The server was unable to create an enrollment invitation for '$($User)'. Common causes are connectivity issues, as well as errors in the information supplied such as username, template names etc. Ensure all values in the request are correct." -ForegroundColor Yellow
			}
		}
	}
	end {}
	<#
	.SYNOPSIS
	This command will create an enrollment for the specified user.
	
	.DESCRIPTION
	Use this command to create enrollments. You can pipe parameters into this command from another command. 
	The command currently does not process notifications. It will return an object with details of the enrollment including the URL and PIN code (called secret).  
	
	.PARAMETER User
	The user parameter specifies the target user.
	This parameter is required. This is either the UPN or sAMAccountName depending on what you are using in your environment. 
	
	.PARAMETER OS
	The OS parameter specifies the type of operating system. Options are iOS, SHTP.
	For android, use SHTP. This parameter is required. 
	
	.PARAMETER PhoneNumber
	This is the phone number notifications will be sent to. The parameter is optional but without it no SMS notifications are sent. 
	
	.PARAMETER Carrier
	Specify the carrier to use. This is optional and only required in case multiple cariers and SMS gateway have been configured. 
	
	.PARAMETER DeviceBindingType
	You can specify either SERIALNUMBER, IMEI or UDID as the device binding paramater. This defaults to SERIALNUMBER. 
	This parameter is only useful if you also specify the deviceBindingData. 
	
	.PARAMETER DeviceBindingData
	By specifying devicebindingdata you can link an enrollment invitation to a specific device. Use the deviceBindingType to specify what you will use, 
	and specify the value here. For example, to bind to a serial number set the deviceBindingType to SERIALNUMBER and provide the serialnumber as the value of deviceBindingData. 
	
	.PARAMETER Ownership
	This parameter specifies the ownership of the device. Values are either CORPORATE or BYOD or NO_BINDING.
	Default value is NO_BINDING. 
	
	.PARAMETER Mode
	This parameter specifes the type of enrollment mode you are using. Make sure the specified mode is enable on the server otherwise, an error will be thrown. 
	Default mode is classic. The select enrollment type must be enabled on the server. 
	Options are: 
	classic: username and password (default)
	high_security: generates an invitation URL, one time PIN and requires used to provide username, PIN and password.
	invitation: generates an invitation URL
	invitation_pin: generates and invitation and one time PIN
	invitation_pwd: generates an inivation and will request the user's password during enrollment 
	username_pin: generates a one time PIN and requires users to login with that pin and the username
	two_factor: generates an invitation url, a one time PIN and requires the user to login with, password and PIN. 
	
	.PARAMETER AgentTemplate
	Specify the template to use when sending a notification to the user to download Secure Hub. The default is blank. 
	This value is case sensitive. To find out the correct name, create an enrollment invitation in the XMS GUI and view the available options for the notification template. 
	
	.PARAMETER InvitationTemplate
	Specify the template to use when sending a notification to the user to with the enrollment URL. The default is blank. 
	This value is case sensitive. To find out the correct name, create an enrollment invitation in the XMS GUI and view the available options for the notification template. 
	
	.PARAMETER PinTemplate
	Specify the template to use when sending a notification for the one time PIN to the user. The default is blank. 
	This value is case sensitive. To find out the correct name, create an enrollment invitation in the XMS GUI and view the available options for the notification template. 
	
	.PARAMETER ConfirmationTemplate
	Specify the template to use when sending a notification to the user at completion of the enrollment. The default is blank. 
	This value is case sensitive. To find out the correct name, create an enrollment invitation in the XMS GUI and view the available options for the notification template. 
	
	.PARAMETER NotifyNow
	Specify if you want to send notifications to the user. Value is either "true" or "false" (default.) 
	
	.EXAMPLE
	New-XMEnrollment -User "ward@citrix.com" -OS "iOS" -Ownership "BYOD" -Mode "invitation_url"
	
	.EXAMPLE
	Import-Csv -Path users.csv | New-Enrollment -OS iOS -Ownership BYOD
	
	This will read a CSV file and create an enrolment for each of the entries.
	
	#>
}
