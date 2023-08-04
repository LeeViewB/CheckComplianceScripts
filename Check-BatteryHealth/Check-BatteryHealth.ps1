###########################################################################
## Author: Liviu Barbat (liviubarbat.com)
## Description: This script will check the battery life of a mobile device
## Note: Make sure to perform your own tests as well.
###########################################################################

## specify the minimum target percentage for the battery health for the device to be compliant.
$batteryHealthCompliancePercentage = 90

##############################################################################################
## Do not edit the lines below
## If you do want to run it manually on a device to see the battery health percentage...
## ... un-comment row 34
##############################################################################################


## getting device type to ensure this is a laptop. PCSystemType 2 = mobile device
[int]$deviceType = (Get-WmiObject -class Win32_ComputerSystem -Property PCSystemType).PCSystemType
[bool]$BatteryHealthStatusCompliance = $false
& powercfg /batteryreport /XML /OUTPUT "batteryreport.xml"
[xml]$batteryReport = Get-Content batteryreport.xml
$myBatteries = $batteryReport.BatteryReport.Batteries.Battery

IF($deviceType -eq 2){
    #doing battery life check, as this device type = mobile
    [array]$batteryDetails = foreach ($battery in $myBatteries) {
        $myBatteryDesignCapacity = $battery.DesignCapacity
        $myBatteryFullChargeCapacity = $battery.FullChargeCapacity
        $myBatteryID = $battery.Id
        ## rounding the result to the nearest integer.
        $myBatteryHealth = [math]::Round(($myBatteryFullChargeCapacity / $myBatteryDesignCapacity) * 100)
        
        if ($myBatteryHealth -gt $batteryHealthCompliancePercentage) {
            $BatteryHealthStatusCompliance = $true
        }

        [PSCustomObject]@{
            BatteryID = $myBatteryID
            BatteryHealth = $myBatteryHealth
            Compliance = $BatteryHealthStatusCompliance
        }
        #Write-Host ("{0} battery life is at {1}% and the compliance status is {2}" -f $myBatteryID,$myBatteryHealth, $BatteryHealthStatusCompliance)
    }
}else{
    ## not doing the battery health check as this device is not a mobile device. PCSystemType does not equal 2
    ## setting the battery battery health status compliance variable to true, so our custom compliance will equal true (device compliant)
    $BatteryHealthStatusCompliance = $true
}

If($batteryDetails.compliance -contains $false){
    [bool]$complianceStatus = $false
}else{
    [bool]$complianceStatus = $true
}

$hash = @{ BatteryLife = $complianceStatus }
return $hash | ConvertTo-Json -Compress