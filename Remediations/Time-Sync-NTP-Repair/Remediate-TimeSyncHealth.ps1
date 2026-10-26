<#
.SYNOPSIS
    Starts Windows Time Service and forces an immediate NTP resynchronization.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>
try {
    Set-Service -Name W32Time -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name W32Time -ErrorAction Stop
    w32tm.exe /resync /force | Out-Null
    Write-Output "SUCCESS: W32Time service started and NTP resync triggered."
    exit 0
} catch {
    Write-Error "Time sync remediation failed: $($_.Exception.Message)"
    exit 1
}
