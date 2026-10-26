<#
.SYNOPSIS
    Verifies that the BitLocker OS volume recovery password is created.
.DESCRIPTION
    Audits the primary OS volume (usually C:) for encryption state and recovery password key protectors.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>

try {
    $osVol = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop
    if ($osVol.VolumeStatus -ne "FullyEncrypted" -and $osVol.VolumeStatus -ne "EncryptionInProgress") {
        Write-Output "COMPLIANT: Volume is not encrypted or BitLocker is disabled on this device."
        exit 0
    }

    $recoveryKey = $osVol.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }
    if (-not $recoveryKey) {
        Write-Output "NON-COMPLIANT: BitLocker is active but no RecoveryPassword key protector was found."
        exit 1
    }

    Write-Output "COMPLIANT: BitLocker RecoveryPassword protector is present on $($env:SystemDrive)."
    exit 0
}
catch {
    Write-Error "Detection error: $($_.Exception.Message)"
    exit 1
}
