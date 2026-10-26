<#
.SYNOPSIS
    Detects stale local user profiles older than 60 days on shared or low-disk Windows endpoints.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>
$MaxInactiveDays = 60
$CutoffDate = (Get-Date).AddDays(-$MaxInactiveDays)

$staleProfiles = Get-CimInstance -ClassName Win32_UserProfile | Where-Object {
    -not $_.Special -and
    -not $_.Loaded -and
    $_.LastUseTime -and
    ($_.LastUseTime -lt $CutoffDate)
}

if ($staleProfiles.Count -gt 0) {
    Write-Output "NON-COMPLIANT: Found $($staleProfiles.Count) inactive user profile(s) older than $MaxInactiveDays days."
    exit 1
}
Write-Output "COMPLIANT: No stale user profiles older than $MaxInactiveDays days."
exit 0
