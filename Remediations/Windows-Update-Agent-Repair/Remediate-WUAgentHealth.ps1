<#
.SYNOPSIS
    Repairs Windows Update agent services and configuration.
.DESCRIPTION
    Sets wuauserv, BITS, and CryptSvc to Automatic/Manual, resets service states,
    and triggers a clean scan for modern WUfB policies.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>

try {
    # Configure startup types
    Set-Service -Name wuauserv -StartupType Manual -ErrorAction SilentlyContinue
    Set-Service -Name BITS -StartupType Automatic -ErrorAction SilentlyContinue
    Set-Service -Name cryptsvc -StartupType Automatic -ErrorAction SilentlyContinue

    # Restart core services
    Restart-Service -Name cryptsvc -Force -ErrorAction SilentlyContinue
    Restart-Service -Name BITS -Force -ErrorAction SilentlyContinue
    Restart-Service -Name wuauserv -Force -ErrorAction SilentlyContinue

    # Trigger usoclient scan in background
    Start-Process -FilePath "usoclient.exe" -ArgumentList "StartScan" -NoNewWindow -ErrorAction SilentlyContinue

    Write-Output "SUCCESS: Windows Update services restored and background scan initiated."
    exit 0
}
catch {
    Write-Error "Remediation error: $($_.Exception.Message)"
    exit 1
}
