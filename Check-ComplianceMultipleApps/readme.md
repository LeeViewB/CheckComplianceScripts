# SYNOPSIS

## Check-ComplianceMultipleApps.ps1
The script will allow you to do 4 different compliance checks for one or multiple apps. Scroll down for Examples.
- on row 3 type in the application names in the array based on the example mentioned in the script.
- on row 4, you can specify if the script should check the HKCU or HKLM. 
    - if set to $true - it will check HKCU. 
    - if set to $false, it will check HKLM.
- on row 5, you can specify if you want to do a version compliance check or just want to check if the app is installed.
    - if set to $true, it will do a compliance check on the installed version of the software. As an example, your device should be Compliant if the Chrome version 116.1.1.1 or newer is installed. In this case, the script will look through the registry and check which version of Chrome is installed. 
    - if set to $false, it will only do a compliance check to see whether the software is installed or not. As an example, your device should be Compliant if Google Chrome is not installed. In this case, the script will only check if Google Chrome is installed and will return **true** or **false**.

# More Info
[Create a compliance policy in Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/create-compliance-policy)

[Custom compliance discovery scripts for Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-custom-script)

[Custom compliance JSON files for Microsoft Intune](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-custom-json)


# Examples
### 1. If you want to ensure that the installed **version** of the following software installed in **HKLM** is equal to or newer:

- Google Chrome  = 116.0.5790.110
- Notepad++ = 9.5.4
- Test App  = 116.0.5790.110
Make sure to:
```
- on row 5, set 
> $userProfileApp = $false
- on row 6, set 
> $isAppInstallCheckOnly = $false
```
- use the the example json file for the custom detection rule: **complianceAppVersionHKLM.json**
- if you want to check for other software, modify the array specified on row 4. Make sure to adjust the json file accordingly.

### 2. If you want to ensure that the installed **version** of the following software installed in **HKCU** is equal to or newer:
- 1Password  = 9.10.9
- Discord = 1.0.9015
- Test App = 1.0.9015
```
Make sure to:
- on row 5, set 
> $userProfileApp = $true
- on row 6, set 
> $isAppInstallCheckOnly = $false
```
- use the the example json file for the custom detection rule: **complianceAppVersionHKCU.json**
- if you want to check for other software, modify the array specified on row 4. Make sure to adjust the json file accordingly.

### 3. If you want to ensure that the software is NOT installed at all on the device for software that writes uninstall information in **HKLM**:
- Google Chrome
- Notepad++
- Test App
Make sure to:
```
- on row 5, set 
> $userProfileApp = $false
- on row 6, set 
> $isAppInstallCheckOnly = $true
```
- use the the example json file for the custom detection rule: **complianceAppInstalledHKLM.json**
- if you want to check for other software, modify the array specified on row 4. Make sure to adjust the json file accordingly.
In this example, the device will be compliant if the software is NOT installed. The script will return True if the software is installed, and false if it isn't.

### 4. If you want to ensure that the software is NOT installed at all on the device for software that writes uninstall information in **HKCU**:
- 1Password
- Discord
- Test App
Make sure to:
```
- on row 5, set 
> $userProfileApp = $true
- on row 6, set 
> $isAppInstallCheckOnly = $true
```
- use the the example json file for the custom detection rule: **complianceAppInstalledHKCU.json**
- if you want to check for other software, modify the array specified on row 4. Make sure to adjust the json file accordingly.
In this example, the device will be compliant if the software is NOT installed. The script will return True if the software is installed, and false if it isn't.