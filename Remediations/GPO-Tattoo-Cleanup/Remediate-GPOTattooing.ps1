<#
.SYNOPSIS
    Cleans up conflicting legacy GPO registry values to enable Intune WUfB policies.
.DESCRIPTION
    Safely removes legacy WSUS server overrides (WUServer, WUStatusServer, UseWUServer)
    from HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate so that modern cloud-managed
    WUfB policies take precedence without registry tattooing interference.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
    Exit 0: Successfully remediated
    Exit 1: Remediation failed
#>

try {
    $wuGPOPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $auPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

    $clearedItems = @()

    if (Test-Path $wuGPOPath) {
        $keysToRemove = @("WUServer", "WUStatusServer", "DoNotConnectToWindowsUpdateInternetLocations")
        foreach ($key in $keysToRemove) {
            if ((Get-ItemProperty -Path $wuGPOPath -Name $key -ErrorAction SilentlyContinue)) {
                Remove-ItemProperty -Path $wuGPOPath -Name $key -Force -ErrorAction SilentlyContinue
                $clearedItems += $key
            }
        }
    }

    if (Test-Path $auPath) {
        if ((Get-ItemProperty -Path $auPath -Name "UseWUServer" -ErrorAction SilentlyContinue)) {
            Remove-ItemProperty -Path $auPath -Name "UseWUServer" -Force -ErrorAction SilentlyContinue
            $clearedItems += "AU\UseWUServer"
        }
    }

    # Restart wuauserv to pick up fresh policy state
    Restart-Service -Name wuauserv -Force -ErrorAction SilentlyContinue

    Write-Output "SUCCESS: Cleared legacy GPO registry overrides: $($clearedItems -join ', '). Windows Update service refreshed."
    exit 0
}
catch {
    Write-Error "Remediation failed: $($_.Exception.Message)"
    exit 1
}
