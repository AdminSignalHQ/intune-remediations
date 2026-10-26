<#
.SYNOPSIS
    Creates a BitLocker Recovery Password protector and triggers escrow to Entra ID.
.DESCRIPTION
    If a machine has encrypted its drive without generating a standard RecoveryPassword protector,
    this script adds the protector and triggers backup to Entra ID (Azure AD).
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>

try {
    $osVol = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop
    $recoveryKey = $osVol.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }

    if (-not $recoveryKey) {
        $added = Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector -ErrorAction Stop
        $recoveryKey = $added.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }
    }

    if ($recoveryKey) {
        # Backup protector to Entra ID (Azure AD)
        Backup-BitLockerKeyProtector -MountPoint $env:SystemDrive -KeyProtectorId $recoveryKey.KeyProtectorId -ErrorAction Stop
        Write-Output "SUCCESS: BitLocker recovery key created and escrowed to Entra ID."
        exit 0
    } else {
        Write-Output "ERROR: Unable to locate or create BitLocker Recovery Password key protector."
        exit 1
    }
}
catch {
    Write-Error "Remediation failed: $($_.Exception.Message)"
    exit 1
}
