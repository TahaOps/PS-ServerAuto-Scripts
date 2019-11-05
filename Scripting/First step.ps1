<#
Author : Taha Ghazali
Creation Date : 2019-10-25
(On scripter's 24th birthday)
Version : 1.1.0.2
Edition Date : 2019-11-04
#>

# FUNCTIONS
function RedError {
    process {Write-Host $_ -ForegroundColor Red}
}
function GreenPrint {
    process {Write-Host $_ -ForegroundColor Green}
}
function WriteToLog{
    param([string]$AddLine)
    ((Get-Date -DisplayHint DateTime).ToString() + " : " + $AddLine) >> "$env:Scripting\Log.txt";
}

# TASK - Set execution policy
Write-Host "Modifying execution policy in order to run all the scripts succesfully"
Write-Host "----------------------------------------------------------------------"
"";"";""
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# TASK - Creating the directory and the environment variable
Write-Host "Creating the directory and the environment variable"
Write-Host "----------------------------------------------------------------------"
"";"";""
if (-Not ((Test-Path -Path "$env:HOMEDRIVE\Scripting") -And (Test-Path env:\Scripting))){
        mkdir "$env:HOMEDRIVE\Scripting\"
        [System.Environment]::SetEnvironmentVariable("Scripting","$env:HOMEDRIVE\Scripting\")
        WriteToLog -AddLine "Setting environment on $env:HOMEDRIVE drive"
        WriteToLog -AddLine "Items on current drive ($env:HOMEDRIVE): $(Get-ChildItem -Path "$env:HOMEDRIVE\"|Sort LastWriteTime -Descending|Format-Table LastWriteTime, Name, Directory|Out-String)"
}
else{
        Write-Host "Good news (or not if you are running this script -at least- twice) : $env:Scripting already exists"
}

# VARIABLES - Getting the current location and the files names
$CurrentLocation = Get-Location
$Files = @("SRV Setup.ps1","Domain Merger.ps1", "Role Installation.ps1")

Write-Host "We are automatizing script installation"

# TASK - 1) Check if files are present in the current location
#           If files are present
if ((Test-Path -Path $CurrentLocation\$($Files[0])) -And  
(Test-Path -Path $CurrentLocation\$($Files[1])) -And
(Test-Path -Path $CurrentLocation\$($Files[2]))){

        Write-Host "All the files required are present."
# TASK - 2) Check if the prompt current location is on the scipting path folder
        if ("$CurrentLocation" -eq "$env:Scripting"){
            Write-Host "We determined you are in the right directory"
            Write-Host "We are all about to lauch the first script"
#           The files are present in the current folder AND current folder is in the scripting environment
#           So, let's launch the first script
            Powershell.exe -File $CurrentLocation\$($Files[0])
        }
# TASK - 2) Check if the prompt current location is on the scipting path folder
#           The files are in the current directory (cf. task one) however, we are not in the scripting environment
#           We are then prompting some lines for the administrator
        else{
#           Print warnings but continue
            Write-Warning "The files are present. However, you are not into the right directory." -WarningAction Continue
            Write-Warning "Your current location is $CurrentLocation however the script should run into the $env:Scripting directory."
            Write-Host "This installer will move scripting files and run the first script"
#           Copy files and writing some lines to the console
            ForEach ($File in $Files) {
            Copy-Item $File -Destination "$env:Scripting\" }
            Write-Host "Files has been copied succesfully. You should delete files from this folder"
            Write-Host "Moving to the right folder"
#           Doing some "cd"            
            Set-Location "$env:Scripting"
#           Launching the first script
            Powershell.exe -File $CurrentLocation\$($Files[0])}} # A previous feature was meant to be implemented in order to check the state of the copy. It will be upgraded soon
# TASK - 1) Check if files are present in the current location
#           else (if) files are NOT present

else {
#           First we print an error
Write-Output "ERROR: A problem just happened. The files aren't in this current directory." | RedError
Write-Output "ERROR: Please ensure that "|RedError ; Write-Output "$Files"|GreenPrint; Write-Output "are present in the current folder."|RedError
#           And then, we log the "ls" of both the current path and the scipting path (C:\Scripting in most cases)
WriteToLog -AddLine "Items on current location ($CurrentLocation): $(Get-ChildItem -Path $CurrentLocation|Sort LastWriteTime -Descending|Format-Table LastWriteTime, Name, Directory|Out-String)"
WriteToLog -AddLine "Items on scripting environment ($env:Scripting) : $(Get-ChildItem -Path $env:Scripting|Sort LastWriteTime -Descending|Format-Table LastWriteTime, Name, Directory|Out-String)"
}