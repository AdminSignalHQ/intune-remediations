<#
.SYNOPSIS
    Safely removes unloaded, non-special local user profiles inactive for more than 60 days via CIM.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>
$MaxInactiveDays = 60
$CutoffDate = (Get-Date).AddDays(-$MaxInactiveDays)

try {
    $staleProfiles = Get-CimInstance -ClassName Win32_UserProfile | Where-Object {
        -not $_.Special -and
        -not $_.Loaded -and
        $_.LastUseTime -and
        ($_.LastUseTime -lt $CutoffDate)
    }

    $removedCount = 0
    foreach ($prof in $staleProfiles) {
        Remove-CimInstance -InputObject $prof -ErrorAction Stop
        $removedCount++
    }
    Write-Output "SUCCESS: Removed $removedCount stale local user profile(s) to free disk space for Feature Updates."
    exit 0
} catch {
    Write-Error "Failed to remove stale profiles: $($_.Exception.Message)"
    exit 1
}
