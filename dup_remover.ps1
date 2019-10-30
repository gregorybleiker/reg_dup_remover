$RegKeySystem = ([Microsoft.Win32.Registry]::LocalMachine).OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\Environment", $True) 
$RegKeyUser = ([Microsoft.Win32.Registry]::CurrentUser).OpenSubKey("Environment", $True) 
$PathSystemValue = $RegKeySystem.GetValue("Path", $Null) 
$PathUserValue = $RegKeyUser.GetValue("Path", $Null) 

#Write-host "Original path :" + $PathValue  
$PathUserValues = $PathUserValue.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries)
$PathSystemValues = $PathSystemValue.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries) 

$IsDuplicate = $False 
$NewValues = @() 


# first remove dups from system path
ForEach ($Value in $PathSystemValues) 
{ 
    if ($NewValues -notcontains $Value) 
    { 
        $NewValues += $Value 
    } 
    else 
    { 
        $IsDuplicate = $True 
        Write-Host "Duplicate System Path Entries found, removing" $Value 

    } 
} 

if ($IsDuplicate) 
{ 
    $NewValue = $NewValues -join ";" 
    $RegKeySystem.SetValue("Path", $NewValue, [Microsoft.Win32.RegistryValueKind]::ExpandString) 
} 
else 
{ 
    Write-Host "No duplicate System PATH entries found" 
} 


#remove duplicates in User Path
$IsDuplicate = $False 
$NewValues = @() 
ForEach ($Value in $PathUserValues) 
{ 
    if ($PathSystemValues -notcontains $Value) 
    { 
        $NewValues += $Value 
    } 
    else 
    { 
        $IsDuplicate = $True 
        Write-Host "Duplicate User Path Entries found, removing" $Value 
    } 
} 

if ($IsDuplicate) 
{ 
    $NewValue = $NewValues -join ";" 
    $RegKeyUser.SetValue("Path", $NewValue, [Microsoft.Win32.RegistryValueKind]::ExpandString) 
} 
else 
{ 
    Write-Host "No duplicate User PATH entries found" 
} 



$RegKeySystem.Close()
$RegKeyUser.Close() 