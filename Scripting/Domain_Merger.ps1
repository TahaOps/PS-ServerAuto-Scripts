<#
Author : Taha Ghazali
Creation Date : 2019-10-11
Version : 1.2.1
Edition Date : 2019-11-05
#>

# TASK - Customizing Prompt
function prompt{'SCRIPT 2: ' + (get-location) + '> '}
# PROMPT - Ask domain name
Write-Host "Now we will add $env:computername to the Forest and restart the machine"
$DomainName = Read-Host -Prompt "Please enter the name of the domain "
Add-Computer -Computername $env:computername -DomainName $DomainName –Credential $DomainName\Administrator –Force #-Restart
# END MESSAGE
Write-Host "Script ended."
# TASK - Unregister this task
Unregister-ScheduledTask -TaskName "Domain Merger"
# CRON TASK and Rebooting
Write-Host "Now we are scheduling a new script at boot in order to add roles on this computer ($ComputerName)"
$Step3 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File %HOMEDRIVE%\Scripting\Role_Installation.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -TaskName "Role Installation" -Action $Step3 -Trigger $trigger
Restart-Computer