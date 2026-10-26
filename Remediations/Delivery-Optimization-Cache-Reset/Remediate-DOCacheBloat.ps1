<#
.SYNOPSIS
    Purges the Windows Delivery Optimization peer cache to reclaim disk space.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>
try {
    Delete-DeliveryOptimizationCache -Force -ErrorAction Stop
    Write-Output "SUCCESS: Purged Delivery Optimization cache."
    exit 0
} catch {
    Write-Error "Failed to clear Delivery Optimization cache: $($_.Exception.Message)"
    exit 1
}
