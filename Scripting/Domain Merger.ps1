<#
Author : Taha Ghazali
Creation Date : 2019-10-11
Version : 1.1.1
Edition Date : 2019-10-22
Works with : PS 4.0
#>

Write-Host "Now we will $env:computername to the Forest and restart the machine"
$DomainName = Read-Host -Prompt "Please enter the name of the domain "
Add-Computer -Computername $env:computername -DomainName $DomainName –Credential $DomainName\Administrator –Force #-Restart
# END MESSAGE
Write-Host "Script ended."

# CRON TASK
Write-Host "Now we are scheduling a new script at boot in order to add roles on this computer ($ComputerName)"
Unregister-ScheduledTask -TaskName "Domain Merger"
$Step3 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File '$env:USERPROFILE\Role Installation.ps1'"
$trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -TaskName "Role Installation" -Action $Step3 -Trigger $trigger
Restart-Computer