# Microsoft Intune Proactive Remediations Library 🛡️

[![Website](https://img.shields.io/badge/Companion%20Guides-adminsignal.com-0078D4?style=for-the-badge&logo=google-chrome&logoColor=white)](https://adminsignal.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207+-blue?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/AdminSignalHQ/intune-remediations)

Production-ready, battle-tested Detection and Remediation script packages for **Microsoft Intune** (Endpoint Analytics Proactive Remediations). Built and curated by [AdminSignal](https://adminsignal.com) for enterprise IT administrators and endpoint mobility engineers.

---

## 📂 Catalog of Remediations

| Package | Purpose | Detection Trigger | Remediation Action |
| :--- | :--- | :--- | :--- |
| [**GPO-Tattoo-Cleanup**](Remediations/GPO-Tattoo-Cleanup) | Clean orphaned GPO registry keys blocking Intune CSPs | Identifies legacy policy registry paths tattooed on hybrid devices | Safely purges orphaned keys to let MDM/CSP win |
| [**Windows-Update-Agent-Repair**](Remediations/Windows-Update-Agent-Repair) | Fix broken Windows Update / WUfB client states | Detects disabled services, hung BITS jobs, or corrupt datastore | Restarts services, clears pending queue, re-registers DLLs |
| [**BitLocker-Key-Escrow-Verify**](Remediations/BitLocker-Key-Escrow-Verify) | Ensure OS BitLocker recovery keys exist in Entra ID | Checks if current volume recovery key is backed up to Entra ID | Triggers Backup-BitLockerKeyProtector into Entra ID |
| [**Pending-Reboot-Notifier**](Remediations/Pending-Reboot-Notifier) | Audit pending reboot states before deployments | Checks CBS, WUfB, and PendingFileRenameOperations | Outputs pending reboot causes to Intune Admin Center |

---

## 🚀 How to Deploy in Microsoft Intune

1. Open the [Microsoft Intune Admin Center](https://intune.microsoft.com).
2. Navigate to **Reports** > **Endpoint analytics** > **Proactive remediations** (or **Devices** > **Remediations**).
3. Click **+ Create script package**.
4. In the **Basics** tab, provide the package name and description.
5. In the **Settings** tab:
   * Upload Detect-<Name>.ps1 into the **Detection script file** field.
   * Upload Remediate-<Name>.ps1 into the **Remediation script file** field (if applicable).
   * **Run this script using the logged-on credentials**: Select **No** (runs in NT AUTHORITY\SYSTEM context).
   * **Enforce script signature check**: Select **No** (unless your organization code-signs scripts).
   * **Run script in 64-bit PowerShell**: Select **Yes** (CRITICAL to avoid 32-bit registry redirection on 64-bit Windows).
6. In the **Assignments** tab:
   * Target your test device group.
   * Configure the frequency (e.g., Daily, or Once every 8 hours).

---

## ⚙️ Standard Exit Code Convention

In accordance with Microsoft Intune Remediation architecture:
* **Detection Script**:
  * Exit 0: Machine is **Compliant** (no problem detected; remediation will **not** run).
  * Exit 1: Machine is **Non-Compliant** (issue detected; triggers remediation script).
* **Remediation Script**:
  * Exit 0: Remediation **Succeeded**.
  * Exit 1: Remediation **Failed**.

---

## 📖 Related Articles on AdminSignal

* [GPO vs. Intune Precedence: Demystifying MDMWinsOverGP in Hybrid Join](https://adminsignal.com)
* [Troubleshooting Windows Update for Business Failures with Intune](https://adminsignal.com)
* [Validating BitLocker Compliance and Entra ID Escrow](https://adminsignal.com)
