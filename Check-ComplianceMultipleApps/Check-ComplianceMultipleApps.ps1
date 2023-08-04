## make sure to enter the exact display name shown in Add Remove Programs.
## While you can use wildcards to search for software, the exact display name discovered in appwiz.cpl will be used as the Setting Name for the json compliance check rule
#[array]$applicationName = @("1Password","Discord","Test App") #example user apps installed in HKCU
[array]$applicationName = @("Google Chrome","Test App") #example machine wide apps installed in HKLM
[bool]$userProfileApp = $false # Switch to true if you want the script to check for app info in HKCU instead of HKLM
[bool]$isAppInstallCheckOnly = $true # if false, it will check only if the app exists. if true, it will only check if the app is installed or not

# -----------------------------------
# DO NOT EDIT THE LINES BELOW
# -----------------------------------

If ($userProfileApp) {
    # Search HKCU for a user-based app install            
    # Testing the reg path for user based apps, if there are none, the path will not exist.
    [array]$myAppRegEntries = If (Test-Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall') { Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Select-Object DisplayName, DisplayVersion }
    [array]$myAppRegEntries += If (Test-Path 'HKCU:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall') { Get-ItemProperty 'HKCU:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion }
} else {
    # Search HKLM for a system-wide app install
    [array]$myAppRegEntries = Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Select-Object DisplayName, DisplayVersion        
}

[array]$appInfo = ForEach ($application in $applicationName) {
    If(-not($isAppInstallCheckOnly -eq $true)){        
                # Flag to indicate if the application is installed
        $appInstalled = $false

        If ($myAppRegEntries) {
            # Check if the app exists in $myAppRegEntries
            Foreach ($myAppReg in $myAppRegEntries) {
                if ($myAppReg.DisplayName -eq $application) {
                    $appInstalled = $true
                    [string]$displayName = $myAppReg.DisplayName
                    [string]$displayVersion = $myAppReg.DisplayVersion
                    break  # No need to check further once found
                }                
            }
        }
        if (-not $appInstalled) {
            # App not installed, set the display name and version accordingly.
            # If not setting this and the app is not installed, the version check would be null, causing the compliance check to error out.
            # this way, if the software is not installed at all, the result for the software will be 0.0.0.0
            $displayName = $application
            $displayVersion = "0.0.0.0"
        }
        # Create a custom object and add it to the array
        @{
            $displayName = $displayVersion                    
        }
    }else{
        # Flag to indicate if the application is not installed
        $appInstalled = $false
        # Check if the app exists in $myAppRegEntries
        foreach ($myAppReg in $myAppRegEntries) {
            if ($myAppReg.DisplayName -eq $application) {
                $appInstalled = $true
                break  # No need to check further once found
            }
        }
        $application = $application + " Installed"
        @{
            $application = $appInstalled
        }
    }
}


# adding loop to convert the $appInfo array into a single custom object named $customObject
# doing this because we want a single object with all the apps and versions listed as key-value pairs in the JSON output, instead of an array with separate objects for each app. Intune no likey that.
$customObject = @{}
foreach ($app in $appInfo) {
    $customObject += $app
}

$hash = $customObject
return $hash | ConvertTo-Json -Compress