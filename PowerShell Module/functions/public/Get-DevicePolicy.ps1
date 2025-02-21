function Get-DevicePolicy {
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipelineByPropertyName, 
			Mandatory = $true)]
		[string]$Id
	)
	begin {
		#check session state
		checkSession
	}
	process {
		$Result = Get-XMObject -Entity "/device/$($Id)/policies"
		return $Result.policies
	}
	<#
	.SYNOPSIS
	Displays the policies applies to a particular device.   

	.DESCRIPTION
	This command will list the policies applied to a particular device. 

	.PARAMETER Id
	Specify the ID of the device. Use Get-XMDevice to find the id of each device.  
	.EXAMPLE
	Get-XMDevicePolicy -Id "8"
	#>
}
