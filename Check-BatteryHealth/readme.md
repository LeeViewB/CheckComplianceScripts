# SYNOPSIS

## Check-BatteryHealth.ps1
This script will allow you to check the the battery health of a device using Intune custom compliance.
On row 8, enter the minimumum battery health percentage for your device to be compliant.
If it's less than that, the device will not be compliant. If it's more, it will be compliant.
This script will also check the device type, in case you deploy the script to a device type other than mobile.
If it's deployed to a desktop, for instance, the script will return compliant.

# More Info
[Create a compliance policy in Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/create-compliance-policy)

[Custom compliance discovery scripts for Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-custom-script)

[Custom compliance JSON files for Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-custom-json)