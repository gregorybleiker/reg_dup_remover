$RegKeySystem = ([Microsoft.Win32.Registry]::LocalMachine).OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\Environment", $True) 
$RegKeyUser = ([Microsoft.Win32.Registry]::CurrentUser).OpenSubKey("Environment", $True) 
$PathSystemValue = $RegKeySystem.GetValue("Path", $Null) 
$PathUserValue = $RegKeyUser.GetValue("Path", $Null) 

#Write-host "Original path :" + $PathValue  
$PathUserValues = $PathUserValue.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries)
$PathSystemValues = $PathSystemValue.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries) 

$HasDuplicatesOrInvalid = $False 
$NewValues = @() 


# first remove dups from system path
ForEach ($Value in $PathSystemValues) { 
    $strippedValue = $Value.trimEnd("\")
    if ($NewValues -notcontains $strippedValue) { 
        if (Test-Path -Path $strippedValue) {
            $NewValues += $strippedValue 
        }
        else {
            $HasDuplicatesOrInvalid = $True 
            Write-Host "Invalid System Path Entries found, removing" $strippedValue 
        }
    } 
    else { 
        $HasDuplicatesOrInvalid = $True 
        Write-Host "Duplicate System Path Entries found, removing" $strippedValue 
    } 
} 

if ($HasDuplicatesOrInvalid) { 
    $NewValue = $NewValues -join ";" 
    $RegKeySystem.SetValue("Path", $NewValue, [Microsoft.Win32.RegistryValueKind]::ExpandString) 
} 
else { 
    Write-Host "No duplicate System PATH entries found" 
} 


#remove duplicates in User Path
$HasDuplicatesOrInvalid = $False 
$NewValues = @() 
ForEach ($Value in $PathUserValues) { 
    $strippedValue = $Value.trimEnd("\")
    if ($PathSystemValues -notcontains $strippedValue) {
        if (Test-Path -Path $strippedValue) { 
            $NewValues += $strippedValue 
        }
        else {
            $HasDuplicatesOrInvalid = $True 
            Write-Host "Invalid System Path Entries found, removing" $strippedValue 
        } 
    }
    else { 
        $HasDuplicatesOrInvalid = $True 
        Write-Host "Duplicate User Path Entries found, removing" $strippedValue 
    } 
} 

if ($HasDuplicatesOrInvalid) { 
    $NewValue = $NewValues -join ";" 
    $RegKeyUser.SetValue("Path", $NewValue, [Microsoft.Win32.RegistryValueKind]::ExpandString) 
} 
else { 
    Write-Host "No duplicate User PATH entries found" 
} 



$RegKeySystem.Close()
$RegKeyUser.Close() 