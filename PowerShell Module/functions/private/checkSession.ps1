function checkSession { #TODO RENAME TO FOLLOW PS GUIDELINES
    #this functions checks the state of the session timeout. And will update in case the timeout type is inactivity. 
    if ($XMSSessionExpiry -gt (Get-Date)) {
        Write-Verbose -Message "Session is still active."
        #if we are using an inactivity timer (rather than static timeout), update the expiry time.
        if ($XMSSessionUseInactivity -eq $true) {
            $TimeToExpiry = (($XMSSessionInactivityTimer) * 60) - 30
            $Global:XMSSessionExpiry = (Get-Date).AddSeconds($TimeToExpiry)
            #Set-Variable -Name 'XMSSessionExpiry' -Value (Get-Date).AddSeconds($TimeToExpiry) -Scope Global
            Write-Verbose -Message 'Session expiry extended by ' + $TimeToExpiry + ' sec. New expiry time is: ' + $XMSSessionExpiry
        }
    }
    else {
        Write-Host 'Session has expired. Please create a new Session using the New-Session command.' -ForegroundColor Yellow
        break 
    }
}
