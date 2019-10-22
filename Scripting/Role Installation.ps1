<#
Author : Taha Ghazali
Creation Date : 2019-10-11
Version : 1.1.4
Edition Date : 2019-10-22
Works with : PS 4.0
#>
Clear-Variable Roles*
$RolesSearch = Read-Host -Prompt "Enter the roles you want to install on this server "
Get-WindowsFeature | Where{$_.Name -like "*$RolesSearch*" -AND $_.InstallState -eq "Available"}
$RolesNumber = Read-Host -Prompt "Enter the number of wanted roles "
$RolesArray = @()
For($i=1; $i -le $RolesNumber; $i++){
$RolesName = Read-Host -Prompt "Enter the name of the role "
$RolesArray += "$RolesName"
}
Install-WindowsFeature -Name $RolesArray
Unregister-ScheduledTask -TaskName "Role Installation"
Restart-Computer