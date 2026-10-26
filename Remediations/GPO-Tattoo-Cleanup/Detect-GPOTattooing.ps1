<#
.SYNOPSIS
    Detects orphaned or conflicting legacy GPO registry settings that interfere with Intune CSPs.
.DESCRIPTION
    Checks if legacy GPO policy registry keys remain tattooed in HKLM:\SOFTWARE\Policies\Microsoft\WindowsUpdate
    when the Windows Update workload has been migrated to Intune.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
    Exit 0: Compliant (No conflicting GPO registry entries found)
    Exit 1: Non-Compliant (Legacy GPO values detected, remediation needed)
#>

try {
    $wuGPOPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $conflictingKeys = @()

    if (Test-Path $wuGPOPath) {
        $values = Get-ItemProperty -Path $wuGPOPath -ErrorAction SilentlyContinue
        # Target legacy WSUS server overrides that conflict with WUfB
        if ($values.WUServer -or $values.WUStatusServer) {
            $conflictingKeys += "WUServer: $($values.WUServer)"
        }
        if ($values.DoNotConnectToWindowsUpdateInternetLocations -eq 1) {
            $conflictingKeys += "DoNotConnectToWindowsUpdateInternetLocations=1"
        }
    }

    $auPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (Test-Path $auPath) {
        $auValues = Get-ItemProperty -Path $auPath -ErrorAction SilentlyContinue
        if ($auValues.UseWUServer -eq 1) {
            $conflictingKeys += "AU\UseWUServer=1"
        }
    }

    if ($conflictingKeys.Count -gt 0) {
        Write-Output "NON-COMPLIANT: Conflicting legacy GPO entries found: $($conflictingKeys -join ', ')"
        exit 1
    } else {
        Write-Output "COMPLIANT: No legacy GPO WSUS registry overrides present."
        exit 0
    }
}
catch {
    Write-Error "Detection error: $($_.Exception.Message)"
    exit 1
}
