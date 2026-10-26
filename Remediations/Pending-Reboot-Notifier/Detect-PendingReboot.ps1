<#
.SYNOPSIS
    Detects pending reboot conditions across all major Windows subsystems.
.DESCRIPTION
    Audits CBS Servicing, Windows Update, Component Based Servicing, and PendingFileRenameOperations.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>

$rebootReasons = @()

# 1. CBS Servicing
if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
    $rebootReasons += "CBS-RebootPending"
}

# 2. Windows Update
if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
    $rebootReasons += "WindowsUpdate-RebootRequired"
}

# 3. Pending File Rename Operations
$pendingFileRename = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue
if ($pendingFileRename.PendingFileRenameOperations) {
    $rebootReasons += "PendingFileRenameOperations"
}

# 4. SCCM / ConfigMgr Client Reboot Pending
try {
    $ccmClient = Invoke-CimMethod -Namespace "root\ccm\ClientSDK" -ClassName "CCM_ClientUtilities" -MethodName "DetermineIfRebootPending" -ErrorAction SilentlyContinue
    if ($ccmClient.RebootPending -eq $true) {
        $rebootReasons += "ConfigMgr-RebootPending"
    }
} catch {}

if ($rebootReasons.Count -gt 0) {
    Write-Output "NON-COMPLIANT: Reboot pending due to: $($rebootReasons -join ', ')"
    exit 1
} else {
    Write-Output "COMPLIANT: No pending reboot detected."
    exit 0
}
