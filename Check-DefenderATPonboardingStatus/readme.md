# SYNOPSIS

## DefenderATPonboardingStatus.ps1
The script will allow you to check whether Defender ATP is onboarded or not.
If onboarded, the OnboardingState DWORD under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status will equal 1.
If it equals 0 or does not exist, the device is not onboarded in Defender ATP.

# More Info
[Create a compliance policy in Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/create-compliance-policy)

[Custom compliance discovery scripts for Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-custom-script)

[Custom compliance JSON files for Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-custom-json)