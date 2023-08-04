####################################################################################################################################
## Author: Liviu Barbat (liviubarbat.com)
## Description: This script will check if a device is Defender ATP onboarded or not
## If correctly onboarded, the value under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status ...
## ... OnboardedState will equal 1.
## Note: Make sure to perform your own tests as well.
####################################################################################################################################

[bool]$defenderATPonboarded = $false

$status = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status' -ErrorAction SilentlyContinue).OnboardingState

If($status -eq 1){
    $defenderATPonboarded = $true
}

$hash = @{ DefenderATPonboarded = $defenderATPonboarded}
return $hash | ConvertTo-Json -Compress