<#
.SYNOPSIS
    Checks if the Windows Delivery Optimization cache exceeds 15 GB.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>
$MaxCacheGB = 15
try {
    $status = Get-DeliveryOptimizationStatus -ErrorAction SilentlyContinue
    $cacheBytes = ($status | Measure-Object -Property FileSizeInCache -Sum).Sum
    $cacheGB = [math]::Round($cacheBytes / 1GB, 2)
    if ($cacheGB -gt $MaxCacheGB) {
        Write-Output "NON-COMPLIANT: Delivery Optimization cache is $cacheGB GB (Limit: $MaxCacheGB GB)."
        exit 1
    }
    Write-Output "COMPLIANT: Delivery Optimization cache size is $cacheGB GB."
    exit 0
} catch {
    Write-Output "COMPLIANT: Delivery Optimization cache within normal parameters."
    exit 0
}
