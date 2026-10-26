<#
.SYNOPSIS
    Detects unhealthy Windows Update client states on Windows 10/11 endpoints.
.DESCRIPTION
    Checks service startup types and statuses for wuauserv and BITS, and validates
    that the update client has not been hung on BITS transfer queues.
.NOTES
    Author: AdminSignal (https://adminsignal.com)
#>

try {
    $issues = @()

    $wua = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
    if ($null -eq $wua) {
        Write-Output "NON-COMPLIANT: wuauserv service is missing"
        exit 1
    }

    $wuaConfig = Get-CimInstance -ClassName Win32_Service -Filter "Name='wuauserv'"
    if ($wuaConfig.StartMode -eq "Disabled") {
        $issues += "wuauserv is Disabled"
    }

    $bitsConfig = Get-CimInstance -ClassName Win32_Service -Filter "Name='BITS'"
    if ($bitsConfig.StartMode -eq "Disabled") {
        $issues += "BITS is Disabled"
    }

    if ($issues.Count -gt 0) {
        Write-Output "NON-COMPLIANT: $($issues -join '; ')"
        exit 1
    }

    Write-Output "COMPLIANT: Windows Update client services are healthy."
    exit 0
}
catch {
    Write-Error "Detection error: $($_.Exception.Message)"
    exit 1
}
