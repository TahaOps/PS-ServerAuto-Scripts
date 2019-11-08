<#
Author : Taha Ghazali
Creation Date : 2019-10-11
Version : 1.2.1
Edition Date : 2019-11-05
#>

# TASK - Customizing Prompt
function prompt{'SCRIPT 2: ' + (get-location) + '> '}

# TASK - Clearing existing Roles* variables
Clear-Variable Roles*

# PROMPT - First : asking the name
$RolesSearch = Read-Host -Prompt "Enter the name of the roles you want to install on this server "
Get-WindowsFeature | Where{$_.Name -like "*$RolesSearch*" -AND $_.InstallState -eq "Available"}
# PROMPT - Second : asking the number
$RolesNumber = Read-Host -Prompt "Enter the number of wanted roles "
# TASK - FOR LOOP
$RolesArray = @()
For($i=1; $i -le $RolesNumber; $i++){
$RolesName = Read-Host -Prompt "Enter the name of the role "
$RolesArray += "$RolesName"
}
# TASK - Install the features
Install-WindowsFeature -Name $RolesArray
# TASK - Unregister this task and rebooting
Unregister-ScheduledTask -TaskName "Role Installation"
Restart-Computer