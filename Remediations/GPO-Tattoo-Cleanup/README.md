# GPO Tattoo Cleanup for Intune-Managed Devices

When moving workloads (such as Windows Update for Business or Defender) from Active Directory Group Policy to Microsoft Intune, Group Policy often **tattoos** the registry. Even if you unassign or disable the GPO, the registry values in `HKLM:\SOFTWARE\Policies\` may remain forever until explicitly wiped.

### Key Details
* **Article Reference**: [GPO vs Intune Precedence on adminsignal.com](https://adminsignal.com)
* **Detection Script**: `Detect-GPOTattooing.ps1`
* **Remediation Script**: `Remediate-GPOTattooing.ps1`
* **Run in 64-bit PowerShell**: **Yes**
* **Run as Account**: **System (No)**
