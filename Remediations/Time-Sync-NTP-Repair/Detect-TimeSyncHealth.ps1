<#
.SYNOPSIS
    Detects stopped W32Time service or unconfigured NTP time synchronization.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>
$svc = Get-Service -Name W32Time -ErrorAction SilentlyContinue
if ($null -eq $svc -or $svc.Status -ne "Running") {
    Write-Output "NON-COMPLIANT: Windows Time Service (W32Time) is not running ($($svc.Status))."
    exit 1
}
Write-Output "COMPLIANT: W32Time is running."
exit 0
